
/**
 * Message
*/

namespace Scene\Mvc\Collection;

use Scene\Mvc\CollectionInterface;
use Scene\Mvc\Collection\MessageInterface;

/**
 * Scene\Mvc\Collection\Message
 *
 * Encapsulates validation info generated before save/delete records fails
 *
 *<code>
 *  use Scene\Mvc\Collection\Message as Message;
 *
 *  class Robots extends \Scene\Mvc\Collection
 *  {
 *
 *    public function beforeSave()
 *    {
 *      if (this->name == 'Peter') {
 *        text = "A robot cannot be named Peter";
 *        field = "name";
 *        type = "InvalidValue";
 *        message = new Message(text, field, type);
 *        this->appendMessage(message);
 *     }
 *   }
 *
 * }
 * </code>
 *
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
     * Collection
     *
     * @var null|\Scene\Mvc\CollectionInterface
     * @access protected
    */
    protected _collection;

    /**
     * Scene\Mvc\Collection\Message constructor
     *
     * @param string message
     * @param string|array field
     * @param string type
     * @param \Scene\Mvc\CollectionInterface collection
     */
    public function __construct(string! message, field = null, type = null, collection = null)
    {
        let this->_message = message,
            this->_field = field,
            this->_type = type;
        if typeof collection == "object" {
            let this->_collection = collection;
        }
    }

    /**
     * Sets message type
     *
     * @param string type
     * @return \Scene\Mvc\Collection\Message
     */
    public function setType(string! type) -> <Message>
    {
        let this->_type = type;
        return this;
    }

    /**
     * Returns message type
     *
     * @return string|null
     */
    public function getType() -> string
    {
        return this->_type;
    }

    /**
     * Sets verbose message
     *
     * @param string message
     * @return \Scene\Mvc\Collection\Message
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
     * @return \Scene\Mvc\Collection\Message
     */
    public function setField(var field) -> <Message>
    {
        let this->_field = field;
        return this;
    }

    /**
     * Returns field name related to message
     *
     * @return string|null
     */
    public function getField()
    {
        return this->_field;
    }

    /**
     * Set the Collection who generates the message
     *
     * @param \Scene\Mvc\CollectionInterface Collection
     * @return \Scene\Mvc\Collection\Message
     */
    public function setModel(<CollectionInterface> Collection) -> <Message>
    {
        let this->_collection = Collection;
        return this;
    }

    /**
     * Returns the Collection that produced the message
     *
     * @return \Scene\Mvc\CollectionInterface|null
     */
    public function getModel() -> <CollectionInterface>
    {
        return this->_collection;
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
     * Magic __set_state helps to re-build messages variable exporting
     *
     * @param array message
     * @return \Scene\Mvc\Collection\Message
     */
    public static function __set_state(array! message) -> <Message>
    {
        return new self(message["_message"], message["_field"], message["_type"]);
    }
}
