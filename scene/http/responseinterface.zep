
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

 use Scene\Http\Response\HeadersInterface;

/**
 * Scene\Http\Response
 *
 * Interface for Scene\Http\Response
 */
 interface ResponseInterface
 {

    /**
     * Sets the HTTP response code
     *
     * @param int code
     * @param string message
     * @return \Scene\Http\ResponseInterface
     */
     public function setStatusCode(int code, string message = null) -> <ResponseInterface>;

    /**
     * Returns headers set by the user
     *
     * @return \Scene\Http\Response\HeadersInterface
     */
     public function getHeaders() -> <HeadersInterface>;

    /**
     * Overwrites a header in the response
     *
     * @param string name
     * @param string value
     * @return \Scene\Http\ResponseInterface
     */
     public function setHeader(string name, value) -> <ResponseInterface>;

    /**
     * Send a raw header to the response
     *
     * @param string header
     * @return \Scene\Http\ResponseInterface
     */
     public function setRawHeader(string header) -> <ResponseInterface>;

    /**
     * Resets all the stablished headers
     *
     * @return \Scene\Http\ResponseInterface
     */
     public function resetHeaders() -> <ResponseInterface>;

    /**
     * Sets output expire time header
     *
     * @param \DateTime datetime
     * @return \Scene\Http\ResponseInterface
     */
     public function setExpires(<\DateTime> datetime) -> <ResponseInterface>;

    /**
     * Sends a Not-Modified response
     *
     * @return \Scene\Http\ResponseInterface
     */
     public function setNotModified() -> <ResponseInterface>;

    /**
     * Sets the response content-type mime, optionally the charset
     *
     * @param string contentType
     * @param string charset
     * @return \Scene\Http\ResponseInterface
     */
     public function setContentType(string contentType, charset = null) -> <ResponseInterface>;

    /**
     * Redirect by HTTP to another action or URL
     *
     * @param string location
     * @param boolean externalRedirect
     * @param int statusCode
     * @return \Scene\Http\ResponseInterface
     */
     public function redirect(location = null, boolean externalRedirect = false, int statusCode = 302) -> <ResponseInterface>;

    /**
     * Sets HTTP response body
     *
     * @param string content
     * @return \Scene\Http\ResponseInterface
     */
     public function setContent(string content) -> <ResponseInterface>;

    /**
     * Sets HTTP response body. The parameter is automatically converted to JSON
     *
     *<code>
     *  response->setJsonContent(array("status" => "OK"));
     *</code>
     *
     * @param string content
     * @return \Scene\Http\ResponseInterface
     */
     public function setJsonContent(content) -> <ResponseInterface>;

    /**
     * Appends a string to the HTTP response body
     *
     * @param string content
     * @return \Scene\Http\ResponseInterface
     */
     public function appendContent(content) -> <ResponseInterface>;

    /**
     * Gets the HTTP response body
     *
     * @return string
     */
     public function getContent() -> string;

    /**
     * Sends headers to the client
     *
     * @return \Scene\Http\ResponseInterface
     */
     public function sendHeaders() -> <ResponseInterface>;

    /**
     * Sends cookies to the client
     *
     * @return \Scene\Http\ResponseInterface
     */
     public function sendCookies() -> <ResponseInterface>;

    /**
     * Prints out HTTP response to the client
     *
     * @return \Scene\Http\ResponseInterface
     */
     public function send() -> <ResponseInterface>;

    /**
     * Sets an attached file to be sent at the end of the request
     *
     * @param string filePath
     * @param string|null attachmentName
     * @return \Scene\Http\ResponseInterface
     */
     public function setFileToSend(string filePath, attachmentName = null) -> <ResponseInterface>;

    }
