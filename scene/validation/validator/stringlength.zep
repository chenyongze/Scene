
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
 * Scene\Validation\Validator\StringLength
 *
 * Validates that a string has the specified maximum and minimum constraints
 * The test is passed if for a string's length L, min<=L<=max, i.e. L must
 * be at least min, and at most max.
 *
 *<code>
 * use Scene\Validation\Validator\StringLength as StringLength;
 *
 * $validator->add('name_last', new StringLength(array(
 *     'max' => 50,
 *     'min' => 2,
 *     'messageMaximum' => 'We don\'t like really long names',
 *     'messageMinimum' => 'We want more than just their initials'
 * )));
 *</code>
 */
class StringLength extends Validator
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
        var isSetMin, isSetMax, value, length, message, minimum, maximum, label, replacePairs;

        /**
         * At least one of 'min' or 'max' must be set
         */
        let isSetMin = this->hasOption("min"),
            isSetMax = this->hasOption("max");

        if !isSetMin && !isSetMax {
            throw new \Scene\Validation\Exception("A minimum or maximum must be set");
        }

        let value = validation->getValue(field);

        let label = this->getOption("label");
        if empty label {
            let label = validation->getLabel(field);
        }

        /**
         * Check if mbstring is available to calculate the correct length
         */
        if function_exists("mb_strlen") {
            let length = mb_strlen(value);
        } else {
            let length = strlen(value);
        }

        /**
         * Maximum length
         */
        if isSetMax {

            let maximum = this->getOption("max");
            if length > maximum {

                /**
                 * Check if the developer has defined a custom message
                 */
                let message = this->getOption("messageMaximum");
                let replacePairs = [":field": label, ":max":  maximum];
                if empty message {
                    let message = validation->getDefaultMessage("TooLong");
                }

                validation->appendMessage(new Message(strtr(message, replacePairs), field, "TooLong", this->getOption("code")));
                return false;
            }
        }

        /**
         * Minimum length
         */
        if isSetMin {

            let minimum = this->getOption("min");
            if length < minimum {

                /**
                 * Check if the developer has defined a custom message
                 */
                let message = this->getOption("messageMinimum");
                let replacePairs = [":field": label, ":min":  minimum];
                if empty message {
                    let message = validation->getDefaultMessage("TooShort");
                }

                validation->appendMessage(new Message(strtr(message, replacePairs), field, "TooShort", this->getOption("code")));
                return false;
            }
        }

        return true;
    }
}
