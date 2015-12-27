
/**
 * Manager Interface
*/

namespace Scene\Mvc\Collection;

use Scene\Mvc\CollectionInterface;
use Scene\Mvc\Collection\BehaviorInterface;
use Scene\Events\ManagerInterface as EventsManagerInterface;

/**
 * Scene\Mvc\Collection\Manager
 *
 * This components controls the initialization of models, keeping record of relations
 * between the different models of the application.
 *
 * A CollectionManager is injected to a model via a Dependency Injector Container such as Scene\Di.
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
     * Sets a custom events manager for a specific model
     *
     * @param \Scene\Mvc\CollectionInterface model
     * @param \Scene\Events\ManagerInterface eventsManager
     */
    public function setCustomEventsManager(<CollectionInterface> model, <EventsManagerInterface> eventsManager);

    /**
     * Returns a custom events manager related to a model
     *
     * @param \Scene\Mvc\CollectionInterface model
     * @return \Scene\Events\ManagerInterface
     */
    public function getCustomEventsManager(<CollectionInterface> model) -> <EventsManagerInterface>;

    /**
     * Initializes a model in the models manager
     *
     * @param \Scene\Mvc\CollectionInterface model
     */
    public function initialize(<CollectionInterface> model);

    /**
     * Check whether a model is already initialized
     *
     * @param string modelName
     * @return bool
     */
    public function isInitialized(string! modelName) -> boolean;

    /**
     * Get the latest initialized model
     *
     * @return \Scene\Mvc\CollectionInterface
     */
    public function getLastInitialized() -> <CollectionInterface>;

    /**
     * Sets a connection service for a specific model
     *
     * @param \Scene\Mvc\CollectionInterface model
     * @param string connectionService
     */
    public function setConnectionService(<CollectionInterface> model, string! connectionService);

    /**
     * Sets if a model must use implicit objects ids
     *
     * @param \Scene\Mvc\CollectionInterface model
     * @param boolean useImplicitObjectIds
     */
    public function useImplicitObjectIds(<CollectionInterface> model, boolean useImplicitObjectIds);

    /**
     * Checks if a model is using implicit object ids
     *
     * @param \Scene\Mvc\CollectionInterface model
     * @return boolean
     */
    public function isUsingImplicitObjectIds(<CollectionInterface> model) -> boolean;

    /**
     * Returns the connection related to a model
     *
     * @param \Scene\Mvc\CollectionInterface model
     * return \MongoDB\Driver\Manage
     */
    public function getConnection(<CollectionInterface> model);

    /**
     * Receives events generated in the models and dispatches them to a events-manager if available
     * Notify the behaviors that are listening in the model
     *
     * @param string eventName
     * @param \Scene\Mvc\CollectionInterface model
     */
    public function notifyEvent(string! eventName, <CollectionInterface> model);
}
