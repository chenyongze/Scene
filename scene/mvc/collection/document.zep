
/**
 * Document
*/

namespace Scene\Mvc\Collection;

use Scene\Mvc\EntityInterface;
use Scene\Mvc\Collection\Exception;

/**
 * Scene\Mvc\Collection\Document
 *
 * This component allows Scene\Mvc\Collection to return rows without an associated entity.
 * This objects implements the ArrayAccess interface to allow access the object as object->x or array[x].
 */
class Document implements EntityInterface, \ArrayAccess
{
    /**
     * Checks whether an offset exists in the document
     *
     * @param string index
     * @return boolean
     */
    public function offsetExists(string! index) -> boolean
    {
        return isset this->{index};
    }

    /**
     * Returns the value of a field using the ArrayAccess interfase
     *
     * @param string $index
     * @return mixed
     */
    public function offsetGet(string! index)
    {
        var value;
        if fetch value, this->{index} {
            return value;
        }
        throw new Exception("The index does not exist in the row");
    }

    /**
     * Change a value using the ArrayAccess interface
     *
     * @param string index
     * @param mixed value
     */
    public function offsetSet(string! index, value) -> void
    {
        let this->{index} = value;
    }

    /**
     * Rows cannot be changed. It has only been implemented to meet the definition of the ArrayAccess interface
     *
     * @param string offset
     */
    public function offsetUnset(offset)
    {
        throw new Exception("The index does not exist in the row");
    }

    /**
     * Reads an attribute value by its name
     *
     *<code>
     *  echo $robot->readAttribute('name');
     *</code>
     *
     * @param string attribute
     * @return mixed
     */
    public function readAttribute(attribute)
    {
        var value;
        if fetch value, this->{attribute} {
            return value;
        }
        return null;
    }

    /**
     * Writes an attribute value by its name
     *
     *<code>
     *  $robot->writeAttribute('name', 'Rosey');
     *</code>
     *
     * @param string attribute
     * @param mixed value
     */
    public function writeAttribute(string! attribute, value) -> void
    {
        let this->{attribute} = value;
    }

    /**
     * Returns the instance as an array representation
     *
     * @return array
     */
    public function toArray()
    {
        return get_object_vars(this);
    }
}
