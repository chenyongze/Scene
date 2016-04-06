
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

namespace Scene\Validation\Validator;

use Scene\Validation;
use Scene\Validation\Validator;
use Scene\Validation\Message;

/**
 * Scene\Validation\Validator\Date
 *
 * Checks if a value is a valid date
 *
 *<code>
 * use Scene\Validation\Validator\Date as DateValidator;
 *
 * $validator->add('date', new DateValidator([
 *     'format' => 'd-m-Y',
 *     'message' => 'The date is invalid'
 * ]));
 *</code>
 */
class Date extends Validator
{
    
    /**
     * Executes the validation
     *
     * @param \Scene\Validation validation
     * @param string field
     * @return boolean
     */
    public function validate(<Validation> validation, string! field) -> boolean
    {
        var value, format, label, message, replacePairs;

        let value = validation->getValue(field);
        let format = this->getOption("format");

        if empty format {
            let format = "Y-m-d";
        }

        if !this->checkDate(value, format) {
            
            let label = this->getOption("label");
            if empty label {
                let label = validation->getLabel(field);
            }

            let message = this->getOption("message");
            let replacePairs = [":field": label];
            if empty message {
                let message = validation->getDefaultMessage("Date");
            }

            validation->appendMessage(new Message(strtr(message, replacePairs), field, "Date", this->getOption("code")));
            return false;
        }

        return true;
    }

    /**
     * Check out
     */
    private function checkDate(value, format) -> boolean
    {
        var date, errors;

        if !is_string(value) {
            return false;
        }

        let date = \DateTime::createFromFormat(format, value);
        let errors = \DateTime::getLastErrors();

        if errors["warning_count"] > 0 || errors["error_count"] > 0 {
            return false;
        }

        return true;
    }
}
