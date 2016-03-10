
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

namespace Scene\Validation\Message;

use Scene\Validation\Message;
use Scene\Validation\MessageInterface;
use Scene\Validation\Exception;

/**
 * Scene\Validation\Message\Group
 *
 * Represents a group of validation messages
 */
class Group implements \Countable, \ArrayAccess, \Iterator
{

    /**
     * Position
     *
     * @var null|int
     * @access protected
    */
    protected _position = 0;

    /**
     * Messages
     *
     * @var null|array
     * @access protected
    */
    protected _messages = [];

    /**
     * Scene\Validation\Message\Group constructor
     *
     * @param array messages
     */
    public function __construct(messages = null)
    {
        if typeof messages == "array" {
            let this->_messages = messages;
        }
    }

    /**
     * Gets an attribute a message using the array syntax
     *
     *<code>
     * print_r($messages[0]);
     *</code>
     *
     * @param scalar index
     * @return \Scene\Validation\MessageInterface
     */
    public function offsetGet(var index) -> <MessageInterface> | boolean
    {
        var message;

        if !is_scalar(index) {
            throw new Exception("Invalid parameter type.");
        }

        if fetch message, this->_messages[index] {
            return message;
        }
        return false;
    }

    /**
     * Sets an attribute using the array-syntax
     *
     *<code>
     * $messages[0] = new \Scene\Validation\Message('This is a message');
     *</code>
     *
     * @param scalar index
     * @param \Scene\Validation\MessageInterface message
     */
    public function offsetSet(var index, var message)
    {
        if !is_scalar(index) {
            throw new Exception("Invalid parameter type.");
        }

        if typeof message != "object" {
            throw new Exception("The message must be an object");
        }
        let this->_messages[index] = message;
    }

    /**
     * Checks if an index exists
     *
     *<code>
     * var_dump(isset($message['database']));
     *</code>
     *
     * @param scalar index
     * @return boolean
     */
    public function offsetExists(var index) -> boolean
    {
        if !is_scalar(index) {
            throw new Exception("Invalid parameter type.");
        }

        return isset this->_messages[index];
    }

    /**
     * Removes a message from the list
     *
     *<code>
     * unset($message['database']);
     *</code>
     *
     * @param scalar index
     */
    public function offsetUnset(var index)
    {
        if !is_scalar(index) {
            throw new Exception("Invalid parameter type.");
        }

        if isset this->_messages[index] {
            unset this->_messages[index];
        }
        return false;
    }

    /**
     * Appends a message to the group
     *
     *<code>
     * $messages->appendMessage(new \Scene\Validation\Message('This is a message'));
     *</code>
     */
    public function appendMessage(<MessageInterface> message)
    {
        let this->_messages[] = message;
    }

    /**
     * Appends an array of messages to the group
     *
     *<code>
     * $messages->appendMessages($messagesArray);
     *</code>
     *
     * @param \Scene\Validation\MessageInterface[]|array messages
     */
    public function appendMessages(messages)
    {
        var currentMessages, finalMessages, message;

        if typeof messages != "array" && typeof messages != "object" {
            throw new Exception("The messages must be array or object");
        }

        let currentMessages = this->_messages;
        if typeof messages == "array" {

            /**
             * An array of messages is simply merged into the current one
             */
            if currentMessages == "array" {
                let finalMessages = array_merge(currentMessages, messages);
            } else {
                let finalMessages = messages;
            }

            let this->_messages = finalMessages;
        } else {

            /**
             * A group of messages is iterated and appended one-by-one to the current list
             */
            for message in iterator(messages) {
                this->appendMessage(message);
            }
        }
    }

    /**
     * Filters the message group by field name
     *
     * @param string fieldName
     * @return array
     */
    public function filter(string! fieldName)
    {
        var filtered, messages, message;

        let filtered = [],
            messages = this->_messages;

        if typeof messages == "array" {

            /**
             * A group of messages is iterated and appended one-by-one to the current list
             */
            for message in messages {

                /**
                 * Get the field name
                 */
                if method_exists(message, "getField") {
                    if fieldName == message->getField() {
                        let filtered[] = message;
                    }
                }
            }
        }

        return filtered;
    }

    /**
     * Returns the number of messages in the list
     *
     * @return int
     */
    public function count() -> int
    {
        return count(this->_messages);
    }

    /**
     * Rewinds the internal iterator
     */
    public function rewind() -> void
    {
        let this->_position = 0;
    }

    /**
     * Returns the current message in the iterator
     *
     * @return \Scene\Validation\MessageInterface
     */
    public function current() -> <MessageInterface>
    {
        return this->_messages[this->_position];
    }

    /**
     * Returns the current position/key in the iterator
     *
     * @return int
     */
    public function key() -> int
    {
        return this->_position;
    }

    /**
     * Moves the internal iteration pointer to the next position
     */
    public function next() -> void
    {
        let this->_position++;
    }

    /**
     * Check if the current message in the iterator is valid
     *
     * @return boolean
     */
    public function valid() -> boolean
    {
        return isset this->_messages[this->_position];
    }

    /**
     * Magic __set_state helps to re-build messages variable when exporting
     *
     * @param array group
     * @return \Scene\Validation\Message\Group
     */
    public static function __set_state(array group) -> <Group>
    {
        return new self(group["_messages"]);
    }
}
