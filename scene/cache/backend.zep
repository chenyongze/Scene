
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

namespace Scene\Cache;

use Scene\Cache\FrontendInterface;

/**
 * Scene\Cache\Backend
 *
 * This class implements common functionality for backend adapters. A backend cache adapter may extend this class
 */
abstract class Backend
{

    /**
     * Frontend
     *
     * @var null|\Scene\Cache\FrontendInterface
     * @access protected
    */  
    protected _frontend { get, set };

    /**
     * Options
     *
     * @var null|array
     * @access protected
    */
    protected _options { get, set };

    /**
     * Prefix
     *
     * @var string
     * @access protected
    */
    protected _prefix = "";

    /**
     * Last Key
     *
     * @var string
     * @access protected
    */
    protected _lastKey = "" { get, set };

    /**
     * Last Lifetime
     *
     * @var null|int
     * @access protected
    */
    protected _lastLifetime = null;

    /**
     * Fresh
     *
     * @var boolean
     * @access protected
    */
    protected _fresh = false;

    /**
     * Started
     *
     * @var boolean
     * @access protected
    */
    protected _started = false;

    /**
     * Scene\Cache\Backend constructor
     *
     * @param \Scene\Cache\FrontendInterface frontend
     * @param array options
     */
    public function __construct(<FrontendInterface> frontend, options = null)
    {
        var prefix;

        /**
         * A common option is the prefix
         */
        if fetch prefix, options["prefix"] {
            let this->_prefix = prefix;
        }

        let this->_frontend = frontend,
            this->_options = options;
    }

    /**
     * Starts a cache. The keyname allows to identify the created fragment
     *
     * @param int|string keyName
     * @param int lifetime
     * @return mixed
     */
    public function start(var keyName, lifetime = null)
    {
        var existingCache, fresh;

        /**
         * Get the cache content verifying if it was expired
         */
        let existingCache = this->{"get"}(keyName, lifetime);

        if existingCache === null {
            let fresh = true;
            this->_frontend->start();
        } else {
            let fresh = false;
        }

        let this->_fresh = fresh,
            this->_started = true;

        /**
         * Update the last lifetime to be used in save()
         */
        if typeof lifetime != "null" {
            let this->_lastLifetime = lifetime;
        }

        return existingCache;
    }

    /**
     * Stops the frontend without store any cached content
     *
     * @param boolean stopBuffer
     */
    public function stop(boolean stopBuffer = true) -> void
    {
        if stopBuffer === true {
            this->_frontend->stop();
        }
        let this->_started = false;
    }

    /**
     * Checks whether the last cache is fresh or cached
     *
     * @return boolean
     */
    public function isFresh() -> boolean
    {
        return this->_fresh;
    }

    /**
     * Checks whether the cache has starting buffering or not
     *
     * @return boolean
     */
    public function isStarted() -> boolean
    {
        return this->_started;
    }

    /**
     * Gets the last lifetime set
     *
     * @return int
     */
    public function getLifetime() -> int
    {
        return this->_lastLifetime;
    }
}
