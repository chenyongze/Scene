
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

namespace Scene\Http\Response;

/**
 * Scene\Http\Response\HeadersInterface initializer
 *
 * Interface for Scene\Http\Response\Headers compatible bags
 */
interface HeadersInterface
{

    /**
     * Sets a header to be sent at the end of the request
     *
     * @param string name
     * @param string value
     */
    public function set(string name, string value);

    /**
     * Gets a header value from the internal bag
     *
     * @param string name
     * @return string | boolean
     */
    public function get(string name) -> string | boolean;

    /**
     * Sets a raw header to be sent at the end of the request
     *
     * @param string header
     */
    public function setRaw(string header);

    /**
     * Sends the headers to the client
     *
     * @return boolean
     */
    public function send() -> boolean;

    /**
     * Reset set headers
     *
     */
    public function reset();

    /**
     * Restore a \Scene\Http\Response\Headers object
     *
     * @param array data
     * @return \Scene\Http\Response\HeadersInterface
     */
    public static function __set_state(array! data) -> <HeadersInterface>;

}