
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

use Scene\CryptInterface;
use Scene\Crypt\Exception;

/**
 * Scene\Crypt
 *
 * Provides encryption facilities to Scene applications
 *
 *<code>
 *  $crypt = new \Scene\Crypt();
 *
 *  $key = 'le password';
 *  $text = 'This is a secret text';
 *
 *  $encrypted = $crypt->encrypt($text, $key);
 *
 *  echo $crypt->decrypt($encrypted, $key);
 *</code>
 */
class Crypt implements CryptInterface
{

    /**
     * Padding: Default
     *
     * @var int
    */
    const PADDING_DEFAULT = 0;

    /**
     * Padding: ANSI X923
     *
     * @var int
    */
    const PADDING_ANSI_X_923 = 1;

    /**
     * Padding: PKCS7
     *
     * @var int
    */
    const PADDING_PKCS7 = 2;

    /**
     * Padding: ISO 10126
     *
     * @var int
    */
    const PADDING_ISO_10126 = 3;

    /**
     * Padding: ISO IEC 7816-4
     *
     * @var int
    */
    const PADDING_ISO_IEC_7816_4 = 4;

    /**
     * Padding: Zero
     *
     * @var int
    */
    const PADDING_ZERO = 5;

    /**
     * Padding: Space
     *
     * @var int
    */
    const PADDING_SPACE = 6;

    /**
     * Key
     *
     * @var null
     * @access protected
    */
    protected _key = "SCENESCENESCENES";

    /**
     * Padding
     *
     * @var int
     * @access protected
    */
    protected _padding = 0;
    
    /**
     * Cipher
     *
     * @var string
     * @access protected
    */
    protected _cipher = "aes-256-cfb";

    /**
     * @brief \Scene\CryptInterface \Scene\Crypt::setPadding(int $scheme)
     *
     * @param int scheme Padding scheme
     * @return \Scene\CryptInterface
     */
    public function setPadding(int! scheme) -> <CryptInterface>
    {
        let this->_padding = scheme;
        return this;
    }

    /**
     * Sets the cipher algorithm
     *
     * @param string cipher
     * @return \Scene\CryptInterface
     */
    public function setCipher(string! cipher) -> <CryptInterface>
    {
        let this->_cipher = cipher;
        return this;
    }

    /**
     * Returns the current cipher
     *
     * @return string
     */
    public function getCipher() -> string
    {
        return this->_cipher;
    }

    /**
     * Sets the encryption key
     *
     * @param string key
     * @return \Scene\CryptInterface
     */
    public function setKey(string! key) -> <CryptInterface>
    {
        let this->_key = key;
        return this;
    }

    /**
     * Returns the encryption key
     *
     * @return string|null
     */
    public function getKey() -> string
    {
        return this->_key;
    }

    /**
     * Pads texts before encryption
     *
     * @param string text
     * @param srting mode
     * @param int blockSize
     * @param int paddingType
     * @return string
     */
    protected function _cryptPadText(string text, string! mode, int! blockSize, int! paddingType) -> string
    {
        int i;
        var paddingSize = 0, padding = null;

        if mode == "cbc" || mode == "ecb" {

            let paddingSize = blockSize - (strlen(text) % blockSize);
            if paddingSize >= 256 {
                throw new Exception("Block size is bigger than 256");
            }

            switch paddingType {

                case self::PADDING_ANSI_X_923:
                    let padding = str_repeat(chr(0), paddingSize - 1) . chr(paddingSize);
                    break;

                case self::PADDING_PKCS7:
                    let padding = str_repeat(chr(paddingSize), paddingSize);
                    break;

                case self::PADDING_ISO_10126:
                    let padding = "";
                    for i in range(0, paddingSize - 2) {
                        let padding .= chr(rand());
                    }
                    let padding .= chr(paddingSize);
                    break;

                case self::PADDING_ISO_IEC_7816_4:
                    let padding = chr(0x80) . str_repeat(chr(0), paddingSize - 1);
                    break;

                case self::PADDING_ZERO:
                    let padding = str_repeat(chr(0), paddingSize);
                    break;

                case self::PADDING_SPACE:
                    let padding = str_repeat(" ", paddingSize);
                    break;

                default:
                    let paddingSize = 0;
                    break;
            }
        }

        if !paddingSize {
            return text;
        }

        if paddingSize > blockSize {
            throw new Exception("Invalid padding size");
        }

        return text . substr(padding, 0, paddingSize);
    }

    /**
     * Removes padding @a padding_type from @a text
     * If the function detects that the text was not padded, it will return it unmodified
     *
     * @param return_value Result, possibly unpadded
     * @param text Message to be unpadded
     * @param mode Encryption mode; unpadding is applied only in CBC or ECB mode
     * @param block_size Cipher block size
     * @param padding_type Padding scheme
     * @return string
     */
    protected function _cryptUnpadText(string text, string! mode, int! blockSize, int! paddingType)
    {
        var padding, last;
        long length;
        int i, paddingSize = 0, ord;

        let length = strlen(text);
        if length > 0 && (length % blockSize == 0) && (mode == "cbc" || mode == "ecb") {

            switch paddingType {

                case self::PADDING_ANSI_X_923:
                    let last = substr(text, length - 1, 1);
                    let ord = (int) ord(last);
                    if ord <= blockSize {
                        let paddingSize = ord;
                        let padding = str_repeat(chr(0), paddingSize - 1) . last;
                        if substr(text, length - paddingSize) != padding {
                            let paddingSize = 0;
                        }
                    }
                    break;

                case self::PADDING_PKCS7:
                    let last = substr(text, length - 1, 1);
                    let ord = (int) ord(last);
                    if ord <= blockSize {
                        let paddingSize = ord;
                        let padding = str_repeat(chr(paddingSize), paddingSize);
                        if substr(text, length - paddingSize) != padding {
                            let paddingSize = 0;
                        }
                    }
                    break;

                case self::PADDING_ISO_10126:
                    let last = substr(text, length - 1, 1);
                    let paddingSize = (int) ord(last);
                    break;

                case self::PADDING_ISO_IEC_7816_4:
                    let i = length - 1;
                    while i > 0 && text[i] == 0x00 && paddingSize < blockSize {
                        let paddingSize++, i--;
                    }
                    if text[i] == 0x80 {
                        let paddingSize++;
                    } else {
                        let paddingSize = 0;
                    }
                    break;

                case self::PADDING_ZERO:
                    let i = length - 1;
                    while i >= 0 && text[i] == 0x00 && paddingSize <= blockSize {
                        let paddingSize++, i--;
                    }
                    break;

                case self::PADDING_SPACE:
                    let i = length - 1;
                    while i >= 0 && text[i] == 0x20 && paddingSize <= blockSize {
                        let paddingSize++, i--;
                    }
                    break;

                default:
                    break;
            }

            if paddingSize && paddingSize <= blockSize {

                if paddingSize < length {
                    return substr(text, 0, length - paddingSize);
                }
                return "";

            } else {
                let paddingSize = 0;
            }

        }

        if !paddingSize {
            return text;
        }
    }

     /**
     * Encrypts a text
     *
     *<code>
     *  $encrypted = $crypt->encrypt("Ultra-secret text", "encrypt password");
     *</code>
     *
     * @param string text
     * @param string key
     */
    public function encrypt(string! text, string! key = null) -> string
    {
        var encryptKey, ivSize, iv, cipher, mode, blockSize, paddingType, padded;

        if !function_exists("openssl_cipher_iv_length") {
            throw new Exception("openssl extension is required");
        }

        if key === null {
            let encryptKey = this->_key;
        } else {
            let encryptKey = key;
        }

        if empty encryptKey {
            throw new Exception("Encryption key cannot be empty");
        }

        let cipher = this->_cipher;
        let mode = strtolower(substr(cipher, strrpos(cipher, "-") - strlen(cipher) + 1));

        if !in_array(cipher, openssl_get_cipher_methods()) {
            throw new Exception("Cipher algorithm is unknown");
        }

        let ivSize = openssl_cipher_iv_length(cipher);
        if ivSize > 0 {
            let blockSize = ivSize;
        } else {
            let blockSize = openssl_cipher_iv_length(str_ireplace("-" . mode, "", cipher));
        }

        let iv = mcrypt_create_iv(ivSize, MCRYPT_RAND);
        if typeof iv != "string" {
            let iv = strval(iv);
        }

        let iv = openssl_random_pseudo_bytes(ivSize);
        let paddingType = this->_padding;

        if paddingType != 0 && (mode == "cbc" || mode == "ecb") {
            let padded = this->_cryptPadText(text, mode, blockSize, paddingType);
        } else {
            let padded = text;
        }

        return iv . openssl_encrypt(padded, cipher, encryptKey, OPENSSL_RAW_DATA, iv);
    }

    /**
     * Decrypts an encrypted text
     *
     *<code>
     *  echo $crypt->decrypt($encrypted, "decrypt password");
     *</code>
     *
     * @param string text
     */
    public function decrypt(string! text, key = null) -> string
    {
        var decryptKey, ivSize, cipher, mode, blockSize, paddingType, decrypted;

        if !function_exists("openssl_cipher_iv_length") {
            throw new Exception("openssl extension is required");
        }

        if key === null {
            let decryptKey = this->_key;
        } else {
            let decryptKey = key;
        }

        if empty decryptKey {
            throw new Exception("Decryption key cannot be empty");
        }

        let cipher = this->_cipher;
        let mode = strtolower(substr(cipher, strrpos(cipher, "-") - strlen(cipher) + 1));

        if !in_array(cipher, openssl_get_cipher_methods()) {
            throw new Exception("Cipher algorithm is unknown");
        }

        let ivSize = openssl_cipher_iv_length(cipher);
        if ivSize > 0 {
            let blockSize = ivSize;
        } else {
            let blockSize = openssl_cipher_iv_length(str_ireplace("-" . mode, "", cipher));
        }

        let decrypted = openssl_decrypt(substr(text, ivSize), cipher, decryptKey, OPENSSL_RAW_DATA, substr(text, 0, ivSize));

        let paddingType = this->_padding;

        if mode == "cbc" || mode == "ecb" {
            return this->_cryptUnpadText(decrypted, mode, blockSize, paddingType);
        }

        return decrypted;
    }

    /**
     * Encrypts a text returning the result as a base64 string
     *
     * @param string text
     * @param string|null key
     * @param boolean safe
     * @return string
     */
    public function encryptBase64(string! text, key = null, boolean! safe = false) -> string
    {
        if safe == true {
            return strtr(base64_encode(this->encrypt(text, key)), "+/", "-_");
        }
        return base64_encode(this->encrypt(text, key));
    }

    /**
     * Decrypt a text that is coded as a base64 string
     *
     * @param string text
     * @param string|null key
     * @return string
     */
    public function decryptBase64(string! text, key = null, boolean! safe = false) -> string
    {
        if safe == true {
            return this->decrypt(base64_decode(strtr(text, "-_", "+/")), key);
        }
        return this->decrypt(base64_decode(text), key);
    }

    /**
     * Returns a list of available cyphers
     *
     * @return array
     */
    public function getAvailableCiphers() -> array
    {
        return openssl_get_cipher_methods();
    }
}
