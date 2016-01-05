
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

namespace Scene;

/**
 * Scene\CryptInterface
 *
 * Interface for Scene\Crypt
 */
interface CryptInterface
{

     /**
     * Sets the cipher algorithm
     *
     * @param string cipher
     * @return \Scene\CryptInterface
     */
     public function setCipher(string! cipher) -> <CryptInterface>;

     /**
     * Returns the current cipher
     *
     * @return string
     */
     public function getCipher() -> string;

     /**
     * Sets the encrypt/decrypt mode
     *
     * @param string mode
     * @return \Scene\CryptInterface
     */
     public function setMode(string! mode) -> <CryptInterface>;

     /**
     * Returns the current encryption mode
     *
     * @return string
     */
     public function getMode() -> string;

     /**
     * Sets the encryption key
     *
     * @param string key
     * @return \Scene\CryptInterface
     */
     public function setKey(string! key) -> <CryptInterface>;

     /**
     * Returns the encryption key
     *
     * @return string
     */
     public function getKey() -> string;

     /**
     * Encrypts a text
     *
     * @param string text
     * @param string|null $key
     * @return string
     */
     public function encrypt(string! text, key = null) -> string;

     /**
     * Decrypts a text
     *
     * @param string text
     * @param string|null $key
     * @return string
     */
     public function decrypt(string! text, string! key = null) -> string;

     /**
     * Encrypts a text returning the result as a base64 string
     *
     * @param string text
     * @param string|null $key
     * @return string
     */
     public function encryptBase64(string! text, key = null) -> string;

     /**
     * Decrypt a text that is coded as a base64 string
     *
     * @param string text
     * @param string|null $key
     * @return string
     */
     public function decryptBase64(string! text, key = null) -> string;

     /**
     * Returns a list of available cyphers
     *
     * @return array
     */
     public function getAvailableCiphers() -> array;

     /**
     * Returns a list of available modes
     *
     * @return array
     */
     public function getAvailableModes() -> array;
}
