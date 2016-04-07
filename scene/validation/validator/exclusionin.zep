
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
use Scene\Validation\Validator;
use Scene\Validation\Exception;

/**
 * Scene\Validation\Validator\ExclusionIn
 *
 * Check if a value is not included into a list of values
 *
 *<code>
 * use Scene\Validation\Validator\ExclusionIn;
 *
 * $validator->add('status', new ExclusionIn([
 *    'message' => 'The status must not be A or B',
 *    'domain' => ['A', 'B']
 * ]));
 *</code>
 */
class ExclusionIn extends Validator
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
        var value, domain, message, label, replacePairs, strict;

        let value = validation->getValue(field);

        /**
         * A domain is an array with a list of valid values
         */
        let domain = this->getOption("domain");
        if typeof domain != "array" {
            throw new Exception("Option 'domain' must be an array");
        }
        
        let strict = false;
        if this->hasOption("strict") {

            if typeof strict != "boolean" {
                throw new Exception("Option 'strict' must be a boolean");
            }

            let strict = this->getOption("strict");
        }

        /**
         * Check if the value is contained by the array
         */
        if in_array(value, domain, strict) {

            let label = this->getOption("label");
            if empty label {
                let label = validation->getLabel(field);
            }

            let message = this->getOption("message");
            let replacePairs = [":field": label, ":domain":  join(", ", domain)];
            if empty message {
                let message = validation->getDefaultMessage("ExclusionIn");
            }

            validation->appendMessage(new Message(strtr(message, replacePairs), field, "ExclusionIn", this->getOption("code")));
            return false;
        }

        return true;
    }
}
