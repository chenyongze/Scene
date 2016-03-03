
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

namespace Scene\Di;

use Scene\Di;
use Scene\DiInterface;
use Scene\Di\InjectionAwareInterface;
use Scene\Di\Exception;
use Scene\Events\ManagerInterface;
use Scene\Events\EventsAwareInterface;
use Scene\Session\BagInterface;

/**
 * Scene\Di\Injectable
 *
 * This class allows to access services in the services container by just only accessing a public property
 * with the same name of a registered service
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
     * @param \Scene\DiInterface dependencyInjector
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
     * @param \Scene\Events\ManagerInterface eventsManager
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
     * @param string propertyName
     * @return mixed
     */
    public function __get(string! propertyName)
    {
        var dependencyInjector, service, persistent;

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
        if propertyName == "persistent" {
            let persistent = <BagInterface> dependencyInjector->get("sessionBag", [get_class(this)]),
                this->{"persistent"} = persistent;
            return persistent;
        }
        
        /**
         * A notice is shown if the property is not defined and isn't a valid service
         */
        trigger_error("Access to undefined property " . propertyName);
        return null;
    }
}
