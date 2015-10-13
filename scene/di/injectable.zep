
namespace Scene\Di;

use Scene\Di;
use Scene\DiInterface;
use Scene\Events\ManagerInterface;
use Scene\Di\InjectionAwareInterface;
use Scene\Events\EventsAwareInterface;
use Scene\Di\Exception;
//use Scene\Session\BagInterface;

/**
 * Scene\Di\Injectable
 *
 * This class allows to access services in the services container by just only accessing a public property
 * with the same name of a registered service
 *
 * @property \Scene\Mvc\Dispatcher|\Scene\Mvc\DispatcherInterface $dispatcher;
 * @property \Scene\Mvc\Router|\Scene\Mvc\RouterInterface $router
 * @property \Scene\Mvc\Url|\Scene\Mvc\UrlInterface $url
 * @property \Scene\Http\Request|\Scene\HTTP\RequestInterface $request
 * @property \Scene\Http\Response|\Scene\HTTP\ResponseInterface $response
 * @property \Scene\Http\Response\Cookies|\Scene\Http\Response\CookiesInterface $cookies
 * @property \Scene\Filter|\Scene\FilterInterface $filter
 * @property \Scene\Flash\Direct $flash
 * @property \Scene\Flash\Session $flashSession
 * @property \Scene\Session\Adapter\Files|\Scene\Session\Adapter|\Scene\Session\AdapterInterface $session
 * @property \Scene\Events\Manager $eventsManager
 * @property \Scene\Db\AdapterInterface $db
 * @property \Scene\Security $security
 * @property \Scene\Crypt $crypt
 * @property \Scene\Tag $tag
 * @property \Scene\Escaper|\Scene\EscaperInterface $escaper
 * @property \Scene\Annotations\Adapter\Memory|\Scene\Annotations\Adapter $annotations
 * @property \Scene\Mvc\Model\Manager|\Scene\Mvc\Model\ManagerInterface $modelsManager
 * @property \Scene\Mvc\Model\MetaData\Memory|\Scene\Mvc\Model\MetadataInterface $modelsMetadata
 * @property \Scene\Mvc\Model\Transaction\Manager $transactionManager
 * @property \Scene\Assets\Manager $assets
 * @property \Scene\Di|\Scene\DiInterface $di
 * @property \Scene\Session\Bag $persistent
 * @property \Scene\Mvc\View|\Scene\Mvc\ViewInterface $view
 */
abstract class Injectable implements InjectionAwareInterface, EventsAwareInterface
{

    /**
     * Dependency Injector
     *
     * @var null|Scene\DiInterface
     * @access protected
    */
    protected _dependencyInjector;

    /**
     * Events Manager
     *
     * @var null|Scene\Events\ManagerInterface
     * @access protected
    */
    protected _eventsManager;

    /**
     * Sets the dependency injector
     *
     * @param \Scene\DiInterface $dependencyInjector
     * @throws Exception
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
        var dependencyInjector;

        let dependencyInjector = this->_dependencyInjector;
        if typeof dependencyInjector != "object" {
            let dependencyInjector = Di::getDefault();
        }
        return dependencyInjector;
    }

    /**
     * Sets the event manager
     *
     * @param \Scene\Events\ManagerInterface $eventsManager
     * @throws Exception
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
     * Magic method __get
     *
     * @param string $propertyName
     * @return mixed
     */
    public function __get(string! propertyName)
    {
        var dependencyInjector, service;
        //var persistent;

        let dependencyInjector = <DiInterface> this->_dependencyInjector;
        if typeof dependencyInjector != "object" {
            let dependencyInjector = Di::getDefault();
            if typeof dependencyInjector != "object" {
                throw new Exception("A dependency injection object is required to access the application services");
            }
        }

        /**
         * Fallback to the PHP userland if the cache is not available
         */
        if dependencyInjector->has(propertyName) {
            let service = dependencyInjector->getShared(propertyName);
            let this->{propertyName} = service;
            return service;
        }

        if propertyName == "di" {
            let this->{"di"} = dependencyInjector;
            return dependencyInjector;
        }

        /**
         * Accessing the persistent property will create a session bag on any class
         */
        /*
        if propertyName == "persistent" {
            let persistent = <BagInterface> dependencyInjector->get("sessionBag", [get_class(this)]),
                this->{"persistent"} = persistent;
            return persistent;
        }
        */
        /**
         * A notice is shown if the property is not defined and isn't a valid service
         */
        trigger_error("Access to undefined property " . propertyName);
        return null;
    }
}
