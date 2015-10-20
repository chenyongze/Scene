
/**
 * PHP
 *
*/

namespace Scene\Mvc\View\Engine;

use Scene\Mvc\View\Engine;
use Scene\Mvc\View\EngineInterface;

/**
 * Scene\Mvc\View\Engine\Php
 *
 * Adapter to use PHP itself as templating engine
 */
class Php extends Engine implements EngineInterface
{

    /**
     * Renders a view using the template engine
     *
     * @param string $path
     * @param mixed $params
     * @param boolean $mustClean
     * @throws Exception
     */
    public function render(string! path, var params, boolean mustClean = false)
    {
        var key, value;

        if mustClean === true {
            ob_clean();
        }

        /**
         * Create the variables in local symbol table
         */
        if typeof params == "array" {
            for key, value in params {
                let {key} = value;
            }
        }

        /**
         * Require the file
         */
        require path;

        if mustClean === true {
            this->_view->setContent(ob_get_contents());
        }
    }
}
