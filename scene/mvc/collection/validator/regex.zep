
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
 * Scene\Mvc\Collection\Validator\Regex
 *
 * Allows validate if the value of a field matches a regular expression
 *
 *<code>
 *use Scene\Mvc\Collection\Validator\Regex as RegexValidator;
 *
 *class Subscriptors extends \Scene\Mvc\Collection
 *{
 *
 *  public function validation()
 *  {
 *      $this->validate(new RegexValidator(array(
 *          "field" => 'created_at',
 *          'pattern' => '/^[0-9]{4}[-\/](0[1-9]|1[12])[-\/](0[1-9]|[12][0-9]|3[01])/'
 *      )));
 *      if ($this->validationHasFailed() == true) {
 *          return false;
 *      }
 *  }
 *
 *}
 *</code>
 */
class Regex extends Validator implements ValidatorInterface
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
        var field, value, failed, matches, pattern, message;

        let field = this->getOption("field");
        if typeof field != "string" {
            throw new Exception("Field name must be a string");
        }

        /**
         * The 'pattern' option must be a valid regular expression
         */
        if !this->isSetOption("pattern") {
            throw new Exception("Validator requires a perl-compatible regex pattern");
        }

        let value = record->readAttribute(field);
        if this->isSetOption("allowEmpty") && empty value {
            return true;
        }

        /**
         * The regular expression is set in the option 'pattern'
         */
        let pattern = this->getOption("pattern");

        /**
         * Check if the value match using preg_match in the PHP userland
         */
        let failed = false;
        let matches = null;
        if preg_match(pattern, value, matches) {
            let failed = matches[0] != value;
        } else {
            let failed = true;
        }

        if failed === true {

            /**
             * Check if the developer has defined a custom message
             */
            let message = this->getOption("message");
            if empty message {
                let message = "Value of field ':field' doesn't match regular expression";
            }

            this->appendMessage(strtr(message, [":field": field]), field, "Regex");
            return false;
        }

        return true;
    }
}
