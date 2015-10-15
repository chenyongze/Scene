
/**
 * Request
 *
*/

namespace Scene\Http;

use Scene\Http\RequestInterface;
use Scene\http\Request\Exception;
use Scene\Http\Request\File;
use Scene\Di\InjectionAwareInterface;
use Scene\DiInterface;
use Scene\FilterInterface;

/**
 * Scene\Http\Request
 *
 * Encapsulates request information for easy and secure access from application controllers.
 *
 * The request object is a simple value object that is passed between the dispatcher and controller classes.
 * It packages the HTTP request environment.
 *
 *<code>
 *  $request = new \Scene\Http\Request();
 *  if ($request->isPost()) {
 *      if ($request->isAjax()) {
 *          echo 'Request was made using POST and AJAX';
 *      }
 *  }
 *</code>
 *
 */
class Request implements RequestInterface, InjectionAwareInterface
{
    /**
     * Dependency Injector
     *
     * @var null|\Scene\DiInterface
     * @access protected
    */
    protected _dependencyInjector;

    /**
     * Filter
     *
     * @var null
     * @access protected
    */
    protected _filter;

    /**
     * Raw Body
     *
     * @var null
     * @access protected
    */
    protected _rawBody;

    /**
     * Put Cache
     *
     * @var null
     * @access protected
    */
    protected _putCache;

    /**
     * Sets the dependency injector
     *
     * @param \Scene\DiInterface $dependencyInjector
     * @throws Exception
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
        return this->_dependencyInjector;
    }

    /**
     * Gets a variable from the $_REQUEST superglobal applying filters if needed.
     * If no parameters are given the $_REQUEST superglobal is returned
     *
     *<code>
     *  //Returns value from $_REQUEST["user_email"] without sanitizing
     *  $userEmail = $request->get("user_email");
     *
     *  //Returns value from $_REQUEST["user_email"] with sanitizing
     *  $userEmail = $request->get("user_email", "email");
     *</code>
     *
     * @param string|null name
     * @param string|array|null filters
     * @param mixed defaultValue
     * @param boolean notAllowEmpty
     * @param boolean noRecursive
     * @return mixed
     * @throws Exception
     */
    public function get(string! name = null, var filters = null, var defaultValue = null, boolean notAllowEmpty = false, boolean noRecursive = false)
    {
        return this->getHelper(_REQUEST, name, filters, defaultValue, notAllowEmpty, noRecursive);
    }

    /**
     * Gets a variable from the $_POST superglobal applying filters if needed
     * If no parameters are given the $_POST superglobal is returned
     *
     *<code>
     *  //Returns value from $_POST["user_email"] without sanitizing
     *  $userEmail = $request->getPost("user_email");
     *
     *  //Returns value from $_POST["user_email"] with sanitizing
     *  $userEmail = $request->getPost("user_email", "email");
     *</code>
     *
     * @param string|null name
     * @param string|array|null filters
     * @param mixed defaultValue
     * @param boolean notAllowEmpty
     * @param boolean noRecursive
     * @return mixed
     * @throws Exception
     */
    public function getPost(string! name = null, var filters = null, var defaultValue = null, boolean notAllowEmpty = false, boolean noRecursive = false)
    {
        return this->getHelper(_POST, name, filters, defaultValue, notAllowEmpty, noRecursive);
    }

    /**
     * Gets a variable from put request
     * 
     *<code>
     *  //Returns value from $_PUT["user_email"] without sanitizing
     *  $userEmail = $request->getPut("user_email");
     *
     *  //Returns value from $_PUT["user_email"] with sanitizing
     *  $userEmail = $request->getPut("user_email", "email");
     *</code>
     *
     * @param string|null name
     * @param string|array|null filters
     * @param mixed defaultValue
     * @param boolean notAllowEmpty
     * @param boolean noRecursive
     * @return mixed
     * @throws Exception
     */
    public function getPut(string! name = null, var filters = null, var defaultValue = null, boolean notAllowEmpty = false, boolean noRecursive = false)
    {
        var put;

        let put = this->_putCache;

        if typeof put != "array" {
            let put = [];
            parse_str(this->getRawBody(), put);

            let this->_putCache = put;
        }

        return this->getHelper(put, name, filters, defaultValue, notAllowEmpty, noRecursive);
    }

    /**
     * Gets variable from $_GET superglobal applying filters if needed
     * If no parameters are given the $_GET superglobal is returned
     *
     *<code>
     *  //Returns value from $_GET["id"] without sanitizing
     *  $id = $request->getQuery("id");
     *
     *  //Returns value from $_GET["id"] with sanitizing
     *  $id = $request->getQuery("id", "int");
     *
     *  //Returns value from $_GET["id"] with a default value
     *  $id = $request->getQuery("id", null, 150);
     *</code>
     *
     * @param string|null name
     * @param string|array|null filters
     * @param mixed defaultValue
     * @param boolean notAllowEmpty
     * @param boolean noRecursive
     * @return mixed
     * @throws Exception
     */
    public function getQuery(string! name = null, var filters = null, var defaultValue = null, boolean notAllowEmpty = false, boolean noRecursive = false)
    {
        return this->getHelper(_GET, name, filters, defaultValue, notAllowEmpty, noRecursive);
    }

    /**
     * Helper to get data from superglobals, applying filters if needed.
     * If no parameters are given the superglobal is returned.
     *
     * @param array source
     * @param string name
     * @param mixed filters
     * @param mixed defaultValue
     * @param boolean notAllowEmpty
     * @param boolsan noRecursive
     */
    protected final function getHelper(array source, string! name = null, var filters = null, var defaultValue = null, boolean notAllowEmpty = false, boolean noRecursive = false)
    {
        var value, filter, dependencyInjector;

        if name === null {
            return source;
        }

        if !fetch value, source[name] {
            return defaultValue;
        }

        if filters !== null {
            let filter = this->_filter;
            if typeof filter != "object" {
                let dependencyInjector = <DiInterface> this->_dependencyInjector;
                if typeof dependencyInjector != "object" {
                    throw new Exception("A dependency injection object is required to access the 'filter' service");
                }
                let filter = <FilterInterface> dependencyInjector->getShared("filter");
                let this->_filter = filter;
            }

            let value = filter->sanitize(value, filters, noRecursive);
        }

        if empty value && notAllowEmpty === true {
            return defaultValue;
        }

        return value;
    }

    /**
     * Gets variable from $_SERVER superglobal
     *
     * @param string name
     * @return mixed
     * @throws Exception
     */
    public function getServer(string! name)
    {
        var serverValue;

        if fetch serverValue, _SERVER[name] {
            return serverValue;
        }
        return null;
    }

    /**
     * Checks whether $_REQUEST superglobal has certain index
     *
     * @param string name
     * @return boolean
     * @throws Exception
     */
    public function has(string! name) -> boolean
    {
        return isset _REQUEST[name];
    }

    /**
     * Checks whether $_POST superglobal has certain index
     *
     * @param string name
     * @return boolean
     * @throws Exception
     */
    public function hasPost(string! name) -> boolean
    {
        return isset _POST[name];
    }

    /**
     * Checks whether the PUT data has certain index
     *
     * @param string name
     * @return boolean
     * @throws Exception
     */
    public function hasPut(string! name) -> boolean
    {
        var put;

        let put = this->getPut();

        return isset put[name];
    }

    /**
     * Checks whether $_GET superglobal has certain index
     *
     * @param string name
     * @return boolean
     * @throws Exception
     */
    public function hasQuery(string! name) -> boolean
    {
        return isset _GET[name];
    }

    /**
     * Checks whether $_SERVER superglobal has certain index
     *
     * @param string name
     * @return mixed
     * @throws Exception
     */
    public final function hasServer(string! name) -> boolean
    {
        return isset _SERVER[name];
    }

    /**
     * Gets HTTP header from request data
     *
     * @param string header
     * @return string
     * @throws Exception
     */
    public final function getHeader(string! header) -> string
    {
        var value, name;

        let name = strtoupper(strtr(header, "-", "_"));

        if fetch value, _SERVER[name] {
            return value;
        }

        if fetch value, _SERVER["HTTP_" . name] {
            return value;
        }

        return "";
    }

    /**
     * Gets HTTP schema (http/https)
     *
     * @return string
     */
    public function getScheme() -> string
    {
        var https, scheme;

        let https = this->getServer("HTTPS");
        if https {
            if https == "off" {
                let scheme = "http";
            } else {
                let scheme = "https";
            }
        } else {
            let scheme = "http";
        }
        return scheme;
    }

    /**
     * Checks whether request has been made using ajax. Checks if $_SERVER['HTTP_X_REQUESTED_WITH']=='XMLHttpRequest'
     *
     * @return boolean
     */
    public function isAjax() -> boolean
    {
        return isset _SERVER["HTTP_X_REQUESTED_WITH"] && _SERVER["HTTP_X_REQUESTED_WITH"] === "XMLHttpRequest";
    }

    /**
     * Checks whether request has been made using SOAP
     *
     * @return boolean
     */
    public function isSoapRequested() -> boolean
    {
        var contentType;

        if isset _SERVER["HTTP_SOAPACTION"] {
            return true;
        } else {
            let contentType = this->getContentType();
            if !empty contentType {
                return memstr(contentType, "application/soap+xml");
            }
        }
        return false;
    }

    /**
     * Checks whether request has been made using any secure layer
     *
     * @return boolean
     */
    public function isSecureRequest() -> boolean
    {
        return this->getScheme() === "https";
    }

    /**
     * Gets HTTP raw request body
     *
     * @return string
     */
    public function getRawBody() -> string
    {
        var rawBody, contents;

        let rawBody = this->_rawBody;
        if empty rawBody {

            let contents = file_get_contents("php://input");

            /**
             * We need store the read raw body because it can't be read again
             */
            let this->_rawBody = contents;
            return contents;
        }
        return rawBody;
    }

    /**
     * Gets decoded JSON HTTP raw request body
     *
     * @param boolean associative
     * @return \stdClass | array | boolean
     */
    public function getJsonRawBody(boolean associative = false) -> <\stdClass> | array | boolean
    {
        var rawBody;

        let rawBody = this->getRawBody();
        if typeof rawBody != "string" {
            return false;
        }

        return json_decode(rawBody, associative);
    }

    /**
     * Gets active server address IP
     *
     * @return string
     */
    public function getServerAddress() -> string
    {
        var serverAddr;

        if fetch serverAddr, _SERVER["SERVER_ADDR"] {
            return serverAddr;
        }
        return gethostbyname("localhost");
    }

    /**
     * Gets active server name
     *
     * @return string
     */
    public function getServerName() -> string
    {
        var serverName;

        if fetch serverName, _SERVER["SERVER_NAME"] {
            return serverName;
        }

        return "localhost";
    }

    /**
     * Gets information about schema, host and port used by the request
     *
     * @return string
     */
    public function getHttpHost() -> string
    {
        var httpHost, scheme, name, port;

        /**
         * Get the server name from _SERVER['HTTP_HOST']
         */
        let httpHost = this->getServer("HTTP_HOST");
        if httpHost {
            return httpHost;
        }

        /**
         * Get current scheme
         */
        let scheme = this->getScheme();

        /**
         * Get the server name from _SERVER['SERVER_NAME']
         */
        let name = this->getServer("SERVER_NAME");

        /**
         * Get the server port from _SERVER['SERVER_PORT']
         */
        let port = this->getServer("SERVER_PORT");

        /**
         * If is standard http we return the server name only
         */
        if scheme == "http" && port == 80  {
            return name;
        }

        /**
         * If is standard secure http we return the server name only
         */
        if scheme == "https" && port == "443" {
            return name;
        }

        return name . ":" . port;
    }

    /**
     * Gets HTTP URI which request has been made
     *
     * @return string
     */
    public final function getURI() -> string
    {
        var requestURI;

        if fetch requestURI, _SERVER["REQUEST_URI"] {
            return requestURI;
        }

        return "";
    }

    /**
     * Gets most possible client IPv4 Address. This method search in $_SERVER['REMOTE_ADDR'] and optionally in $_SERVER['HTTP_X_FORWARDED_FOR']
     *
     * @param boolean|null trustForwardedHeader
     * @return string|boolean
     * @throws Exception
     */
    public function getClientAddress(boolean trustForwardedHeader = false) -> string | boolean
    {
        var address = null;

        /**
         * Proxies uses this IP
         */
        if trustForwardedHeader {
            fetch address, _SERVER["HTTP_X_FORWARDED_FOR"];
            if address === null {
                fetch address, _SERVER["HTTP_CLIENT_IP"];
            }
        }

        if address === null {
            fetch address, _SERVER["REMOTE_ADDR"];
        }

        if typeof address == "string" {
            if memstr(address, ",") {
                /**
                 * The client address has multiples parts, only return the first part
                 */
                return explode(",", address)[0];
            }
            return address;
        }

        return false;
    }

    /**
     * Gets HTTP method which request has been made
     *
     * @return string
     */
    public final function getMethod() -> string
    {
        var requestMethod;

        if fetch requestMethod, _SERVER["REQUEST_METHOD"] {
            return requestMethod;
        }
        return "";
    }

    /**
     * Gets HTTP user agent used to made the request
     *
     * @return string
     */
    public function getUserAgent() -> string
    {
        var userAgent;

        if fetch userAgent, _SERVER["HTTP_USER_AGENT"] {
            return userAgent;
        }
        return "";
    }

    /**
     * Checks if a method is a valid HTTP method
     *
     * @param string method
     * @return boolean
     */
    public function isValidHttpMethod(string method) -> boolean
    {
        var lowerMethod;

        let lowerMethod = strtoupper(method);

        switch method {

            case "GET":
            case "POST":
            case "PUT":
            case "DELETE":
            case "HEAD":
            case "OPTIONS":
            case "PATCH":
                return true;
        }

        return false;
    }

    /**
     * Check if HTTP method match any of the passed methods
     * When strict is true it checks if validated methods are real HTTP methods
     *
     * @param string|array methods
     * @param boolean $strict
     * @return boolean
     */
    public function isMethod(var methods, boolean strict = false) -> boolean
    {
        var httpMethod, method;

        let httpMethod = this->getMethod();

        if typeof methods == "string" {
            if strict && !this->isValidHttpMethod(methods) {
                throw new Exception("Invalid HTTP method: " . methods);
            }
            return methods == httpMethod;
        }

        if typeof methods == "array" {
            for method in methods {
                if strict && !this->isValidHttpMethod(method) {
                    if typeof method == "string" {
                        throw new Exception("Invalid HTTP method: " . method);
                    } else {
                        throw new Exception("Invalid HTTP method: non-string");
                    }
                }
                if method == httpMethod {
                    return true;
                }
            }
            return false;
        }

        if strict {
            throw new Exception("Invalid HTTP method: non-string");
        }

        return false;
    }

    /**
     * Checks whether HTTP method is POST. if $_SERVER['REQUEST_METHOD']=='POST'
     *
     * @return boolean
     */
    public function isPost() -> boolean
    {
        return this->getMethod() === "POST";
    }

    /**
     * Checks whether HTTP method is GET. if $_SERVER['REQUEST_METHOD']=='GET'
     *
     * @return boolean
     */
    public function isGet() -> boolean
    {
        return this->getMethod() === "GET";
    }

    /**
     * Checks whether HTTP method is PUT. if $_SERVER['REQUEST_METHOD']=='PUT'
     *
     * @return boolean
     */
    public function isPut() -> boolean
    {
        return this->getMethod() === "PUT";
    }

    /**
     * Checks whether HTTP method is PATCH. if $_SERVER['REQUEST_METHOD']=='PATCH'
     *
     * @return boolean
     */
    public function isPatch() -> boolean
    {
        return this->getMethod() === "PATCH";
    }

    /**
     * Checks whether HTTP method is HEAD. if $_SERVER['REQUEST_METHOD']=='HEAD'
     *
     * @return boolean
     */
    public function isHead() -> boolean
    {
        return this->getMethod() === "HEAD";
    }

    /**
     * Checks whether HTTP method is DELETE. if $_SERVER['REQUEST_METHOD']=='DELETE'
     *
     * @return boolean
     */
    public function isDelete() -> boolean
    {
        return this->getMethod() === "DELETE";
    }

    /**
     * Checks whether HTTP method is OPTIONS. if $_SERVER['REQUEST_METHOD']=='OPTIONS'
     *
     * @return boolean
     */
    public function isOptions() -> boolean
    {
        return this->getMethod() === "OPTIONS";
    }

    /**
     * Checks whether request includes attached files
     *
     * @param boolean onlySuccessful
     * @return long
     * @throws Exception
     */
    public function hasFiles(boolean onlySuccessful = false) -> long
    {
        var files, file, error;
        int numberFiles = 0;

        let files = _FILES;

        if typeof files != "array" {
            return 0;
        }

        for file in files {
            if fetch error, file["error"] {

                if typeof error != "array" {
                    if !error || !onlySuccessful {
                        let numberFiles++;
                    }
                }

                if typeof error == "array" {
                    let numberFiles += this->hasFileHelper(error, onlySuccessful);
                }
            }
        }

        return numberFiles;
    }

    /**
     * Recursively counts file in an array of files
     *
     * @param mixed data
     * @param boolean onlySuccessful
     * @return long
     */
    protected final function hasFileHelper(var data, boolean onlySuccessful) -> long
    {
        var value;
        int numberFiles = 0;

        if typeof data != "array" {
            return 1;
        }

        for value in data {
            if typeof value != "array" {
                if !value || !onlySuccessful {
                    let numberFiles++;
                }
            }

            if typeof value == "array" {
                let numberFiles += this->hasFileHelper(value, onlySuccessful);
            }
        }

        return numberFiles;
    }

    /**
     * Gets attached files as \Scene\Http\Request\File instances
     *
     * @param boolean onlySuccessful
     * @return \Scene\Http\Request\File[]|null
     * @throws Exception
     */
    public function getUploadedFiles(boolean onlySuccessful = false) -> <File[]>
    {
        var superFiles, prefix, input, smoothInput, file, dataFile;
        array files = [];

        let superFiles = _FILES;

        if count(superFiles) > 0 {

            for prefix, input in superFiles {
                if typeof input["name"] == "array" {
                    let smoothInput = this->smoothFiles(input["name"], input["type"], input["tmp_name"], input["size"], input["error"], prefix);

                    for file in smoothInput {
                        if onlySuccessful == false || file["error"] == UPLOAD_ERR_OK {
                            let dataFile = [
                                "name": file["name"],
                                "type": file["type"],
                                "tmp_name": file["tmp_name"],
                                "size": file["size"],
                                "error": file["error"]
                            ];

                            let files[] = new File(dataFile, file["key"]);
                        }
                    }
                } else {
                    if onlySuccessful == false || input["error"] == UPLOAD_ERR_OK {
                        let files[] = new File(input, prefix);
                    }
                }
            }
        }

        return files;
    }

    /**
     * Smooth out $_FILES to have plain array with all files uploaded
     *
     * @param array names
     * @param array types
     * @param array tmp_names
     * @param array errors
     * @param string prefix
     * @return array
     */
    protected final function smoothFiles(array! names, array! types, array! tmp_names, array! sizes, array! errors, string prefix) -> array
    {
        var idx, name, file, files, parentFiles, p;

        let files = [];

        for idx, name in names {
            let p = prefix . "." . idx;

            if typeof name == "string" {

                let files[] = [
                    "name": name,
                    "type": types[idx],
                    "tmp_name": tmp_names[idx],
                    "size": sizes[idx],
                    "error": errors[idx],
                    "key": p
                ];
            }

            if typeof name == "array" {
                let parentFiles = this->smoothFiles(names[idx], types[idx], tmp_names[idx], sizes[idx], errors[idx], p);

                for file in parentFiles {
                    let files[] = file;
                }
            }
        }

        return files;
    }

    /**
     * Returns the available headers in the request
     *
     * @return array
     */
    public function getHeaders() -> array
    {
        var name, value, contentHeaders;
        array headers;

        let headers = [];
        let contentHeaders = ["CONTENT_TYPE": true, "CONTENT_LENGTH": true];

        for name, value in _SERVER {
            if starts_with(name, "HTTP_") {
                let name = ucwords(strtolower(str_replace("_", " ", substr(name, 5)))),
                    name = str_replace(" ", "-", name);
                let headers[name] = value;
            } elseif isset contentHeaders[name] {
                let name = ucwords(strtolower(str_replace("_", " ", name))),
                    name = str_replace(" ", "-", name);
                let headers[name] = value;
            }
        }

        return headers;
    }

    /**
     * Gets web page that refers active request. ie: http://www.google.com
     *
     * @return string
     */
    public function getHTTPReferer() -> string
    {
        var httpReferer;
        if fetch httpReferer, _SERVER["HTTP_REFERER"] {
            return httpReferer;
        }
        return "";
    }

    /**
     * Process a request header and return an array of values with their qualities
     *
     * @param string serverIndex
     * @param string name
     * @return array
     * @throws Exception
     */
    protected final function _getQualityHeader(string! serverIndex, string! name) -> array
    {
        var returnedParts, part, headerParts, headerPart, split;

        let returnedParts = [];
        for part in preg_split("/,\\s*/", this->getServer(serverIndex), -1, PREG_SPLIT_NO_EMPTY) {

            let headerParts = [];
            for headerPart in preg_split("/\s*;\s*/", trim(part), -1, PREG_SPLIT_NO_EMPTY) {
                if strpos(headerPart, "=") !== false {
                    let split = explode("=", headerPart, 2);
                    if split[0] === "q" {
                        let headerParts["quality"] = (double) split[1];
                    } else {
                        let headerParts[split[0]] = split[1];
                    }
                } else {
                    let headerParts[name] = headerPart;
                    let headerParts["quality"] = 1.0;
                }
            }

            let returnedParts[] = headerParts;
        }

        return returnedParts;
    }

    /**
     * Process a request header and return the one with best quality
     *
     * @param array qualityParts
     * @param string name
     * @return string
     * @throws Exception
     */
    protected final function _getBestQuality(array qualityParts, string! name) -> string
    {
        int i;
        double quality, acceptQuality;
        var selectedName, accept;

        let i = 0,
            quality = 0.0,
            selectedName = "";

        for accept in qualityParts {
            if i == 0 {
                let quality = (double) accept["quality"],
                    selectedName = accept[name];
            } else {
                let acceptQuality = (double) accept["quality"];
                if acceptQuality > quality {
                    let quality = acceptQuality,
                        selectedName = accept[name];
                }
            }
            let i++;
        }
        return selectedName;
    }

    /**
     * Gets content type which request has been made
     *
     * @return string
     */
    public function getContentType() -> string | null
    {
        var contentType;

        if fetch contentType, _SERVER["CONTENT_TYPE"] {
            return contentType;
        } else {
            /**
             * @see https://bugs.php.net/bug.php?id=66606
             */
            if fetch contentType, _SERVER["HTTP_CONTENT_TYPE"] {
                return contentType;
            }
        }

        return null;
    }

    /**
     * Gets array with mime/types and their quality accepted by the browser/client from $_SERVER['HTTP_ACCEPT']
     *
     * @return array
     */
    public function getAcceptableContent() -> array
    {
        return this->_getQualityHeader("HTTP_ACCEPT", "accept");
    }

    /**
     * Gets best mime/type accepted by the browser/client from $_SERVER['HTTP_ACCEPT']
     *
     * @return array
     */
    public function getBestAccept() -> string
    {
        return this->_getBestQuality(this->getAcceptableContent(), "accept");
    }

    /**
     * Gets charsets array and their quality accepted by the browser/client from $_SERVER['HTTP_ACCEPT_CHARSET']
     *
     * @return array
     */
    public function getClientCharsets() -> var
    {
        return this->_getQualityHeader("HTTP_ACCEPT_CHARSET", "charset");
    }

    /**
     * Gets best charset accepted by the browser/client from $_SERVER['HTTP_ACCEPT_CHARSET']
     *
     * @return string
     */
    public function getBestCharset() -> string
    {
        return this->_getBestQuality(this->getClientCharsets(), "charset");
    }

    /**
     * Gets languages array and their quality accepted by the browser/client from $_SERVER['HTTP_ACCEPT_LANGUAGE']
     *
     * @return array
     */
    public function getLanguages() -> array
    {
        return this->_getQualityHeader("HTTP_ACCEPT_LANGUAGE", "language");
    }

    /**
     * Gets best language accepted by the browser/client from $_SERVER['HTTP_ACCEPT_LANGUAGE']
     *
     * @return string
     */
    public function getBestLanguage() -> string
    {
        return this->_getBestQuality(this->getLanguages(), "language");
    }


    /**
     * Gets auth info accepted by the browser/client from $_SERVER['PHP_AUTH_USER']
     *
     * @return array
     */
    public function getBasicAuth() -> array | null
    {
        var auth;

        if isset _SERVER["PHP_AUTH_USER"] && isset _SERVER["PHP_AUTH_PW"] {
            let auth = [];
            let auth["username"] = _SERVER["PHP_AUTH_USER"];
            let auth["password"] = _SERVER["PHP_AUTH_PW"];
            return auth;
        }

        return null;
    }

    /**
     * Gets auth info accepted by the browser/client from $_SERVER['PHP_AUTH_DIGEST']
     *
     * @return array
     */
    public function getDigestAuth() -> array
    {
        var digest, matches, match;
        array auth;

        let auth = [];
        if fetch digest, _SERVER["PHP_AUTH_DIGEST"] {
            let matches = [];
            if !preg_match_all("#(\\w+)=(['\"]?)([^'\" ,]+)\\2#", digest, matches, 2) {
                return auth;
            }
            if typeof matches == "array" {
                for match in matches {
                    let auth[match[1]] = match[3];
                }
            }
        }

        return auth;
    }
}
