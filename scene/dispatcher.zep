
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

namespace Scene;

use Scene\DiInterface;
use Scene\Di\InjectionAwareInterface;
use Scene\Events\ManagerInterface;
use Scene\Events\EventsAwareInterface;
use Scene\DispatcherInterface;
use Scene\FilterInterface;
use Scene\Exception;

/**
 * Scene\Dispatcher
 *
 * This is the base class for Scene\Mvc\Dispatcher and Scene\Cli\Dispatcher.
 * This class can't be instantiated directly, you can use it to create your own dispatchers.
 */
abstract class Dispatcher implements DispatcherInterface, InjectionAwareInterface, EventsAwareInterface
{

    /**
     * Exception: No DI
     *
     * @var int
    */
    const EXCEPTION_NO_DI = 0;

    /**
     * Exception: Cyclic Routing
     *
     * @var int
    */
    const EXCEPTION_CYCLIC_ROUTING = 1;

    /**
     * Exception: Handler not found
     *
     * @var int
    */
    const EXCEPTION_HANDLER_NOT_FOUND = 2;

    /**
     * Exception: Invalid handler
     *
     * @var int
    */
    const EXCEPTION_INVALID_HANDLER = 3;

    /**
     * Exception: Invalid params
     *
     * @var int
    */
    const EXCEPTION_INVALID_PARAMS = 4;

    /**
     * Exception: Action not found
     *
     * @var int
    */
    const EXCEPTION_ACTION_NOT_FOUND = 5;

    /**
     * Dependency Injector
     *
     * @var null|\Scene\DiInterface
     * @access protected
    */
    protected _dependencyInjector;

    /**
     * Events Manager
     *
     * @var null|\Scene\Events\ManagerInterface
     * @access protected
    */
    protected _eventsManager;

    /**
     * Active Handler
     *
     * @var null|object
     * @access protected
    */
    protected _activeHandler;

    /**
     * Finished
     *
     * @var null|boolean
     * @access protected
    */
    protected _finished;

    /**
     * Forwarded
     *
     * @var boolean
     * @access protected
    */
    protected _forwarded = false;

    /**
     * Module Name
     *
     * @var null|string
     * @access protected
    */
    protected _moduleName = null;

    /**
     * Namespace Name
     *
     * @var null|string
     * @access protected
    */
    protected _namespaceName = null;

    /**
     * Handler Name
     *
     * @var null|string
     * @access protected
    */
    protected _handlerName = null;

    /**
     * Action Name
     *
     * @var null|string
     * @access protected
    */
    protected _actionName = null;

    /**
     * Params
     *
     * @var null|array
     * @access protected
    */
    protected _params = [];

    /**
     * Returned Value
     *
     * @var mixed
     * @access protected
    */
    protected _returnedValue = null;

    /**
     * Last Handler
     *
     * @var null|object
     * @access protected
    */
    protected _lastHandler = null;

    /**
     * Default Namespace
     *
     * @var null|string
     * @access protected
    */
    protected _defaultNamespace = null;

    /**
     * Default Handler
     *
     * @var null|object
     * @access protected
    */
    protected _defaultHandler = null;

    /**
     * Default Action
     *
     * @var string
     * @access protected
    */
    protected _defaultAction = "";

    /**
     * Handler Suffix
     *
     * @var string
     * @access protected
    */
    protected _handlerSuffix = "";

    /**
     * Action Suffix
     *
     * @var string
     * @access protected
    */
    protected _actionSuffix = "Action";

    /**
     * Previous Handler Name
     *
     * @var string
     * @access protected
    */
    protected _previousHandlerName = null;

    /**
     * Previous Action Name
     *
     * @var string
     * @access protected
    */
    protected _previousActionName = null;

    /**
     * Sets the dependency injector
     *
     * @param \Scene\DiInterface dependencyInjector
     */
    public function setDI(<DiInterface> dependencyInjector)
    {
        let this->_dependencyInjector = dependencyInjector;
    }

    /**
     * Returns the internal dependency injector
     *
     * @return \Scene\DiInterface|null
     */
    public function getDI() -> <DiInterface>
    {
        return this->_dependencyInjector;
    }

    /**
     * Sets the events manager
     *
     * @param \Scene\Events\ManagerInterface eventsManager
     */
    public function setEventsManager(<ManagerInterface> eventsManager)
    {
        let this->_eventsManager = eventsManager;
    }

    /**
     * Returns the internal event manager
     *
     * @return \Scene\Events\ManagerInterface|null
     */
    public function getEventsManager() -> <ManagerInterface>
    {
        return this->_eventsManager;
    }

    /**
     * Sets the default action suffix
     *
     * @param string actionSuffix
     */
    public function setActionSuffix(string actionSuffix)
    {
        let this->_actionSuffix = actionSuffix;
    }

    /**
     * Gets the default action suffix
     *
     * @return string
     */
    public function getActionSuffix() -> string
    {
        return this->_actionSuffix;
    }

    /**
     * Sets the module where the controller is (only informative)
     *
     * @param string moduleName
     */
    public function setModuleName(string moduleName)
    {
        let this->_moduleName = moduleName;
    }

    /**
     * Gets the module where the controller class is
     *
     * @return string
     */
    public function getModuleName() -> string
    {
        return this->_moduleName;
    }

    /**
     * Sets the namespace where the controller class is
     *
     * @param string namespaceName
     */
    public function setNamespaceName(string namespaceName)
    {
        let this->_namespaceName = namespaceName;
    }

    /**
     * Gets a namespace to be prepended to the current handler name
     *
     * @return string
     */
    public function getNamespaceName() -> string
    {
        return this->_namespaceName;
    }

    /**
     * Sets the default namespace
     *
     * @param string namespace
     */
    public function setDefaultNamespace(string namespaceName)
    {
        let this->_defaultNamespace = namespaceName;
    }

    /**
     * Returns the default namespace
     *
     * @return string
     */
    public function getDefaultNamespace() -> string
    {
        return this->_defaultNamespace;
    }

    /**
     * Sets the default action name
     *
     * @param string actionName
     */
    public function setDefaultAction(string actionName)
    {
        let this->_defaultAction = actionName;
    }

    /**
     * Sets the action name to be dispatched
     *
     * @param string actionName
     */
    public function setActionName(string actionName)
    {
        let this->_actionName = actionName;
    }

    /**
     * Gets the latest dispatched action name
     *
     * @return string
     */
    public function getActionName() -> string
    {
        return this->_actionName;
    }

    /**
     * Sets action params to be dispatched
     *
     * @param array params
     */
    public function setParams(var params)
    {
        if typeof params != "array" {
            this->{"_throwDispatchException"}("Parameters must be an Array");
            return null;
        }
        let this->_params = params;
    }

    /**
     * Gets action params
     *
     * @return array
     */
    public function getParams() -> array
    {
        return this->_params;
    }

    /**
     * Set a param by its name or numeric index
     *
     * @param  mixed param
     * @param  mixed value
     */
    public function setParam(var param, var value)
    {
        let this->_params[param] = value;
    }

    /**
     * Gets a param by its name or numeric index
     *
     * @param mixed param
     * @param string|array|null filters
     * @param mixed defaultValue
     * @return mixed
     */
    public function getParam(param, filters = null, defaultValue = null)
    {
        var params, filter, paramValue, dependencyInjector;

        let params = this->_params;
        if !fetch paramValue, params[param] {
            return defaultValue;
        }

        if filters === null {
            return paramValue;
        }

        let dependencyInjector = this->_dependencyInjector;
        if typeof dependencyInjector != "object" {
            this->{"_throwDispatchException"}("A dependency injection object is required to access the 'filter' service", self::EXCEPTION_NO_DI);
        }
        let filter = <FilterInterface> dependencyInjector->getShared("filter");
        return filter->sanitize(paramValue, filters);
    }

    /**
     * Returns the current method to be/executed in the dispatcher
     *
     * @return string
     */
    public function getActiveMethod() -> string
    {
        return this->_actionName . this->_actionSuffix;
    }

    /**
     * Check if a param exists
     *
     * @param  mixed param
     * @return boolean
     */
    public function hasParam(param) -> boolean
    {
        return isset this->_params[param];
    }

    /**
     * Checks if the dispatch loop is finished or has more pendent controllers/tasks to dispatch
     *
     * @return boolean
     */
    public function isFinished() -> boolean
    {
        return this->_finished;
    }

    /**
     * Sets the latest returned value by an action manually
     *
     * @param mixed value
     */
    public function setReturnedValue(var value)
    {
        let this->_returnedValue = value;
    }

    /**
     * Returns value returned by the lastest dispatched action
     *
     * @return mixed
     */
    public function getReturnedValue()
    {
        return this->_returnedValue;
    }

    /**
     * Dispatches a handle action taking into account the routing parameters
     *
     * @return object
     */
    public function dispatch()
    {
        boolean hasService;
        int numberDispatches;
        var value, handler, dependencyInjector, namespaceName, handlerName,
            actionName, params, eventsManager,
            actionSuffix, handlerClass, status, actionMethod,
            wasFresh = false, e;

        let dependencyInjector = <DiInterface> this->_dependencyInjector;
        if typeof dependencyInjector != "object" {
            this->{"_throwDispatchException"}("A dependency injection container is required to access related dispatching services", self::EXCEPTION_NO_DI);
            return false;
        }

        /*
         * Calling beforeDispatchLoop
         */
        let eventsManager = <ManagerInterface> this->_eventsManager;
        if typeof eventsManager == "object" {
            if eventsManager->fire("dispatch:beforeDispatchLoop", this) === false {
                return false;
            }
        }

        let value = null,
            handler = null,
            numberDispatches = 0,
            actionSuffix = this->_actionSuffix,

            this->_finished = false;

        while !this->_finished {

            let numberDispatches++;

            /*
             * Throw an exception after 256 consecutive forwards
             */
            if numberDispatches == 256 {
                this->{"_throwDispatchException"}("Dispatcher has detected a cyclic routing causing stability problems", self::EXCEPTION_CYCLIC_ROUTING);
                break;
            }

            let this->_finished = true;

            this->_resolveEmptyProperties();

            let namespaceName = this->_namespaceName;
            let handlerName = this->_handlerName;
            let actionName = this->_actionName;
            let handlerClass = this->getHandlerClass();

            /*
             * Calling beforeDispatch
             */
            if typeof eventsManager == "object" {

                if eventsManager->fire("dispatch:beforeDispatch", this) === false {
                    continue;
                }

                /*
                 * Check if the user made a forward in the listener
                 */
                if this->_finished === false {
                    continue;
                }
            }

            /*
             * Handlers are retrieved as shared instances from the Service Container
             */
            let hasService = (bool) dependencyInjector->has(handlerClass);
            if !hasService {
                /*
                 * DI doesn't have a service with that name, try to load it using an autoloader
                 */
                let hasService = (bool) class_exists(handlerClass);
            }

            /*
             * If the service can be loaded we throw an exception
             */
            if !hasService {
                let status = this->{"_throwDispatchException"}(handlerClass . " handler class cannot be loaded", self::EXCEPTION_HANDLER_NOT_FOUND);
                if status === false {

                    /*
                     * Check if the user made a forward in the listener
                     */
                    if this->_finished === false {
                        continue;
                    }
                }
                break;
            }

            /*
             * Handlers must be only objects
             */
            let handler = dependencyInjector->getShared(handlerClass);

            /*
             * If the object was recently created in the DI we initialize it
             */
            if dependencyInjector->wasFreshInstance() === true {
                let wasFresh = true;
            }

            if typeof handler != "object" {
                let status = this->{"_throwDispatchException"}("Invalid handler returned from the services container", self::EXCEPTION_INVALID_HANDLER);
                if status === false {
                    if this->_finished === false {
                        continue;
                    }
                }
                break;
            }

            let this->_activeHandler = handler;

            /*
             * Check if the params is an array
             */
            let params = this->_params;
            if typeof params != "array" {

                /*
                 * An invalid parameter variable was passed throw an exception
                 */
                let status = this->{"_throwDispatchException"}("Action parameters must be an Array", self::EXCEPTION_INVALID_PARAMS);
                if status === false {
                    if this->_finished === false {
                        continue;
                    }
                }
                break;
            }

            /*
             * Check if the method exists in the handler
             */
            let actionMethod = actionName . actionSuffix;

            if !method_exists(handler, actionMethod) {

                /*
                 * Call beforeNotFoundAction
                 */
                if typeof eventsManager == "object" {

                    if eventsManager->fire("dispatch:beforeNotFoundAction", this) === false {
                        continue;
                    }

                    if this->_finished === false {
                        continue;
                    }
                }

                /*
                 * Try to throw an exception when an action isn't defined on the object
                 */
                let status = this->{"_throwDispatchException"}("Action '" . actionName . "' was not found on handler '" . handlerName . "'", self::EXCEPTION_ACTION_NOT_FOUND);
                if status === false {
                    if this->_finished === false {
                        continue;
                    }
                }
                break;
            }

            /*
             * Calling beforeExecuteRoute
             */
            if typeof eventsManager == "object" {

                if eventsManager->fire("dispatch:beforeExecuteRoute", this) === false {
                    continue;
                }

                /*
                 * Check if the user made a forward in the listener
                 */
                if this->_finished === false {
                    continue;
                }
            }

            /*
             * Calling beforeExecuteRoute as callback and event
             */
            if method_exists(handler, "beforeExecuteRoute") {

                if handler->beforeExecuteRoute(this) === false {
                    continue;
                }

                /*
                 * Check if the user made a forward in the listener
                 */
                if this->_finished === false {
                    continue;
                }
            }

            /**
             * Call the 'initialize' method just once per request
             */
            if wasFresh === true {

                if method_exists(handler, "initialize") {
                    handler->initialize();
                }

                /**
                 * Calling afterInitialize
                 */
                if typeof eventsManager == "object" {
                    if eventsManager->fire("dispatch:afterInitialize", this) === false {
                        continue;
                    }

                    /*
                     * Check if the user made a forward in the listener
                     */
                    if this->_finished === false {
                        continue;
                    }
                }
            }

            try {

                /*
                 * We update the latest value produced by the latest handler
                 */
                let this->_returnedValue = call_user_func_array([handler, actionMethod], params),
                    this->_lastHandler = handler;

            } catch \Exception, e {
                if this->{"_handleException"}(e) === false {
                    if this->_finished === false {
                        continue;
                    }
                } else {
                    throw new Exception(e);
                }
            }

            /*
             * Calling afterExecuteRoute
             */
            if typeof eventsManager == "object" {

                if eventsManager->fire("dispatch:afterExecuteRoute", this, value) === false {
                    continue;
                }

                if this->_finished === false {
                    continue;
                }

                /*
                 * Calling afetDispatch
                 */
                eventsManager->fire("dispatch:afterDispatch", this);
            }

            /*
             * Calling afterExecuteRoute as callback and event
             */
            if method_exists(handler, "afterExecuteRoute") {

                if handler->afterExecuteRoute(this, value) === false {
                    continue;
                }

                if this->_finished === false {
                    continue;
                }
            }
        }

        /*
         * Call afterDispatchLoop
         */
        if typeof eventsManager == "object" {
            eventsManager->fire("dispatch:afterDispatchLoop", this);
        }

        return handler;
    }

    /**
     * Forwards the execution flow to another controller/action
     * Dispatchers are unique per module. Forwarding between modules is not allowed
     *
     *<code>
     *  $this->dispatcher->forward(array("controller" => "posts", "action" => "index"));
     *</code>
     *
     * @param array forward
     */
    public function forward(var forward)
    {
        var namespaceName, controllerName, params, actionName, taskName;

        if typeof forward != "array" {
            this->{"_throwDispatchException"}("Forward parameter must be an Array");
            return null;
        }

        // Check if we need to forward to another namespace
        if fetch namespaceName, forward["namespace"] {
            let this->_namespaceName = namespaceName;
        }

        // Check if we need to forward to another controller
        if fetch controllerName, forward["controller"] {
            let this->_previousHandlerName = this->_handlerName,
                this->_handlerName = controllerName;
        } else {
            if fetch taskName, forward["task"] {
                let this->_previousHandlerName = this->_handlerName,
                    this->_handlerName = taskName;
            }
        }

        // Check if we need to forward to another action
        if fetch actionName, forward["action"] {
            let this->_previousActionName = this->_actionName,
                this->_actionName = actionName;
        }

        // Check if we need to forward changing the current parameters
        if fetch params, forward["params"] {
            let this->_params = params;
        }

        let this->_finished = false,
            this->_forwarded = true;
    }

    /**
     * Check if the current executed action was forwarded by another one
     *
     * @return boolean
     */
    public function wasForwarded() -> boolean
    {
        return this->_forwarded;
    }

    /**
     * Possible class name that will be located to dispatch the request
     *
     * @return string
     */
    public function getHandlerClass() -> string
    {
        var handlerSuffix, handlerName, namespaceName,
            camelizedClass, handlerClass;

        this->_resolveEmptyProperties();

        let handlerSuffix = this->_handlerSuffix,
            handlerName = this->_handlerName,
            namespaceName = this->_namespaceName;

        // We don't camelize the classes if they are in namespaces
        if !memstr(handlerName, "\\") {
            let camelizedClass = camelize(handlerName);
        } else {
            let camelizedClass = handlerName;
        }

        // Create the complete controller class name prepending the namespace
        if namespaceName {
            if ends_with(namespaceName, "\\") {
                let handlerClass = namespaceName . camelizedClass . handlerSuffix;
            } else {
                let handlerClass = namespaceName . "\\" . camelizedClass . handlerSuffix;
            }
        } else {
            let handlerClass = camelizedClass . handlerSuffix;
        }

        return handlerClass;
    }

    /**
     * Set empty properties to their defaults (where defaults are available)
     */
    protected function _resolveEmptyProperties() -> void
    {
        // If the current namespace is null we used the set in this->_defaultNamespace
        if !this->_namespaceName {
            let this->_namespaceName = this->_defaultNamespace;
        }

        // If the handler is null we use the set in this->_defaultHandler
        if !this->_handlerName {
            let this->_handlerName = this->_defaultHandler;
        }

        // If the action is null we use the set in this->_defaultAction
        if !this->_actionName {
            let this->_actionName = this->_defaultAction;
        }
    }
}
