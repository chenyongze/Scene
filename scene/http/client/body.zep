
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

use Scene\Http\Client;

/**
 * Scene\Http\Client\Body
 *
 * Body of HTTP client
 * 
 */
class Body
{
    
    /**
     * Prepares a file for upload. To be used inside the parameters declaration for a request.
     * 
     * @param string filename
     * @param string mimetype
     * @param string postname
     */
    public static function file(string filename, string mimetype = "", string postname = "")
    {
        if (class_exists("CURLFile")) {
            return new \CURLFile(filename, mimetype, postname);
        }

        if function_exists("curl_file_create") {
            return curl_file_create(filename, mimetype, postname);
        }

        if empty postname {
            let postname = basename(filename);
        }

        return sprintf("@%s;filename=%s;type=%s", filename, postname, mimetype);
    }

    public function json(var data)
    {
        return json_encode(data);
    }

    public function form($data)
    {
        var client;

        if typeof data == "array" || typeof data == "object" || data instanceof \Traversable {
            let client = new Client();
            return http_build_query(client->buildHTTPCurlQuery(data));
        }

        return data;
    }

    public function multipart(var data, var files = false)
    {
        var name, file;

        if typeof data == "object" {
            return get_object_vars(data);
        }

        if typeof data != "array" {
            return [data];
        }

        if files !== false {
            for name, file in files {
                let data[name] = call_user_func([__CLASS__, "file"], file);
            }
        }

        return data;
    }
}
