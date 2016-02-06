
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

namespace Scene\Http\Client;

/**
 * Scene\Http\Client\Response
 *
 * Response of HTTP client
 * 
 */
class Response
{
    public code;
    public raw_body;
    public body;
    public headers;

    /**
     * @param int code response code of the cURL request
     * @param string raw_body the raw body of the cURL response
     * @param string headers raw header string from cURL response
     * @param array json_args arguments to pass to json_decode function
     */
    public function __construct(int code, string raw_body, string headers, array json_args = [])
    {
        var json;

        let this->code     = code;
        let this->headers  = this->parseHeaders(headers);
        let this->raw_body = raw_body;
        let this->body     = raw_body;

        // make sure raw_body is the first argument
        array_unshift(json_args, raw_body);

        let json = call_user_func_array("json_decode", json_args);

        if json_last_error() === JSON_ERROR_NONE {
            let this->body = json;
        }
    }

    /**
     * if PECL_HTTP is not available use a fall back function
     *
     * @param string raw_headers
     * @return array
     */
    private function parseHeaders(string raw_headers) -> array
    {
        var key, headers, h;

        let key = "", headers = [];

        for _, h in explode("\n", raw_headers) {
            let h = explode(":", h, 2);

            if isset h[1] {
                if !isset headers[h[0]] {
                    let headers[h[0]] = trim(h[1]);
                } elseif typeof headers[h[0]] == "array" {
                    let headers[h[0]] = array_merge(headers[h[0]], [trim(h[1])]);
                } else {
                    let headers[h[0]] = array_merge([headers[h[0]]], [trim(h[1])]);
                }

                let key = h[0];
            } else {
                if substr(h[0], 0, 1) == "\t" {
                    let headers[key] .= "\r\n\t" . trim(h[0]);
                } elseif !key {
                    let headers[0] = trim(h[0]);
                }
            }
        }

        return headers;
    }
}
