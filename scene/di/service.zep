
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

use Scene\DiInterface;
use Scene\Di\Exception;
use Scene\Di\ServiceInterface;
use Scene\Di\Service\Builder;

/**
 * Scene\Di\Service
 *
 * Represents individually a service in the services container
 *
 *<code>
 * $service = new Scene\Di\Service('request', 'Scene\Http\Request');
 * $request = $service->resolve();
 *<code>
 *
 */
class Service implements ServiceInterface
{
    /**
     * Name
     *
     * @var null|string
     * @access protected
    */
    protected _name;

    /**
     * Definiton
     *
     * @var mixed
     * @access protected
    */
    protected _definition;

    /**
     * Shared
     *
     * @var null|boolean
     * @access protected
    */
    protected _shared = false;

    /**
     * Resolved
     *
     * @var null|boolean
     * @access protected
    */
    protected _resolved = false;

    /**
     * Shared Instance
     *
     * @var null|object
     * @access protected
    */
    protected _sharedInstance;

    /**
     * \Scene\DI\Service
     *
     * @param string! $name
     * @param mixed $definition
     * @param boolean|null $shared
     * @throws Exception
     */
    public final function __construct(string! name, definition, boolean shared = false)
    {
        let this->_name = name,
            this->_definition = definition,
            this->_shared = shared;
    }

    /**
     * Returns the service's name
     *
     * @return string
     */
    public function getName() -> string
    {
        return this->_name;
    }

    /**
     * Sets if the service is shared or not
     *
     * @param boolean $shared
     * @throws Exception
     */
    public function setShared(boolean shared) -> void
    {
        let this->_shared = shared;
    }

    /**
     * Check whether the service is shared or not
     *
     * @return boolean
     */
    public function isShared() -> boolean
    {
        return this->_shared;
    }

    /**
     * Sets/Resets the shared instance related to the service
     *
     * @param object $sharedInstance
     * @throws Exception
     */
    public function setSharedInstance(sharedInstance) -> void
    {
        let this->_sharedInstance = sharedInstance;
    }

    /**
     * Set the service definition
     *
     * @param mixed definition
     */
    public function setDefinition(definition) -> void
    {
        let this->_definition = definition;
    }

    /**
     * Returns the service definition
     *
     * @return mixed
     */
    public function getDefinition()
    {
        return this->_definition;
    }

    /**
     * Resolves the service
     *
     * @param array|null $parameters
     * @param \Scene\DiInterface|null $dependencyInjector
     * @return mixed
     * @throws Exception
     */
    public function resolve(parameters = null, <DiInterface> dependencyInjector = null)
    {
        boolean found;
        var shared, definition, sharedInstance, reflection, instance, builder;

        let shared = this->_shared;

        /**
         * Check if the service is shared
         */
        if shared {
            let sharedInstance = this->_sharedInstance;
            if sharedInstance !== null {
                return sharedInstance;
            }
        }

        let found = true,
            instance = null;

        let definition = this->_definition;
        if typeof definition == "string" {

            /**
             * String definitions can be class names without implicit parameters
             */
            if class_exists(definition) {
                if typeof parameters == "array" {
                    if count(parameters) {
                        let reflection = new \ReflectionClass(definition);
                        let instance = reflection->newInstanceArgs(parameters);
                    } else {
                        let reflection = new \ReflectionClass(definition);
                        let instance = $reflection->newInstance();
                    }
                } else {
                    let reflection = new \ReflectionClass(definition);
                    let instance = $reflection->newInstance();
                }
            } else {
                let found = false;
            }
        } else {

            /**
             * Object definitions can be a Closure or an already resolved instance
             */
            if typeof definition == "object" {
                if definition instanceof \Closure {
                    
                    /**
                     * Bounds the closure to the current DI
                     */
                    if typeof dependencyInjector == "object" {
                        let definition = \Closure::bind(definition, dependencyInjector);
                    }

                    if typeof parameters == "array" {
                        let instance = call_user_func_array(definition, parameters);
                    } else {
                        let instance = call_user_func(definition);
                    }
                } else {
                    let instance = definition;
                }
            } else {
                /**
                 * Array definitions require a 'className' parameter
                 */
                if typeof definition == "array" {
                    let builder = new Builder(),
                        instance = builder->build(dependencyInjector, definition, parameters);
                } else {
                    let found = false;
                }
            }
        }

        /**
         * If the service can't be built, we must throw an exception
         */
        if found === false  {
            throw new Exception("Service '" . this->_name . "' cannot be resolved");
        }

        /**
         * Update the shared instance if the service is shared
         */
        if shared {
            let this->_sharedInstance = instance;
        }

        let this->_resolved = true;

        return instance;
    }

    /**
     * Changes a parameter in the definition without resolve the service
     *
     * @param int $position
     * @param array $parameter
     * @return \Scene\DI\ServiceInterface
     * @throws Exception
     */
    public function setParameter(int position, array! parameter) -> <ServiceInterface>
    {
        var definition, arguments;

        let definition = this->_definition;
        if typeof definition != "array" {
            throw new Exception("Definition must be an array to update its parameters");
        }

        /**
         * Update the parameter
         */
        if fetch arguments, definition["arguments"] {
            let arguments[position] = parameter;
        } else {
            let arguments = [position: parameter];
        }

        /**
         * Re-update the arguments
         */
        let definition["arguments"] = arguments;

        /**
         * Re-update the definition
         */
        let this->_definition = definition;

        return this;
    }

    /**
     * Returns a parameter in a specific position
     *
     * @param int $position
     * @return array|null
     * @throws Exception
     */
    public function getParameter(int position)
    {
        var definition, arguments, parameter;

        let definition = this->_definition;
        if typeof definition != "array" {
            throw new Exception("Definition must be an array to obtain its parameters");
        }

        /**
         * Update the parameter
         */
        if fetch arguments, definition["arguments"] {
            if fetch parameter, arguments[position] {
                return parameter;
            }
        }

        return null;
    }

    /**
     * Returns true if the service was resolved
     */
    public function isResolved() -> boolean
    {
        return this->_resolved;
    }

    /**
     * Restore the internal state of a service
     *
     * @param array $attributes
     * @return \Scene\DI\ServiceInterface
     * @throws Exception
     */
    public static function __set_state(array! attributes) -> <ServiceInterface>
    {
        var name, definition, shared;

        if !fetch name, attributes["_name"] {
            throw new Exception("The attribute '_name' is required");
        }

        if !fetch definition, attributes["_definition"] {
            throw new Exception("The attribute '_definition' is required");
        }

        if !fetch shared, attributes["_shared"] {
            throw new Exception("The attribute '_shared' is required");
        }

        return new self(name, definition, shared);
    }
}
