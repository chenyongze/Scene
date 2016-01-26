
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

use Scene\Events\ManagerInterface;
use Scene\Events\EventsAwareInterface;

/**
 * Scene\Loader
 *
 * This component helps to load your project classes automatically based on some conventions
 *
 *<code>
 * //Creates the autoloader
 * $loader = new Loader();
 *
 * //Register some namespaces
 * $loader->registerNamespaces(array(
 *   'Example\Base' => 'vendor/example/base/',
 *   'Example\Adapter' => 'vendor/example/adapter/',
 *   'Example' => 'vendor/example/'
 * ));
 *
 * //register autoloader
 * $loader->register();
 *
 * //Requiring this class will automatically include file vendor/example/adapter/Some.php
 * $adapter = Example\Adapter\Some();
 *</code>
 */
class Loader implements EventsAwareInterface
{
    /**
     * Events Manager
     *
     * @var Scene\Events\ManagerInterface|null
     * @access protected
    */
    protected _eventsManager = null;

    /**
     * Found Path
     *
     * @var string|null
     * @access protected
    */
    protected _foundPath = null;

    /**
     * Checked Path
     *
     * @var string|null
     * @access protected
    */
    protected _checkedPath = null;

    /**
     * Classes
     *
     * @var array|null
     * @access protected
    */
    protected _classes = null;

    /**
     * Extensions
     *
     * @var array
     * @access protected
    */
    protected _extensions;

    /**
     * Namespaces
     *
     * @var array|null
     * @access protected
    */
    protected _namespaces = null;

    /**
     * Directories
     *
     * @var array|null
     * @access protected
    */
    protected _directories = null;

    /**
     * Registered
     *
     * @var boolean
     * @access protected
    */
    protected _registered = false;

    /**
     * Scene\Loader constructor
     */
    public function __construct()
    {
        let this->_extensions = ["php"];
    }

    /**
     * Sets the events manager
     *
     * @param \Scene\Events\ManagerInterface eventsManager
     * @throws \Scene\Loader\Exception
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
     * Sets an array of extensions that the loader must try in each attempt to locate the file
     *
     * @param array extensions
     * @return \Scene\Loader
     * @throws \Scene\Loader\Exception
     */
    public function setExtensions(array! extensions) -> <Loader>
    {
        let this->_extensions = extensions;
        return this;
    }

    /**
     * Return file extensions registered in the loader
     *
     * @return array
     */
    public function getExtensions() -> array
    {
        return this->_extensions;
    }

    /**
     * Register namespaces and their related directories
     *
     * @param array namespaces
     * @param boolean|null merge
     * @return \Scene\Loader
     * @throws \Scene\Loader\Exception
     */
    public function registerNamespaces(array! namespaces, boolean merge = false) -> <Loader>
    {
        var currentNamespaces, preparedNamespaces, name, paths;

        let preparedNamespaces = this->prepareNamespace(namespaces);

        if merge {
            let currentNamespaces = this->_namespaces;
            if typeof currentNamespaces == "array" {
                for name, paths in preparedNamespaces {
                    if !isset currentNamespaces[name] {
                        let currentNamespaces[name] = [];
                    }

                    let currentNamespaces[name] = array_merge(currentNamespaces[name], paths);
                }

                let this->_namespaces = currentNamespaces;
            } else {
                let this->_namespaces = preparedNamespaces;
            }
        } else {
            let this->_namespaces = preparedNamespaces;
        }

        return this;
    }

    /**
     * Prepare Namespace
     * 
     * @param  array namespaces
     * @return array
     */
    protected function prepareNamespace(array! namespaces) -> array
    {
        var localPaths, name, paths, prepared;

        let prepared = [];
        for name, paths in namespaces {
            if typeof paths != "array" {
                let localPaths = [paths];
            } else {
                let localPaths = paths;
            }

            let prepared[name] = localPaths;
        }

        return prepared;
    }

    /**
     * Return current namespaces registered in the autoloader
     *
     * @return array|null
     */
    public function getNamespaces() -> array
    {
        return this->_namespaces;
    }

    /**
     * Register directories on which "not found" classes could be found
     *
     * @param array directories
     * @param boolean|null merge
     * @return \Scene\Loader
     * @throws \Scene\Loader\Exception
     */
    public function registerDirs(array! directories, boolean merge = false) -> <Loader>
    {
        var currentDirectories, mergedDirectories;

        if merge {
            let currentDirectories = this->_directories;
            if typeof currentDirectories == "array" {
                let mergedDirectories = array_merge(currentDirectories, directories);
            } else {
                let mergedDirectories = directories;
            }
            let this->_directories = mergedDirectories;
        } else {
            let this->_directories = directories;
        }
        return this;
    }

    /**
     * Return current directories registered in the autoloader
     *
     * @return array|null
     */
    public function getDirs() -> array
    {
        return this->_directories;
    }

    /**
     * Register classes and their locations
     *
     * @param array classes
     * @param boolean|null merge
     * @return \Scene\Loader
     * @throws \Scene\Loader\Exception
     */
    public function registerClasses(array! classes, boolean merge = false) -> <Loader>
    {
        var mergedClasses, currentClasses;

        if merge {
            let currentClasses = this->_classes;
            if typeof currentClasses == "array" {
                let mergedClasses = array_merge(currentClasses, classes);
            } else {
                let mergedClasses = classes;
            }
            let this->_classes = mergedClasses;
        } else {
            let this->_classes = classes;
        }
        return this;
    }

    /**
     * Return the current class-map registered in the autoloader
     *
     * @return array|null
     */
    public function getClasses() -> array
    {
        return this->_classes;
    }

    /**
     * Register the autoload method
     *
     * @return \Scene\Loader
     */
    public function register() -> <Loader>
    {
        if this->_registered === false {
            spl_autoload_register([this, "autoLoad"]);
            let this->_registered = true;
        }
        return this;
    }

    /**
     * Unregister the autoload method
     *
     * @return \Scene\Loader
     */
    public function unregister() -> <Loader>
    {
        if this->_registered === true {
            spl_autoload_unregister([this, "autoLoad"]);
            let this->_registered = false;
        }
        return this;
    }

    /**
     * Makes the work of autoload registered classes
     *
     * @param string className
     * @return boolean
     */
    public function autoLoad(string! className) -> boolean
    {
        var eventsManager, classes, extensions, filePath, ds, fixedDirectory,
            directories, ns, namespaces, nsPrefix,
            directory, fileName, extension, nsClassName;

        let eventsManager = this->_eventsManager;
        if typeof eventsManager == "object" {
            eventsManager->fire("loader:beforeCheckClass", this, className);
        }

        /**
         * First we check for static paths for classes
         */
        let classes = this->_classes;
        if typeof classes == "array" {
            if fetch filePath, classes[className] {
                if typeof eventsManager == "object" {
                    let this->_foundPath = filePath;
                    eventsManager->fire("loader:pathFound", this, filePath);
                }
                require filePath;
                return true;
            }
        }

        let extensions = this->_extensions;

        let ds = DIRECTORY_SEPARATOR,
            ns = "\\";

        /**
         * Checking in namespaces
         */
        let namespaces = this->_namespaces;
        if typeof namespaces == "array" {

            for nsPrefix, directories in namespaces {

                /**
                 * The class name must start with the current namespace
                 */
                if starts_with(className, nsPrefix) {

                    /**
                     * Append the namespace separator to the prefix
                     */
                    let fileName = substr(className, strlen(nsPrefix . ns));
                    let fileName = str_replace(ns, ds, fileName);

                    if fileName {

                        for directory in directories {
                            /**
                             * Add a trailing directory separator if the user forgot to do that
                             */
                            let fixedDirectory = rtrim(directory, ds) . ds;

                            for extension in extensions {

                                let filePath = fixedDirectory . fileName . "." . extension;

                                /**
                                 * Check if a events manager is available
                                 */
                                if typeof eventsManager == "object" {
                                    let this->_checkedPath = filePath;
                                    eventsManager->fire("loader:beforeCheckPath", this);
                                }

                                /**
                                 * This is probably a good path, let's check if the file exists
                                 */
                                if is_file(filePath) {

                                    if typeof eventsManager == "object" {
                                        let this->_foundPath = filePath;
                                        eventsManager->fire("loader:pathFound", this, filePath);
                                    }

                                    /**
                                     * Simulate a require
                                     */
                                    require filePath;

                                    /**
                                     * Return true mean success
                                     */
                                    return true;
                                }
                            }
                        }
                    }
                }
            }
        }

        /**
         * Change the namespace separator by directory separator too
         */
        let nsClassName = str_replace("\\", ds, className);

        /**
         * Checking in directories
         */
        let directories = this->_directories;
        if typeof directories == "array" {

            for directory in directories {

                /**
                 * Add a trailing directory separator if the user forgot to do that
                 */
                let fixedDirectory = rtrim(directory, ds) . ds;

                for extension in extensions {

                    /**
                     * Create a possible path for the file
                     */
                    let filePath = fixedDirectory . nsClassName . "." . extension;

                    if typeof eventsManager == "object" {
                        let this->_checkedPath = filePath;
                        eventsManager->fire("loader:beforeCheckPath", this, filePath);
                    }

                    /**
                     * Check in every directory if the class exists here
                     */
                    if is_file(filePath) {

                        /**
                         * Call 'pathFound' event
                         */
                        if typeof eventsManager == "object" {
                            let this->_foundPath = filePath;
                            eventsManager->fire("loader:pathFound", this, filePath);
                        }

                        /**
                         * Simulate a require
                         */
                        require filePath;

                        /**
                         * Return true meaning success
                         */
                        return true;
                    }
                }
            }
        }

        /**
         * Call 'afterCheckClass' event
         */
        if typeof eventsManager == "object" {
            eventsManager->fire("loader:afterCheckClass", this, className);
        }

        /**
         * Cannot find the class, return false
         */
        return false;
    }

    /**
     * Get the path when a class was found
     *
     * @return string|null
     */
    public function getFoundPath() -> string
    {
        return this->_foundPath;
    }

    /**
     * Get the path the loader is checking for a path
     *
     * @return string|null
     */
    public function getCheckedPath() -> string
    {
        return this->_checkedPath;
    }
}
