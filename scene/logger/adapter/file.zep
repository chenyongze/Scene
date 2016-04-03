
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

namespace Scene\Logger\Adapter;

use Scene\Logger\Adapter;
use Scene\Logger\AdapterInterface;
use Scene\Logger\Exception;
use Scene\Logger\FormatterInterface;
use Scene\Logger\Formatter\Line as LineFormatter;

/**
 * Scene\Logger\Adapter\File
 *
 * Adapter to store logs in plain text files
 *
 *<code>
 *  $logger = new \Scene\Logger\Adapter\File("app/logs/test.log");
 *  $logger->log("This is a message");
 *  $logger->log(\Scene\Logger::ERROR, "This is an error");
 *  $logger->error("This is another error");
 *  $logger->close();
 *</code>
 */
class File extends Adapter implements AdapterInterface
{

    /**
     * File handler resource
     *
     * @var resource
     * @access protected
     */
    protected _fileHandler;

    /**
     * File Path
     *
     * @var null|string
     * @access protected
     */
    protected _path { get };

    /**
     * Path options
     *
     * @var null|array
     * @access protected
     */
    protected _options;

    /**
     * Scene\Logger\Adapter\File constructor
     *
     * @param string name
     * @param array options
     */
    public function __construct(string! name, options = null)
    {
        var mode = null, handler;

        if typeof options === "array" {
            if fetch mode, options["mode"] {
                if memstr(mode, "r") {
                    throw new Exception("Logger must be opened in append or write mode");
                }
            }
        }

        if mode === null {
            let mode = "ab";
        }

        /**
         * We use 'fopen' to respect to open-basedir directive
         */
        let handler = fopen(name, mode);
        if typeof handler != "resource" {
            throw new Exception("Can't open log file at '" . name . "'");
        }

        let this->_path = name,
            this->_options = options,
            this->_fileHandler = handler;
    }

    /**
     * Returns the internal formatter
     *
     * @return Scene\Logger\FormatterInterface;
     */
    public function getFormatter() -> <FormatterInterface>
    {
        if typeof this->_formatter !== "object" {
            let this->_formatter = new LineFormatter();
        }

        return this->_formatter;
    }

    /**
     * Writes the log to the file itself
     *
     * @param string message
     * @param int type
     * @param int time
     * @param array context
     */
    public function logInternal(string message, int type, int time, array context) -> void
    {
        var fileHandler;

        let fileHandler = this->_fileHandler;
        if typeof fileHandler !== "resource" {
            throw new Exception("Cannot send message to the log because it is invalid");
        }

        fwrite(fileHandler, this->getFormatter()->format(message, type, time, context));
    }

    /**
     * Closes the logger
     *
     * @return boolean
     */
    public function close() -> boolean
    {
        return fclose(this->_fileHandler);
    }

    /**
     * Opens the internal file handler after unserialization
     */
    public function __wakeup()
    {
        var path, mode;

        let path = this->_path;
        if typeof path !== "string" {
            throw new Exception("Invalid data passed to Scene\\Logger\\Adapter\\File::__wakeup()");
        }

        if !fetch mode, this->_options["mode"] {
            let mode = "ab";
        }

        if typeof mode !== "string" {
            throw new Exception("Invalid data passed to Scene\\Logger\\Adapter\\File::__wakeup()");
        }

        if memstr(mode, "r") {
            throw new Exception("Logger must be opened in append or write mode");
        }

        /**
         * Re-open the file handler if the logger was serialized
         */
        let this->_fileHandler = fopen(path, mode);
    }
}
