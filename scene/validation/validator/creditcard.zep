
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
 * Scene\Validation\Validator\CreditCard
 *
 * Checks if a value has a valid creditcard number
 *
 *<code>
 * use Scene\Validation\Validator\CreditCard as CreditCardValidator;
 *
 * $validator->add('creditcard', new CreditCardValidator([
 *    'message' => 'The credit card number is not valid'
 * ]));
 *</code>
 */
class CreditCard extends Validator
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
        var message, label, replacePairs, value, valid;

        let value = validation->getValue(field);

        let valid = this->verifyByLuhnAlgorithm(value);

        if !valid {
            
            let label = this->getOption("label");
            if empty label {
                let label = validation->getLabel(field);
            }

            let message = this->getOption("message");
            let replacePairs = [":field": label];
            if empty message {
                let message = validation->getDefaultMessage("CreditCard");
            }

            validation->appendMessage(new Message(strtr(message, replacePairs), field, "CreditCard", this->getOption("code")));
            return false;
        }

        return true;
    }

    /**
     * is a simple checksum formula used to validate a variety of identification numbers
     * 
     * @param  string number
     * @return boolean
     */
    private function verifyByLuhnAlgorithm(number) -> boolean
    {
        array digits;
        let digits = (array) str_split(number);

        var digit, position, hash = "";

        for position, digit in digits->reversed() {
            let hash .= (position % 2 ? digit * 2 : digit);
        }

        var result;
        let result = array_sum(str_split(hash));

        return (result % 10 == 0);
    }
}
