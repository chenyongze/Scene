
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
use Scene\Di\ServiceInterface;

/**
 * Scene\DiInterface
 *
 * Interface for Scene\Di
 */
interface DiInterface extends \ArrayAccess
{

    /**
     * Registers a service in the services container
     *
     * @param string name
     * @param mixed definition
     * @param boolean shared
     * @return \Scene\Di\ServiceInterface
     */
    public function set(string! name, definition, boolean shared = false) -> <ServiceInterface>;

    /**
     * Registers an "always shared" service in the services container
     *
     * @param string name
     * @param mixed definition
     * @return \Scene\Di\ServiceInterface
     */
    public function setShared(string! name, definition) -> <ServiceInterface>;

    /**
     * Removes a service in the services container
     *
     * @param string! $name
     */
    public function remove(string! name);

    /**
     * Attempts to register a service in the services container
     * Only is successful if a service hasn't been registered previously
     * with the same name
     *
     * @param string name
     * @param mixed definition
     * @param boolean shared
     * @return \Scene\Di\ServiceInterface
     */
    public function attempt(string! name, definition, boolean shared = false) -> <ServiceInterface>;

    /**
     * Resolves the service based on its configuration
     *
     * @param string name
     * @param array parameters
     * @return mixed
     */
    public function get(string! name, parameters = null);

    /**
     * Returns a shared service based on their configuration
     *
     * @param string name
     * @param array parameters
     * @return mixed
     */
    public function getShared(string! name, parameters = null);

    /**
     * Sets a service using a raw \Scene\DI\Service definition
     *
     * @param string! $name
     * @param \Scene\DI\ServiceInterface $rawDefinition
     * @return \Scene\DI\ServiceInterface
     */
    public function setRaw(string! name, <ServiceInterface> rawDefinition) -> <ServiceInterface>;

    /**
     * Returns a service definition without resolving
     *
     * @param string name
     * @return mixed
     */
    public function getRaw(string! name);

    /**
     * Returns the corresponding \Scene\Di\Service instance for a service
     *
     * @param string! $name
     * @return \Scene\DI\ServiceInterface
     */
    public function getService(string! name) -> <ServiceInterface>;

    /**
     * Check whether the DI contains a service by a name
     *
     * @param string! $name
     * @return boolean
     */
    public function has(string! name) -> boolean;

    /**
     * Check whether the last service obtained via getShared produced a fresh instance or an existing one
     *
     * @return boolean
     */
    public function wasFreshInstance() -> boolean;

    /**
     * Return the services registered in the DI
     *
     * @return \Scene\Di\ServiceInterface[]
     */
    public function getServices();

     /**
     * Set a default dependency injection container to be obtained into static methods
     *
     * @param \Scene\DiInterface $dependencyInjector
     */
    public static function setDefault(<DiInterface> dependencyInjector);

    /**
     * Return the last DI created
     *
     * @return \Scene\DiInterface
     */
    public static function getDefault() -> <DiInterface>;

    /**
     * Resets the internal default DI
     */
    public static function reset();
}