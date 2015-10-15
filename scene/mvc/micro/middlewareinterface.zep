
/**
 * Middleware Interface
 *
*/

namespace Scene\Mvc\Micro;

/**
 * Scene\Mvc\Micro\MiddlewareInterface
 *
 * Allows to implement Scene\Mvc\Micro middleware in classes
 */
interface MiddlewareInterface
{

    /**
     * Calls the middleware
     *
     * @param \Scene\Mvc\Micro application
     */
	public function call(<\Scene\Mvc\Micro> application);

}