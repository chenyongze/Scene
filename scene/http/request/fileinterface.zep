
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

/**
 * Scene\Http\Request\FileInterface
 *
 * Interface for Scene\Http\Request\File
 *
 */
interface FileInterface
{

     /**
     * \Scene\Http\Request\FileInterface constructor
     *
     * @param array file
     * @param mixed key
     */
     public function __construct(array! file, key = null);

     /**
     * Returns the file size of the uploaded file
     *
     * @return int
     */
     public function getSize() -> int;

     /**
     * Returns the real name of the uploaded file
     *
     * @return string
     */
     public function getName() -> string;

     /**
     * Returns the temporal name of the uploaded file
     *
     * @return string
     */
     public function getTempName() -> string;

     /**
     * Returns the mime type reported by the browser
     * This mime type is not completely secure, use getRealType() instead
     *
     * @return string
     */
     public function getType() -> string;

     /**
     * Gets the real mime type of the upload file using finfo
     *
     * @return string
     */
     public function getRealType() -> string;

     /**
     * Move the temporary file to a destination
     *
     * @param string destination
     * @return boolean
     */
     public function moveTo(string! destination) -> boolean;

}