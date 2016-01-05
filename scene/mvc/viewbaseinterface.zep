
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
 * Scene\Mvc\ViewBaseInterface
 *
 * Interface for Scene\Mvc\View\Simple
 */
interface ViewBaseInterface
{

    /**
     * Sets views directory. Depending of your platform, always add a trailing slash or backslash
     *
     * @param string viewsDir
     */
    public function setViewsDir(string! viewsDir);

    /**
     * Gets views directory
     *
     * @return string
     */
    public function getViewsDir() -> string;

    /**
     * Adds parameters to views (alias of setVar)
     *
     * @param string key
     * @param mixed value
     */
    public function setParamToView(string! key, value);

    /**
     * Adds parameters to views
     *
     * @param string key
     * @param mixed value
     */
    public function setVar(string! key, value);

    /**
     * Returns parameters to views
     *
     * @return array
     */
    public function getParamsToView() -> array;

    /**
     * Returns the cache instance used to cache
     *
     * @return \Scene\Cache\BackendInterface
     */
    public function getCache() -> <\Scene\Cache\BackendInterface>;

    /**
     * Cache the actual view render to certain level
     *
     * @param boolean|array options
     */
    public function cache(options = true);

    /**
     * Externally sets the view content
     *
     * @param string $content
     */
    public function setContent(string! content);

    /**
     * Returns cached output from another view stage
     *
     * @return string
     */
    public function getContent() -> string;

    /**
     * Renders a partial view
     *
     * @param string partialPath
     * @param mixed params
     * @return string
     */
    public function partial(string! partialPath, var params = null) -> string;
}
