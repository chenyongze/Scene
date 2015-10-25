
/**
 * Dispatcher Interface
*/

namespace Scene\Mvc;

use Scene\Mvc\ControllerInterface;
use Scene\DispatcherInterface as DispatcherInterfaceBase;

/**
 * Scene\Mvc\DispatcherInterface
 *
 * Interface for Scene\Mvc\Dispatcher
 */
interface DispatcherInterface extends DispatcherInterfaceBase
{

    /**
     * Sets the default controller suffix
     *
     * @param string controllerSuffix
     */
    public function setControllerSuffix(string! controllerSuffix);

    /**
     * Sets the default controller name
     *
     * @param string controllerName
     */
    public function setDefaultController(string! controllerName);

    /**
     * Sets the controller name to be dispatched
     *
     * @param string $controllerName
     */
    public function setControllerName(string! controllerName);

    /**
     * Gets last dispatched controller name
     *
     * @return string
     */
    public function getControllerName() -> string;

    /**
     * Returns the lastest dispatched controller
     *
     * @return \Scene\Mvc\ControllerInterface
     */
    public function getLastController() -> <ControllerInterface>;

    /**
     * Returns the active controller in the dispatcher
     *
     * @return \Scene\Mvc\ControllerInterface
     */
    public function getActiveController() -> <ControllerInterface>;
}
