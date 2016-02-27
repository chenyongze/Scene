
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
 * Scene\Cache\BackendInterface
 *
 * Interface for Scene\Cache\Backend adapters
 */
interface BackendInterface
{

	/**
	 * Starts a cache. The keyname allows to identify the created fragment
	 *
	 * @param int|string keyName
	 * @param int lifetime
	 * @return mixed
	 */
	public function start(keyName, lifetime = null);

	/**
	 * Stops the frontend without store any cached content
	 *
	 * @param boolean stopBuffer
	 */
	public function stop(stopBuffer = true);

	/**
	 * Returns front-end instance adapter related to the back-end
	 *
	 * @return mixed
	 */
	public function getFrontend();

	/**
	 * Returns the backend options
	 *
	 * @return array
	 */
	public function getOptions();

	/**
	 * Checks whether the last cache is fresh or cached
	 */
	public function isFresh() -> boolean;

	/**
	 * Checks whether the cache has starting buffering or not
	 */
	public function isStarted() -> boolean;

	/**
	 * Sets the last key used in the cache
	 *
	 * @param string lastKey
	 */
	public function setLastKey(lastKey);

	/**
	 * Gets the last key stored by the cache
	 *
	 * @return string
	 */
	public function getLastKey();

	/**
	 * Returns a cached content
	 *
	 * @param int|string keyName
	 * @param int|null lifetime
	 * @return mixed
	 */
	public function get(keyName, lifetime = null);

	/**
	 * Stores cached content into the file backend and stops the frontend
	 *
	 * @param int|string|null keyName
	 * @param int|string|null content
	 * @param int|null lifetime
	 * @param boolean|null stopBuffer
	 */
	public function save(keyName = null, content = null, lifetime = null, stopBuffer = true);

	/**
	 * Deletes a value from the cache by its key
	 *
	 * @param int|string keyName
	 * @return boolean
	 */
	public function delete(keyName);

	/**
	 * Query the existing cached keys
	 *
	 * @param string prefix
	 * @return array
	 */
	public function queryKeys(prefix = null);

	/**
	 * Checks if cache exists and it hasn't expired
	 *
	 * @param  string keyName
	 * @param  int lifetime
	 * @return boolean
	 */
	public function exists(keyName = null, lifetime = null);
}
