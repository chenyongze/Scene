
/*
 * EntityInterface
 */

namespace Scene\Mvc;

/**
 * Scene\Mvc\EntityInterface
 *
 * Interface for Scene\Mvc\Collection and Scene\Mvc\Model
 */
interface EntityInterface
{
    /**
     * Reads an attribute value by its name
     *
     * @param string attribute
     * @return mixed
     */
    public function readAttribute(string! attribute);

    /**
     * Writes an attribute value by its name
     *
     * @param string attribute
     * @param mixed value
     */
    public function writeAttribute(string! attribute, value);
}
