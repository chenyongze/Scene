
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

/**
 * Scene\Validation\Validator\Between
 *
 * Validates that a value is between an inclusive range of two values.
 * For a value x, the test is passed if minimum<=x<=maximum.
 *
 *<code>
 * use Scene\Validation\Validator\Between;
 *
 * validator->add('name', new Between(array(
 *    'minimum' => 0,
 *    'maximum' => 100,
 *    'message' => 'The price must be between 0 and 100'
 * )));
 *</code>
 */
class Between extends Validator
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
        var value, minimum, maximum, message, label, replacePairs;

        let value = validation->getValue(field),
                minimum = this->getOption("minimum"),
                maximum = this->getOption("maximum");

        if value < minimum || value > maximum {

            let label = this->getOption("label");
            if empty label {
                let label = validation->getLabel(field);
            }

            let message = this->getOption("message");
            let replacePairs = [":field": label, ":min": minimum, ":max": maximum];
            if empty message {
                let message = validation->getDefaultMessage("Between");
            }

            validation->appendMessage(new Message(strtr(message, replacePairs), field, "Between", this->getOption("code")));
            return false;
        }

        return true;
    }
}
