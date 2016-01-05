
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

namespace Scene\Http\Request;

use Scene\Http\Request\FileInterface;

/**
 * Scene\Http\Request\File
 *
 * Provides OO wrappers to the $_FILES superglobal
 *
 *<code>
 *  class PostsController extends \Scene\Mvc\Controller
 *  {
 *
 *      public function uploadAction()
 *      {
 *          //Check if the user has uploaded files
 *          if ($this->request->hasFiles()) {
 *              //Print the real file names and their sizes
 *              foreach ($this->request->getUploadedFiles() as $file){
 *                  echo $file->getName(), " ", $file->getSize(), "\n";
 *              }
 *          }
 *      }
 *
 *  }
 *</code>
 */
class File implements FileInterface
{
    /**
     * Name
     *
     * @var null|string
     * @access protected
    */
    protected _name;

    /**
     * Temp
     *
     * @var null|string
     * @access protected
    */
    protected _tmp;

    /**
     * Size
     *
     * @var null|int
     * @access protected
    */
    protected _size;

    /**
     * Type
     *
     * @var null|string
     * @access protected
    */
    protected _type;

    /**
     * RealType
     *
     * @var null|string
     * @access protected
    */
    protected _realType;

    /**
     * @var string|null
     */
    protected _error { get };

    /**
     * @var string|null
     */
    protected _key { get };

    /**
     * @var string
     */
    protected _extension { get };

    /**
     * \Scene\Http\Request\File constructor
     *
     * @param array file
     * @param string|null key
     * @throws Exception
     */
    public function __construct(array! file, key = null)
    {
        if typeof file != "array" {
            throw new Exception("Scene\\Http\\Request\\File requires a valid uploaded file");
        }

        var name, tempName, size, type, error;

        if fetch name, file["name"] {
            let this->_name = name;

            if defined("PATHINFO_EXTENSION") {
                let this->_extension = pathinfo(name, PATHINFO_EXTENSION);
            }
        }

        if fetch tempName, file["tmp_name"] {
            let this->_tmp = tempName;
        }

        if fetch size, file["size"] {
            let this->_size = size;
        }

        if fetch type, file["type"] {
            let this->_type = type;
        }

        if fetch error, file["error"] {
            let this->_error = error;
        }

        if key {
            let this->_key = key;
        }
    }

    /**
     * Returns the file size of the uploaded file
     *
     * @return int|null
     */
    public function getSize() -> int
    {
        return this->_size;
    }

    /**
     * Returns the real name of the uploaded file
     *
     * @return string|null
     */
    public function getName() -> string
    {
        return this->_name;
    }

    /**
     * Returns the temporal name of the uploaded file
     *
     * @return string|null
     */
    public function getTempName() -> string
    {
        return this->_tmp;
    }

    /**
     * Returns the mime type reported by the browser
     * This mime type is not completely secure, use getRealType() instead
     *
     * @return string|null
     */
    public function getType() -> string
    {
        return this->_type;
    }

    /**
     * Gets the real mime type of the upload file using finfo
     *
     * @return null
     */
    public function getRealType() -> string
    {
        var finfo, mime;

        let finfo = finfo_open(FILEINFO_MIME_TYPE);
        if typeof finfo != "resource" {
            return "";
        }

        let mime = finfo_file(finfo, this->_tmp);
        finfo_close(finfo);

        return mime;
    }

    /**
     * Checks whether the file has been uploaded via Post.
     *
     * @return boolean
    */
    public function isUploadedFile() -> boolean
    {
        var tmp;

        let tmp = this->getTempName();
        return typeof tmp == "string" && is_uploaded_file(tmp);
    }

    /**
     * Moves the temporary file to a destination within the application
     *
     * @param string destination
     * @return boolean
     * @throws Exception
     */
    public function moveTo(string! destination) -> boolean
    {
        return move_uploaded_file(this->_tmp, destination);
    }
}
