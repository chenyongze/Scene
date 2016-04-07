
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
 * Scene\Validation\Validator\Regex
 *
 * Allows validate if the value of a field matches a regular expression
 *
 *<code>
 *use Scene\Validation\Validator\Regex as RegexValidator;
 *
 * $validator->add('created_at', new RegexValidator([
 *    'pattern' => '/^[0-9]{4}[-\/](0[1-9]|1[12])[-\/](0[1-9]|[12][0-9]|3[01])$/',
 *    'message' => 'The creation date is invalid'
 * ]));
 *</code>
 */
class Regex extends Validator
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
        var matches, failed, message, value, label, replacePairs;

        /**
         * Regular expression is set in the option 'pattern'
         * Check if the value match using preg_match in the PHP userland
         */
        let matches = null;
        let value = validation->getValue(field);

        if preg_match(this->getOption("pattern"), value, matches) {
            let failed = matches[0] != value;
        } else {
            let failed = true;
        }

        if failed === true {

            let label = this->getOption("label");
            if empty label {
                let label = validation->getLabel(field);
            }

            let message = this->getOption("message");
            let replacePairs = [":field": label];
            if empty message {
                let message = validation->getDefaultMessage("Regex");
            }

            validation->appendMessage(new Message(strtr(message, replacePairs), field, "Regex", this->getOption("code")));
            return false;
        }

        return true;
    }
}
