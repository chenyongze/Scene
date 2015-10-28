
/*
 * Timestampable
 */

namespace Scene\Mvc\Collection\Behavior;

use Scene\Mvc\CollectionInterface;
use Scene\Mvc\Collection\Behavior;
use Scene\Mvc\Collection\BehaviorInterface;
use Scene\Mvc\Collection\Exception;

/**
 * Scene\Mvc\Collection\Behavior\Timestampable
 *
 * Allows to automatically update a collection’s attribute saving the
 * datetime when a record is created or updated
 */
class Timestampable extends Behavior implements BehaviorInterface
{

    /**
     * Listens for notifications from the models manager
     *
     * @param string type
     * @param Scene\Mvc\CollectionInterface collection
     */
    public function notify(string! type, <CollectionInterface> collection)
    {
        var options, timestamp, singleField, field, generator, format;

        /**
         * Check if the developer decided to take action here
         */
        if this->mustTakeAction(type) !== true {
            return null;
        }

        let options = this->getOptions(type);
        if typeof options == "array" {

            /**
             * The field name is required in this behavior
             */
            if !fetch field, options["field"] {
                throw new Exception("The option 'field' is required");
            }

            let timestamp = null;

            if fetch format, options["format"] {
                /**
                 * Format is a format for date()
                 */
                let timestamp = date(format);
            } else {
                if fetch generator, options["generator"] {

                    /**
                     * A generator is a closure that produce the correct timestamp value
                     */
                    if typeof generator == "object" {
                        if generator instanceof \Closure {
                            let timestamp = call_user_func(generator);
                        }
                    }
                }
            }

            /**
             * Last resort call time()
             */
            if timestamp === null {
                let timestamp = time();
            }

            /**
             * Assign the value to the field, use writeattribute if the property is protected
             */
            if typeof field == "array" {
                for singleField in field {
                    collection->writeAttribute(singleField, timestamp);
                }
            } else {
                collection->writeAttribute(field, timestamp);
            }
        }
    }
}
