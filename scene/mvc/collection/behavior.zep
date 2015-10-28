
/*
 * Behavior
 */

namespace Scene\Mvc\Collection;

use Scene\Mvc\CollectionInterface;

/**
 * Scene\Mvc\Collection\Behavior
 *
 * This is an optional base class for ORM behaviors
 */
abstract class Behavior
{
    
    /**
     * Options
     *
     * @var null|array
     * @access protected
    */
    protected _options;

    /**
     * Scene\Mvc\Collection\Behavior
     *
     * @param array options
     */
    public function __construct(options = null)
    {
        let this->_options = options;
    }

    /**
     * Checks whether the behavior must take action on certain event
     *
     * @param string eventName
     * @return boolean
     */
    protected function mustTakeAction(string! eventName) -> boolean
    {
        return isset this->_options[eventName];
    }

    /**
     * Returns the behavior options related to an event
     *
     * @param string eventName
     * @return array
     */
    protected function getOptions(string! eventName = null)
    {
        var options, eventOptions;

        let options = this->_options;
        if eventName !== null {
            if fetch eventOptions, options[eventName] {
                return eventOptions;
            }
            return null;
        }
        return options;
    }

    /**
     * This method receives the notifications from the EventsManager
     *
     * @param string type
     * @param Scene\Mvc\CollectionInterface collection
     */
    public function notify(string type, <CollectionInterface> collection)
    {
        return null;
    }

    /**
     * Acts as fallbacks when a missing method is called on the collection
     *
     * @param Scene\Mvc\CollectionInterface collection
     * @param string method
     * @param mixed arguments
     */
    public function missingMethod(<CollectionInterface> collection, string method, arguments = null)
    {
        return null;
    }

}