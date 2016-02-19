
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

use Scene\Application\Exception;
use Scene\DiInterface;
use Scene\Di\Injectable;

/**
 * Scene\Application
 *
 * Base class for Scene\Cli\Console and Scene\Mvc\Application.
 */
abstract class Application extends Injectable
{

	/**
     * Default Module
     *
     * @var null|string
     * @access protected
     */
    protected _defaultModule;

    /**
     * Modules
     *
     * @var null|array
     * @access protected
     */
    protected _modules;

    /**
     * Scene\Mvc\Application
     *
     * @param \Scene\DiInterface|null $dependencyInjector
     */
    public function __construct(<DiInterface> dependencyInjector = null)
    {
        if typeof dependencyInjector == "object" {
            let this->_dependencyInjector = dependencyInjector;
        }
    }

    /**
     * Register an array of modules present in the application
     *
     *<code>
     *  $this->registerModules(array(
     *      'frontend' => array(
     *          'className' => 'Multiple\Frontend\Module',
     *          'path' => '../apps/frontend/Module.php'
     *      ),
     *      'backend' => array(
     *          'className' => 'Multiple\Backend\Module',
     *          'path' => '../apps/backend/Module.php'
     *      )
     *  ));
     *</code>
     *
     * @param array modules
     * @param boolean merge
     * @return \Scene\Application
     */
    public function registerModules(array modules, boolean merge = false) -> <Application>
    {
        var registeredModules;

        if merge === false {
            let this->_modules = modules;
        } else {
            let registeredModules = this->_modules;
            if typeof registeredModules == "array" {
                let this->_modules = array_merge(registeredModules, modules);
            } else {
                let this->_modules = modules;
            }
        }

        return this;
    }

    /**
     * Return the modules registered in the application
     *
     * @return array
     */
    public function getModules()
    {
        return this->_modules;
    }

    /**
     * Gets the module definition registered in the application via module name
     *
     * @param string name
     * @return array|object
     */
    public function getModule(string! name)
    {
        var module;

        if !fetch module, this->_modules[name] {
            throw new Exception("Module '" . name . "' isn't registered in the application container");
        }

        return module;
    }

    /**
     * Sets the module name to be used if the router doesn't return a valid module
     *
     * @param string defaultModule
     * @return \Scene\Application
     */
    public function setDefaultModule(string! defaultModule) -> <Application>
    {
        let this->_defaultModule = defaultModule;
        return this;
    }

    /**
     * Returns the default module name
     */
    public function getDefaultModule() -> string
    {
        return this->_defaultModule;
    }

    /**
     * Handles a request
     */
    abstract public function handle();
}
