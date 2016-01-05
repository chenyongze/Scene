
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

namespace Scene\Session;

/**
 * Scene\Session\Adapter
 *
 * Base class for Scene\Session adapters
 */
abstract class Adapter
{

    const SESSION_ACTIVE = 2;

    const SESSION_NONE = 1;

    const SESSION_DISABLED = 0;

    /**
     * Unique ID
     *
     * @var null|string
     * @access protected
    */
    protected _uniqueId;

    /**
     * Started
     *
     * @var boolean
     * @access protected
    */
    protected _started = false;

    /**
     * Options
     *
     * @var null|array
     * @access protected
    */
    protected _options;

    /**
     * Scene\Session\Adapter constructor
     *
     * @param array options
     */
    public function __construct(var options = null)
    {
        if typeof options == "array" {
            this->setOptions(options);
        }
    }

    /**
     * Starts the session (if headers are already sent the session will not be started)
     *
     * @return boolean
     */
    public function start() -> boolean
    {
        if !headers_sent() {
            if !this->_started && this->status() !== self::SESSION_ACTIVE {
                session_start();
                let this->_started = true;              
                return true;
            }
        }
        return false;
    }

    /**
     * Sets session's options
     *
     *<code>
     *  $session->setOptions(array(
     *      'uniqueId' => 'my-private-app'
     *  ));
     *</code>
     *
     * @param array options
     */
    public function setOptions(array! options)
    {
        var uniqueId;

        if fetch uniqueId, options["uniqueId"] {
            let this->_uniqueId = uniqueId;
        }

        let this->_options = options;
    }

    /**
     * Get internal options
     *
     * @return array|null
     */
    public function getOptions() -> array
    {
        return this->_options;
    }

    /**
     * Set session name
     *
     * @param string name
     */
    public function setName(string name)
    {
        session_name(name);
    }

    /**
     * Get session name
     *
     * @return string
     */
    public function getName() -> string
    {
        return session_name();
    }

    /**
     * {@inheritdoc}
     *
     * @param boolean deleteOldSession
     * @return Scene\Session\Adapter
     */
    public function regenerateId(boolean deleteOldSession = true) -> <Adapter>
    {
        session_regenerate_id(deleteOldSession);
        return this;
    }

    /**
     * Gets a session variable from an application context
     *
     *<code>
     *  $session->get('auth', 'yes');
     *</code>
     *
     * @param string index
     * @param mixed defaultValue
     * @param boolean remove
     * @return mixed
     */
    public function get(string index, var defaultValue = null, boolean remove = false) -> var
    {
        var value, key, uniqueId;

        let uniqueId = this->_uniqueId;
        if !empty uniqueId {
            let key = uniqueId . "#" . index;
        } else {
            let key = index;
        }

        if fetch value, _SESSION[key] {
            if remove {
                unset _SESSION[key];
            }
            return value;
        }

        return defaultValue;
    }

    /**
     * Sets a session variable in an application context
     *
     *<code>
     *  $session->set('auth', 'yes');
     *</code>
     *
     * @param string index
     * @param mixed value
     */
    public function set(string index, var value)
    {
        var uniqueId;

        let uniqueId = this->_uniqueId;
        if !empty uniqueId {
            let _SESSION[uniqueId . "#" . index] = value;
            return;
        }

        let _SESSION[index] = value;
    }

    /**
     * Check whether a session variable is set in an application context
     *
     *<code>
     *  var_dump($session->has('auth'));
     *</code>
     *
     * @param string index
     * @return boolean
     */
    public function has(string index) -> boolean
    {
        var uniqueId;

        let uniqueId = this->_uniqueId;
        if !empty uniqueId {
            return isset _SESSION[uniqueId . "#" . index];
        }

        return isset _SESSION[index];
    }

    /**
     * Removes a session variable from an application context
     *
     *<code>
     *  $session->remove('auth');
     *</code>
     *
     * @param string index
     */
    public function remove(string index)
    {
        var uniqueId, sessionIndex;

        let uniqueId = this->_uniqueId;
        if !empty uniqueId {
            let sessionIndex = uniqueId . "#" .index;
        } else {
            let sessionIndex = index;
        }

        unset _SESSION[sessionIndex];
    }

    /**
     * Returns active session id
     *
     *<code>
     *  echo $session->getId();
     *</code>
     *
     * @return string
     */
    public function getId() -> string
    {
        return session_id();
    }

    /**
     * Set the current session id
     *
     *<code>
     *  $session->setId($id);
     *</code>
     *
     * @param string id
     */
    public function setId(string id)
    {
        session_id(id);
    }

    /**
     * Check whether the session has been started
     *
     *<code>
     *  var_dump($session->isStarted());
     *</code>
     *
     * @return boolean|null
     */
    public function isStarted() -> boolean
    {
        return this->_started;
    }

    /**
     * Destroys the active session
     *
     *<code>
     *  var_dump($session->destroy());
     *  var_dump($session->destroy(true));
     *</code>
     *
     * @param boolean removeData
     * @return boolean
     */
    public function destroy(boolean removeData = false) -> boolean
    {
        var uniqueId, key;

        if removeData {
            let uniqueId = this->_uniqueId;
            if !empty uniqueId {
                for key, _ in _SESSION {
                    if starts_with(key, uniqueId . "#") {
                        unset _SESSION[key];
                    }
                }
            } else {
                let _SESSION = [];
            }
        }

        let this->_started = false;
        return session_destroy();
    }

    /**
     * Returns the status of the current session. For PHP 5.3 this function will always return SESSION_NONE
     *
     *<code>
     *  var_dump($session->status());
     *
     *  // PHP 5.4 and above will give meaningful messages, 5.3 gets SESSION_NONE always
     *  if ($session->status() !== $session::SESSION_ACTIVE) {
     *      $session->start();
     *  }
     *</code>
     *
     * @return int
     */
    public function status()
    {
        var status;

        let status = session_status();

        switch status {
            case PHP_SESSION_DISABLED:
                return self::SESSION_DISABLED;

            case PHP_SESSION_ACTIVE:
                return self::SESSION_ACTIVE;
            
            case PHP_SESSION_NONE:
                return self::SESSION_NONE;

        }
    }

    /**
     * Alias: Gets a session variable from an application context
     */
    public function __get(string index)
    {
        return this->get(index);
    }

    /**
     * Alias: Sets a session variable in an application context
     */
    public function __set(string index, var value)
    {
        return this->set(index, value);
    }

    /**
     * Alias: Check whether a session variable is set in an application context
     */
    public function __isset(string index) -> boolean
    {
        return this->has(index);
    }

    /**
     * Alias: Removes a session variable from an application context
     */
    public function __unset(string index)
    {
        return this->remove(index);
    }

    public function __destruct()
    {
        if this->_started {
            session_write_close();
            let this->_started = false;
        }
    }
}
