
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

namespace Scene\Mvc\Collection;

/**
 * Scene\Mvc\Collection\Message
 *
 * Interface for Scene\Mvc\Collection\Message
 */
interface MessageInterface
{

    /**
     * Scene\Mvc\Collection\Message constructor
     *
     * @param string message
     * @param string field
     * @param string type
     */
    public function __construct(message, field = null, type = null);

    /**
     * Sets message type
     *
     * @param string type
     */
    public function setType(type);

    /**
     * Returns message type
     *
     * @return string
     */
    public function getType();

    /**
     * Sets verbose message
     *
     * @param string message
     */
    public function setMessage(message);

    /**
     * Returns verbose message
     *
     * @return string
     */
    public function getMessage();

    /**
     * Sets field name related to message
     *
     * @param string field
     */
    public function setField(field);

    /**
     * Returns field name related to message
     *
     * @return string
     */
    public function getField();

    /**
     * Magic __toString method returns verbose message
     */
    public function __toString() -> string;

    /**
     * Magic __set_state helps to recover messsages from serialization
     *
     * @param array $message
     * @return \Scene\Mvc\Collection\MessageInterface
     */
    public static function __set_state(array! message) -> <MessageInterface>;

}
