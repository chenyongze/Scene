
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
 * Scene\DI\InjectionAwareInterface initializer
 * 
 * This interface must be implemented in those classes that uses internally the Scene\Di that creates them
 */
interface InjectionAwareInterface
{
    /**
     * Sets the dependency injector
     *
     * @param \Scene\DiInterface dependencyInjector
     */
    public function setDI(<DiInterface> dependencyInjector);

    /**
     * Returns the internal dependency injector
     *
     * @return \Scene\DiInterface
     */
    public function getDI() -> <DiInterface>;
}
