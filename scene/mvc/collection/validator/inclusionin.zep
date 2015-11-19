
/**
 * Inclusion In Validator
*/

namespace Scene\Mvc\Collection\Validator;

use Scene\Mvc\Collection\Validator;
use Scene\Mvc\Collection\ValidatorInterface;
use Scene\Mvc\Collection\Exception;
use Scene\Mvc\EntityInterface;

/**
 * Scene\Mvc\Collection\Validator\InclusionIn
 *
 * Check if a value is included into a list of values
 *
 *<code>
 *  use Scene\Mvc\Collection\Validator\InclusionIn as InclusionInValidator;
 *
 *  class Subscriptors extends \Scene\Mvc\Collection
 *  {
 *
 *      public function validation()
 *      {
 *          $this->validate(new InclusionInValidator(array(
 *              "field" => 'status',
 *              'domain' => array('A', 'I')
 *          )));
 *          if ($this->validationHasFailed() == true) {
 *              return false;
 *          }
 *      }
 *
 *  }
 *</code>
 */
class Inclusionin extends Validator implements ValidatorInterface
{
    /**
     * Executes validator
     *
     * @param \Scene\Mvc\EntityInterface $record
     * @return boolean
     * @throws Exception
     */
    public function validate(<EntityInterface> record) -> boolean
    {
        var field, domain, value, message, strict;

        let field = this->getOption("field");
        if typeof field != "string" {
            throw new Exception("Field name must be a string");
        }

        /**
         * The 'domain' option must be a valid array of not allowed values
         */
        if this->isSetOption("domain") === false {
            throw new Exception("The option 'domain' is required for this validator");
        }

        let domain = this->getOption("domain");
        if typeof domain != "array" {
            throw new Exception("Option 'domain' must be an array");
        }

        let value = record->readAttribute(field);
        if this->isSetOption("allowEmpty") && empty value {
            return true;
        }

        let strict = false;
        if this->isSetOption("strict") {
            if typeof strict != "boolean" {
                throw new Exception("Option 'strict' must be a boolean");
            }

            let strict = this->getOption("strict");
        }

        /**
         * Check if the value is contained in the array
         */
        if !in_array(value, domain, strict) {

            /**
             * Check if the developer has defined a custom message
             */
            let message = this->getOption("message");
            if empty message {
                let message = "Value of field ':field' must be part of list: :domain";
            }

            this->appendMessage(strtr(message, [":field": field, ":domain":  join(", ", domain)]), field, "Inclusion");
            return false;
        }

        return true;
    }
}
