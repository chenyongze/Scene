
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
 * Scene\Cache\Frontend\None
 *
 * Discards any kind of frontend data input. This frontend does not have expiration time or any other options
 *
 *<code>
 *<?php
 *
 *  //Create a None Cache
 *  $frontCache = new \Scene\Cache\Frontend\None();
 *
 *  // Create the component that will cache "Data" to a "Memcached" backend
 *  // Memcached connection settings
 *  $cache = new \Scene\Cache\Backend\Memcache($frontCache, array(
 *      "host" => "localhost",
 *      "port" => "11211"
 *  ));
 *
 *  // This Frontend always return the data as it's returned by the backend
 *  $cacheKey = 'robots_order_id.cache';
 *  $robots    = $cache->get($cacheKey);
 *  if ($robots === null) {
 *
 *      // This cache doesn't perform any expiration checking, so the data is always expired
 *      // Make the database call and populate the variable
 *      $robots = Robots::find(array("order" => "id"));
 *
 *      $cache->save($cacheKey, $robots);
 *  }
 *
 *  // Use $robots :)
 *  foreach ($robots as $robot) {
 *      echo $robot->name, "\n";
 *  }
 *</code>
 */
class None implements FrontendInterface
{

    /**
     * Returns cache lifetime, always one second expiring content
     */
    public function getLifetime() -> int
    {
        return 1;
    }

    /**
     * Check whether if frontend is buffering output, always false
     */
    public function isBuffering() -> boolean
    {
        return false;
    }

    /**
     * Starts output frontend
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

    }

    /**
     * Stops output frontend
     */
    public function stop()
    {

    }

    /**
     * Prepare data to be stored
     *
     * @param mixed $data
     */
    public function beforeStore(var data)
    {
        return data;
    }

    /**
     * Prepares data to be retrieved to user
     *
     * @param mixed $data
     */
    public function afterRetrieve(var data)
    {
        return data;
    }
}
