
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

namespace Scene\Mvc\View\Engine;

use Scene\Mvc\View\Engine;
use Scene\Mvc\View\EngineInterface;

/**
 * Scene\Mvc\View\Engine\Php
 *
 * Adapter to use PHP itself as templating engine
 */
class Php extends Engine implements EngineInterface
{

    /**
     * Renders a view using the template engine
     *
     * @param string $path
     * @param mixed $params
     * @param boolean $mustClean
     * @throws Exception
     */
    public function render(string! path, var params, boolean mustClean = false)
    {
        var key, value;

        if mustClean === true {
            ob_clean();
        }

        /**
         * Create the variables in local symbol table
         */
        if typeof params == "array" {
            for key, value in params {
                let {key} = value;
            }
        }

        /**
         * Require the file
         */
        require path;

        if mustClean === true {
            this->_view->setContent(ob_get_contents());
        }
    }
}
