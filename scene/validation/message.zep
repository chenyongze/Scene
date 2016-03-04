
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

namespace Phalcon\Validation;

use Phalcon\Validation\MessageInterface;

/**
 * Phalcon\Validation\Message
 *
 * Encapsulates validation info generated in the validation process
 */
class Message implements MessageInterface
{

    /**
     * Type
     *
     * @var null|string
     * @access protected
    */
    protected _type;

    /**
     * Message
     *
     * @var null|string
     * @access protected
    */
    protected _message;

    /**
     * Field
     *
     * @var null|string
     * @access protected
    */
    protected _field;
    
    /**
     * code
     *
     * @var null|int
     * @access protected
    */
    protected _code;

    /**
     * \Scene\Validation\Message constructor
     *
     * @param string message
     * @param string field
     * @param string type
     * @param int code
     */
    public function __construct(string! message, string field = null, string type = null, int code = null)
    {
        let this->_message = message,
            this->_field = field,
            this->_type = type,
            this->_code = code;
    }

    /**
     * Sets message type
     *
     * @param string type
     * @return \Scene\Mvc\Model\MessageInterface
     */
    public function setType(string! type) -> <Message>
    {
        let this->_type = type;
        return this;
    }

    /**
     * Returns message type
     *
     * @return string
     */
    public function getType() -> string
    {
        return this->_type;
    }

    /**
     * Sets verbose message
     *
     * @param string message
     * @return \Scene\Mvc\Model\MessageInterface
     */
    public function setMessage(string! message) -> <Message>
    {
        let this->_message = message;
        return this;
    }

    /**
     * Returns verbose message
     *
     * @return string
     */
    public function getMessage() -> string
    {
        return this->_message;
    }

    /**
     * Sets field name related to message
     *
     * @param string field
     * @return \Scene\Mvc\Model\MessageInterface
     */
    public function setField(string! field) -> <Message>
    {
        let this->_field = field;
        return this;
    }

    /**
     * Returns field name related to message
     *
     * @return string
     */
    public function getField()
    {
        return this->_field;
    }
    
    /**
     * Sets code for the message
     *
     * @param int code
     */
    public function setCode(int! code) -> <Message>
    {
        let this->_code = code;
        return this;
    }

    /**
     * Returns the message code
     *
     * @return int
     */
    public function getCode() -> int
    {
        return this->_code;
    }

    /**
     * Magic __toString method returns verbose message
     *
     * @return string
     */
    public function __toString() -> string
    {
        return this->_message;
    }

    /**
     * Magic __set_state helps to recover messsages from serialization
     *
     * @param array message
     * @return \Scene\Mvc\Model\MessageInterface
     */
    public static function __set_state(array! message) -> <Message>
    {
        return new self(message["_message"], message["_field"], message["_type"]);
    }
}
