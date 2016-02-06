
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

use Scene\Http\Client\Method;
use Scene\Http\Client\Response;
use Scene\Http\Client\Exception;

/**
 * Scene\Http\Client
 *
 * HTTP client
 *
 */
class Client
{

    /**
     * Cookie
     *
     * @var null|string
     * @access protected
    */
    protected _cookie = null;

    /**
     * Cookie File
     *
     * @var null|string
     * @access protected
    */
    protected _cookieFile = null;

    /**
     * Curl options
     *
     * @var null|array
     * @access protected
    */
    protected _curlOpts = [];

    /**
     * Default headers
     *
     * @var null|array
     * @access protected
    */
    protected _defaultHeaders = [];

    /**
     * Handle
     *
     * @var null|string
     * @access protected
    */
    protected _handle = null;

    /**
     * Json options
     *
     * @var null|array
     * @access protected
    */
    protected _jsonOpts = [];

    /**
     * Socket time out
     *
     * @var null|string
     * @access protected
    */
    protected _socketTimeout = null;

    /**
     * Verify peer
     *
     * @var boolean
     * @access protected
    */
    protected _verifyPeer = true;

    /**
     * Verify host
     *
     * @var boolean
     * @access protected
    */
    protected _verifyHost = true;

    /**
     * Auth
     *
     * @var array
     * @access protected
    */
    protected _auth = [
        "user" : "",
        "pass" : "",
        "method" : CURLAUTH_BASIC
    ];

    /**
     * Proxy
     *
     * @var array
     * @access protected
    */
    protected _proxy = [
        "port" : false,
        "tunnel" : false,
        "address" : false,
        "type" : CURLPROXY_HTTP,
        "auth" : [
            "user" : "",
            "pass" : "",
            "method" : CURLAUTH_BASIC
        ]
    ];

    /**
     * Set JSON decode mode
     *
     * @param bool assoc When TRUE, returned objects will be converted into associative arrays.
     * @param int depth User specified recursion depth.
     * @param int options Bitmask of JSON decode options. Currently only JSON_BIGINT_AS_STRING is supported (default is to cast large integers as floats)
     */
    public function jsonOpts(boolean assoc = false, int! depth = 512, int! options = 0)
    {
        let this->_jsonOpts = [assoc, depth, options];
    }

    /**
     * Verify SSL peer
     *
     * @param bool enabled enable SSL verification, by default is true
     */
    public function verifyPeer(boolean enabled)
    {
        let this->_verifyPeer = enabled;
    }

    /**
     * Verify SSL host
     *
     * @param bool enabled enable SSL host verification, by default is true
     */
    public function verifyHost(boolean enabled)
    {
        let this->_verifyhost = enabled;
    }

    /**
     * Set a timeout
     *
     * @param integer seconds timeout value in seconds
     */
    public function timeout(int! seconds)
    {
        let this->_socketTimeout = seconds;
    }

    /**
     * Set default headers to send on every request
     *
     * @param array headers headers array
     */
    public function defaultHeaders(array! headers)
    {
        let this->_defaultHeaders = array_merge(this->_defaultHeaders, headers);
    }

    /**
     * Set a new default header to send on every request
     *
     * @param string name header name
     * @param string value header value
     */
    public function defaultHeader(string! name, string! value)
    {
        let this->_defaultHeaders[name] = value;
    }

    /**
     * Clear all the default headers
     */
    public function clearDefaultHeaders()
    {
        let this->_defaultHeaders = [];
    }

    /**
     * Set curl options to send on every request
     *
     * @param array options options array
     * @return array
     */
    public function curlOpts(array! options) -> array
    {
        return this->_mergeCurlOptions(this->_curlOpts, options);
    }

    /**
     * Set a new default header to send on every request
     *
     * @param string name header name
     * @param string value header value
     */
    public function curlOpt(string! name, string! value)
    {
        let this->_curlOpts[name] = value;
    }

    /**
     * Clear all the default headers
     */
    public function clearCurlOpts()
    {
        let this->_curlOpts = [];
    }

    /**
     * Set a Mashape key to send on every request as a header
     * Obtain your Mashape key by browsing one of your Mashape applications on https://www.mashape.com
     *
     * Note: Mashape provides 2 keys for each application: a 'Testing' and a 'Production' one.
     *       Be aware of which key you are using and do not share your Production key.
     *
     * @param string key Mashape key
     */
    public function setMashapeKey(string! key)
    {
        this->defaultHeader("X-Mashape-Key", key);
    }

    /**
     * Set a coockie string for enabling coockie handling
     *
     * @param string cookie
     */
    public function cookie(string! cookie)
    {
        let this->_cookie = cookie;
    }

    /**
     * Set a coockie file path for enabling coockie handling
     *
     * $cookieFile must be a correct path with write permission
     *
     * @param string cookieFile - path to file for saving cookie
     */
    public function cookieFile(string! cookieFile)
    {
        let this->_cookieFile = cookieFile;
    }

    /**
     * Set authentication method to use
     *
     * @param string username authentication username
     * @param string password authentication password
     * @param int method authentication method
     */
    public function auth(string! username = "", string! password = "", int! method = 1)
    {
        let this->_auth["user"] = username,
            this->_auth["pass"] = password,
            this->_auth["method"] = method;
    }

    /**
     * Set proxy to use
     *
     * @param string address proxy address
     * @param int port proxy port
     * @param int port proxy type (Available options for this are CURLPROXY_HTTP, CURLPROXY_HTTP_1_0 CURLPROXY_SOCKS4, CURLPROXY_SOCKS5, CURLPROXY_SOCKS4A and CURLPROXY_SOCKS5_HOSTNAME)
     * @param boolean tunnel enable/disable tunneling
     */
    public function proxy(string! address, int! port = 1080, int! type = 0, boolean tunnel = false)
    {
        let this->_proxy["type"] = type,
            this->_proxy["port"] = port,
            this->_proxy["tunnel"] = tunnel,
            this->_proxy["address"] = address;
    }

    /**
     * Set proxy authentication method to use
     *
     * @param string username authentication username
     * @param string password authentication password
     * @param int method authentication method
     */
    public function proxyAuth(string! username, string! password, int! method = 1)
    {
        let this->_proxy["auth"]["user"] = username,
            this->_proxy["auth"]["pass"] = password,
            this->_proxy["auth"]["method"] = method;
    }

    /**
     * Send a GET request to a URL
     *
     * @param string url URL to send the GET request to
     * @param array headers additional headers to send
     * @param mixed parameters parameters to send in the querystring
     * @param string username Authentication username (deprecated)
     * @param string password Authentication password (deprecated)
     * @return \Scene\Http\Client\Response
     */
    public function get(string! url, array! headers = [], var parameters = null, string username = null, string password = null)
    {
        return this->send(Method::GET, url, parameters, headers, username, password);
    }

    /**
     * Send a HEAD request to a URL
     * 
     * @param string url URL to send the HEAD request to
     * @param array headers additional headers to send
     * @param mixed parameters parameters to send in the querystring
     * @param string username Basic Authentication username (deprecated)
     * @param string password Basic Authentication password (deprecated)
     * @return \Scene\Http\Client\Response
     */
    public function head(string! url, array! headers = [], var parameters = null, string username = null, string password = null)
    {
        return this->send(Method::HEAD, url, parameters, headers, username, password);
    }

    /**
     * Send a OPTIONS request to a URL
     * 
     * @param string url URL to send the OPTIONS request to
     * @param array headers additional headers to send
     * @param mixed parameters parameters to send in the querystring
     * @param string username Basic Authentication username
     * @param string password Basic Authentication password
     * @return \Scene\Http\Client\Response
     */
    public function options(string! url, array! headers = [], var parameters = null, string username = null, string password = null)
    {
        return this->send(Method::OPTIONS, url, parameters, headers, username, password);
    }

    /**
     * Send a CONNECT request to a URL
     * 
     * @param string url URL to send the CONNECT request to
     * @param array headers additional headers to send
     * @param mixed parameters parameters to send in the querystring
     * @param string username Basic Authentication username (deprecated)
     * @param string password Basic Authentication password (deprecated)
     * @return \Scene\Http\Client\Response
     */
    public function connect(string! url, array! headers = [], var parameters = null, string username = null, string password = null)
    {
        return this->send(Method::CONNECT, url, parameters, headers, username, password);
    }

    /**
     * Send POST request to a URL
     * 
     * @param string url URL to send the POST request to
     * @param array headers additional headers to send
     * @param mixed body POST body data
     * @param string username Basic Authentication username (deprecated)
     * @param string password Basic Authentication password (deprecated)
     * @return \Scene\Http\Client\Response response
     */
    public function post(string! url, array! headers = [], var parameters = null, string username = null, string password = null)
    {
        return this->send(Method::POST, url, parameters, headers, username, password);
    }

    /**
     * Send DELETE request to a URL
     * 
     * @param string url URL to send the DELETE request to
     * @param array headers additional headers to send
     * @param mixed body DELETE body data
     * @param string username Basic Authentication username (deprecated)
     * @param string password Basic Authentication password (deprecated)
     * @return \Scene\Http\Client\Response
     */
    public function delete(string! url, array! headers = [], var parameters = null, string username = null, string password = null)
    {
        return this->send(Method::DELETE, url, parameters, headers, username, password);
    }

    /**
     * Send PUT request to a URL
     * 
     * @param string url URL to send the PUT request to
     * @param array headers additional headers to send
     * @param mixed body PUT body data
     * @param string username Basic Authentication username (deprecated)
     * @param string password Basic Authentication password (deprecated)
     * @return \Scene\Http\Client\Response
     */
    public function put(string! url, array! headers = [], var parameters = null, string username = null, string password = null)
    {
        return this->send(Method::PUT, url, parameters, headers, username, password);
    }

    /**
     * Send PATCH request to a URL
     * 
     * @param string url URL to send the PATCH request to
     * @param array headers additional headers to send
     * @param mixed body PATCH body data
     * @param string username Basic Authentication username (deprecated)
     * @param string password Basic Authentication password (deprecated)
     * @return \Scene\Http\Client\Response
     */
    public function patch(string! url, array! headers = [], var parameters = null, string username = null, string password = null)
    {
        return this->send(Method::PATCH, url, parameters, headers, username, password);
    }

    /**
     * Send TRACE request to a URL
     * 
     * @param string url URL to send the TRACE request to
     * @param array headers additional headers to send
     * @param mixed body TRACE body data
     * @param string username Basic Authentication username (deprecated)
     * @param string password Basic Authentication password (deprecated)
     * @return \Scene\Http\Client\Response
     */
    public function trace(string! url, array! headers = [], var parameters = null, string username = null, string password = null)
    {
        return this->send(Method::TRACE, url, parameters, headers, username, password);
    }

    /**
     * This function is useful for serializing multidimensional arrays, and avoid getting
     * the 'Array to string conversion' notice
     */
    public function buildHTTPCurlQuery(var data, var parent = false)
    {
        var result, key, value, new_key;

        let result = [];

        if typeof data == "object" {
            let data = get_object_vars(data);
        }

        for key, value in data {
            if parent {
                let new_key = sprintf("%s[%s]", parent, key);
            } else {
                let new_key = key;
            }

            if (typeof value == "array" || typeof value == "object") && !(value instanceof \CURLFile) {
                let result = array_merge(result, this->buildHTTPCurlQuery(value, new_key));
            } else {
                let result[new_key] = value;
            }
        }

        return result;
    }

    /**
     * Send a cURL request
     * 
     * @param \Scene\Http\Client\Method method HTTP method to use
     * @param string url URL to send the request to
     * @param mixed body request body
     * @param array headers additional headers to send
     * @param string username Authentication username (deprecated)
     * @param string password Authentication password (deprecated)
     * @throws Exception if a cURL error occurs
     * @return \Scene\Http\Client\Response
     */
    public function send(string method, string! url, var body = null, array headers = [], string username = null, string password = null)
    {
        var curl_base_options, response, error, info, header_size, header, httpCode;

        let this->_handle = curl_init();

        if method !== Method::GET {
            curl_setopt(this->_handle, CURLOPT_CUSTOMREQUEST, method);

            if typeof body == "array" || body instanceof \Traversable {
                curl_setopt(this->_handle, CURLOPT_POSTFIELDS, this->buildHTTPCurlQuery(body));
            } else {
                curl_setopt(this->_handle, CURLOPT_POSTFIELDS, body);
            }
        } elseif typeof body == "array" {
            if strpos(url, "?") !== false {
                let url .= "&";
            } else {
                let url .= "?";
            }

            let url .= urldecode(http_build_query(this->buildHTTPCurlQuery(body)));
        }

        let curl_base_options = [
            CURLOPT_URL : this->_encodeUrl(url),
            CURLOPT_RETURNTRANSFER : true,
            CURLOPT_FOLLOWLOCATION : true,
            CURLOPT_MAXREDIRS : 10,
            CURLOPT_HTTPHEADER : this->getFormattedHeaders(headers),
            CURLOPT_HEADER : true,
            CURLOPT_SSL_VERIFYPEER : this->_verifyPeer,
            //CURLOPT_SSL_VERIFYHOST accepts only 0 (false) or 2 (true). Future versions of libcurl will treat values 1 and 2 as equals
            CURLOPT_SSL_VERIFYHOST : this->_verifyHost === false ? 0 : 2,
            // If an empty string, '', is set, a header containing all supported encoding types is sent
            CURLOPT_ENCODING : ""
        ];

        curl_setopt_array(this->_handle, this->_mergeCurlOptions(curl_base_options, this->_curlOpts));

        if this->_socketTimeout != null {
            curl_setopt(this->_handle, CURLOPT_TIMEOUT, this->_socketTimeout);
        }

        if this->_cookie {
            curl_setopt(this->_handle, CURLOPT_COOKIE, this->_cookie);
        }

        if this->_cookieFile {
            curl_setopt(this->_handle, CURLOPT_COOKIEFILE, this->_cookieFile);
            curl_setopt(this->_handle, CURLOPT_COOKIEJAR, this->_cookieFile);
        }

        // supporting deprecated http auth method
        if !empty username {
            curl_setopt_array(this->_handle, [
                CURLOPT_HTTPAUTH : CURLAUTH_BASIC,
                CURLOPT_USERPWD : username . ":" . password
            ]);
        }

        if !empty this->_auth["user"] {
            curl_setopt_array(this->_handle, [
                CURLOPT_HTTPAUTH : this->_auth["method"],
                CURLOPT_USERPWD : this->_auth["user"] . ":" . this->_auth["pass"]
            ]);
        }

        if this->_proxy["address"] !== false {
            curl_setopt_array(this->_handle, [
                CURLOPT_PROXYTYPE       : this->_proxy["type"],
                CURLOPT_PROXY           : this->_proxy["address"],
                CURLOPT_PROXYPORT       : this->_proxy["port"],
                CURLOPT_HTTPPROXYTUNNEL : this->_proxy["tunnel"],
                CURLOPT_PROXYAUTH       : this->_proxy["auth"]["method"],
                CURLOPT_PROXYUSERPWD    : this->_proxy["auth"]["user"] . ":" . this->_proxy["auth"]["pass"]
            ]);
        }

        let response = curl_exec(this->_handle);
        let error    = curl_error(this->_handle);
        let info     = this->getInfo();

        if error {
            throw new Exception(error);
        }

        // Split the full response in its headers and body
        let header_size = info["header_size"];
        let header      = substr(response, 0, header_size);
        let body        = substr(response, header_size);
        let httpCode    = info["http_code"];

        return new Response(httpCode, body, header, this->_jsonOpts);
    }

    public function getInfo(var options = false)
    {
        var info;

        if options {
            let info = curl_getinfo(this->_handle, options);
        } else {
            let info = curl_getinfo(this->_handle);
        }

        return info;
    }

    public function getCurlHandle()
    {
        return this->_handle;
    }

    public function getFormattedHeaders(headers)
    {
        var formattedHeaders, combinedHeaders, key, value;

        let formattedHeaders = [];

        let combinedHeaders = array_change_key_case(array_merge((array) headers, this->_defaultHeaders));

        for key, value in combinedHeaders {
            let formattedHeaders[] = this->_getHeaderString(key, value);
        }

        if !array_key_exists("user-agent", combinedHeaders) {
            let formattedHeaders[] = "user-agent: scene/0.1";
        }

        if !array_key_exists("expect", combinedHeaders) {
            let formattedHeaders[] = "expect:";
        }

        return formattedHeaders;

    }

    protected function _getArrayFromQuerystring(query)
    {
        var values;

        let query = preg_replace_callback("/(?:^|(?<=&))[^=[]+/", function(matchs){
            return bin2hex(urldecode(matchs[0]));
        }, query);

        parse_str(query, values);

        return array_combine(array_map("hex2bin", array_keys(values)), values);
    }

    /**
     * Ensure that a URL is encoded and safe to use with cURL
     * 
     * @param  string url URL to encode
     * @return string
     */
    protected function _encodeUrl(string url)
    {
        var url_parsed, scheme, host, port, path, query, result;

        let url_parsed = parse_url(url);

        let scheme = url_parsed["scheme"] . "://";
        let host   = url_parsed["host"];
        let port   = (isset(url_parsed["port"]) ? url_parsed["port"] : null);
        let path   = (isset(url_parsed["path"]) ? url_parsed["path"] : null);
        let query  = (isset(url_parsed["query"]) ? url_parsed["query"] : null);

        if query !== null {
            let query = "?" . http_build_query(this->_getArrayFromQuerystring(query));
        }

        if port && port[0] !== ":" {
            let port = ":" . port;
        }

        let result = scheme . host . port . path . query;
        return result;
    }

    protected function _getHeaderString(key, value)
    {
        let key = trim(strtolower(key));
        return key . ": " . value;
    }

    /**
     * @param array existing_options
     * @param array new_options
     * @return array
     */
    protected function _mergeCurlOptions(array existing_options, array new_options) -> array
    {
        let existing_options = new_options + existing_options;
        return existing_options;
    }
}