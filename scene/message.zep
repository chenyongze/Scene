/**
 *  Message
 */

namespace Scene;

use Scene\DiInterface;
use Scene\Di\InjectionAwareInterface;
use Scene\Message\Exception;

class Message implements InjectionAwareInterface
{

    /**
     * Dependency Injector
     *
     * @var null|\Scene\DiInterface
     * @access protected
    */
    protected _dependencyInjector;

    /**
     * Message
     *
     * @var string
     * @access protected
    */
    protected _message;

    /**
     * Sets the dependency injector
     *
     * @param \Scene\DiInterface dependencyInjector
     */
    public function setDI(<DiInterface> dependencyInjector)
    {
        let this->_dependencyInjector = dependencyInjector;
    }

    /**
     * Returns the internal dependency injector
     *
     * @return \Scene\DiInterface|null
     */
    public function getDI() -> <DiInterface>
    {
        return this->_dependencyInjector;
    }

    /**
     * Set message
     *
     * @param string message
     * @param boolean cover
     * @return \Scene\Message
     */
    public function set(message, cover = false)
    {
        if typeof message != "string" && typeof message != "array" {
            throw new Exception("The message type must be string.");        
        }

        if empty this->_message || cover {
            let this->_message = message;
        }

        return this;
    }

    /**
     * Get message
     *
     * @return array
     */
    public function get()
    {
        var message;
        
        let message = this->_message;
        
        if typeof message == "array" {
            return message;
        } else {
            return ["message" : message];
        }
    }

    /**
     * Clear message
     * 
     * @return \Scene\Message
     */
    public function clear()
    {
        let this->_message = null;
        return this;
    }
}