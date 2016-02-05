
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
 * Scene\Http\Client\File
 *
 * File of HTTP client
 * 
 */
class File
{
    /**
     * Prepares a file for upload. To be used inside the parameters declaration for a request.
     * 
     * @param string filename
     * @param string mimetype
     * @param string postname
     */
    public static function add(string filename, string mimetype = "", string postname = "")
    {
        if function_exists("curl_file_create") {
            return curl_file_create(filename, mimetype, postname);
        } else {
            if !postname {
                let postname = basename(filename);
            }
            return sprintf("@%s;filename=%s;type=%s", filename, postname, mimetype);
        }
    }
}
