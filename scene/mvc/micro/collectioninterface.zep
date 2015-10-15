
/**
 * Collection Interface
 *
*/

namespace Scene\Mvc\Micro;

/**
 * Scene\Mvc\Micro\CollectionInterface
 *
 * Interface for Scene\Mvc\Micro\Collection
 */
interface CollectionInterface
{

    /**
     * Sets a prefix for all routes added to the collection
     *
     * @param string prefix
     * @return \Scene\Mvc\Micro\CollectionInterface
     */
	public function setPrefix(string! prefix) -> <CollectionInterface>;

    /**
     * Returns the collection prefix if any
     *
     * @return string
     */
	public function getPrefix() -> string;

    /**
     * Returns the registered handlers
     *
     * @return array
     */
	public function getHandlers();

    /**
     * Sets the main handler
     *
     * @param mixed handler
     * @param boolean|null lazy
     * @return \Scene\Mvc\Micro\CollectionInterface
     */
	public function setHandler(handler, boolean lazy = false) -> <CollectionInterface>;

    /**
     * Sets if the main handler must be lazy loaded
     *
     * @param boolean $lazy
     * @return \Scene\Mvc\Micro\CollectionInterface
     */
	public function setLazy(boolean! lazy) -> <CollectionInterface>;

    /**
     * Returns if the main handler must be lazy loaded
     *
     * @return boolean
     */
	public function isLazy() -> boolean;

	/**
	 * Returns the main handler
	 *
	 * @return mixed
	 */
	public function getHandler();

	/**
	 * Maps a route to a handler
	 *
	 * @param  string routePattern
	 * @param  callable handler
	 * @param  string name
     * @return \Scene\Mvc\Micro\CollectionInterface
	 */
	public function map(string! routePattern, handler, name = null) -> <CollectionInterface>;

	/**
	 * Maps a route to a handler that only matches if the HTTP method is GET
	 *
	 * @param  string routePattern
	 * @param  callable handler
	 * @param  string name
     * @return \Scene\Mvc\Micro\CollectionInterface
	 */
	public function get(string! routePattern, handler, name = null) -> <CollectionInterface>;

	/**
	 * Maps a route to a handler that only matches if the HTTP method is POST
	 *
	 * @param  string routePattern
	 * @param  callable handler
	 * @param  string name
     * @return \Scene\Mvc\Micro\CollectionInterface
	 */
	public function post(string! routePattern, handler, name = null) -> <CollectionInterface>;

	/**
	 * Maps a route to a handler that only matches if the HTTP method is PUT
	 *
	 * @param  string routePattern
	 * @param  callable handler
	 * @param  string name
     * @return \Scene\Mvc\Micro\CollectionInterface
	 */
	public function put(string! routePattern, handler, name = null) -> <CollectionInterface>;

	/**
	 * Maps a route to a handler that only matches if the HTTP method is PATCH
	 *
	 * @param  string routePattern
	 * @param  callable handler
	 * @param  string name
     * @return \Scene\Mvc\Micro\CollectionInterface
	 */
	public function patch(string! routePattern, handler, name = null) -> <CollectionInterface>;

	/**
	 * Maps a route to a handler that only matches if the HTTP method is HEAD
	 *
	 * @param  string routePattern
	 * @param  callable handler
	 * @param  string name
     * @return \Scene\Mvc\Micro\CollectionInterface
	 */
	public function head(string! routePattern, handler, name = null) -> <CollectionInterface>;

	/**
	 * Maps a route to a handler that only matches if the HTTP method is DELETE
	 *
	 * @param  string routePattern
	 * @param  callable handler
	 * @param  string name
     * @return \Scene\Mvc\Micro\CollectionInterface
	 */
	public function delete(string! routePattern, handler, name = null) -> <CollectionInterface>;

	/**
	 * Maps a route to a handler that only matches if the HTTP method is OPTIONS
	 *
	 * @param  string routePattern
	 * @param  callable handler
	 * @param  string name
     * @return \Scene\Mvc\Micro\CollectionInterface
	 */
	public function options(string! routePattern, handler, name = null) -> <CollectionInterface>;

}