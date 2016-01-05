
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

namespace Scene\Mvc\View;

/**
 * Scene\Mvc\View\EngineInterface
 *
 * Interface for Scene\Mvc\View engine adapters
 */
interface EngineInterface
{
    
    /**
     * Returns cached ouput on another view stage
     *
     * @return array
     */
    public function getContent() -> array;

    /**
     * Renders a partial inside another view
     *
     * @param string partialPath
     * @param mixed params
     * @return string
     */
    public function partial(string! partialPath, var params = null) -> string;

    /**
     * Renders a view using the template engine
     *
     * @param string path
     * @param array params
     * @param boolean mustClean
     */
    public function render(string path, var params, boolean mustClean = false);
}
