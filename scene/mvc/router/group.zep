
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

namespace Scene\Mvc\Router;

use Scene\Mvc\Router\Route;

/**
 * Scene\Mvc\Router\Group
 *
 * Helper class to create a group of routes with common attributes
 *
 *<code>
 * $router = new \Scene\Mvc\Router();
 *
 * //Create a group with a common module and controller
 * $blog = new Group(array(
 *  'module' => 'blog',
 *  'controller' => 'index'
 * ));
 *
 * //All the routes start with /blog
 * $blog->setPrefix('/blog');
 *
 * //Add a route to the group
 * $blog->add('/save', array(
 *  'action' => 'save'
 * ));
 *
 * //Add another route to the group
 * $blog->add('/edit/{id}', array(
 *  'action' => 'edit'
 * ));
 *
 * //This route maps to a controller different than the default
 * $blog->add('/blog', array(
 *  'controller' => 'about',
 *  'action' => 'index'
 * ));
 *
 * //Add the group to the router
 * $router->mount($blog);
 *</code>
 *
 */
class Group implements GroupInterface
{

    /**
     * Prefix
     *
     * @var null|string
     * @access protected
    */
    protected _prefix;

    /**
     * Hostname
     *
     * @var null|string
     * @access protected
    */
    protected _hostname;

    /**
     * Paths
     *
     * @var null|array|string
     * @access protected
    */
    protected _paths;

    /**
     * Routes
     *
     * @var null|array
     * @access protected
    */
    protected _routes;

    /**
     * Before Match
     *
     * @var null|string
     * @access protected
    */
    protected _beforeMatch;

    /**
     * \Scene\Mvc\Router\Group constructor
     *
     * @param array|null paths
     */
    public function __construct(var paths = null)
    {
        if typeof paths == "array" || typeof paths == "string" {
            let this->_paths = paths;
        }

        if method_exists(this, "initialize") {
            this->{"initialize"}(paths);
        }
    }

    /**
     * Set a hostname restriction for all the routes in the group
     *
     * @param string hostname
     * @return \Scene\Mvc\Router\GroupInterface
     */
    public function setHostname(string hostname) -> <GroupInterface>
    {
        let this->_hostname = hostname;
        return this;
    }

    /**
     * Returns the hostname restriction
     *
     * @return string|null
     */
    public function getHostname() -> string
    {
        return this->_hostname;
    }

    /**
     * Set a common uri prefix for all the routes in this group
     *
     * @param string prefix
     * @return \Scene\Mvc\Router\GroupInterface
     */
    public function setPrefix(string prefix) -> <GroupInterface>
    {
        let this->_prefix = prefix;
        return this;
    }

    /**
     * Returns the common prefix for all the routes
     */
    public function getPrefix() -> string
    {
        return this->_prefix;
    }

    /**
     * Sets a callback that is called if the route is matched.
     * The developer can implement any arbitrary conditions here
     * If the callback returns false the route is treated as not matched
     *
     * @param callable string prefix
     * @return \Scene\Mvc\Router\GroupInterface
     */
     public function beforeMatch(callable beforeMatch) -> <GroupInterface>
    {
        let this->_beforeMatch = beforeMatch;
        return this;
    }

    /**
     * Returns the 'before-match' condition if any
     *
     * @return callable string|null
     */
    public function getBeforeMatch() -> callable
    {
        return this->_beforeMatch;
    }

    /**
     * Set common paths for all the routes in the group
     *
     * @param mixed paths
     * @return \Scene\Mvc\Router\GroupInterface
     */
    public function setPaths(var paths) -> <GroupInterface>
    {
        let this->_paths = paths;
        return this;
    }

    /**
     * Returns the common paths defined for this group
     *
     * @return array|string|null
     */
    public function getPaths() -> array | string
    {
        return this->_paths;
    }

    /**
     * Returns the routes added to the group
     *
     * @return \Scene\Mvc\Router\RouteInterface[]|null
     */
    public function getRoutes() -> <RouteInterface[]>
    {
        return this->_routes;
    }

    /**
     * Adds a route to the router on any HTTP method
     *
     *<code>
     * $router->add('/about', 'About::index');
     *</code>
     *
     * @param string pattern
     * @param mixed paths
     * @param string|null httpMethods
     * @return \Scene\Mvc\Router\RouteInterface
     */
    public function add(string! pattern, var paths = null, var httpMethods = null) -> <RouteInterface>
    {
        return this->_addRoute(pattern, paths, httpMethods);
    }

    /**
     * Adds a route to the router that only match if the HTTP method is GET
     *
     * @param string pattern
     * @param mixed paths
     * @return \Scene\Mvc\Router\RouteInterface
     */
    public function addGet(string! pattern, var paths = null) -> <RouteInterface>
    {
        return this->_addRoute(pattern, paths, "GET");
    }

    /**
     * Adds a route to the router that only match if the HTTP method is POST
     *
     * @param string pattern
     * @param mixed paths
     * @return \Scene\Mvc\Router\RouteInterface
     */
    public function addPost(string! pattern, var paths = null) -> <RouteInterface>
    {
        return this->_addRoute(pattern, paths, "POST");
    }

    /**
     * Adds a route to the router that only match if the HTTP method is PUT
     *
     * @param string pattern
     * @param mixed paths
     * @return \Scene\Mvc\Router\RouteInterface
     */
    public function addPut(string! pattern, var paths = null) -> <RouteInterface>
    {
        return this->_addRoute(pattern, paths, "PUT");
    }

    /**
     * Adds a route to the router that only match if the HTTP method is PATCH
     *
     * @param string pattern
     * @param mixed paths
     * @return \Scene\Mvc\Router\RouteInterface
     */
    public function addPatch(string! pattern, var paths = null) -> <RouteInterface>
    {
        return this->_addRoute(pattern, paths, "PATCH");
    }

    /**
     * Adds a route to the router that only match if the HTTP method is DELETE
     *
     * @param string pattern
     * @param mixed paths
     * @return \Scene\Mvc\Router\RouteInterface
     */
    public function addDelete(string! pattern, var paths = null) -> <RouteInterface>
    {
        return this->_addRoute(pattern, paths, "DELETE");
    }

    /**
     * Add a route to the router that only match if the HTTP method is OPTIONS
     *
     * @param string pattern
     * @param mixed paths
     * @return \Scene\Mvc\Router\RouteInterface
     */
    public function addOptions(string! pattern, var paths = null) -> <RouteInterface>
    {
        return this->_addRoute(pattern, paths, "OPTIONS");
    }

    /**
     * Adds a route to the router that only match if the HTTP method is HEAD
     *
     * @param string pattern
     * @param mixed paths
     * @return \Scene\Mvc\Router\RouteInterface
     */
    public function addHead(string! pattern, var paths = null) -> <RouteInterface>
    {
        return this->_addRoute(pattern, paths, "HEAD");
    }

    /**
     * Removes all the pre-defined routes
     */
    public function clear() -> void
    {
        let this->_routes = [];
    }

    /**
     * Adds a route applying the common attributes
     *
     * @param string patten
     * @param Mixed paths
     * @param Mixed httpMethods
     * @return \Scene\Mvc\Router\RouteInterface
     * @throws Exception
     */
    protected function _addRoute(string! pattern, var paths = null, var httpMethods = null) -> <RouteInterface>
    {
        var mergedPaths, route, defaultPaths, processedPaths;

        /**
         * Check if the paths need to be merged with current paths
         */
        let defaultPaths = this->_paths;

        if typeof defaultPaths == "array" {

            if typeof paths == "string" {
                let processedPaths = Route::getRoutePaths(paths);
            } else {
                let processedPaths = paths;
            }

            if typeof processedPaths == "array" {
                /**
                 * Merge the paths with the default paths
                 */
                let mergedPaths = array_merge(defaultPaths, processedPaths);
            } else {
                let mergedPaths = defaultPaths;
            }
        } else {
            let mergedPaths = paths;
        }

        /**
         * Every route is internally stored as a Scene\Mvc\Router\Route
         */
        let route = new Route(this->_prefix . pattern, mergedPaths, httpMethods),
            this->_routes[] = route;

        route->setGroup(this);
        return route;
    }
}
