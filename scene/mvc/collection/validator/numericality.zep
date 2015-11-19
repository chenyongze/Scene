
/**
 * Numericality Validator
*/

namespace Scene\Mvc\Collection\Validator;

use Scene\Mvc\Collection\Validator;
use Scene\Mvc\Collection\ValidatorInterface;
use Scene\Mvc\Collection\Exception;
use Scene\Mvc\EntityInterface;

/**
 * Scene\Mvc\Collection\Validator\Numericality
 *
 * Allows to validate if a field has a valid numeric format
 *
 *<code>
 *use Scene\Mvc\Collection\Validator\Numericality as NumericalityValidator;
 *
 *class Products extends \Scene\Mvc\Collection
 *{
 *
 *  public function validation()
 *  {
 *      $this->validate(new NumericalityValidator(array(
 *          "field" => 'price'
 *      )));
 *      if ($this->validationHasFailed() == true) {
 *          return false;
 *      }
 *  }
 *
 *}
 *</code>
 */
class Numericality extends Validator implements ValidatorInterface
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

        let value = record->readAttribute(field);

        if this->isSetOption("allowEmpty") && empty value {
            return true;
        }

        /**
         * Check if the value is numeric using is_numeric in the PHP userland
         */
        if !is_numeric(value) {

            /**
             * Check if the developer has defined a custom message
             */
            let message = this->getOption("message");
            if empty message {
                let message = "Value of field :field must be numeric";
            }

            this->appendMessage(strtr(message, [":field": field]), field, "Numericality");
            return false;
        }

        return true;
    }
}
