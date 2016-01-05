
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

namespace Scene\Cache\Frontend;

use Scene\Cache\FrontendInterface;

/**
 * Scene\Cache\Frontend\Data
 *
 * Allows to cache native PHP data in a serialized form
 *
 *<code>
 *<?php
 *
 *  // Cache the files for 2 days using a Data frontend
 *  $frontCache = new \Scene\Cache\Frontend\Data(array(
 *      "lifetime" => 172800
 *  ));
 *
 *  // Create the component that will cache "Data" to a "File" backend
 *  // Set the cache file directory - important to keep the "/" at the end of
 *  // of the value for the folder
 *  $cache = new \Scene\Cache\Backend\File($frontCache, array(
 *      "cacheDir" => "../app/cache/"
 *  ));
 *
 *  // Try to get cached records
 *  $cacheKey = 'robots_order_id.cache';
 *  $robots    = $cache->get($cacheKey);
 *  if ($robots === null) {
 *
 *      // $robots is null due to cache expiration or data does not exist
 *      // Make the database call and populate the variable
 *      $robots = Robots::find(array("order" => "id"));
 *
 *      // Store it in the cache
 *      $cache->save($cacheKey, $robots);
 *  }
 *
 *  // Use $robots :)
 *  foreach ($robots as $robot) {
 *      echo $robot->name, "\n";
 *  }
 *</code>
 */
class Data implements FrontendInterface
{

    /**
     * Frontend Options
     *
     * @var null|array
     * @access protected
    */
    protected _frontendOptions;

    /**
     * Scene\Cache\Frontend\Data constructor
     *
     * @param array frontendOptions
     */
    public function __construct(frontendOptions = null)
    {
        let this->_frontendOptions = frontendOptions;
    }

    /**
     * Returns the cache lifetime
     *
     * @return int
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
    public function stop()
    {

    }

    /**
     * Serializes data before storing them
     *
     * @param mixed data
     * @return string
     */
    public function beforeStore(var data)
    {
        return serialize(data);
    }

    /**
     * Unserializes data after retrieval
     *
     * @param mixed data
     * @return mixed
     */
    public function afterRetrieve(var data)
    {
        return unserialize(data);
    }
}
