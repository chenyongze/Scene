
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

namespace Scene\Logger;

/**
 * Scene\Logger\Item
 *
 * Represents each item in a logging transaction
 *
 */
class Item
{

    /**
     * Log type
     *
     * @var integer
     */
    protected _type { get };

    /**
     * Log message
     *
     * @var string
     */
    protected _message { get };

    /**
     * Log timestamp
     *
     * @var integer
     */
    protected _time { get };

    /**
     * Content
     *
     * @var null|array
     * @access protected
    */
    protected _context { get };

    /**
     * Scene\Logger\Item constructor
     *
     * @param string message
     * @param integer type
     * @param integer time
     * @param array context
     */
    public function __construct(string message, int type, int time = 0, var context = null)
    {
        let this->_message = message,
            this->_type = type,
            this->_time = time;

        if typeof context == "array" {
            let this->_context = context;
        }
    }
}
