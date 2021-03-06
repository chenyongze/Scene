
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

namespace Scene\Session;

use Scene\Di;
use Scene\DiInterface;
use Scene\Di\InjectionAwareInterface;

/**
 * Scene\Session\Bag
 *
 * This component helps to separate session data into "namespaces". Working by this way
 * you can easily create groups of session variables into the application
 *
 *<code>
 *  $user = new \Scene\Session\Bag('user');
 *  $user->name = "Kimbra Johnson";
 *  $user->age  = 22;
 *</code>
 */
class Bag implements InjectionAwareInterface, BagInterface, \IteratorAggregate, \ArrayAccess, \Countable
{

    /**
     * Dependency Injector
     *
     * @var null|\Scene\DiInterface
     * @access protected
    */
    protected _dependencyInjector;

    /**
     * Name
     *
     * @var null|string
     * @access protected
    */
    protected _name;

    /**
     * Data
     *
     * @var null|array
     * @access protected
    */
    protected _data;

    /**
     * Initialized
     *
     * @var boolean
     * @access protected
    */
    protected _initialized = false;

    /**
     * Session
     *
     * @var null|\Scene\Session\Adapter
     * @access protected
    */
    protected _session;

    /**
     * Scene\Session\Bag constructor
     */
    public function __construct(string! name)
    {
        let this->_name = name;
    }

    /**
     * Sets the DependencyInjector container
     */
    public function setDI(<DiInterface> dependencyInjector)
    {
        let this->_dependencyInjector = dependencyInjector;
    }

    /**
     * Returns the DependencyInjector container
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
     * Initializes the session bag. This method must not be called directly, the class calls it when its internal data is accesed
     */
    public function initialize()
    {
        var session, dependencyInjector, data;

        let session = this->_session;
        if typeof session != "object" {

            let dependencyInjector = this->_dependencyInjector;
            if typeof dependencyInjector != "object" {
                let dependencyInjector = Di::getDefault();
            }

            let session = dependencyInjector->getShared("session"),
                this->_session = session;
        }

        let data = session->get(this->_name);
        if typeof data != "array" {
            let data = [];
        }

        let this->_data = data;
        let this->_initialized = true;
    }

    /**
     * Destroyes the session bag
     *
     *<code>
     * $user->destroy();
     *</code>
     */
    public function destroy()
    {
        if this->_initialized === false {
            this->initialize();
        }
        let this->_data = [];
        this->_session->remove(this->_name);
    }

    /**
     * Sets a value in the session bag
     *
     *<code>
     * $user->set('name', 'Kimbra');
     *</code>
     */
    public function set(string! property, var value)
    {
        if this->_initialized === false {
            this->initialize();
        }

        let this->_data[property] = value;
        this->_session->set(this->_name, this->_data);
    }

    /**
     * Magic setter to assign values to the session bag
     *
     *<code>
     * $user->name = "Kimbra";
     *</code>
     */
    public function __set(string! property, var value)
    {
        this->set(property, value);
    }

    /**
     * Obtains a value from the session bag optionally setting a default value
     *
     *<code>
     * echo $user->get('name', 'Kimbra');
     *</code>
     */
    public function get(string! property, var defaultValue = null) -> var
    {
        var value;

        /**
         * Check first if the bag is initialized
         */
        if this->_initialized === false {
            this->initialize();
        }

        /**
         * Retrieve the data
         */
        if fetch value, this->_data[property] {
            return value;
        }

        return defaultValue;
    }

    /**
     * Magic getter to obtain values from the session bag
     *
     *<code>
     * echo $user->name;
     *</code>
     */
    public function __get(string! property) -> var
    {
        return this->get(property);
    }

    /**
     * Check whether a property is defined in the internal bag
     *
     *<code>
     * var_dump($user->has('name'));
     *</code>
     */
    public function has(string! property) -> boolean
    {
        if this->_initialized === false {
            this->initialize();
        }

        return isset this->_data[property];
    }

    /**
     * Magic isset to check whether a property is defined in the bag
     *
     *<code>
     * var_dump(isset($user['name']));
     *</code>
     */
    public function __isset(string! property) -> boolean
    {
        return this->has(property);
    }

    /**
     * Removes a property from the internal bag
     *
     *<code>
     * $user->remove('name');
     *</code>
     */
    public function remove(string! property) -> boolean
    {
        var data;

        let data = this->_data;
        if isset data[property] {
            unset data[property];
            this->_session->set(this->_name, data);
            let this->_data = data;
            return true;
        }

        return false;
    }

    /**
     * Magic unset to remove items using the array syntax
     *
     *<code>
     * unset($user['name']);
     *</code>
     */
    public function __unset(string! property) -> boolean
    {
        return this->remove(property);
    }

    /**
     * Return length of bag
     *
     *<code>
     * echo $user->count();
     *</code>
     *
     * @return int
     */
    public final function count() -> int
    {
        if this->_initialized === false {
            this->initialize();
        }
        return count(this->_data);
    }

    /**
     * Returns the bag iterator
     *
     * @return \ArrayIterator
     */
    public final function getIterator() -> <\ArrayIterator>
    {
        if this->_initialized === false {
            this->initialize();
        }

        return new \ArrayIterator(this->_data);
    }

    /**
     * @param string property
     * @param mixed value
     */
    public final function offsetSet(string! property, var value)
    {
        return this->set(property, value);
    }

    /**
     * @param string property
     */
    public final function offsetExists(string! property) -> boolean
    {
        return this->has(property);
    }

    /**
     * @param string property
     */
    public final function offsetUnset(string! property)
    {
        return this->remove(property);
    }

    /**
     * @param string property
     */
    public final function offsetGet(string! property) -> var
    {
        return this->get(property);
    }
}
