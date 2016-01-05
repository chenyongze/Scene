
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

namespace Scene\Mvc\Micro;

/**
 * Scene\Mvc\Micro\LazyLoader
 *
 * Lazy-Load of handlers for Mvc\Micro using auto-loading
 */
class LazyLoader
{
    
    /**
     * Handler
     *
     * @var null|object
     * @access protected
    */
    protected _handler;

    /**
     * Definition
     *
     * @var null|string
     * @access protected
    */
    protected _definition;

    /**
     * \Scene\Mvc\Micro\LazyLoader constructor
     *
     * @param string definition
     */
    public function __construct(string! definition)
    {
        let this->_definition = definition;
    }

    /**
     * Initializes the internal handler, calling functions on it
     *
     * @param string method
     * @param array arguments
     * @return mixed
     */
    public function __call(string! method, arguments)
    {
        var handler, definition;

        let handler = this->_handler;

        if typeof handler != "object" {
            let definition = this->_definition;
            let handler = new {definition}();
            let this->_handler = handler;
        }

        /**
         * Call the handler
         */
        return call_user_func_array([handler, method], arguments);
    }
}
