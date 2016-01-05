
/*
 +------------------------------------------------------------------------+
 |                       ___  ___ ___ _ __   ___                          |
 |                      / __|/ __/ _ \  _ \ / _ \                         |
 |                      \__ \ (_|  __/ | | |  __/                         |
 |                      |___/\___\___|_| |_|\___|                         |
 |                                                                        |
 +------------------------------------------------------------------------+
 | Copyright (c) 2015-2016 Scene Team (http://mcorce.com)                 |
 +------------------------------------------------------------------------+
 | This source file is subject to the MIT License that is bundled         |
 | with this package in the file docs/LICENSE.txt.                        |
 |                                                                        |
 | If you did not receive a copy of the license and are unable to         |
 | obtain it through the world-wide-web, please send an email             |
 | to scene@mcorce.com so we can send you a copy immediately.             |
 +------------------------------------------------------------------------+
 | Authors: DangCheng <dangcheng@hotmail.com>                             |
 +------------------------------------------------------------------------+
 */

namespace Scene\Mvc\Collection\Validator;

use Scene\Mvc\Collection\Validator;
use Scene\Mvc\Collection\ValidatorInterface;
use Scene\Mvc\Collection\Exception;
use Scene\Mvc\EntityInterface;

/**
 * Scene\Mvc\Collection\Validator\ExclusionIn
 *
 * Check if a value is not included into a list of values
 *
 *<code>
 *  use Scene\Mvc\Collection\Validator\ExclusionIn as ExclusionInValidator;
 *
 *  class Subscriptors extends \Scene\Mvc\Collection
 *  {
 *
 *      public function validation()
 *      {
 *          $this->validate(new ExclusionInValidator(array(
 *              'field' => 'status',
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
class Exclusionin extends Validator implements ValidatorInterface
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
        var field, domain, value, message;

        let field = this->getOption("field");

        if typeof field != "string" {
            throw new Exception("Field name must be a string");
        }

        /**
         * The "domain" option must be a valid array of not allowed values
         */
        if this->isSetOption("domain") === false {
            throw new Exception("The option 'domain' is required by this validator");
        }

        let domain = this->getOption("domain");
        if typeof domain != "array" {
            throw new Exception("Option 'domain' must be an array");
        }

        let value = record->readAttribute(field);
        if this->isSetOption("allowEmpty") && empty value {
            return true;
        }

        /**
         * We check if the value contained into the array
         */
        if in_array(value, domain) {

            /**
             * Check if the developer has defined a custom message
             */
            let message = this->getOption("message");
            if empty message {
                let message = "Value of field ':field' must not be part of list: :domain";
            }

            this->appendMessage(strtr(message, [":field": field, ":domain":  join(", ", domain)]), field, "Exclusion");
            return false;
        }

        return true;
    }
}
