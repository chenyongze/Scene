
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
 * Scene\EscaperInterface
 *
 * Interface for Scene\Escaper
 */
interface EscaperInterface
{

    /**
     * Sets the encoding to be used by the escaper
     *
     * @param string encoding
     */
    public function setEncoding(encoding);

    /**
     * Returns the internal encoding used by the escaper
     *
     * @return string
     */
    public function getEncoding();

    /**
     * Sets the HTML quoting type for htmlspecialchars
     *
     * @param int quoteType
     */
    public function setHtmlQuoteType(quoteType);

    /**
     * Escapes a HTML string
     *
     * @param string text
     * @return string
     */
    public function escapeHtml(text);

    /**
     * Escapes a HTML attribute string
     *
     * @param string text
     * @return string
     */
    public function escapeHtmlAttr(text);

    /**
     * Escape CSS strings by replacing non-alphanumeric chars by their hexadecimal representation
     *
     * @param string css
     * @return string
     */
    public function escapeCss(css);

    /**
     * Escape Javascript strings by replacing non-alphanumeric chars by their hexadecimal representation
     *
     * @param string js
     * @return string
     */
    public function escapeJs(js);

    /**
     * Escapes a URL. Internally uses rawurlencode
     *
     * @param string url
     * @return string
     */
    public function escapeUrl(url);
}
