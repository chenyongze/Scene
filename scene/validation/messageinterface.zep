
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
 * Scene\Validation\Message
 *
 * Interface for Scene\Validation\Message
 */
interface MessageInterface
{
    /**
     * Sets message type
     *
     * @param string type
     * @return \Scene\Mvc\Model\MessageInterface
     */
    public function setType(string! type) -> <MessageInterface>;

    /**
     * Returns message type
     *
     * @return string
     */
    public function getType() -> string;

    /**
     * Sets verbose message
     *
     * @param string message
     * @return \Scene\Mvc\Model\MessageInterface
     */
    public function setMessage(string! message) -> <MessageInterface>;

    /**
     * Returns verbose message
     *
     * @return string
     */
    public function getMessage() -> string;

    /**
     * Sets field name related to message
     *
     * @param string field
     * @return \Scene\Mvc\Model\MessageInterface
     */
    public function setField(string! field) -> <MessageInterface>;

    /**
     * Returns field name related to message
     *
     * @return string
     */
    public function getField();

    /**
     * Magic __toString method returns verbose message
     *
     * @return string
     */
    public function __toString() -> string;

    /**
     * Magic __set_state helps to recover messsages from serialization
     *
     * @param array message
     * @return \Scene\Mvc\Model\MessageInterface
     */
    public static function __set_state(array! message) -> <MessageInterface>;

}
