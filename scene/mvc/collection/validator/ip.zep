
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
 * Scene\Mvc\Collection\Validator\IP
 *
 * Validates that a value is ipv4 address in valid range
 *
 *<code>
 *use Scene\Mvc\Collection\Validator\Ip;
 *
 *class Data extends Scene\Mvc\Collection
 *{
 *
 *  public function validation()
 *  {
 *      // Any pubic IP
 *      $this->validate(new IP(array(
 *          'field'             => 'server_ip',
 *          'version'           => IP::VERSION_4 | IP::VERSION_6, // v6 and v4. The same if not specified
 *          'allowReserved'     => false,   // False if not specified. Ignored for v6
 *          'allowPrivate'      => false,   // False if not specified
 *          'message'           => 'IP address has to be correct'
 *      )));
 *
 *      // Any public v4 address
 *      $this->validate(new IP(array(
 *          'field'             => 'ip_4',
 *          'version'           => IP::VERSION_4,
 *          'message'           => 'IP address has to be correct'
 *      )));
 *
 *      // Any v6 address
 *      $this->validate(new IP(array(
 *          'field'             => 'ip6',
 *          'version'           => IP::VERSION_6,
 *          'allowPrivate'      => true,
 *          'message'           => 'IP address has to be correct'
 *      )));
 *
 *      if ($this->validationHasFailed() == true) {
 *          return false;
 *      }
 *  }
 *
 *}
 *</code>
 */

class Ip extends Validator implements ValidatorInterface
{
    const VERSION_4  = FILTER_FLAG_IPV4;
    const VERSION_6  = FILTER_FLAG_IPV6;

    /**
     * Executes the validator
     *
     * @param \Scene\Mvc\EntityInterface record
     * @return boolean
     * @throws Exception
     */
    public function validate(<EntityInterface> record) -> boolean
    {
        var field, value, message, version, allowPrivate, allowReserved, options;

        let field = this->getOption("field");

        if typeof field != "string" {
            throw new Exception("Field name must be a string");
        }

        let value = record->readAttribute(field);
        let version = this->getOption("version", FILTER_FLAG_IPV4 | FILTER_FLAG_IPV6);
        let allowPrivate = this->getOption("allowPrivate") ? 0 : FILTER_FLAG_NO_PRIV_RANGE;
        let allowReserved = this->getOption("allowReserved") ? 0 : FILTER_FLAG_NO_RES_RANGE;

        let options = [
            "options": [
                "default": false
            ],
            "flags": version | allowPrivate | allowReserved
        ];

        /**
         * Filters the format using FILTER_VALIDATE_IP
         */
        if !filter_var(value, FILTER_VALIDATE_IP, options) {

            let message = this->getOption("message", "IP address is incorrect");
            this->appendMessage(strtr(message, [":field": field]), field, "IP");

            return false;
        }

        return true;
    }
}
