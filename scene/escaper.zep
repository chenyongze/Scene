
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

use Scene\EscaperInterface;
use Scene\Escaper\Exception;

/**
 * Scene\Escaper
 *
 * Escapes different kinds of text securing them. By using this component you may
 * prevent XSS attacks.
 *
 * This component only works with UTF-8. The PREG extension needs to be compiled with UTF-8 support.
 *
 *<code>
 *  $escaper = new \Scene\Escaper();
 *  $escaped = $escaper->escapeCss("font-family: <Verdana>");
 *  echo $escaped; // font\2D family\3A \20 \3C Verdana\3E
 *</code>
 */
class Escaper implements EscaperInterface
{

    /**
     * Encoding
     *
     * @var string
     * @access protected
    */
    protected _encoding = "utf-8";

    /**
     * HTML Escape Map
     *
     * @var null
     * @access protected
    */
    protected _htmlEscapeMap = null;

    /**
     * HTML Quote Type
     *
     * @var int
     * @access protected
    */
    protected _htmlQuoteType = 3;

    /**
     * Sets the encoding to be used by the escaper
     *
     *<code>
     * $escaper->setEncoding('utf-8');
     *</code>
     *
     * @param string encoding
     */
    public function setEncoding(string encoding) -> void
    {
        let this->_encoding = encoding;
    }

    /**
     * Returns the internal encoding used by the escaper
     *
     * @return string
     */
    public function getEncoding() -> string
    {
        return this->_encoding;
    }

    /**
     * Sets the HTML quoting type for htmlspecialchars
     *
     *<code>
     * $escaper->setHtmlQuoteType(ENT_XHTML);
     *</code>
     *
     * @param int quoteType
     */
    public function setHtmlQuoteType(int quoteType) -> void
    {
        let this->_htmlQuoteType = quoteType;
    }

    /**
     * Check if charset is ASCII or ISO-8859-1
     *
     * @param string str
     * @return string|boolean
    */
    private static function basicCharset(string str)
    {
        int l, i;
        boolean iso;
        char ch;

        let l = strlen(str),
            iso = false;

        let i = 0;
        while i < l {
            let ch = str[i];
            let i++;
            if (ch !== '0') {
                if (ch == 172 || (ch >= 128 && ch <= 159)) {
                    continue;
                }
                if (ch >= 160) {
                    let iso = true;
                }
            }

            return false;
        }

        if (iso === false) {
            return "ASCII";
        }

        return "ISO-8859-1";

    }

    /**
     * Detect the character encoding of a string to be handled by an encoder
     * Special-handling for chr(172) and chr(128) to chr(159) which fail to be detected by mb_detect_encoding()
     *
     * @param string str
     * @return string|null
     */
    public final function detectEncoding(string str) -> string | null
    {
        var charset;

        /**
        * Check if charset is ASCII or ISO-8859-1
        */
        let charset = self::basicCharset(str);
        if typeof charset == "string" {
            return charset;
        }

        /**
        * We require mbstring extension here
        */
        if !function_exists("mb_detect_encoding") {
            return null;
        }

        /**
         * Strict encoding detection with fallback to non-strict detection.
         * Check encoding
         */
        for charset in ["UTF-32", "UTF-8", "ISO-8859-1", "ASCII"] {
            if mb_detect_encoding(str, charset, true) {
                return charset;
            }
        }

        /**
         * Fallback to global detection
         */
        return mb_detect_encoding(str);
    }

    /**
     * Utility to normalize a string's encoding to UTF-32.
     *
     * @param string str
     * @return string
     */
    public final function normalizeEncoding(string str) -> string
    {
        /**
         * mbstring is required here
         */
        if !function_exists("mb_convert_encoding") {
            throw new Exception("Extension 'mbstring' is required");
        }

        /**
         * Convert to UTF-32 (4 byte characters, regardless of actual number of bytes in
         * the character).
         */
        return mb_convert_encoding(str, "UTF-32", this->detectEncoding(str));
    }

    /**
     * Escapes a HTML string. Internally uses htmlspecialchars
     *
     * @param string text
     * @return string
     */
    public function escapeHtml(string text) -> string
    {
        return htmlspecialchars(text, this->_htmlQuoteType, this->_encoding);
    }

    /**
     * Escapes a HTML attribute string
     *
     * @param string attribute
     * @return string
     */
    public function escapeHtmlAttr(string attribute) -> string
    {
        return htmlspecialchars(attribute, ENT_QUOTES, this->_encoding);
    }

    /**
     * Escape CSS strings by replacing non-alphanumeric chars by their hexadecimal escaped representation
     *
     * @param string css
     * @return string|boolean
     */
    public function escapeCss(string css) -> string | boolean
    {
        var a;
        int i, l;
        int d, e, f, g, h;

        let css = this->normalizeEncoding(css);
        let l = strlen(css);

        if (l <= 0 || l % 4 !== 0) {
            return false;
        }

        let a = "", i = 0;

        while i < l {
            //Get UTF-32 ASCII code (4 bytes)
            let e = css[i],
                f = css[i + 1],
                g = css[i + 2],
                h = css[i + 3],
                d = e + f + g + h,
                i = i + 4;
            
            if (d === 0) {
                /*
                 * CSS 2.1 section 4.1.3: "It is undefined in CSS 2.1 what happens if a
                 * style sheet does contain a character with Unicode codepoint zero."
                 */
                return false;
            } elseif ((d > 49 && d < 58) || (d > 96 && d < 123) || (d > 64 && d < 91)) {
                /**
                 * Alphanumeric characters are not escaped
                 */
                let a .= chr(d);
            } else {
                /**
                 * Escape character
                 */
                let a .= "\\" . dechex(d) . " ";
            }

        }

        return a;
    }

    /**
     * Escape javascript strings by replacing non-alphanumeric chars by their hexadecimal escaped representation
     *
     * @param string js
     * @return string|boolean
     */
    public function escapeJs(string js) -> string | boolean
    {
        var a;
        int i, l;
        int d, e, f, g, h;

        let js = this->normalizeEncoding(js),
            l = strlen(js);

        let a = "", i = 0;

        if (l <= 0 || l % 4 !== 0) {
            return false;
        }

        while i < l {

            let e = js[i],
                f = js[i + 1],
                g = js[i + 2],
                h = js[i + 3],
                d = e + f + g + h,
                i = i + 4;

            if d === 0 {
                return false;
            } elseif (d > 49 && d < 58) || (d > 96 && d < 123) ||
                    (d > 64 && d < 91) || d === 9 || d === 10 ||
                    d === 32 || d === 33 || d === 35|| d === 36 ||
                    (d > 39 && d < 48) || d === 58 || d === 59 ||
                    d === 63 || d === 92 || (d > 93 && d < 97) ||
                    (d > 122 && d < 127) {

                let a .= chr(d);
            } else {
                let a .= "\\x" . dechex(d);
            }
        }

        return a;
    }

    /**
     * Escapes a URL. Internally uses rawurlencode
     *
     * @param string url
     * @return string
     */
    public function escapeUrl(string url) -> string
    {
        return rawurlencode(url);
    }
}
