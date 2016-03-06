
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

namespace Scene\Validation;

use Scene\Validation;
use Scene\Validation\Exception;
use Scene\Validation\ValidatorInterface;

/**
 * Scene\Validation\Validator
 *
 * This is a base class for validators
 */
abstract class Validator implements ValidatorInterface
{
    
    /**
     * Options
     *
     * @var null
     * @access protected
    */
    protected _options;

    /**
     * \Scene\Validation\Validator constructor
     *
     * @param array options
     */
    public function __construct(array! options = null)
    {
        let this->_options = options;
    }

    /**
     * Checks if an option is defined
     *
     * @param string key
     * @return boolean
     */
    public function hasOption(string! key) -> boolean
    {
        return isset this->_options[key];
    }

    /**
     * Returns an option in the validator's options
     * Returns null if the option hasn't been set
     *
     * @param string key
     * @return mixed
     */
    public function getOption(string! key, var defaultValue = null) -> var
    {
        var options, value;
        let options = this->_options;

        if typeof options == "array" {
            if fetch value, options[key] {
                return value;
            }
        }

        return defaultValue;
    }

    /**
     * Sets an option in the validator
     *
     * @param string key
     * @param mixed value
     */
    public function setOption(string! key, value) -> void
    {
        let this->_options[key] = value;
    }

    /**
     * Executes the validation
     *
     * @param \Scene\Validation validation
     * @param string attribute
     * @return boolean
     */
    abstract public function validate(<Validation> validation, string! attribute) -> boolean;
}
