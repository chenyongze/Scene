
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

use Scene\Mvc\Router\RouteInterface;
use Scene\Mvc\Router\GroupInterface;

/**
 * Scene\Mvc\RouterInterface
 *
 * Interface for Scene\Mvc\Router
 */
interface RouterInterface
{

    /**
     * Sets the name of the default module
     *
     * @param string moduleName
     */
    public function setDefaultModule(string! moduleName) -> void;

    /**
     * Sets the default controller name
     *
     * @param string controllerName
     */
    public function setDefaultController(string! controllerName) -> void;

    /**
     * Sets the default action name
     *
     * @param string actionName
     */
    public function setDefaultAction(string! actionName) -> void;

    /**
     * Sets an array of default paths
     *
     * @param array defaults
     */
    public function setDefaults(array! defaults) -> void;

    /**
     * Handles routing information received from the rewrite engine
     *
     * @param string|null uri
     */
    public function handle(string uri = null) -> void;

    /**
     * Adds a route to the router on any HTTP method
     *
     * @param string pattern
     * @param mixed paths
     * @param string|null httpMethods
     * @return \Scene\Mvc\Router\RouteInterface
     */
    public function add(string! pattern, var paths = null, var httpMethods = null) -> <RouteInterface>;

    /**
     * Adds a route to the router that only match if the HTTP method is GET
     *
     * @param string pattern
     * @param mixed paths
     * @return \Scene\Mvc\Router\RouteInterface
     */
    public function addGet(string! pattern, var paths = null) -> <RouteInterface>;

    /**
     * Adds a route to the router that only match if the HTTP method is POST
     *
     * @param string pattern
     * @param mixed paths
     * @return \Scene\Mvc\Router\RouteInterface
     */
    public function addPost(string! pattern, var paths = null) -> <RouteInterface>;

    /**
     * Adds a route to the router that only match if the HTTP method is PUT
     *
     * @param string pattern
     * @param mixed paths
     * @return \Scene\Mvc\Router\RouteInterface
     */
    public function addPut(string! pattern, var paths = null) -> <RouteInterface>;

    /**
     * Adds a route to the router that only match if the HTTP method is PATCH
     *
     * @param string pattern
     * @param mixed paths
     * @return \Scene\Mvc\Router\RouteInterface
     */
    public function addPatch(string! pattern, paths = null) -> <RouteInterface>;

    /**
     * Adds a route to the router that only match if the HTTP method is DELETE
     *
     * @param string pattern
     * @param mixed paths
     * @return \Scene\Mvc\Router\RouteInterface
     */
    public function addDelete(string! pattern, var paths = null) -> <RouteInterface>;

    /**
     * Add a route to the router that only match if the HTTP method is OPTIONS
     *
     * @param string pattern
     * @param mixed paths
     * @return \Scene\Mvc\Router\RouteInterface
     */
    public function addOptions(string! pattern, var paths = null) -> <RouteInterface>;

    /**
     * Adds a route to the router that only match if the HTTP method is HEAD
     *
     * @param string pattern
     * @param mixed paths
     * @return \Scene\Mvc\Router\RouteInterface
     */
    public function addHead(string! pattern, var paths = null) -> <RouteInterface>;

    /**
     * Mounts a group of routes in the router
     *
     * @param \Scene\Mvc\Router\RouteInterface group
     * @return \Scene\Mvc\Router\RouteInterface
     */
    public function mount(<GroupInterface> group) -> <RouterInterface>;

    /**
     * Removes all the defined routes
     */
    public function clear() -> void;

    /**
     * Returns processed module name
     *
     * @return string
     */
    public function getModuleName() -> string;

    /**
     * Returns processed namespace name
     *
     * @return string
     */
    public function getNamespaceName() -> string;

    /**
     * Returns processed controller name
     *
     * @return string
     */
    public function getControllerName() -> string;

    /**
     * Returns processed action name
     *
     * @return string
     */
    public function getActionName() -> string;

    /**
     * Returns processed extra params
     *
     * @return array
     */
    public function getParams() -> array;

    /**
     * Returns the route that matchs the handled URI
     *
     * @return \Scene\Mvc\Router\RouteInterface
     */
    public function getMatchedRoute();

    /**
     * Return the sub expressions in the regular expression matched
     * 
     * @return array
     */
    public function getMatches() -> array;

    /**
     * Check if the router macthes any of the defined routes
     *
     * @return bool
     */
    public function wasMatched() -> boolean;

    /**
     * Return all the routes defined in the router
     *
     * @return \Scene\Mvc\Router\RouteInterface[]
     */
    public function getRoutes() -> <RouteInterface[]>;

    /**
     * Returns a route object by its id
     *
     * @param mixed id
     * @return \Scene\Mvc\Router\RouteInterface
     */
    public function getRouteById(var id) -> <RouteInterface>;

    /**
     * Returns a route object by its name
     *
     * @param string name
     * @return \Scene\Mvc\Router\RouteInterface
     */
    public function getRouteByName(string! name) -> <RouteInterface>;
}
