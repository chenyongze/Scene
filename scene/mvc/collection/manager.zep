
/**
 * Manager
*/

namespace Scene\Mvc\Collection;

use Scene\DiInterface;
use Scene\Di\InjectionAwareInterface;
use Scene\Mvc\CollectionInterface;
use Scene\Mvc\Collection\BehaviorInterface;
use Scene\Events\EventsAwareInterface;
use Scene\Events\ManagerInterface as EventsManagerInterface;

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
     * Implicit Object Ids
     *
     * @var null|array
     * @access protected
    */
    protected _implicitObjectsIds;

    /**
     * Behaviors
     *
     * @var null|array
     * @access protected
    */
    protected _behaviors;

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
     * Initializes a model in the models manager
     *
     * @param \Scene\Mvc\CollectionInterface $model
     */
    public function initialize(<CollectionInterface> model) -> void
    {
        var className, initialized, eventsManager;

        let className = get_class_lower(model);
        let initialized = this->_initialized;

        /**
         * Models are just initialized once per request
         */
        if !isset initialized[className] {

            /**
             * Call the 'initialize' method if it's implemented
             */
            if method_exists(model, "initialize") {
                model->{"initialize"}();
            }

            /**
             * If an EventsManager is available we pass to it every initialized model
             */
            let eventsManager = this->_eventsManager;
            if typeof eventsManager == "object" {
                eventsManager->fire("collectionManager:afterInitialize", model);
            }

            let this->_initialized[className] = model;
            let this->_lastInitialized = model;
        }
    }

    /**
     * Check whether a model is already initialized
     *
     * @param string modelName
     * @return bool
     */
    public function isInitialized(string! modelName) -> boolean
    {
        return isset this->_initialized[strtolower(modelName)];
    }

    /**
     * Get the latest initialized model
     *
     * @return \Scene\Mvc\CollectionInterface
     */
    public function getLastInitialized() -> <CollectionInterface>
    {
        return this->_lastInitialized;
    }

    /**
     * Sets a connection service for a specific model
     *
     * @param \Scene\Mvc\CollectionInterface model
     * @param string connectionService
     */
    public function setConnectionService(<CollectionInterface> model, string! connectionService) -> void
    {
        let this->_connectionServices[get_class(model)] = connectionService;
    }

    /**
     * Sets whether a model must use implicit objects ids
     *
     * @param \Scene\Mvc\CollectionInterface $model
     * @param boolean $useImplicitObjectIds
     */
    public function useImplicitObjectIds(<CollectionInterface> model, boolean useImplicitObjectIds) -> void
    {
        let this->_implicitObjectsIds[get_class(model)] = useImplicitObjectIds;
    }

    /**
     * Checks if a model is using implicit object ids
     *
     * @param \Scene\Mvc\CollectionInterface $model
     * @return boolean
     */
    public function isUsingImplicitObjectIds(<CollectionInterface> model) -> boolean
    {
        var implicit;

        /**
         * All collections use by default are using implicit object ids
         */
        if fetch implicit, this->_implicitObjectsIds[get_class(model)] {
            return implicit;
        }

        return true;
    }

    /**
     * Returns the connection related to a model
     *
     * @param \Scene\Mvc\CollectionInterface model
     * @return \Mongo
     */
    public function getConnection(<CollectionInterface> model)
    {
        var service, connectionService, connection, dependencyInjector, entityName;

        let service = "mongo";
        let connectionService = this->_connectionServices;
        if typeof connectionService == "array" {
            let entityName = get_class(model);

            /**
             * Check if the model has a custom connection service
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
        let connection = dependencyInjector->getShared(service);
        if typeof connection != "object" {
            throw new Exception("Invalid injected connection service");
        }

        return connection;
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
        var behavior, behaviors, modelsBehaviors, eventsManager, status = null, customEventsManager;

        let behaviors = this->_behaviors;
        if typeof behaviors == "array" {
            if fetch modelsBehaviors, behaviors[get_class_lower(model)] {

                /**
                 * Notify all the events on the behavior
                 */
                for behavior in modelsBehaviors {
                    let status = behavior->notify(eventName, model);
                    if status === false {
                        return false;
                    }
                }
            }
        }

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

    /**
     * Dispatch a event to the listeners and behaviors
     * This method expects that the endpoint listeners/behaviors returns true
     * meaning that a least one was implemented
     *
     * @param \Scene\Mvc\CollectionInterface model
     * @param string eventName
     * @param mixed data
     * @return boolean
     */
    public function missingMethod(<CollectionInterface> model, string! eventName, var data) -> boolean
    {
        var behaviors, modelsBehaviors, result, eventsManager, behavior;

        /**
         * Dispatch events to the global events manager
         */
        let behaviors = this->_behaviors;
        if typeof behaviors == "array" {

            if fetch modelsBehaviors, behaviors[get_class_lower(model)] {

                /**
                 * Notify all the events on the behavior
                 */
                for behavior in modelsBehaviors {
                    let result = behavior->missingMethod(model, eventName, data);
                    if result !== null {
                        return result;
                    }
                }
            }
        }

        /**
         * Dispatch events to the global events manager
         */
        let eventsManager = this->_eventsManager;
        if typeof eventsManager == "object" {
            return eventsManager->fire("model:" . eventName, model, data);
        }

        return false;
    }

    /**
     * Binds a behavior to a model
     *
     * @param \Scene\Mvc\CollectionInterface model
     * @param \Scene\Mvc\Collection\BehaviorInterface behavior
     */
    public function addBehavior(<CollectionInterface> model, <BehaviorInterface> behavior)
    {
        var entityName, modelsBehaviors;

        let entityName = get_class_lower(model);

        /**
         * Get the current behaviors
         */
        if !fetch modelsBehaviors, this->_behaviors[entityName] {
            let modelsBehaviors = [];
        }

        /**
         * Append the behavior to the list of behaviors
         */
        let modelsBehaviors[] = behavior;

        /**
         * Update the behaviors list
         */
        let this->_behaviors[entityName] = modelsBehaviors;
    }
}
