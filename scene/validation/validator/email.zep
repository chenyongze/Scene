
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
 * Scene\Validation\Validator\Email
 *
 * Checks if a value has a correct e-mail format
 *
 *<code>
 *use Scene\Validation\Validator\Email as EmailValidator;
 *
 * $validator->add('email', new EmailValidator([
 *    'message' => 'The e-mail is not valid'
 * ]));
 *</code>
 */
class Email extends Validator
{

    /**
     * Executes the validation
     *
     * @param \Scene\Validation $validation
     * @param string $field
     * @return boolean
     */
    public function validate(<Validation> validation, string! field) -> boolean
    {
        var value, message, label, replacePairs;

        let value = validation->getValue(field);

        if !filter_var(value, FILTER_VALIDATE_EMAIL) {

            let label = this->getOption("label");
            if empty label {
                let label = validation->getLabel(field);
            }

            let message = this->getOption("message");
            let replacePairs = [":field": label];
            if empty message {
                let message = validation->getDefaultMessage("Email");
            }

            validation->appendMessage(new Message(strtr(message, replacePairs), field, "Email", this->getOption("code")));
            return false;
        }

        return true;
    }
}
