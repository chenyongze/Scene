
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
use MongoDB\Driver\Manage;
use MongoDB\Driver\WriteConcern;
use MongoDB\Driver\ReadPreference;
use MongoDB\Driver\BulkWrite;
use MongoDB\Driver\Query;
use MongoDB\Driver\Command;
use MongoDB\Driver\WriteResult;

/**
 * Scene\Mvc\Collection\Manager
 *
 * This components controls the initialization of models, keeping record of relations
 * between the different models of the application.
 *
 * A CollectionManager is injected to a model via a Dependency Injector Container such as Scene\Di.
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
     * Default DB
     *
     * @var string
     * @access protected
     */
    protected _defaultDB;

    /**
     * DB
     *
     * @var string
     * @access protected
     */
    protected _db;

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
     * Connection Services
     *
     * @var null|array
     * @access protected
    */
    protected _connectionServices;

    /**
     * Write Concern
     * 
     * @var MongoDB\Driver\WriteConcern|null
     * @access protected
     */
    protected _writeConcern;

    /**
     * Read Preference
     * @var MongoDB\Driver\ReadPreference|null
     * @access protected
     */
    protected _readPreference;

    /**
     * Implicit Object Ids
     *
     * @var null|array
     * @access protected
    */
    protected _implicitObjectsIds;

    /**
     * Magager construct
     * 
     * @param string $defaultDB
     */
    public function __construct(string defaultDB = null)
    {
        let this->_defaultDB = defaultDB;
    }

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
     * Sets a custom events manager for a specific model
     *
     * @param \Scene\Mvc\CollectionInterface model
     * @param \Scene\Events\ManagerInterface eventsManager
     */
    public function setCustomEventsManager(<CollectionInterface> model, <EventsManagerInterface> eventsManager) -> void
    {
        let this->_customEventsManager[get_class_lower(model)] = eventsManager;
    }

    /**
     * Returns a custom events manager related to a model
     *
     * @param \Scene\Mvc\CollectionInterface model
     * @return \Scene\Events\ManagerInterface
     */
    public function getCustomEventsManager(<CollectionInterface> model) //-> <EventsManagerInterface>
    {
        var customEventsManager, className;

        let customEventsManager = this->_customEventsManager;
        if typeof customEventsManager == "array" {
            let className = get_class_lower(model);
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
     * Set DB name
     *
     * @throws Exception
     */
    public function setDB(string db = null)
    {
        let this->_db = db;
    }

    /**
     * Get DB name
     * 
     * @return string
     */
    public function getDB()
    {
        if this->_db {
            return this->_db;
        } else {
            return this->_defaultDB;
        }
    }

    /**
     * Sets a connection service for a specific collection
     *
     * @param \Scene\Mvc\CollectionInterface collection
     * @param string connectionService
     */
    public function setConnectionService(<CollectionInterface> collection, string! connectionService) -> void
    {
        let this->_connectionServices[get_class(collection)] = connectionService;
    }

    /**
     * Returns the connection related to a collection
     *
     * @param \Scene\Mvc\CollectionInterface collection
     * @return \MongoDB\Driver\Manage
     * @throws Exception
     */
    public function getConnection(<CollectionInterface> collection) -> <Manage>
    {
        var service, connectionService, entityName, dependencyInjector, connection;

        let service = "mongo",
            connectionService = this->_connectionServices;
        if typeof connectionService == "array" {
            let entityName = get_class(collection);

            /**
             * Check if the collection has a custom connection service
             */
            if isset connectionService[entityName] {
                let service = connectionService[entityName];
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
     * Set Write Concern
     * 
     * @param MongoDB\Driver\WriteConcern $writeConcern
     */
    public function setWriteConcern(<WriteConcern> writeConcern) -> void
    {
        let this->_writeConcern = writeConcern;
    }

    /**
     * Get Write Concern
     * 
     * @return MongoDB\Driver\WriteConcern
     */
    public function getWriteConcern() -> <WriteConcern>
    {
        var writeConcern, wc;

        let writeConcern = this->_writeConcern;

        if !writeConcern {
            // Construct a write concern
            let wc = new WriteConcern(
                // Guarantee that writes are acknowledged by a majority of our nodes
                WriteConcern::MAJORITY,
                // But only wait 1000ms because we have an application to run!
                1000
            );

            let this->_writeConcern = wc;
            return wc;
        }

        return writeConcern;
    }

    /**
     * Set Read Preference
     * 
     * @param MongoDB\Driver\ReadPreference $readPreference
     */
    public function setReadPreference(<ReadPreference> readPreference) -> void
    {
        let this->_readPreference = readPreference;
    }

    /**
     * Set read preference
     * 
     * @return MongoDB\Driver\ReadPreference;
     */
    public function getReadPreference() -> <ReadPreference>
    {
        var readPreference, rp;

        let readPreference = this->_readPreference;

        if !readPreference {
            // Construct a read preference
            let rp = new ReadPreference(
                /* We prefer to read from a secondary, but are OK with reading from the
                 * primary if necessary (e.g. secondaries are offline) */
                ReadPreference::RP_PRIMARY
            );

            let this->_readPreference = rp;
            return rp;
        }

        return readPreference;
    }

    /**
     * Sets whether a collection must use implicit objects ids
     *
     * @param \Scene\Mvc\CollectionInterface collection
     * @param boolean useImplicitObjectIds
     */
    public function useImplicitObjectIds(<CollectionInterface> collection, boolean useImplicitObjectIds) -> void
    {
        let this->_implicitObjectsIds[get_class(collection)] = useImplicitObjectIds;
    }

    /**
     * Checks if a collection is using implicit object ids
     *
     * @param \Scene\Mvc\CollectionInterface collection
     * @return boolean
     */
    public function isUsingImplicitObjectIds(<CollectionInterface> collection) -> boolean
    {
        var implicit;

        /**
         * All collections use by default are using implicit object ids
         */
        if fetch implicit, this->_implicitObjectsIds[get_class(collection)] {
            return implicit;
        }

        return true;
    }

    /**
     * Executes query on a server
     * 
     * @param  \Scene\Mvc\CollectionInterface collection
     * @param  string db
     * @param  string source
     * @param  \MongoDB\Driver\Query bulk
     * @return \MongoDB\Driver\WriteResult
     */
    public function executeQuery(<CollectionInterface> collection, string db, string source, <Query> query) -> <WriteResult>
    {
        var dbCollection, connection;

        if !db {
            let db = (string) this->getDB();
        }

        let dbCollection = db . "." . source;

        let connection = this->getConnection(collection);

        /* Specify the full namespace as the first argument, followed by the query
         * object and an optional read preference. MongoDB\Driver\Cursor is returned
         * success; otherwise, an exception is thrown. */
        return connection->executeQuery(dbCollection, query, this->getReadPreference());
    }

    /**
     * Executes one or more write operations on the primary server.
     * 
     * @param  \Scene\Mvc\CollectionInterface collection
     * @param  string db
     * @param  string source
     * @param  \MongoDB\Driver\BulkWrite bulk
     * @return \MongoDB\Driver\WriteResult
     */
    public function executeBulkWrite(<CollectionInterface> collection, string db, string source, <BulkWrite> bulk) -> <WriteResult>
    {
        var dbCollection, connection;

        if !db {
            let db = (string) this->getDB();
        }

        let dbCollection = db . "." . source;

        let connection = this->getConnection(collection);

        /* Specify the full namespace as the first argument, followed by the bulk
         * write object and an optional write concern. MongoDB\Driver\WriteResult is
         * returned on success; otherwise, an exception is thrown. */
        return connection->executeBulkWrite(dbCollection, bulk, this->getWriteConcern());
    }

    /**
     * Execute a database command
     * 
     * @param  \Scene\Mvc\CollectionInterface $collection
     * @param  string $db
     * @param  \MongoDB\Driver\Command $command
     * @return array
     */
    public function executeCommand(<CollectionInterface> collection, string db, string source, <command> command) -> array
    {
        var connection, cursor;
        
        if !db {
            let db = (string) this->getDB();
        }

        let connection = this->getConnection(collection);

        let cursor = connection->executeCommand(db, command, this->getReadPreference());
        return current(cursor->toArray());
    }

    /**
     * Receives events generated in the models and dispatches them to a events-manager if available
     * Notify the behaviors that are listening in the model
     *
     * @param string $eventName
     * @param \Scene\Mvc\CollectionInterface $model
     * @return mixed
     */
    public function notifyEvent(string! eventName, <CollectionInterface> model)
    {
        var eventsManager, status = null, customEventsManager;

        /**
         * Dispatch events to the global events manager
         */
        let eventsManager = this->_eventsManager;
        if typeof eventsManager == "object" {
            let status = eventsManager->fire( "collection:" . eventName, model);
            if !status {
                return status;
            }
        }

        /**
         * A model can has a specific events manager for it
         */
        let customEventsManager = this->_customEventsManager;
        if typeof customEventsManager == "array" {
            if isset customEventsManager[get_class_lower(model)] {
                let status = customEventsManager->fire("collection:" . eventName, model);
                if !status {
                    return status;
                }
            }
        }

        return status;
    }
  
}
