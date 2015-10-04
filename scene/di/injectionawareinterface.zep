
/**
 * Injection Aware Interface
 *
*/
namespace Scene\Di;

use Scene\DiInterface;

/**
 * Scene\DI\InjectionAwareInterface initializer
 * 
 * This interface must be implemented in those classes that uses internally the Scene\Di that creates them
 */
interface InjectionAwareInterface
{
    /**
     * Sets the dependency injector
     *
     * @param \Scene\DiInterface $dependencyInjector
     */
    public function setDI(<DiInterface> dependencyInjector);

    /**
     * Returns the internal dependency injector
     *
     * @return \Scene\DiInterface
     */
    public function getDI() -> <DiInterface>;
}
