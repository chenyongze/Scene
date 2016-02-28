
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

namespace Scene\Cache\Backend;

use Scene\Cache\Backend;
use Scene\Cache\BackendInterface;
use Scene\Cache\FrontendInterface;
use Scene\Cache\Exception;

/**
 * Scene\Cache\Backend\Redis
 *
 * Allows to cache output fragments, PHP data or raw data to a redis backend
 *
 * This adapter uses the special redis key "_SC_" to store all the keys internally used by the adapter
 *
 *<code>
 *
 * // Cache data for 2 days
 * $frontCache = new \Scene\Cache\Frontend\Data(array(
 *    "lifetime" => 172800
 * ));
 *
 * //Create the Cache setting redis connection options
 * $cache = new \Scene\Cache\Backend\Redis($frontCache, array(
 *      'host' => 'localhost',
 *      'port' => 6379,
 *      'auth' => 'foobared',
 *      'persistent' => false
 * ));
 *
 * //Cache arbitrary data
 * $cache->save('my-data', array(1, 2, 3, 4, 5));
 *
 * //Get data
 * $data = $cache->get('my-data');
 *
 *</code>
 */

class Redis extends Backend implements BackendInterface
{

    /**
     * Redis
     *
     * @var null|\Redis
     * @access protected
    */
    protected _redis = null;

    /**
     * Scene\Cache\Backend\Redis constructor
     *
     * @param Scene\Cache\FrontendInterface frontend
     * @param array options
     */
    public function __construct(<FrontendInterface> frontend, options = null)
    {

        if !isset options["host"] {
            let options["host"] = "127.0.0.1";
        }

        if !isset options["port"] {
            let options["port"] = 6379;
        }

        if !isset options["index"] {
            let options["index"] = 0;
        }

        if !isset options["persistent"] {
            let options["persistent"] = false;
        }

        if !isset options["statsKey"] {
            // Disable tracking of cached keys per default
            let options["statsKey"] = "_SC_";
        }

        parent::__construct(frontend, options);
    }

    /**
     * Create internal connection to redis
     */
    public function _connect()
    {
        var options, redis, persistent, success, host, port, auth, index;

        let options = this->_options;
        let redis = new \Redis();

        if !fetch host, options["host"] || !fetch port, options["port"] || !fetch persistent, options["persistent"] {
            throw new Exception("Unexpected inconsistency in options");
        }

        if persistent {
            let success = redis->pconnect(host, port);
        } else {
            let success = redis->connect(host, port);
        }

        if !success {
            throw new Exception("Could not connect to the Redisd server " . host .":" . port);
        }

        if fetch auth, options["auth"] {
            let success = redis->auth(auth);

            if !success {
                throw new Exception("Failed to authenticate with the Redisd server");
            }
        }

        if fetch index, options["index"] {
            let success = redis->select(index);

            if !success {
                throw new Exception("Redisd server selected database failed");
            }
        }

        let this->_redis = redis;
    }

    /**
     * Returns a cached content
     *
     * @param int|string keyName
     * @param long lifetime
     * @return mixed
     */
    public function get(keyName, lifetime = null)
    {
        var redis, frontend, prefix, lastKey, cachedContent;

        let redis = this->_redis;
        if typeof redis != "object" {
            this->_connect();
            let redis = this->_redis;
        }

        let frontend = this->_frontend;
        let prefix = this->_prefix;
        let lastKey = "_SC_" . prefix . keyName;
        let this->_lastKey = lastKey;
        let cachedContent = redis->get(lastKey);

        if !cachedContent {
            return null;
        }

        if is_numeric(cachedContent) {
            return cachedContent;
        }

        return frontend->afterRetrieve(cachedContent);
    }

    /**
     * Stores cached content into the file backend and stops the frontend
     *
     * @param int|string keyName
     * @param int|string content
     * @param long lifetime
     * @param boolean stopBuffer
     */
    public function save(keyName = null, content = null, lifetime = null, boolean stopBuffer = true)
    {
        var prefixedKey, lastKey, prefix, frontend, redis, cachedContent,
            tmp, success, options, specialKey, isBuffering;

        if keyName === null {
            let lastKey = this->_lastKey;
            let prefixedKey = substr(lastKey, 5);
        } else {
            let prefix = this->_prefix;
            let prefixedKey = prefix . keyName;
            let lastKey = "_SC_" . prefixedKey;
        }

        if !lastKey {
            throw new Exception("The cache must be started first");
        }

        let frontend = this->_frontend;

        /**
         * Check if a connection is created or make a new one
         */
        let redis = this->_redis;
        if typeof redis != "object" {
            this->_connect();
            let redis = this->_redis;
        }

        if content === null {
            let cachedContent = frontend->getContent();
        } else {
            let cachedContent = content;
        }

        /**
         * Prepare the content in the frontend
         */
        if !is_numeric(cachedContent) {
            let cachedContent = frontend->beforeStore(cachedContent);
        }

        let success = redis->set(lastKey, cachedContent);

        if !success {
            throw new Exception("Failed storing the data in redis");
        }

        if lifetime === null {
            let tmp = this->_lastLifetime;

            if !tmp {
                let lifetime = frontend->getLifetime();
            } else {
                let lifetime = tmp;
            }
        }

        redis->settimeout(lastKey, lifetime);

        let options = this->_options;

        if !fetch specialKey, options["statsKey"] {
            throw new Exception("Unexpected inconsistency in options");
        }

        if specialKey != "" {
            redis->sAdd(specialKey, prefixedKey);
        }

        let isBuffering = frontend->isBuffering();

        if stopBuffer === true {
            frontend->stop();
        }

        if isBuffering === true {
            echo cachedContent;
        }

        let this->_started = false;
    }

    /**
     * Deletes a value from the cache by its key
     *
     * @param int|string keyName
     * @return boolean
     */
    public function delete(keyName)
    {
        var redis, prefix, prefixedKey, lastKey, options, specialKey;

        let redis = this->_redis;
        if typeof redis != "object" {
            this->_connect();
            let redis = this->_redis;
        }

        let prefix = this->_prefix;
        let prefixedKey = prefix . keyName;
        let lastKey = "_SC_" . prefixedKey;
        let options = this->_options;

        if !fetch specialKey, options["statsKey"] {
            throw new Exception("Unexpected inconsistency in options");
        }

        if specialKey != "" {
            redis->sRem(specialKey, prefixedKey);
        }

        /**
        * Delete the key from redis
        */
        return redis->delete(lastKey);
    }

    /**
     * Query the existing cached keys
     *
     * @param string prefix
     * @return array
     */
    public function queryKeys(prefix = null)
    {
        var redis, options, keys, specialKey, key, value;

        let redis = this->_redis;
        if typeof redis != "object" {
            this->_connect();
            let redis = this->_redis;
        }

        let options = this->_options;

        if !fetch specialKey, options["statsKey"] {
            throw new Exception("Unexpected inconsistency in options");
        }

        if specialKey == "" {
            throw new Exception("Cached keys need to be enabled to use this function (options['statsKey'] == '_PHCM')!");
        }

        /**
        * Get the key from redis
        */
        let keys = redis->sMembers(specialKey);
        if typeof keys == "array" {
            for key, value in keys {
                if prefix && !starts_with(value, prefix) {
                    unset(keys[key]);
                }
            }
        }

        return keys;
    }

    /**
     * Checks if cache exists and it isn't expired
     *
     * @param string keyName
     * @param long lifetime
     * @return boolean
     */
    public function exists(keyName = null, lifetime = null) -> boolean
    {
        var lastKey, redis, prefix;

        if !keyName {
            let lastKey = this->_lastKey;
        } else {
            let prefix = this->_prefix;
            let lastKey = "_SC_" . prefix . keyName;
        }

        if lastKey {
            let redis = this->_redis;
            if typeof redis != "object" {
                this->_connect();
                let redis = this->_redis;
            }

            if !redis->get(lastKey) {
                return false;
            }
            return true;
        }

        return false;
    }

    /**
     * Increment of given $keyName by $value
     *
     * @param  string keyName
     * @param  long value
     * @return long
     */
    public function increment(keyName = null, value = null)
    {
        var redis, prefix, lastKey;

        let redis = this->_redis;
        if typeof redis != "object" {
            this->_connect();
            let redis = this->_redis;
        }

        if !keyName {
            let lastKey = this->_lastKey;
        } else {
            let prefix = this->_prefix;
            let lastKey = "_SC_" . prefix . keyName;
            let this->_lastKey = lastKey;
        }

        if !value {
            let value = 1;
        }

        return redis->incrBy(lastKey, value);
    }

    /**
     * Decrement of $keyName by given $value
     *
     * @param  string keyName
     * @param  long value
     * @return long
     */
    public function decrement(keyName = null, value = null)
    {
        var redis, prefix, lastKey;

        let redis = this->_redis;
        if typeof redis != "object" {
            this->_connect();
            let redis = this->_redis;
        }

        if !keyName {
            let lastKey = this->_lastKey;
        } else {
            let prefix = this->_prefix;
            let lastKey = "_SC_" . prefix . keyName;
            let this->_lastKey = lastKey;
        }

        if !value {
            let value = 1;
        }

        return redis->decrBy(lastKey, value);
    }

    /**
     * Immediately invalidates all existing items.
     */
    public function flush() -> boolean
    {
        var options, specialKey, redis, keys, key, lastKey;

        let options = this->_options;

        if !fetch specialKey, options["statsKey"] {
            throw new Exception("Unexpected inconsistency in options");
        }

        let redis = this->_redis;
        if typeof redis != "object" {
            this->_connect();
            let redis = this->_redis;
        }

        if specialKey == "" {
            throw new Exception("Cached keys need to be enabled to use this function (options['statsKey'] == '_PHCM')!");
        }

        let keys = redis->sMembers(specialKey);
        if typeof keys == "array" {
            for key in keys {
                let lastKey = "_SC_" . key;
                redis->sRem(specialKey, key);
                redis->delete(lastKey);
            }
        }

        return true;
    }
}
