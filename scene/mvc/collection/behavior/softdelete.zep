
/*
 * SoftDelete
 */

namespace Scene\Mvc\Collection\Behavior;

use Scene\Mvc\CollectionInterface;
use Scene\Mvc\Collection\Behavior;
use Scene\Mvc\Collection\BehaviorInterface;
use Scene\Mvc\Collection\Exception;

/**
 * Scene\Mvc\Collection\Behavior\SoftDelete
 *
 * Instead of permanently delete a record it marks the record as
 * deleted changing the value of a flag column
 */
class SoftDelete extends Behavior implements BehaviorInterface
{

    /**
     * Listens for notifications from the collections manager
     *
     * @param string type
     * @param Scene\Mvc\CollectionInterface collection
     */
    public function notify(string! type, <CollectionInterface> collection)
    {
        var options, value, field, updateModel, message;

        if type == "beforeDelete" {

            let options = this->getOptions();

            /**
             * 'value' is the value to be updated instead of delete the record
             */
            if !fetch value, options["value"] {
                throw new Exception("The option 'value' is required");
            }

            /**
             * 'field' is the attribute to be updated instead of delete the record
             */
            if !fetch field, options["field"] {
                throw new Exception("The option 'field' is required");
            }

            /**
             * Skip the current operation
             */
            collection->skipOperation(true);

            /**
             * If the record is already flagged as 'deleted' we don't delete it again
             */
            if collection->readAttribute(field) != value {

                /**
                 * Clone the current model to make a clean new operation
                 */
                let updateModel = clone collection;

                updateModel->writeAttribute(field, value);

                /**
                 * Update the cloned collection
                 */
                if !updateModel->save() {

                    /**
                     * Transfer the messages from the cloned collection to the original model
                     */
                    for message in updateModel->getMessages() {
                        collection->appendMessage(message);
                    }

                    return false;
                }

                /**
                 * Update the original collection too
                 */
                collection->writeAttribute(field, value);
            }
        }
    }
}