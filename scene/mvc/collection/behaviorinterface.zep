
/*
 * BehaviorInterface
 */

namespace Scene\Mvc\Collection;

use Scene\Mvc\CollectionInterface;

/**
 * Scene\Mvc\Collection\BehaviorInterface
 *
 * Interface for Scene\Mvc\Collection\Behavior
 */
interface BehaviorInterface
{

    /**
     * Scene\Mvc\Collection\Behavior
     *
     * @param array options
     */
    public function __construct(options = null);

    /**
     * This method receives the notifications from the EventsManager
     *
     * @param string type
     * @param Scene\Mvc\CollectionInterface collection
     */
    public function notify(string! type, <CollectionInterface> collection);

    /**
     * Calls a method when it's missing in the collection
     *
     * @param Scene\Mvc\CollectionInterface collection
     * @param string method
     * @param mixed arguments
     */
    public function missingMethod(<CollectionInterface> collection, string method, arguments = null);

}