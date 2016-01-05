
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

/**
 * Scene\Cache\FrontendInterface
 *
 * Interface for Scene\Cache\Frontend adapters
 */
interface FrontendInterface
{

    /**
     * Returns the cache lifetime
     *
     * @return int
     */
    public function getLifetime() -> int;

    /**
     * Check whether if frontend is buffering output
     *
     * @return boolean
     */
    public function isBuffering() -> boolean;

    /**
     * Starts the frontend
     */
    public function start();

    /**
     * Returns output cached content
     *
     * @return string
     */
    public function getContent();

    /**
     * Stops the frontend
     */
    public function stop();

    /**
     * Serializes data before storing it
     *
     * @param mixed data
     */
    public function beforeStore(data);

    /**
     * Unserializes data after retrieving it
     *
     * @param mixed data
     */
    public function afterRetrieve(data);
}
