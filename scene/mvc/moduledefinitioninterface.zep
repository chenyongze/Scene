
/**
 * Module Definition Interface
*/

namespace Scene\Mvc;

use Scene\DiInterface;

/**
 * Scene\Mvc\ModuleDefinitionInterface
 *
 * This interface must be implemented by class module definitions
 */
interface ModuleDefinitionInterface
{

    /**
     * Registers an autoloader related to the module
     */
    public function registerAutoloaders(<DiInterface> dependencyInjector = null);

    /**
     * Registers services related to the module
     */
    public function registerServices(<DiInterface> dependencyInjector);
}