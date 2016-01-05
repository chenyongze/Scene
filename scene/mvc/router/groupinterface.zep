
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

use Scene\Mvc\Router\RouteInterface;

/**
 * Scene\Mvc\Router\GroupInterface
 *
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
interface GroupInterface
{

    /**
     * Set a hostname restriction for all the routes in the group
     *
     * @param string hostname
     * @return \Scene\Mvc\Router\GroupInterface
     */
    public function setHostname(string hostname) -> <GroupInterface>;

    /**
     * Returns the hostname restriction
     *
     * @return string|null
     */
    public function getHostname() -> string;

    /**
     * Set a common uri prefix for all the routes in this group
     *
     * @param string prefix
     * @return \Scene\Mvc\Router\GroupInterface
     */
    public function setPrefix(string prefix) -> <GroupInterface>;

    /**
     * Returns the common prefix for all the routes
     *
     * @return string|null
     */
    public function getPrefix() -> string;

    /**
     * Sets a callback that is called if the route is matched.
     * The developer can implement any arbitrary conditions here
     * If the callback returns false the route is treated as not matched
     *
     * @param callable string prefix
     * @return \Scene\Mvc\Router\GroupInterface
     */
     public function beforeMatch(callable beforeMatch) -> <GroupInterface>;

    /**
     * Returns the 'before-match' condition if any
     *
     * @return callable string|null
     */
    public function getBeforeMatch() -> callable;

    /**
     * Set common paths for all the routes in the group
     *
     * @param mixed paths
     * @return \Scene\Mvc\Router\GroupInterface
     */
    public function setPaths(var paths) -> <GroupInterface>;

    /**
     * Returns the common paths defined for this group
     *
     * @return array|string|null
     */
    public function getPaths() -> array | string;

    /**
     * Returns the routes added to the group
     *
     * @return \Scene\Mvc\Router\RouteInterface[]|null
     */
    public function getRoutes() -> <RouteInterface[]>;

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
    public function addPatch(string! pattern, var paths = null) -> <RouteInterface>;

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
     * Removes all the pre-defined routes
     */
    public function clear() -> void;
}
