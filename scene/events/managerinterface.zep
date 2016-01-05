
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
 * Scene\Events\Manager
 *
 * Scene Events Manager, offers an easy way to intercept and manipulate, if needed,
 * the normal flow of operation. With the EventsManager the developer can create hooks or
 * plugins that will offer monitoring of data, manipulation, conditional execution and much more.
 */
interface ManagerInterface
{

    /**
     * Attach a listener to the events manager
     *
     * @param string eventType
     * @param object|callable handler
     */
    public function attach(string! eventType, handler);

    /**
     * Detach the listener from the events manager
     *
     * @param string eventType
     * @param object handler
     */
    public function detach(string! eventType, handler);

    /**
     * Removes all events from the EventsManager
     *
     * @param string|null $type
     */
    public function detachAll(string! type = null);

    /**
     * Fires an event in the events manager causing the active listeners to be notified about it
     *
     * @param string eventType
     * @param object source
     * @param mixed  data
     * @return mixed
     */
    public function fire(string! eventType, source, data = null);

    /**
     * Returns all the attached listeners of a certain type
     *
     * @param string type
     * @return array
     */
    public function getListeners(string! type);

}
