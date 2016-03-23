
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

namespace Scene\Logger;

use Scene\Logger;
use Scene\Logger\AdapterInterface;
use Scene\Logger\FormatterInterface;
use Scene\Logger\Exception;

/**
 * Scene\Logger\Multiple
 *
 * Handles multiples logger handlers
 */
class Multiple
{

    /**
     * Loggers
     *
     * @var null|array
     * @access protected
    */
    protected _loggers { get };

    /**
     * Formatter
     *
     * @var null|\Scene\Logger\FormatterInterface
     * @access protected
    */
    protected _formatter { get };

    /**
     * Log level
     *
     * @var null|int
     * @access protected
    */
    protected _logLevel { get };

    /**
     * Pushes a logger to the logger tail
     */
    public function push(<AdapterInterface> logger)
    {
        let this->_loggers[] = logger;
    }

    /**
     * Sets a global formatter
     */
    public function setFormatter(<FormatterInterface> formatter)
    {
        var loggers, logger;

        let loggers = this->_loggers;
        if typeof loggers == "array" {
            for logger in loggers {
                logger->setFormatter(formatter);
            }
        }
        let this->_formatter = formatter;
    }

    /**
     * Sets a global level
     */
    public function setLogLevel(int level)
    {
        var loggers, logger;

        let loggers = this->_loggers;
        if typeof loggers == "array" {
            for logger in loggers {
                logger->setLogLevel(level);
            }
        }
        let this->_logLevel = level;
    }

    /**
     * Sends a message to each registered logger
     *
     * @param int type
     * @param string|null message
     * @param array|null context
     */
    public function log(var type, var message = null, array! context = null)
    {
        var loggers, logger;

        let loggers = this->_loggers;
        if typeof loggers == "array" {
            for logger in loggers {
                logger->log(type, message, context);
            }
        }
    }

    /**
     * Sends/Writes an critical message to the log
     *
     * @param string message
     * @param array context
     */
    public function critical(string! message, array! context = null)
    {
        this->log(Logger::CRITICAL, message, context);
    }

    /**
     * Sends/Writes an emergency message to the log
     *
     * @param string message
     * @param array context
     */
    public function emergency(string! message, array! context = null)
    {
        this->log(Logger::EMERGENCY, message, context);
    }

    /**
     * Sends/Writes a debug message to the log
     *
     * @param string message
     * @param array context
     */
    public function debug(string! message, array! context = null)
    {
        this->log(Logger::DEBUG, message, context);
    }

    /**
     * Sends/Writes an error message to the log
     *
     * @param string message
     * @param array context
     */
    public function error(string! message, array! context = null)
    {
        this->log(Logger::ERROR, message, context);
    }

    /**
     * Sends/Writes an info message to the log
     *
     * @param string message
     * @param array context
     */
    public function info(string! message, array! context = null)
    {
        this->log(Logger::INFO, message, context);
    }

    /**
     * Sends/Writes a notice message to the log
     *
     * @param string message
     * @param array context
     */
    public function notice(string! message, array! context = null)
    {
        this->log(Logger::NOTICE, message, context);
    }

    /**
     * Sends/Writes a warning message to the log
     *
     * @param string message
     * @param array context
     */
    public function warning(string! message, array! context = null)
    {
        this->log(Logger::WARNING, message, context);
    }

    /**
     * Sends/Writes an alert message to the log
     *
     * @param string message
     * @param array context
     */
    public function alert(string! message, array! context = null)
    {
        this->log(Logger::ALERT, message, context);
    }
}
