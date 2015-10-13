
/**
 * Filter Interface
 *
*/
namespace Scene;

/**
 * Scene\FilterInterface initializer
 *
 * Interface for Scene\Filter
 */
interface FilterInterface
{

     /**
     * Adds a user-defined filter
     *
     * @param string name
     * @param callable handler
     * @return \Scene\FilterInterface
     */
     public function add(string! name, handler) -> <FilterInterface>;

     /**
     * Sanizites a value with a specified single or set of filters
     *
     * @param  mixed value
     * @param  mixed filters
     * @return mixed
     */
     public function sanitize(value, filters) -> var;

     /**
     * Return the user-defined filters in the instance
     *
     * @return array
     */
     public function getFilters() -> array;
}