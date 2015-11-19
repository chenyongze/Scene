
/**
 * PresenceOf Validator
*/

namespace Scene\Mvc\Collection\Validator;

use Scene\Mvc\Collection\Validator;
use Scene\Mvc\Collection\ValidatorInterface;
use Scene\Mvc\Collection\Exception;
use Scene\Mvc\EntityInterface;

/**
 * Scene\Mvc\Collection\Validator\PresenceOf
 *
 * Allows to validate if a filed have a value different of null and empty string ("")
 *
 *<code>
 *use Scene\Mvc\Collection\Validator\PresenceOf;
 *
 *class Subscriptors extends \Scene\Mvc\Collection
 *{
 *
 *  public function validation()
 *  {
 *      $this->validate(new PresenceOf(array(
 *          "field" => 'name',
 *          "message" => 'The name is required'
 *      )));
 *      if ($this->validationHasFailed() == true) {
 *          return false;
 *      }
 *  }
 *
 *}
 *</code>
 */
class PresenceOf extends Validator implements ValidatorInterface
{
    
    /**
     * Executes the validator
     *
     * @param \Scene\Mvc\EntityInterface record
     * @return boolean
     * @throws Exception
     */
    public function validate(<EntityInterface> record) -> boolean
    {
        var field, value, message;

        let field = this->getOption("field");
        if typeof field != "string" {
            throw new Exception("Field name must be a string");
        }

        /**
         * A value is null when it is identical to null or a empty string
         */
        let value = record->readAttribute(field);

        if is_null(value) || (is_string(value) && !strlen(value)) {

            /**
             * Check if the developer has defined a custom message
             */
            let message = this->getOption("message");
            if empty message {
                let message = "':field' is required";
            }

            this->appendMessage(strtr(message, [":field": field]), field, "PresenceOf");
            return false;
        }

        return true;
    }
}
