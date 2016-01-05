
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

namespace Scene\Session;

/**
 * Scene\Session\BagInterface
 *
 * Interface for Scene\Session\Bag
 */
interface BagInterface
{

    /**
     * Initializes the session bag. This method must not be called directly, the class calls it when its internal data is accesed
     */
    public function initialize();

    /**
     * Destroyes the session bag
     */
    public function destroy();

    /**
     * Setter of values
     *
     * @param string property
     * @param string value
     */
    public function set(string! property, value);

    /**
     * Getter of values
     *
     * @param string property
     * @param mixed defaultValue
     * @return mixed
     */
    public function get(string! property, defaultValue = null);

    /**
     * Isset property
     *
     * @param string property
     * @return boolean
     */
    public function has(string! property) -> boolean;

    /**
     * Setter of values
     *
     * @param string property
     * @param string value
     */
    public function __set(string! property, value);

    /**
     * Getter of values
     *
     * @param string property
     * @return mixed
     */
    public function __get(string! property);

    /**
     * Isset property
     *
     * @param string property
     * @return boolean
     */
    public function __isset(string! property) -> boolean;

}