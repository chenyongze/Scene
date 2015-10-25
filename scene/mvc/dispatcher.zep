
/**
 * Dispatcher
*/

namespace Scene\Mvc;

use Scene\Dispatcher as BaseDispatcher;
use Scene\Mvc\DispatcherInterface;
use Scene\Mvc\Dispatcher\Exception;
use Scene\Events\ManagerInterface;
use Scene\Http\ResponseInterface;
use Scene\Mvc\ControllerInterface;


/**
 * Scene\Mvc\Dispatcher
 *
 * Dispatching is the process of taking the request object, extracting the module name,
 * controller name, action name, and optional parameters contained in it, and then
 * instantiating a controller and calling an action of that controller.
 *
 *<code>
 *
 *  $di = new \Scene\Di();
 *
 *  $dispatcher = new \Scene\Mvc\Dispatcher();
 *
 *  $dispatcher->setDI($di);
 *
 *  $dispatcher->setControllerName('posts');
 *  $dispatcher->setActionName('index');
 *  $dispatcher->setParams(array());
 *
 *  $controller = $dispatcher->dispatch();
 *</code>
 */
class Dispatcher extends BaseDispatcher implements DispatcherInterface
{

    /**
     * Handler Suffix
     *
     * @var string
     * @access protected
    */
    protected _handlerSuffix = "Controller";

    /**
     * Default Handler
     *
     * @var string
     * @access protected
    */
    protected _defaultHandler = "index";

    /**
     * Default Action
     *
     * @var string
     * @access protected
    */
    protected _defaultAction = "index";

    /**
     * Sets the default controller suffix
     */
    public function setControllerSuffix(string! controllerSuffix)
    {
        let this->_handlerSuffix = controllerSuffix;
    }

    /**
     * Sets the default controller name
     *
     * @param string controllerName
     */
    public function setDefaultController(string! controllerName)
    {
        let this->_defaultHandler = controllerName;
    }

    /**
     * Sets the controller name to be dispatched
     *
     * @param string controllerName
     */
    public function setControllerName(string! controllerName)
    {
        let this->_handlerName = controllerName;
    }

    /**
     * Gets last dispatched controller name
     *
     * @return string
     */
    public function getControllerName() -> string
    {
        return this->_handlerName;
    }

    /**
     * Gets previous dispatched controller name
     *
     * @return string
     */
    public function getPreviousControllerName() -> string
    {
        return this->_previousHandlerName;
    }

    /**
     * Gets previous dispatched action name
     *
     * @return string
     */
    public function getPreviousActionName() -> string
    {
        return this->_previousActionName;
    }

    /**
     * Throws an internal exception
     *
     * @param string $message
     * @param int $exceptionCode
     * @return boolean|null
     * @throws Exception
     */
    protected function _throwDispatchException(string! message, int exceptionCode = 0)
    {
        var dependencyInjector, response, exception;

        let dependencyInjector = this->_dependencyInjector;
        if typeof dependencyInjector != "object" {
            throw new Exception(
                "A dependency injection container is required to access the 'response' service",
                BaseDispatcher::EXCEPTION_NO_DI
            );
        }

        let response = <ResponseInterface> dependencyInjector->getShared("response");

        /**
         * Dispatcher exceptions automatically sends a 404 status
         */
        response->setStatusCode(404, "Not Found");

        /**
         * Create the real exception
         */
        let exception = new Exception(message, exceptionCode);

        if this->_handleException(exception) === false {
            return false;
        }

        /**
         * Throw the exception if it wasn't handled
         */
        throw exception;
    }

    /**
     * Handles a user exception
     *
     * @param \Exception $exception
     * @throws Exception
     * @return boolean|null
     */
    protected function _handleException(<\Exception> exception)
    {
        var eventsManager;
        let eventsManager = <ManagerInterface> this->_eventsManager;
        if typeof eventsManager == "object" {
            if eventsManager->fire("dispatch:beforeException", this, exception) === false {
                return false;
            }
        }
    }

    /**
     * Possible controller class name that will be located to dispatch the request
     *
     * @return string
     */
    public function getControllerClass() -> string
    {
        return this->getHandlerClass();
    }

    /**
     * Returns the lastest dispatched controller
     *
     * @return \Scene\Mvc\ControllerInterface|null
     */
    public function getLastController() -> <ControllerInterface>
    {
        return this->_lastHandler;
    }

    /**
     * Returns the active controller in the dispatcher
     *
     * @return \Scene\Mvc\ControllerInterface|null
     */
    public function getActiveController() -> <ControllerInterface>
    {
        return this->_activeHandler;
    }
}
