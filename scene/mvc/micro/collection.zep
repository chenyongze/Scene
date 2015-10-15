
/**
 * Micro Collection
 *
*/

namespace Scene\Mvc\Micro;

/**
 * Scene\Mvc\Micro\Collection
 *
 * Groups Micro-Mvc handlers as controllers
 *
 *<code>
 *
 * $app = new \Scene\Mvc\Micro();
 *
 * $collection = new Collection();
 *
 * $collection->setHandler(new PostsController());
 *
 * $collection->get('/posts/edit/{id}', 'edit');
 *
 * $app->mount($collection);
 *
 *</code>
 *
 */
class Collection implements CollectionInterface
{

    /**
     * Prefix
     *
     * @var null|string
     * @access protected
    */
    protected _prefix;

    /**
     * Lazy
     *
     * @var null|boolean
     * @access protected
    */
    protected _lazy;

    /**
     * Handler
     *
     * @var null|mixed
     * @access protected
    */
    protected _handler;

    /**
     * Handlers
     *
     * @var null|array
     * @access protected
    */
    protected _handlers;

	/**
	 * Internal function to add a handler to the group
	 *
	 * @param string|array method
	 * @param string routePattern
	 * @param mixed handler
	 * @param string name
	 */
	protected function _addMap(string! method, var routePattern, var handler, var name)
	{
		let this->_handlers[] = [method, routePattern, handler, name];
	}

    /**
     * Sets a prefix for all routes added to the collection
     *
     * @param string prefix
     * @return \Scene\Mvc\Micro\CollectionInterface
     */
	public function setPrefix(string! prefix) -> <CollectionInterface>
	{
		let this->_prefix = prefix;
		return this;
	}

    /**
     * Returns the collection prefix if any
     *
     * @return string|null
     */
	public function getPrefix() -> string
	{
		return this->_prefix;
	}

	/**
	 * Returns the registered handlers
	 *
	 * @return array|null
	 */
	public function getHandlers()
	{
		return this->_handlers;
	}

	/**
	 * Sets the main handler
	 *
	 * @param mixed handler
	 * @param boolean lazy
	 * @return \Scene\Mvc\Micro\CollectionInterface
	 */
	public function setHandler(var handler, boolean lazy = false) -> <CollectionInterface>
	{
		let this->_handler = handler, this->_lazy = lazy;
		return this;
	}

    /**
     * Sets if the main handler must be lazy loaded
     *
     * @param boolean lazy
     * @return \Scene\Mvc\Micro\CollectionInterface
     */
	public function setLazy(boolean! lazy) -> <CollectionInterface>
	{
		let this->_lazy = lazy;
		return this;
	}

    /**
     * Returns if the main handler must be lazy loaded
     *
     * @return boolean|null
     */
	public function isLazy() -> boolean
	{
		return this->_lazy;
	}

	/**
	 * Returns the main handler
	 *
	 * @return mixed
	 */
	public function getHandler()
	{
		return this->_handler;
	}

	/**
	 * Maps a route to a handler
	 *
	 * @param  string routePattern
	 * @param  callable handler
	 * @param  string name
	 * @return \Scene\Mvc\Micro\CollectionInterface
	 */
	public function map(string! routePattern, var handler, var name = null) -> <CollectionInterface>
	{
		this->_addMap(null, routePattern, handler, name);
		return this;
	}

	/**
	 * Maps a route to a handler that only matches if the HTTP method is GET
	 *
	 * @param  string routePattern
	 * @param  callable handler
	 * @param  string name
	 * @return \Scene\Mvc\Micro\CollectionInterface
	 */
	public function get(string! routePattern, handler, var name = null) -> <CollectionInterface>
	{
		this->_addMap("GET", routePattern, handler, name);
		return this;
	}

	/**
	 * Maps a route to a handler that only matches if the HTTP method is POST
	 *
	 * @param  string routePattern
	 * @param  callable handler
	 * @param  string name
	 * @return \Scene\Mvc\Micro\CollectionInterface
	 */
	public function post(string! routePattern, handler, var name = null) -> <CollectionInterface>
	{
		this->_addMap("POST", routePattern, handler, name);
		return this;
	}

	/**
	 * Maps a route to a handler that only matches if the HTTP method is PUT
	 *
	 * @param  string routePattern
	 * @param  callable handler
	 * @param  string name
	 * @return \Scene\Mvc\Micro\CollectionInterface
	 */
	public function put(string! routePattern, var handler, var name = null) -> <CollectionInterface>
	{
		this->_addMap("PUT", routePattern, handler, name);
		return this;
	}

	/**
	 * Maps a route to a handler that only matches if the HTTP method is PATCH
	 *
	 * @param  string routePattern
	 * @param  callable handler
	 * @param  string name
	 * @return \Scene\Mvc\Micro\CollectionInterface
	 */
	public function patch(string! routePattern, var handler, var name = null) -> <CollectionInterface>
	{
		this->_addMap("PATCH", routePattern, handler, name);
		return this;
	}

	/**
	 * Maps a route to a handler that only matches if the HTTP method is HEAD
	 *
	 * @param  string routePattern
	 * @param  callable handler
	 * @param  string name
	 * @return \Scene\Mvc\Micro\CollectionInterface
	 */
	public function head(string! routePattern, var handler, var name = null) -> <CollectionInterface>
	{
		this->_addMap("HEAD", routePattern, handler, name);
		return this;
	}

	/**
	 * Maps a route to a handler that only matches if the HTTP method is DELETE
	 *
	 * @param  string   routePattern
	 * @param  callable handler
	 * @param  string name
	 * @return \Scene\Mvc\Micro\CollectionInterface
	 */
	public function delete(string! routePattern, var handler, var name = null) -> <CollectionInterface>
	{
		this->_addMap("DELETE", routePattern, handler, name);
		return this;
	}

	/**
	 * Maps a route to a handler that only matches if the HTTP method is OPTIONS
	 *
	 * @param string routePattern
	 * @param callable handler
	 * @return \Scene\Mvc\Micro\CollectionInterface
	 */
	public function options(string! routePattern, handler, var name = null) -> <CollectionInterface>
	{
		this->_addMap("OPTIONS", routePattern, handler, name);
		return this;
	}
}
