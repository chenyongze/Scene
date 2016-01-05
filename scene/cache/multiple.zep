
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

use Scene\Cache\Exception;
use Scene\Cache\BackendInterface;

/**
 * Scene\Cache\Multiple
 *
 * Allows to read to chained backend adapters writing to multiple backends
 *
 *<code>
 *   use Scene\Cache\Frontend\Data as DataFrontend,
 *       Scene\Cache\Multiple,
 *       Scene\Cache\Backend\Apc as ApcCache,
 *       Scene\Cache\Backend\Memcache as MemcacheCache,
 *       Scene\Cache\Backend\File as FileCache;
 *
 *   $ultraFastFrontend = new DataFrontend(array(
 *       "lifetime" => 3600
 *   ));
 *
 *   $fastFrontend = new DataFrontend(array(
 *       "lifetime" => 86400
 *   ));
 *
 *   $slowFrontend = new DataFrontend(array(
 *       "lifetime" => 604800
 *   ));
 *
 *   //Backends are registered from the fastest to the slower
 *   $cache = new Multiple(array(
 *       new ApcCache($ultraFastFrontend, array(
 *           "prefix" => 'cache',
 *       )),
 *       new MemcacheCache($fastFrontend, array(
 *           "prefix" => 'cache',
 *           "host" => "localhost",
 *           "port" => "11211"
 *       )),
 *       new FileCache($slowFrontend, array(
 *           "prefix" => 'cache',
 *           "cacheDir" => "../app/cache/"
 *       ))
 *   ));
 *
 *   //Save, saves in every backend
 *   $cache->save('my-key', $data);
 *</code>
 */
class Multiple
{

    /**
     * Backends
     *
     * @var null|array
     * @access protected
    */
    protected _backends;

    /**
     * Scene\Cache\Multiple constructor
     *
     * @param Scene\Cache\BackendInterface[] backends
     * @throws Exception
     */
    public function __construct(backends = null)
    {
        if typeof backends != "null" {
            if typeof backends != "array" {
                throw new Exception("The backends must be an array");
            }
            let this->_backends = backends;
        }
    }

    /**
     * Adds a backend
     *
     * @param \Scene\Cache\BackendInterface backend
     * @return \Scene\Cache\Multiple
     */
    public function push(<BackendInterface> backend) -> <Multiple>
    {
        let this->_backends[] = backend;
        return this;
    }

    /**
     * Returns a cached content reading the internal backends
     *
     * @param string|int keyName
     * @param long lifetime
     * @return mixed
     */
    public function get(var keyName, lifetime = null)
    {
        var backend, content;

        for backend in this->_backends {
            let content = backend->get(keyName, lifetime);
            if content != null {
                return content;
            }
        }

        return null;
    }

    /**
     * Starts every backend
     *
     * @param string|int keyName
     * @param long lifetime
     */
    public function start(var keyName, lifetime = null) -> void
    {
        var backend;

        for backend in this->_backends {
            backend->start(keyName, lifetime);
        }
    }

    /**
    * Stores cached content into all backends and stops the frontend
    *
    * @param string|null keyName
    * @param string|null content
    * @param long|null lifetime
    * @param boolean|null stopBuffer
    */
    public function save(var keyName = null, content = null, lifetime = null, stopBuffer = null) -> void
    {
        var backend;

        for backend in this->_backends {
            backend->save(keyName, content, lifetime, stopBuffer);
        }
    }

    /**
     * Deletes a value from each backend
     *
     * @param string|int keyName
     * @return boolean
     */
    public function delete(var keyName) -> boolean
    {
        var backend;

        for backend in this->_backends {
            backend->delete(keyName);
        }

        return true;
    }

    /**
     * Checks if cache exists in at least one backend
     *
     * @param  string|int keyName
     * @param  long lifetime
     * @return boolean
     */
    public function exists(var keyName = null, lifetime = null) -> boolean
    {
        var backend;

        for backend in this->_backends {
            if backend->exists(keyName, lifetime) == true {
                return true;
            }
        }

        return false;
    }
    
    /**
     * Flush all backend(s)
     *
     * @return boolean
     */
    public function flush() -> boolean
    {
        var backend;
        
        for backend in this->_backends {
            backend->flush();
        }
        
        return true;
    }
}
