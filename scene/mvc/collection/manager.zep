
/*
 +------------------------------------------------------------------------+
 |                       ___  ___ ___ _ __   ___                          |
 |                      / __|/ __/ _ \  _ \ / _ \                         |
 |                      \__ \ (_|  __/ | | |  __/                         |
 |                      |___/\___\___|_| |_|\___|                         |
 |                                                                        |
 +------------------------------------------------------------------------+
 | Copyright (c) 2015-2016 Scene Team (http://mcorce.com)                 |
 +------------------------------------------------------------------------+
 | This source file is subject to the MIT License that is bundled         |
 | with this package in the file docs/LICENSE.txt.                        |
 |                                                                        |
 | If you did not receive a copy of the license and are unable to         |
 | obtain it through the world-wide-web, please send an email             |
 | to scene@mcorce.com so we can send you a copy immediately.             |
 +------------------------------------------------------------------------+
 | Authors: DangCheng <dangcheng@hotmail.com>                             |
 +------------------------------------------------------------------------+
 */

namespace Scene\Mvc\Collection;

use Scene\DiInterface;
use Scene\Di\InjectionAwareInterface;
use Scene\Mvc\CollectionInterface;
use Scene\Mvc\Collection\BehaviorInterface;
use Scene\Events\EventsAwareInterface;
use Scene\Events\ManagerInterface as EventsManagerInterface;
use Scene\Mvc\Collection\Client;
use MongoDB\Driver\BulkWrite;
use MongoDB\Driver\Query;
use MongoDB\Driver\Command;
use MongoDB\Driver\WriteResult;

/**
 * Scene\Mvc\Collection\Manager
 *
 * This components controls the initialization of collections, keeping record of relations
 * between the different collections of the application.
 *
 * A CollectionManager is injected to a collection via a Dependency Injector Container such as Scene\Di.
 *
 * <code>
 * $di = new \Scene\Di();
 *
 * $di->set('collectionManager', function(){
 *      return new \Scene\Mvc\Collection\Manager();
 * });
 *
 * $robot = new Robots($di);
 * </code>
 */
class Manager implements ManagerInterface, InjectionAwareInterface, EventsAwareInterface
{

    /**
     * Dependency Injector
     *
     * @var \Scene\DiInterface|null
     * @access protected
    */
    protected _dependencyInjector;

    /**
     * Events Manager
     *
     * @var \Scene\Events\ManagerInterface|null
     * @access protected
    */
    protected _eventsManager;

    /**
     * Custom Events Manager
     *
     * @var array|null
     * @access protected
    */
    protected _customEventsManager;

    /**
     * Initialized
     *
     * @var null|array
     * @access protected
    */
    protected _initialized;

    /**
     * Last Initialized
     *
     * @var null|\Scene\Mvc\CollectionInterface
     * @access protected
    */
    protected _lastInitialized;

    /**
     * Connection Services
     *
     * @var null|array
     * @access protected
    */
    protected _connectionServices;

    /**
     * Implicit Object Ids
     *
     * @var null|array
     * @access protected
    */
    protected _implicitObjectsIds;

    /**
     * Sets the DependencyInjector container
     *
     * @param \Scene\DiInterface dependencyInjector
     */
    public function setDI(<DiInterface> dependencyInjector) -> void
    {
        let this->_dependencyInjector = dependencyInjector;
    }

    /**
     * Returns the DependencyInjector container
     *
     * @return \Scene\DiInterface|null
     */
    public function getDI() -> <DiInterface>
    {
        return this->_dependencyInjector;
    }

    /**
     * Sets the event manager
     *
     * @param \Scene\Events\ManagerInterface eventsManager
     */
    public function setEventsManager(<EventsManagerInterface> eventsManager) -> void
    {
        let this->_eventsManager = eventsManager;
    }

    /**
     * Returns the internal event manager
     *
     * @return \Scene\Events\ManagerInterface
     */
    public function getEventsManager() -> <EventsManagerInterface>
    {
        return this->_eventsManager;
    }

    /**
     * Sets a custom events manager for a specific collection
     *
     * @param \Scene\Mvc\CollectionInterface collection
     * @param \Scene\Events\ManagerInterface eventsManager
     */
    public function setCustomEventsManager(<CollectionInterface> collection, <EventsManagerInterface> eventsManager) -> void
    {
        let this->_customEventsManager[get_class_lower(collection)] = eventsManager;
    }

    /**
     * Returns a custom events manager related to a collection
     *
     * @param \Scene\Mvc\CollectionInterface collection
     * @return \Scene\Events\ManagerInterface
     */
    public function getCustomEventsManager(<CollectionInterface> collection) //-> <EventsManagerInterface>
    {
        var customEventsManager, className;

        let customEventsManager = this->_customEventsManager;
        if typeof customEventsManager == "array" {
            let className = get_class_lower(collection);
            if isset customEventsManager[className] {
                return customEventsManager[className];
            }
        }
    }

    /**
     * Initializes a collection in the collections manager
     *
     * @param \Scene\Mvc\CollectionInterface collection
     */
    public function initialize(<CollectionInterface> collection) -> void
    {
        var className, initialized, eventsManager;

        let className = get_class_lower(collection);
        let initialized = this->_initialized;

        /**
         * Collections are just initialized once per request
         */
        if !isset initialized[className] {

            /**
             * Call the 'initialize' method if it's implemented
             */
            if method_exists(collection, "initialize") {
                collection->{"initialize"}();
            }

            /**
             * If an EventsManager is available we pass to it every initialized collection
             */
            let eventsManager = this->_eventsManager;
            if typeof eventsManager == "object" {
                eventsManager->fire("collectionManager:afterInitialize", collection);
            }

            let this->_initialized[className] = collection;
            let this->_lastInitialized = collection;
        }
    }

    /**
     * Check whether a collection is already initialized
     *
     * @param string collectionName
     * @return bool
     */
    public function isInitialized(string! collectionName) -> boolean
    {
        return isset this->_initialized[strtolower(collectionName)];
    }

    /**
     * Get the latest initialized collection
     *
     * @return \Scene\Mvc\CollectionInterface
     */
    public function getLastInitialized() -> <CollectionInterface>
    {
        return this->_lastInitialized;
    }

    /**
     * Sets a connection service for a specific collection
     *
     * @param \Scene\Mvc\CollectionInterface collection
     * @param string connectionService
     */
    public function setConnection(<CollectionInterface> collection, string! connectionService) -> void
    {
        let this->_connectionServices[get_class_lower(collection)] = connectionService;
    }

    /**
     * Returns the connection related to a collection
     *
     * @param \Scene\Mvc\CollectionInterface collection
     * @return \Scene\Mvc\Collection\Client
     */
    public function getConnection(<CollectionInterface> collection) -> <Client>
    {
        var service, connectionService, className, dependencyInjector, connection;

        let service = "mongoClient",
            connectionService = this->_connectionServices;
        if typeof connectionService == "array" {
            let className = get_class_lower(collection);

            /**
             * Check if the collection has a custom connection service
             */
            if isset connectionService[className] {
                let service = connectionService[className];
            }
        }

        let dependencyInjector = this->_dependencyInjector;
        if typeof dependencyInjector != "object" {
            throw new Exception("A dependency injector container is required to obtain the services related to the ORM");
        }

        /**
         * Request the connection service from the DI
         */
        let connection = this->_dependencyInjector->getShared(service);
        if typeof connection != "object" {
            throw new Exception("Invalid injected connection service");
        }

        return connection;
    }

    /**
     * Executes query on a server
     * 
     * @param  \Scene\Mvc\CollectionInterface collection
     * @param  string source
     * @param  \MongoDB\Driver\Query bulk
     * @return \MongoDB\Driver\WriteResult
     */
    public function executeQuery(<CollectionInterface> collection, string source, <Query> query) -> <WriteResult>
    {
        var dbCollection, connection, connectionServer, database;

        let connection = this->getConnection(collection);
        let connectionServer = connection->getServer();
        let database = connection->getDatabaseName();

        let dbCollection = database . "." . source;

        /* Specify the full namespace as the first argument, followed by the query
         * object and an optional read preference. MongoDB\Driver\Cursor is returned
         * success; otherwise, an exception is thrown. */
        return connectionServer->executeQuery(dbCollection, query, connection->getReadPreference());
    }

    /**
     * Executes one or more write operations on the primary server.
     * 
     * @param  \Scene\Mvc\CollectionInterface collection
     * @param  string source
     * @param  \MongoDB\Driver\BulkWrite bulk
     * @return \MongoDB\Driver\WriteResult
     */
    public function executeBulkWrite(<CollectionInterface> collection, string source, <BulkWrite> bulk) -> <WriteResult>
    {
        var dbCollection, connection, connectionServer, database;

        let connection = this->getConnection(collection);
        let connectionServer = connection->getServer();
        let database = connection->getDatabaseName();

        let dbCollection = database . "." . source;

        /* Specify the full namespace as the first argument, followed by the bulk
         * write object and an optional write concern. MongoDB\Driver\WriteResult is
         * returned on success; otherwise, an exception is thrown. */
        return connectionServer->executeBulkWrite(dbCollection, bulk, connection->getWriteConcern());
    }

    /**
     * Execute a database command
     * 
     * @param  \Scene\Mvc\CollectionInterface collection
     * @param  \MongoDB\Driver\Command command
     * @return array
     */
    public function executeCommand(<CollectionInterface> collection, <command> command) -> array
    {
        var connection, connectionServer, database, cursor;
        
        let connection = this->getConnection(collection);
        let connectionServer = connection->getServer();
        let database = connection->getDatabaseName();

        let cursor = connectionServer->executeCommand(database, command, connection->getReadPreference());
        return current(cursor->toArray());
    }

    /**
     * Receives events generated in the collections and dispatches them to a events-manager if available
     * Notify the behaviors that are listening in the collection
     *
     * @param string eventName
     * @param \Scene\Mvc\CollectionInterface collection
     * @return mixed
     */
    public function notifyEvent(string! eventName, <CollectionInterface> collection)
    {
        var eventsManager, status = null, customEventsManager;

        /**
         * Dispatch events to the global events manager
         */
        let eventsManager = this->_eventsManager;
        if typeof eventsManager == "object" {
            let status = eventsManager->fire( "collection:" . eventName, collection);
            if !status {
                return status;
            }
        }

        /**
         * A collection can has a specific events manager for it
         */
        let customEventsManager = this->_customEventsManager;
        if typeof customEventsManager == "array" {
            if isset customEventsManager[get_class_lower(collection)] {
                let status = customEventsManager->fire("collection:" . eventName, collection);
                if !status {
                    return status;
                }
            }
        }

        return status;
    }
  
}
