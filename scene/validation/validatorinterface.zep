
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

/**
 * Scene\Validation\ValidatorInterface
 *
 * Interface for Scene\Validation\Validator
 */
interface ValidatorInterface
{

    /**
     * Checks if an option is defined
     *
     * @param string key
     * @return boolean
     */
    public function hasOption(string! key) -> boolean;

    /**
     * Returns an option in the validator's options
     * Returns null if the option hasn't been set
     *
     * @param string key
     * @param mixed defaultValue
     * @return mixed
     */
    public function getOption(string! key, var defaultValue = null) -> var;

    /**
     * Executes the validation
     *
     * @param \Scene\Validator validator
     * @param string attribute
     * @return boolean
     */
    public function validate(<\Scene\Validation> validation, string! attribute) -> boolean;

}