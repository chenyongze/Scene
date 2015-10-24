
/**
 * Json Cache Frontend
 *
*/

namespace Scene\Cache\Frontend;

use Scene\Cache\FrontendInterface;

/**
 * Scene\Cache\Frontend\Json
 *
 * Allows to cache data converting/deconverting them to JSON.
 *
 * This adapter uses the json_encode/json_decode PHP's functions
 *
 * As the data is encoded in JSON other systems accessing the same backend could
 * process them
 *
 *<code>
 *<?php
 *
 * // Cache the data for 2 days
 * $frontCache = new \Scene\Cache\Frontend\Json(array(
 *    "lifetime" => 172800
 * ));
 *
 * //Create the Cache setting memcached connection options
 * $cache = new \Scene\Cache\Backend\Memcache($frontCache, array(
 *      'host' => 'localhost',
 *      'port' => 11211,
 *      'persistent' => false
 * ));
 *
 * //Cache arbitrary data
 * $cache->save('my-data', array(1, 2, 3, 4, 5));
 *
 * //Get data
 * $data = $cache->get('my-data');
 *</code>
 */
class Json implements FrontendInterface
{

    protected _frontendOptions;

    /**
     * Scene\Cache\Frontend\Base64 constructor
     *
     * @param array frontendOptions
     */
    public function __construct(frontendOptions = null)
    {
        let this->_frontendOptions = frontendOptions;
    }

    /**
     * Returns the cache lifetime
     */
    public function getLifetime() -> int
    {
        var options, lifetime;
        let options = this->_frontendOptions;
        if typeof options == "array" {
            if fetch lifetime, options["lifetime"] {
                return lifetime;
            }
        }
        return 1;
    }

    /**
     * Check whether if frontend is buffering output
     *
     * @return boolean
     */
    public function isBuffering() -> boolean
    {
        return false;
    }

    /**
     * Starts output frontend. Actually, does nothing
     */
    public function start()
    {

    }

    /**
     * Returns output cached content
     *
     * @return string
     */
    public function getContent()
    {
        return null;
    }

    /**
     * Stops output frontend
     */
    public function stop() -> void
    {

    }

    /**
     * Serializes data before storing them
     *
     * @param mixed data
     * @return string
     */
    public function beforeStore(data) -> string
    {
        return json_encode(data);
    }

    /**
     * Unserializes data after retrieval
     *
     * @param mixed data
     * @return mixed
     */
    public function afterRetrieve(data)
    {
        return json_decode(data);
    }
}
