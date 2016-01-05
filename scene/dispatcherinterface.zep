
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

/**
 * Scene\DispatcherInterface
 *
 * Interface for Scene\Dispatcher
 */
interface DispatcherInterface
{

    /**
     * Sets the default action suffix
     *
     * @param string actionSuffix
     */
    public function setActionSuffix(string actionSuffix);

    /**
     * Sets the default namespace
     *
     * @param string namespace
     */
    public function setDefaultNamespace(string defaultNamespace);

    /**
     * Sets the default action name
     *
     * @param string actionName
     */
    public function setDefaultAction(string actionName);

    /**
     * Sets the namespace which the controller belongs to
     *
     * @param string namespaceName
     */
    public function setNamespaceName(string namespaceName);

    /**
     * Sets the module name which the application belongs to
     *
     * @param string moduleName
     */
    public function setModuleName(string moduleName);

    /**
     * Sets the action name to be dispatched
     *
     * @param string actionName
     */
    public function setActionName(string actionName);

    /**
     * Gets last dispatched action name
     *
     * @return string
     */
    public function getActionName() -> string;

    /**
     * Sets action params to be dispatched
     *
     * @param array params
     */
    public function setParams(params);

    /**
     * Gets action params
     *
     * @return array
     */
    public function getParams() -> array;

    /**
     * Set a param by its name or numeric index
     *
     * @param  mixed param
     * @param  mixed value
     */
    public function setParam(param, value);

    /**
     * Gets a param by its name or numeric index
     *
     * @param  mixed param
     * @param  string|array filters
     * @return mixed
     */
    public function getParam(param, filters = null);

    /**
     * Checks if the dispatch loop is finished or has more pendent controllers/tasks to dispatch
     *
     * @return boolean
     */
    public function isFinished() -> boolean;

    /**
     * Returns value returned by the lastest dispatched action
     *
     * @return mixed
     */
    public function getReturnedValue();

    /**
     * Dispatches a handle action taking into account the routing parameters
     *
     * @return object
     */
    public function dispatch();

    /**
     * Forwards the execution flow to another controller/action
     *
     * @param array forward
     */
    public function forward(forward);
}
