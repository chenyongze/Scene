
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

namespace Scene\Validation\Validator;

use Scene\Validation;
use Scene\Validation\Validator;
use Scene\Validation\Message;

/**
 * Scene\Validation\Validator\File
 *
 * Checks if a value has a correct file
 *
 *<code>
 *use Scene\Validation\Validator\File as FileValidator;
 *
 * $validator->add('file', new FileValidator(array(
 *    'maxSize' => '2M',
 *    'messageSize' => ':field exceeds the max filesize (:max)',
 *    'allowedTypes' => array('image/jpeg', 'image/png'),
 *    'messageType' => 'Allowed file types are :types',
 *    'maxResolution' => '800x600',
 *    'messageMaxResolution' => 'Max resolution of :field is :max'
 * )));
 *</code>
 */
class File extends Validator
{

    /**
     * Executes the validation
     *
     * @param \Scene\Validation validation
     * @param string field
     * @return boolean
     */
    public function validate(<Validation> validation, string! field) -> boolean
    {
        var value, message, label, replacePairs, types, byteUnits, unit, maxSize, matches, bytes, mime, tmp, width, height, minResolution, maxResolution, minWidth, maxWidth, minHeight, maxHeight;

        let value = validation->getValue(field),
            label = this->getOption("label");

        if empty label {
            let label = validation->getLabel(field);
        }

        /**
         * Upload is larger than PHP allowed size (post_max_size or upload_max_filesize)
         */
        if _SERVER["REQUEST_METHOD"] == "POST" && empty _POST && empty _FILES && _SERVER["CONTENT_LENGTH"] > 0 || value->getError() === UPLOAD_ERR_INI_SIZE {

            let message = this->getOption("messageIniSize"),
                replacePairs = [":field": label];

            if empty message {
                let message = validation->getDefaultMessage("FileIniSize");
            }

            validation->appendMessage(new Message(strtr(message, replacePairs), field, "FileIniSize", this->getOption("code")));
            return false;
        }

        if value->getError() !== UPLOAD_ERR_OK || !is_uploaded_file(value->getTempName()) {

            let message = this->getOption("messageEmpty"),
                replacePairs = [":field": label];

            if empty message {
                let message = validation->getDefaultMessage("FileEmpty");
            }

            validation->appendMessage(new Message(strtr(message, replacePairs), field, "FileEmpty", this->getOption("code")));
            return false;
        }

        if !value->getName() || !value->getType() || !value->getSize() {

            let message = this->getOption("messageValid"),
                replacePairs = [":field": label];

            if empty message {
                let message = validation->getDefaultMessage("FileValid");
            }

            validation->appendMessage(new Message(strtr(message, replacePairs), field, "FileValid", this->getOption("code")));
            return false;
        }

        if this->hasOption("maxSize") {

            let byteUnits = ["B": 0, "K": 10, "M": 20, "G": 30, "T": 40, "KB": 10, "MB": 20, "GB": 30, "TB": 40],
                maxSize = this->getOption("maxSize"),
                matches = NULL,
                unit = "B";

            preg_match("/^([0-9]+(?:\\.[0-9]+)?)(" . implode("|", array_keys(byteUnits)) . ")?$/Di", maxSize, matches);

            if isset matches[2] {
                let unit = matches[2];
            }

            let bytes = floatval(matches[1]) * pow(2, byteUnits[unit]);

            if floatval(value->getSize()) > floatval(bytes) {
                
                let message = this->getOption("messageSize"),
                    replacePairs = [":field": label, ":max": maxSize];

                if empty message {
                    let message = validation->getDefaultMessage("FileSize");
                }

                validation->appendMessage(new Message(strtr(message, replacePairs), field, "FileSize", this->getOption("code")));
                return false;
            }
        }

        if this->hasOption("allowedTypes") {

            let types = this->getOption("allowedTypes");

            if typeof types != "array" {
                throw new \Scene\Validation\Exception("Option 'allowedTypes' must be an array");
            }

            if function_exists("finfo_open") {
                let tmp = finfo_open(FILEINFO_MIME_TYPE),
                    mime = finfo_file(tmp, value->getTempName());

                finfo_close(tmp);
            } else {
                let mime = value->getType();
            }

            if !in_array(mime, types) {
                
                let message = this->getOption("messageType"),
                    replacePairs = [":field": label, ":types": join(", ", types)];

                if empty message {
                    let message = validation->getDefaultMessage("FileType");
                }

                validation->appendMessage(new Message(strtr(message, replacePairs), field, "FileType", this->getOption("code")));
                return false;
            }
        }

        if this->hasOption("minResolution") || this->hasOption("maxResolution") {
            
            if (extension_loaded("Imagick")) {
                let tmp = new \Scene\Image\Adapter\Imagick(value->getTempName());
            } elseif (extension_loaded("gd")) {
                let tmp = new \Scene\Image\Adapter\GD(value->getTempName());
            } else {
                throw new \Scene\Validation\Exception("Imagick or gd was no install or load !");                
            }

            let width = tmp->getWidth();
            let height = tmp->getHeight();

            if this->hasOption("minResolution") {
                let minResolution = explode("x", this->getOption("minResolution")),
                    minWidth = minResolution[0],
                    minHeight = minResolution[1];
            } else {
                let minWidth = 1,
                    minHeight = 1;
            }

            if width < minWidth || height < minHeight {
                
                let message = this->getOption("messageMinResolution"),
                    replacePairs = [":field": label, ":min": this->getOption("minResolution")];

                if empty message {
                    let message = validation->getDefaultMessage("FileMinResolution");
                }

                validation->appendMessage(new Message(strtr(message, replacePairs), field, "FileMinResolution", this->getOption("code")));
                return false;
            }

            if this->hasOption("maxResolution") {

                let maxResolution = explode("x", this->getOption("maxResolution")),
                    maxWidth = maxResolution[0],
                    maxHeight = maxResolution[1];

                if width > maxWidth || height > maxHeight {
                    
                    let message = this->getOption("messageMaxResolution"),
                        replacePairs = [":field": label, ":max": this->getOption("maxResolution")];

                    if empty message {
                        let message = validation->getDefaultMessage("FileMaxResolution");
                    }

                    validation->appendMessage(new Message(strtr(message, replacePairs), field, "FileMaxResolution", this->getOption("code")));
                    return false;
                }
            }
        }

        return true;
    }

    /**
     * Check on empty
     *
     * @param \Scene\Validation validation
     * @param string field
     * @return boolean
     */
    public function isAllowEmpty(<Validation> validation, string! field) -> boolean
    {
        var value;
        let value = validation->getValue(field);

        return !value || value->getError() === UPLOAD_ERR_NO_FILE;
    }
}
