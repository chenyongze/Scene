
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

namespace Scene\Mvc;

use Scene\Mvc\ControllerInterface;
use Scene\DispatcherInterface as DispatcherInterfaceBase;

/**
 * Scene\Mvc\DispatcherInterface
 *
 * Interface for Scene\Mvc\Dispatcher
 */
interface DispatcherInterface extends DispatcherInterfaceBase
{

    /**
     * Sets the default controller suffix
     *
     * @param string controllerSuffix
     */
    public function setControllerSuffix(string! controllerSuffix);

    /**
     * Sets the default controller name
     *
     * @param string controllerName
     */
    public function setDefaultController(string! controllerName);

    /**
     * Sets the controller name to be dispatched
     *
     * @param string $controllerName
     */
    public function setControllerName(string! controllerName);

    /**
     * Gets last dispatched controller name
     *
     * @return string
     */
    public function getControllerName() -> string;

    /**
     * Returns the lastest dispatched controller
     *
     * @return \Scene\Mvc\ControllerInterface
     */
    public function getLastController() -> <ControllerInterface>;

    /**
     * Returns the active controller in the dispatcher
     *
     * @return \Scene\Mvc\ControllerInterface
     */
    public function getActiveController() -> <ControllerInterface>;
}
