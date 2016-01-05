
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

namespace Scene\Mvc;

/**
 * Scene\Mvc\UrlInterface
 *
 * Interface for Scene\Mvc\UrlInterface
 */
interface UrlInterface
{

    /**
     * Sets a prefix to all the urls generated
     *
     * @param string baseUri
     */
    public function setBaseUri(string! baseUri);

    /**
     * Returns the prefix for all the generated urls. By default /
     *
     * @return string
     */
    public function getBaseUri() -> string;

    /**
     * Sets a base paths for all the generated paths
     *
     * @param string basePath
     */
    public function setBasePath(string! basePath);

    /**
     * Returns a base path
     *
     * @return string
     */
    public function getBasePath() -> string;

    /**
     * Generates a URL
     *
     * @param string|array uri
     * @param array|object args Optional arguments to be appended to the query string
     * @param bool local
     * @return string
     */
    public function get(uri = null, args = null, boolean local = null) -> string;

    /**
     * Generates a local path
     *
     * @param string path
     * @return string
     */
    public function path(path = null) -> string;
}
