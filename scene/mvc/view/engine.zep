
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

use Scene\DiInterface;
use Scene\Di\Injectable;
use Scene\Mvc\ViewBaseInterface;

/**
 * Scene\Mvc\View\Engine
 *
 * All the template engine adapters must inherit this class. This provides
 * basic interfacing between the engine and the Scene\Mvc\View component.
 */
abstract class Engine extends Injectable
{

    /**
     * View
     *
     * @var null|\Scene\Mvc\ViewInterface
     * @access protected
    */
    protected _view;

    /**
     * \Scene\Mvc\View\Engine constructor
     *
     * @param \Scene\Mvc\ViewBaseInterface $view
     * @param \Scene\DiInterface|null $dependencyInjector
     */
    public function __construct(<ViewBaseInterface> view, <DiInterface> dependencyInjector = null)
    {
        let this->_view = view;
        let this->_dependencyInjector = dependencyInjector;
    }

    /**
     * Returns cached ouput on another view stage
     *
     * @return string
     */
    public function getContent() -> string
    {
        return this->_view->getContent();
    }

    /**
     * Renders a partial inside another view
     *
     * @param string partialPath
     * @param mixed params
     * @return string
     */
    public function partial(string! partialPath, var params = null) -> string
    {
        return this->_view->partial(partialPath, params);
    }

    /**
     * Returns the view component related to the adapter
     */
    public function getView() -> <ViewBaseInterface>
    {
        return this->_view;
    }
}
