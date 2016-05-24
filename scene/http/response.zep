
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

use Scene\Http\ResponseInterface;
use Scene\Http\Response\Exception;
use Scene\Http\Response\HeadersInterface;
use Scene\Http\Response\CookiesInterface;
use Scene\Http\Response\Headers;
use Scene\Di;
use Scene\DiInterface;
use Scene\Di\InjectionAwareInterface;
use Scene\Mvc\UrlInterface;
use Scene\Mvc\ViewInterface;

/**
 * Scene\Http\Response
 *
 * Part of the HTTP cycle is return responses to the clients.
 * Scene\HTTP\Response is the Scene component responsible to achieve this task.
 * HTTP responses are usually composed by headers and body.
 *
 *<code>
 *  $response = new \Scene\Http\Response();
 *  $response->setStatusCode(200, "OK");
 *  $response->setContent("<html><body>Hello</body></html>");
 *  $response->send();
 *</code>
 */
class Response implements ResponseInterface, InjectionAwareInterface
{
    /**
     * Sent
     *
     * @var boolean
     * @access protected
    */
    protected _sent = false;

    /**
     * Content
     *
     * @var null|string
     * @access protected
    */
    protected _content;

    /**
     * Headers
     *
     * @var null|\Scene\Http\Response\HeadersInterface
     * @access protected
    */
    protected _headers;
 
    /**
     * Cookies
     *
     * @var null|\Scene\廎系tp\Response\CookiesInterface
     * @access protected
    */
    protected _cookies;

    /**
     * File
     *
     * @var null|string
     * @access protected
    */
    protected _file;

    /**
     * Dependency Injector
     *
     * @var null|\Scene\DiInterface
     * @access protected
    */
    protected _dependencyInjector;

    /**
     * Scene\Http\Response constructor
     *
     * @param string content
     * @param int code
     * @param string status
     */
    public function __construct(content = null, code = null, status = null)
    {
        /**
         * A Phalcon\Http\Response\Headers bag is temporary used to manage the headers before sent them to the client
         */
        let this->_headers = new Headers();

        if content !== null {
            let this->_content = content;
        }
        if code !== null {
            this->setStatusCode(code, status);
        }
    }

    /**
     * Sets the dependency injector
     *
     * @param \Scene\DiInterface dependencyInjector
     */
    public function setDI(<DiInterface> dependencyInjector)
    {
        let this->_dependencyInjector = dependencyInjector;
    }

    /**
     * Returns the internal dependency injector
     *
     * @return \Scene\DiInterface|null
     */
    public function getDI() -> <DiInterface>
    {
        var dependencyInjector;

        let dependencyInjector = this->_dependencyInjector;
        if typeof dependencyInjector != "object" {
            let dependencyInjector = Di::getDefault();
        }
        return dependencyInjector;
    }

    /**
     * Sets the HTTP response code
     *
     *<code>
     *  $response->setStatusCode(404, "Not Found");
     *</code>
     *
     * @param int code
     * @param string message
     * @return \Scene\Http\ResponseInterface
     */
    public function setStatusCode(int code, string message = null) -> <ResponseInterface>
    {
        var headers, currentHeadersRaw, key, defaultMessage, statusCodes;

        let headers = this->getHeaders(),
            currentHeadersRaw = headers->toArray();

        /**
         * We use HTTP/1.1 instead of HTTP/1.0
         *
         * Before that we would like to unset any existing HTTP/x.y headers
         */
        if typeof currentHeadersRaw == "array" {
            for key, _ in currentHeadersRaw {
                if typeof key == "string" && strstr(key, "HTTP/") {
                    headers->remove(key);
                }
            }
        }

        // if an empty message is given we try and grab the default for this
        // status code. If a default doesn't exist, stop here.
        if message === null {

            let statusCodes = [
                // INFORMATIONAL CODES
                100 : "Continue",
                101 : "Switching Protocols",
                102 : "Processing",
                // SUCCESS CODES
                200 : "OK",
                201 : "Created",
                202 : "Accepted",
                203 : "Non-Authoritative Information",
                204 : "No Content",
                205 : "Reset Content",
                206 : "Partial Content",
                207 : "Multi-status",
                208 : "Already Reported",
                226 : "IM Used",
                // REDIRECTION CODES
                300 : "Multiple Choices",
                301 : "Moved Permanently",
                302 : "Found",
                303 : "See Other",
                304 : "Not Modified",
                305 : "Use Proxy",
                306 : "Switch Proxy", // Deprecated
                307 : "Temporary Redirect",
                308 : "Permanent Redirect",
                // CLIENT ERROR
                400 : "Bad Request",
                401 : "Unauthorized",
                402 : "Payment Required",
                403 : "Forbidden",
                404 : "Not Found",
                405 : "Method Not Allowed",
                406 : "Not Acceptable",
                407 : "Proxy Authentication Required",
                408 : "Request Time-out",
                409 : "Conflict",
                410 : "Gone",
                411 : "Length Required",
                412 : "Precondition Failed",
                413 : "Request Entity Too Large",
                414 : "Request-URI Too Large",
                415 : "Unsupported Media Type",
                416 : "Requested range not satisfiable",
                417 : "Expectation Failed",
                418 : "I'm a teapot",
                421 : "Misdirected Request",
                422 : "Unprocessable Entity",
                423 : "Locked",
                424 : "Failed Dependency",
                425 : "Unordered Collection",
                426 : "Upgrade Required",
                428 : "Precondition Required",
                429 : "Too Many Requests",
                431 : "Request Header Fields Too Large",
                451 : "Unavailable For Legal Reasons",
                499 : "Client Closed Request",
                // SERVER ERROR
                500 : "Internal Server Error",
                501 : "Not Implemented",
                502 : "Bad Gateway",
                503 : "Service Unavailable",
                504 : "Gateway Time-out",
                505 : "HTTP Version not supported",
                506 : "Variant Also Negotiates",
                507 : "Insufficient Storage",
                508 : "Loop Detected",
                511 : "Network Authentication Required"
            ];

            if !isset statusCodes[code] {
                throw new Exception("Non-standard statuscode given without a message");
            }

            let defaultMessage = statusCodes[code],
                message = defaultMessage;
        }

        headers->setRaw("HTTP/1.1 " . code . " " . message);

        /**
         * We also define a 'Status' header with the HTTP status
         */
        headers->set("Status", code . " " . message);

        return this;
    }

    /**
     * Returns the status code
     *
     *<code>
     *  print_r($response->getStatusCode());
     *</code>
     *
     * @return array
     */
    public function getStatusCode() -> array
    {
        return this->getHeaders()->get("Status");
    }

    /**
     * Sets a headers bag for the response externally
     *
     * @param \Scene\Http\Response\HeadersInterface headers
     * @return \Scene\Http\ResponseInterface
     */
    public function setHeaders(<HeadersInterface> headers) -> <ResponseInterface>
    {
        let this->_headers = headers;
        return this;
    }

    /**
     * Returns headers set by the user
     *
     * @return \Scene\Http\Response\HeadersInterface
     */
    public function getHeaders() -> <HeadersInterface>
    {
        return this->_headers;
    }

    /**
     * Sets a cookies bag for the response externally
     *
     * @param \Scene\Http\Response\CookiesInterface cookies
     * @return \Scene\Http\ResponseInterface
     */
    public function setCookies(<CookiesInterface> cookies) -> <ResponseInterface>
    {
        let this->_cookies = cookies;
        return this;
    }

    /**
     * Returns coookies set by the user
     *
     * @return \Scene\Http\Response\CookiesInterface|null
     */
    public function getCookies() -> <CookiesInterface>
    {
        return this->_cookies;
    }

    /**
     * Overwrites a header in the response
     *
     *<code>
     *  $response->setHeader("Content-Type", "text/plain");
     *</code>
     *
     * @param string name
     * @param string value
     * @return \Scene\Http\ResponseInterface
     */
    public function setHeader(string name, value) -> <ResponseInterface>
    {
        var headers;
        let headers = this->getHeaders();
        headers->set(name, value);
        return this;
    }

    /**
     * Send a raw header to the response
     *
     *<code>
     *  $response->setRawHeader("HTTP/1.1 404 Not Found");
     *</code>
     *
     * @param string header
     * @return \Scene\Http\ResponseInterface
     */
    public function setRawHeader(string header) -> <ResponseInterface>
    {
        var headers;
        let headers = this->getHeaders();
        headers->setRaw(header);
        return this;
    }

    /**
     * Resets all the stablished headers
     *
     * @return \Scene\Http\ResponseInterface
     */
    public function resetHeaders() -> <ResponseInterface>
    {
        var headers;
        let headers = this->getHeaders();
        headers->reset();
        return this;
    }

    /**
     * Sets a Expires header to use HTTP cache
     *
     *<code>
     *  $response->setExpires(new DateTime());
     *</code>
     *
     * @param DateTime datetime
     * @return \Scene\Http\ResponseInterface
     */
    public function setExpires(<\DateTime> datetime) -> <ResponseInterface>
    {
        var date;

        let date = clone datetime;

        /**
         * All the expiration times are sent in UTC
         * Change the timezone to utc
         */
        date->setTimezone(new \DateTimeZone("UTC"));

        /**
         * The 'Expires' header set this info
         */
        this->setHeader("Expires", date->format("D, d M Y H:i:s") . " GMT");
        return this;
    }

    /**
     * Sets Last-Modified header
     *
     *<code>
     *  $this->response->setLastModified(new DateTime());
     *</code>
     *
     * @param \DateTime datetime
     * @return \Scene\Http\ResponseInterface
     */
    public function setLastModified(<\DateTime> datetime) -> <ResponseInterface>
    {
        var date;

        let date = clone datetime;

        /**
         * All the Last-Modified times are sent in UTC
         * Change the timezone to utc
         */
        date->setTimezone(new \DateTimeZone("UTC"));

        /**
         * The 'Last-Modified' header sets this info
         */
        this->setHeader("Last-Modified", date->format("D, d M Y H:i:s") . " GMT");
        return this;
    }

    /**
     * Sets Cache headers to use HTTP cache
     *
     *<code>
     *  $response->setCache(60);
     *</code>
     *
     * @param int minutes
     * @return \Scene\Http\ResponseInterface
     */
    public function setCache(int! minutes) -> <ResponseInterface>
    {
        var date;

        let date = new \DateTime();
        date->modify("+" . minutes . " minutes");

        this->setExpires(date);
        this->setHeader("Cache-Control", "max-age=" . (minutes * 60));

        return this;
    }

    /**
     * Sends a Not-Modified response
     *
     * @return \Scene\Http\ResponseInterface
     */
    public function setNotModified() -> <ResponseInterface>
    {
        this->setStatusCode(304, "Not modified");
        return this;
    }

    /**
     * Sets the response content-type mime, optionally the charset
     *
     *<code>
     *  $response->setContentType('application/pdf');
     *  $response->setContentType('text/plain', 'UTF-8');
     *</code>
     *
     * @param string contentType
     * @param string|null charset
     * @return \Scene\Http\ResponseInterface
     */
    public function setContentType(string contentType, charset = null) -> <ResponseInterface>
    {
        if charset === null {
            this->setHeader("Content-Type", contentType);
        } else {
            this->setHeader("Content-Type", contentType . "; charset=" . charset);
        }

        return this;
    }

    /**
     * Set a custom ETag
     *
     *<code>
     *  $response->setEtag(md5(time()));
     *</code>
     *
     * @param string etag
     */
    public function setEtag(string etag) -> <ResponseInterface>
    {
        this->setHeader("Etag", etag);

        return this;
    }

    /**
     * Redirect by HTTP to another action or URL
     *
     *<code>
     *  //Using a string redirect (internal/external)
     *  $response->redirect("posts/index");
     *  $response->redirect("http://en.wikipedia.org", true);
     *  $response->redirect("http://www.example.com/new-location", true, 301);
     *
     *</code>
     *
     * @param string|array|null location
     * @param boolean|null externalRedirect
     * @param int|null statusCode
     * @return \Scene\Http\ResponseInterface
     */
    public function redirect(location = null, boolean externalRedirect = false, int statusCode = 302) -> <ResponseInterface>
    {
        var header, url, dependencyInjector, matched, view;

        if !location {
            let location = "";
        }

        if externalRedirect {
            let header = location;
        } else {
            if typeof location == "string" && strstr(location, "://") {
                let matched = preg_match("/^[^:\\/?#]++:/", location);
                if matched {
                    let header = location;
                } else {
                    let header = null;
                }
            } else {
                let header = null;
            }
        }

        let dependencyInjector = this->getDI();

        if !header {
            let url = <UrlInterface> dependencyInjector->getShared("url"),
                header = url->get(location);
        }

        if dependencyInjector->has("view") {
            let view = dependencyInjector->getShared("view");
            if view instanceof ViewInterface {
                view->disable();
            }
        }

        /**
         * The HTTP status is 302 by default, a temporary redirection
         */
        if statusCode < 300 || statusCode > 308 {
            let statusCode = 302;
        }

        this->setStatusCode(statusCode);

        /**
         * Change the current location using 'Location'
         */
        this->setHeader("Location", header);

        return this;
    }

    /**
     * Sets HTTP response body
     *
     *<code>
     *  $response->setContent("<h1>Hello!</h1>");
     *</code>
     *
     * @param string content
     * @return \Scene\Http\ResponseInterface
     */
    public function setContent(string content) -> <ResponseInterface>
    {
        let this->_content = content;
        return this;
    }

    /**
     * Sets HTTP response body. The parameter is automatically converted to JSON
     *
     *<code>
     *  $response->setJsonContent(array("status" => "OK"));
     *</code>
     *
     * @param mixed content
     * @param int jsonOptions
     * @return \Scene\Http\ResponseInterface
     */
    public function setJsonContent(var content, int jsonOptions = 0, int depth = 512) -> <ResponseInterface>
    {
        this->setContentType("application/json", "UTF-8");
        this->setContent(json_encode(content, jsonOptions, depth));
        return this;
    }

    /**
     * Appends a string to the HTTP response body
     *
     * @param string content
     * @return \Scene\Http\ResponseInterface
     */
    public function appendContent(content) -> <ResponseInterface>
    {
        let this->_content = this->getContent() . content;
        return this;
    }

    /**
     * Gets the HTTP response body
     *
     * @return string|null
     */
    public function getContent() -> string
    {
        return this->_content;
    }

    /**
     * Check if the response is already sent
     *
     * @return boolean
     */
    public function isSent() -> boolean
    {
        return this->_sent;
    }

    /**
     * Sends headers to the client
     *
     * @return \Scene\Http\ResponseInterface
     */
    public function sendHeaders() -> <ResponseInterface>
    {
        this->_headers->send();
        return this;
    }

    /**
     * Sends cookies to the client
     *
     * @return \Scene\Http\ResponseInterface
     */
    public function sendCookies() -> <ResponseInterface>
    {
        var cookies;
        let cookies = this->_cookies;
        if typeof cookies == "object" {
            cookies->send();
        }
        return this;
    }

    /**
     * Prints out HTTP response to the client
     *
     * @return \Scene\Http\ResponseInterface
     */
    public function send() -> <ResponseInterface>
    {
        var content, file;

        if this->_sent {
            throw new Exception("Response was already sent");
        }

        this->sendHeaders();

        this->sendCookies();

        /**
         * Output the response body
         */
        let content = this->_content;
        if content != null {
            echo content;
        } else {
            let file = this->_file;

            if typeof file == "string" && strlen(file) {
                readfile(file);
            }
        }

        let this->_sent = true;
        return this;
    }

    /**
     * Sets an attached file to be sent at the end of the request
     *
     * @param string filePath
     * @param string|null attachmentName
     * @param boolean|null attachment
     * @throws Excepiton
     */
    public function setFileToSend(string filePath, attachmentName = null, attachment = true) -> <ResponseInterface>
    {
        var basePath;

        if typeof attachmentName != "string" {
            let basePath = basename(filePath);
        } else {
            let basePath = attachmentName;
        }

        if attachment {
            this->setRawHeader("Content-Description: File Transfer");
            this->setRawHeader("Content-Type: application/octet-stream");
            this->setRawHeader("Content-Disposition: attachment; filename=" . basePath);
            this->setRawHeader("Content-Transfer-Encoding: binary");
        }

        let this->_file = filePath;

        return this;
    }
}
