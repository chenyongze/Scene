
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

namespace Scene\Events;

use Scene\Events\Exception;

/**
 * Scene\Events\Event
 *
 * This class offers contextual information of a fired event in the EventsManager
 *
 */
class Event
{

    /**
     * Type
     *
     * @var string|null
     * @access protected
    */
    protected _type { set, get };

     /**
     * Source
     *
     * @var object|null
     * @access protected
    */
    protected _source { get };

    /**
     * Data
     *
     * @var mixed
     * @access protected
    */
    protected _data { set, get };

    /**
     * Stopped
     *
     * @var boolean
     * @access protected
    */
    protected _stopped = false;

    /**
     * Cancelable
     *
     * @var boolean
     * @access protected
    */
    protected _cancelable = true { get };

    /**
     * Phalcon\Events\Event constructor
     *
     * @param string type
     * @param object source
     * @param mixed data
     * @param boolean cancelable
     */
    public function __construct(string! type, source, data = null, boolean cancelable = true)
    {
        let this->_type = type,
            this->_source = source;

        if data !== null {
            let this->_data = data;
        }

        if cancelable !== true {
            let this->_cancelable = cancelable;
        }
    }

    /**
     * Stops the event preventing propagation
     */
    public function stop() -> void
    {
        if !this->_cancelable {
            throw new Exception("Trying to cancel a non-cancelable event");
        }

        let this->_stopped = true;
    }

    /**
     * Check whether the event is currently stopped
     */
    public function isStopped() -> boolean
    {
        return this->_stopped;
    }
}
