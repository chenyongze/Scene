
/**
 * Headers
 *
*/

namespace Scene\Http\Response;

/**
 * Scene\Http\Response\Headers
 *
 * This class is a bag to manage the response headers
 */
class Headers implements HeadersInterface
{
    /**
     * Headers
     *
     * @var null|array
     * @access protected
    */
    protected _headers = [];

    /**
     * Sets a header to be sent at the end of the request
     *
     * @param string name
     * @param string value
     */
    public function set(string name, string value)
    {
        let this->_headers[name] = value;
    }

    /**
     * Gets a header value from the internal bag
     *
     * @param string name
     * @return string|boolean
     */
    public function get(string name) -> string | boolean
    {
        var headers, headerValue;
        let headers = this->_headers;

        if fetch headerValue, headers[name] {
            return headerValue;
        }

        return false;
    }

    /**
     * Sets a raw header to be sent at the end of the request
     *
     * @param string header
     * @throws Exception
     */
    public function setRaw(string header)
    {
        let this->_headers[header] = null;
    }

    /**
     * Removes a header to be sent at the end of the request
     *
     * @param string header
     * @throws Exception
     */
    public function remove(string header)
    {
        var headers;

        let headers = this->_headers;
        unset(headers[header]);
        let this->_headers = headers;
    }

    /**
     * Sends the headers to the client
     *
     * @return boolean
     */
    public function send() -> boolean
    {
        var header, value;
        if !headers_sent() {
            for header, value in this->_headers {
                if !empty value {
                    header(header . ": " . value, true);
                } else {
                    header(header, true);
                }
            }
            return true;
        }
        return false;
    }

    /**
     * Reset set headers
     */
    public function reset()
    {
        let this->_headers = [];
    }

    /**
     * Returns the current headers as an array
     *
     * @return array
     */
    public function toArray() -> array
    {
        return this->_headers;
    }

    /**
     * Restore a \Scene\Http\Response\Headers object
     *
     * @param array data
     * @return \Scene\Http\Response\Headers
     * @throws Exception
     */
    public static function __set_state(array! data) -> <Headers>
    {
        var headers, key, value, dataHeaders;
        let headers = new self();
        if fetch dataHeaders, data["_headers"] {
            for key, value in dataHeaders {
                headers->set(key, value);
            }
        }
        return headers;
    }
}
