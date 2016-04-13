
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

namespace Scene\Mvc\Collection;

use Scene\Mvc\CollectionInterface;
use Scene\Mvc\Collection\BehaviorInterface;
use Scene\Events\ManagerInterface as EventsManagerInterface;

/**
 * Scene\Mvc\Collection\Manager
 *
 * This components controls the initialization of collections, keeping record of relations
 * between the different collections of the application.
 *
 * A CollectionManager is injected to a collection via a Dependency Injector Container such as Scene\Di.
 *
 * <code>
 * $di = new \Scene\Di();
 *
 * $di->set('collectionManager', function() {
 *      return new \Scene\Mvc\Collection\Manager();
 * });
 *
 * $robot = new Robots(di);
 * </code>
 */
interface ManagerInterface
{

    /**
     * Sets a custom events manager for a specific collection
     *
     * @param \Scene\Mvc\CollectionInterface collection
     * @param \Scene\Events\ManagerInterface eventsManager
     */
    public function setCustomEventsManager(<CollectionInterface> collection, <EventsManagerInterface> eventsManager);

    /**
     * Returns a custom events manager related to a collection
     *
     * @param \Scene\Mvc\CollectionInterface collection
     * @return \Scene\Events\ManagerInterface
     */
    public function getCustomEventsManager(<CollectionInterface> collection) -> <EventsManagerInterface>;

    /**
     * Initializes a collection in the collections manager
     *
     * @param \Scene\Mvc\CollectionInterface collection
     */
    public function initialize(<CollectionInterface> collection);

    /**
     * Check whether a collection is already initialized
     *
     * @param string collectionName
     * @return bool
     */
    public function isInitialized(string! collectionName) -> boolean;

    /**
     * Get the latest initialized collection
     *
     * @return \Scene\Mvc\CollectionInterface
     */
    public function getLastInitialized() -> <CollectionInterface>;

    /**
     * Sets a connection service for a specific collection
     *
     * @param \Scene\Mvc\CollectionInterface collection
     * @param string connectionService
     */
    public function setConnection(<CollectionInterface> collection, string! connectionService);

    /**
     * Returns the connection related to a collection
     *
     * @param \Scene\Mvc\CollectionInterface collection
     * return \MongoDB\Driver\Manage
     */
    public function getConnection(<CollectionInterface> collection);

    /**
     * Receives events generated in the collections and dispatches them to a events-manager if available
     * Notify the behaviors that are listening in the collection
     *
     * @param string eventName
     * @param \Scene\Mvc\CollectionInterface collection
     */
    public function notifyEvent(string! eventName, <CollectionInterface> collection);
}
