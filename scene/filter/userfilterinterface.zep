
/**
 * User Filter Interface
 *
*/

namespace Scene\Filter;

/**
 * Scene\Filter\UserFilterInterface initializer
 *
 * Interface for Scene\Filter user-filters
 */
interface UserFilterInterface
{

	/**
     * Filters a value
     *
     * @param mixed $value
     * @return mixed
     */
	public function filter(value);
}
