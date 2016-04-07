
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
use Scene\Validation\Message;
use Scene\Validation\Exception;
use Scene\Validation\Validator;

/**
 * Scene\Validation\Validator\Confirmation
 *
 * Checks that two values have the same value
 *
 *<code>
 *use Scene\Validation\Validator\Confirmation;
 *
 * $validator->add('password', new Confirmation([
 *    'message' => 'Password doesn\'t match confirmation',
 *    'with' => 'confirmPassword'
 * ]));
 *</code>
 */
class Confirmation extends Validator
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
        var fieldWith, value, valueWith, message, label, labelWith, replacePairs;

        let fieldWith = this->getOption("with"),
            value = validation->getValue(field),
            valueWith = validation->getValue(fieldWith);

        if !this->compare(value, valueWith) {

            let label = this->getOption("label");
            if empty label {
                let label = validation->getLabel(field);
            }

            let labelWith = this->getOption("labelWith");
            if empty labelWith {
                let labelWith = validation->getLabel(fieldWith);
            }

            let message = this->getOption("message");
            let replacePairs = [":field": label, ":with": labelWith];

            if empty message {
                let message = validation->getDefaultMessage("Confirmation");
            }

            validation->appendMessage(new Message(strtr(message, replacePairs), field, "Confirmation", this->getOption("code")));
            return false;
        }

        return true;
    }

    /**
     * Compare strings
     *
     * @param string a
     * @param string b
     * @return boolean
     */
    protected final function compare(string a, string b) -> boolean
    {
        if this->getOption("ignoreCase", false) {

            /**
             * mbstring is required here
             */
            if !function_exists("mb_strtolower") {
                throw new Exception("Extension 'mbstring' is required");
            }

            let a = mb_strtolower(a, "utf-8");
            let b = mb_strtolower(b, "utf-8");
        }

        return a == b;
    }
}
