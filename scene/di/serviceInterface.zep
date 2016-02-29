
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

/**
 * Scene\Di\ServiceInterface initializer
 *
 * Represents a service in the services container
 */
interface ServiceInterface
{

    /**
     * Returns the service's name
     *
     * @param string
     */
    public function getName();

     /**
     * Sets if the service is shared or not
     *
     * @param boolean shared
     */
    public function setShared(boolean shared);

    /**
     * Check whether the service is shared or not
     *
     * @return boolean
     */
    public function isShared() -> boolean;

    /**
     * Set the service definition
     *
     * @param mixed definition
     */
    public function setDefinition(definition);

    /**
     * Returns the service definition
     *
     * @return mixed
     */
    public function getDefinition();

    /**
     * Resolves the service
     *
     * @param array parameters
     * @param \Scene\DiInterface|null $dependencyInjector
     * @return mixed
     */
    public function resolve(parameters = null, <DiInterface> dependencyInjector = null);

    /**
     * Changes a parameter in the definition without resolve the service
     *
     * @param int position
     * @param  array paramter
     * @return  \Scene\Di\ServiceInterface
     */
    public function setParameter(int position, array! parameter) -> <ServiceInterface>;

    /**
     * Restore the interal state of a service
     *
     * @param array attributes
     * @return \Scene\Di\ServiceInterface
     */
    public static function __set_state(array! attributes) -> <ServiceInterface>;

}