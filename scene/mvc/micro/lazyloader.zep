
/**
 * Lazy Loader
 *
*/

namespace Scene\Mvc\Micro;

/**
 * Scene\Mvc\Micro\LazyLoader
 *
 * Lazy-Load of handlers for Mvc\Micro using auto-loading
 */
class LazyLoader
{
    
    /**
     * Handler
     *
     * @var null|object
     * @access protected
    */
    protected _handler;

    /**
     * Definition
     *
     * @var null|string
     * @access protected
    */
    protected _definition;

    /**
     * \Scene\Mvc\Micro\LazyLoader constructor
     *
     * @param string definition
     */
    public function __construct(string! definition)
    {
        let this->_definition = definition;
    }

    /**
     * Initializes the internal handler, calling functions on it
     *
     * @param string method
     * @param array arguments
     * @return mixed
     */
    public function __call(string! method, arguments)
    {
        var handler, definition;

        let handler = this->_handler;

        if typeof handler != "object" {
            let definition = this->_definition;
            let handler = new {definition}();
            let this->_handler = handler;
        }

        /**
         * Call the handler
         */
        return call_user_func_array([handler, method], arguments);
    }
}
