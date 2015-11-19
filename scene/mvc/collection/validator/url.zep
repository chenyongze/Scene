
/**
 * URL Validator
*/

namespace Scene\Mvc\Collection\Validator;

use Scene\Mvc\Collection\Validator;
use Scene\Mvc\Collection\ValidatorInterface;
use Scene\Mvc\Collection\Exception;
use Scene\Mvc\EntityInterface;

/**
 * Scene\Mvc\Collecction\Validator\Url
 *
 * Allows to validate if a field has a url format
 *
 *<code>
 *use Scene\Mvc\Collecction\Validator\Url as UrlValidator;
 *
 *class Posts extends \Scene\Mvc\Collecction
 *{
 *
 *  public function validation()
 *  {
 *      $this->validate(new UrlValidator(array(
 *          'field' => 'source_url'
 *      )));
 *      if ($this->validationHasFailed() == true) {
 *          return false;
 *      }
 *  }
 *
 *}
 *</code>
 */
class Url extends Validator implements ValidatorInterface
{
    /**
     * Executes the validator
     *
     * @param \Scene\Mvc\EntityInterface $record
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
         * Filters the format using FILTER_VALIDATE_URL
         */
        if !filter_var(value, FILTER_VALIDATE_URL) {

            /**
             * Check if the developer has defined a custom message
             */
            let message = this->getOption("message");
            if empty message {
                let message = ":field does not have a valid url format";
            }

            this->appendMessage(strtr(message, [":field": field]), field, "Url");
            return false;
        }

        return true;
    }
}
