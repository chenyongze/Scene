
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
 * Scene\Mvc\Collection\Validator\Email
 *
 * Allows to validate if email fields has correct values
 *
 *<code>
 *  use Scene\Mvc\Collection\Validator\Email as EmailValidator;
 *
 *  class Subscriptors extends \Scene\Mvc\Collection
 *  {
 *
 *      public function validation()
 *      {
 *          $this->validate(new EmailValidator(array(
 *              'field' => 'electronic_mail'
 *          )));
 *          if ($this->validationHasFailed() == true) {
 *              return false;
 *          }
 *      }
 *  }
 *</code>
 */
class Email extends Validator implements ValidatorInterface
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
         * Filters the format using FILTER_VALIDATE_EMAIL
         */
        if !filter_var(value, FILTER_VALIDATE_EMAIL) {

            let message = this->getOption("message");
            if empty message {
                let message = "Value of field ':field' must have a valid e-mail format";
            }

            this->appendMessage(strtr(message, [":field": field]), field, "Email");
            return false;
        }

        return true;
    }
}
