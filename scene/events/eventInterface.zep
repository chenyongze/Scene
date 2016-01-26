
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

/**
 * Scene\Events\EventInterface
 *
 * Interface for Scene\Events\Event class
 */
interface EventInterface
{
    /**
     * Gets event data
     */
    public function getData() -> var;

    /**
     * Sets event data
     * 
     * @param mixed data
     * @return \Scene\Events\EventInterface
     */
    public function setData(data = null) -> <EventInterface>;

    /**
     * Gets event type
     */
    public function getType() -> var;

    /**
     * Set the event's type
     *
     * @param string eventType
     * @return \Scene\Events\EventInterface
     */
    public function setType(string! type) -> <EventInterface>;

    /**
     * Stops the event preventing propagation
     *
     * @return \Scene\Events\EventInterface
     * @throws Exception
     */
    public function stop() -> <EventInterface>;

    /**
     * Check whether the event is currently stopped
     *
     * @return boolean
     */
    public function isStopped() -> boolean;

    /**
     * Check whether the event is cancelable
     *
     * @return boolean
     */
    public function isCancelable() -> boolean;
}