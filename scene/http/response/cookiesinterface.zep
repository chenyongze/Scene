
/**
 * Cookies Interface
 *
*/

namespace Scene\Http\Response;

use Scene\Http\CookieInterface;

/**
 * Scene\Http\Response\CookiesInterface
 *
 * Interface for Scene\Http\Response\Cookies
 */
interface CookiesInterface
{

    /**
     * Set if cookies in the bag must be automatically encrypted/decrypted
     *
     * @param boolean useEncryption
     * @return \Scene\Http\Response\CookiesInterface
     */
    public function useEncryption(boolean useEncryption) -> <CookiesInterface>;

    /**
     * Returns if the bag is automatically encrypting/decrypting cookies
     *
     * @return boolean
     */
    public function isUsingEncryption() -> boolean;

    /**
     * Sets a cookie to be sent at the end of the request
     *
     * @param string name
     * @param mixed value
     * @param int|null expire
     * @param string|null path
     * @param boolean|null secure
     * @param string|null domain
     * @param boolean|null httpOnly
     * @return \Scene\Http\Response\CookiesInterface
     */
    public function set(string! name, value = null, int expire = 0, string path = "/", boolean secure = null, string! domain = null, boolean httpOnly = null) -> <CookiesInterface>;

    /**
     * Gets a cookie from the bag
     *
     * @param string name
     * @return \Scene\Http\CookieInterface
     */
    public function get(string! name) -> <CookieInterface>;

    /**
     * Check if a cookie is defined in the bag or exists in the $_COOKIE superglobal
     *
     * @param string name
     * @return boolean
     */
    public function has(string! name) -> boolean;

    /**
     * Deletes a cookie by its name
     * This method does not removes cookies from the $_COOKIE superglobal
     *
     * @param string name
     * @return boolean
     */
    public function delete(string! name) -> boolean;

    /**
     * Sends the cookies to the client
     *
     * @return boolean
     */
    public function send() -> boolean;

    /**
     * Reset set cookies
     *
     * @return \Scene\Http\Response\CookiesInterface
     */
    public function reset() -> <CookiesInterface>;

}
