
/*
 +------------------------------------------------------------------------+
 |                       ___  ___ ___ _ __   ___                          |
 |                      / __|/ __/ _ \  _ \ / _ \                         |
 |                      \__ \ (_|  __/ | | |  __/                         |
 |                      |___/\___\___|_| |_|\___|                         |
 |                                                                        |
 +------------------------------------------------------------------------+
 | Copyright (c) 2015-2016 Scene Team (http://mcorce.com)                 |
 +------------------------------------------------------------------------+
 | This source file is subject to the MIT License that is bundled         |
 | with this package in the file docs/LICENSE.txt.                        |
 |                                                                        |
 | If you did not receive a copy of the license and are unable to         |
 | obtain it through the world-wide-web, please send an email             |
 | to scene@mcorce.com so we can send you a copy immediately.             |
 +------------------------------------------------------------------------+
 | Authors: DangCheng <dangcheng@hotmail.com>                             |
 +------------------------------------------------------------------------+
 */

namespace Scene\Http;

/**
 * Scene\Http\CookieInterface
 *
 * Interface for Scene\Http\Cookie
 */
interface CookieInterface
{
    /**
     * Sets the cookie's value
     *
     * @param string value
     * @return \Scene\Http\CookieInterface
     */
    public function setValue(value) -> <CookieInterface>;

    /**
     * Returns the cookie's value
     *
     * @param string|array filters
     * @param string defaultValue
     * @return mixed
     */
    public function getValue(filters = null, defaultValue = null);
    
    /**
     * Sends the cookie to the HTTP client
     *
     * @return \Scene\Http\CookieInterface
     */
    public function send() -> <CookieInterface>;

    /**
     * Deletes the cookie
     */
    public function delete();

    /**
     * Sets if the cookie must be encrypted/decrypted automatically
     *
     * @param boolean useEncryption
     * @return \Scene\Http\CookieInterface
     */
    public function useEncryption(boolean useEncryption) -> <CookieInterface>;

    /**
     * Check if the cookie is using implicit encryption
     *
     * @return boolean
     */
    public function isUsingEncryption() -> boolean;
    
    /**
     * Sets the cookie's expiration time
     *
     * @param int expire
     * @return \Scene\Http\CookieInterface
     */
    public function setExpiration(int expire) -> <CookieInterface>;

    /**
     * Returns the current expiration time
     *
     * @return string
     */
    public function getExpiration() -> string;

    /**
     * Sets the cookie's expiration time
     *
     * @param string path
     * @return \Scene\Http\CookieInterface
     */
    public function setPath(string! path) -> <CookieInterface>;

    /**
     * Returns the current cookie's path
     *
     * @return string
     */
    public function getPath() -> string; 

    /**
     * Returns the current cookie's name
     *
     * @return string
     */
    public function getName() -> string;

    /**
     * Sets the domain that the cookie is available to
     *
     * @param string domain
     * @return \Scene\Http\CookieInterface
     */
    public function setDomain(string! domain) -> <CookieInterface>;

    /**
     * Returns the domain that the cookie is available to
     *
     * @return string
     */
    public function getDomain() -> string;

    /**
     * Sets if the cookie must only be sent when the connection is secure (HTTPS)
     *
     * @param boolean secure
     * @return \Scene\Http\CookieInterface
     */
    public function setSecure(boolean secure) -> <CookieInterface>;

    /**
     * Returns whether the cookie must only be sent when the connection is secure (HTTPS)
     *
     * @return boolean
     */
    public function getSecure() -> boolean;

    /**
     * Sets if the cookie is accessible only through the HTTP protocol
     *
     * @param boolean httpOnly
     * @return \Scene\Http\CookieInterface
     */
    public function setHttpOnly(boolean httpOnly) -> <CookieInterface>;

    /**
     * Returns if the cookie is accessible only through the HTTP protocol
     *
     * @return boolean
     */
    public function getHttpOnly() -> boolean;
}
