
/**
 * Adapter Interface
 *
*/

namespace Scene\Session;

/**
 * Scene\Session\AdapterInterface
 *
 * Interface for Scene\Session adapters
 */
interface AdapterInterface
{

    /**
     * Starts session, optionally using an adapter
     */
    public function start();

    /**
     * Sets session options
     *
     * @param array options
     */
    public function setOptions(array! options);

    /**
     * Get internal options
     *
     * @return array
     */
    public function getOptions() -> array;

    /**
     * Gets a session variable from an application context
     *
     * @param string index
     * @param mixed defaultValue
     * @return array
     */
    public function get(string index, var defaultValue = null);

    /**
     * Sets a session variable in an application context
     *
     * @param string index
     * @param string value
     */
    public function set(string index, var value);

    /**
     * Check whether a session variable is set in an application context
     *
     * @param string index
     * @return boolean
     */
    public function has(string index) -> boolean;

    /**
     * Removes a session variable from an application context
     *
     * @param string index
     */
    public function remove(string index);

    /**
     * Returns active session id
     *
     * @return string
     */
    public function getId() -> string;

    /**
     * Check whether the session has been started
     *
     * @return boolean
     */
    public function isStarted() -> boolean;

    /**
     * Destroys the active session
     *
     * @return boolean
     */
    public function destroy(boolean removeData = false) -> boolean;

    /**
     * Regenerate session's id
     *
     * @param boolean
     * @return Scene\Session\AdapterInterface
     */
    public function regenerateId(boolean deleteOldSession = true) -> <AdapterInterface>;

    /**
     * Set session name
     *
     * @param string name
     */
    public function setName(string name);

    /**
     * Get session name
     *
     * @param string
     */
    public function getName() -> string;
}
