
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
use Scene\Logger\Item;
use Scene\Logger\AdapterInterface;
use Scene\Logger\FormatterInterface;
use Scene\Logger\Exception;

/**
 * Scene\Logger\Adapter
 *
 * Base class for Scene\Logger adapters
 */
abstract class Adapter
{

    /**
     * Tells if there is an active transaction or not
     *
     * @var boolean
     * @access protected
     */
    protected _transaction = false;

    /**
     * Array with messages queued in the transaction
     *
     * @var array
     * @access protected
     */
    protected _queue = [];

    /**
     * Formatter
     *
     * @var object
     * @access protected
     */
    protected _formatter;

    /**
     * Log level
     *
     * @var int
     * @access protected
     */
    protected _logLevel = 9;

    /**
     * Filters the logs sent to the handlers that are less or equal than a specific level
     *
     * @param int level
     * @return \Scene\Logger\AdapterInterface
     */
    public function setLogLevel(int level) -> <AdapterInterface>
    {
        let this->_logLevel = level;
        return this;
    }

    /**
     * Returns the current log level
     *
     * @return int
     */
    public function getLogLevel() -> int
    {
        return this->_logLevel;
    }

    /**
     * Sets the message formatter
     *
     * @param \Scene\Logger\FormatterInterface $formatter
     * @return \Scene\Logger\AdapterInterface
     */
    public function setFormatter(<FormatterInterface> formatter) -> <AdapterInterface>
    {
        let this->_formatter = formatter;
        return this;
    }

    /**
     * Starts a transaction
     *
     * @return \Scene\Logger\AdapterInterface
     */
    public function begin() -> <AdapterInterface>
    {
        let this->_transaction = true;
        return this;
    }

    /**
     * Commits the internal transaction
     *
     * @return \Scene\Logger\AdapterInterface
     */
    public function commit() -> <AdapterInterface>
    {
        var message;

        if !this->_transaction {
            throw new Exception("There is no active transaction");
        }

        let this->_transaction = false;

        /**
         * Check if the queue has something to log
         */
        for message in this->_queue {
            this->{"logInternal"}(
                message->getMessage(),
                message->getType(),
                message->getTime(),
                message->getContext()
            );
        }

        // clear logger queue at commit
        let this->_queue = [];

        return this;
    }

    /**
     * Rollbacks the internal transaction
     *
     * @return \Scene\Logger\AdapterInterface
     */
    public function rollback() -> <AdapterInterface>
    {
        if !this->_transaction {
            throw new Exception("There is no active transaction");
        }

        let this->_transaction = false,
            this->_queue = [];

        return this;
    }

    /**
     * Returns the whether the logger is currently in an active transaction or not
     *
     * @return boolean
     */
    public function isTransaction() -> boolean
    {
        return this->_transaction;
    }

    /**
     * Sends/Writes a critical message to the log
     *
     * @param string message
     * @param array content
     * @return \Scene\Logger\AdapterInterface
     */
    public function critical(string! message, array! context = null) -> <AdapterInterface>
    {
        return this->log(Logger::CRITICAL, message, context);
    }

    /**
     * Sends/Writes an emergency message to the log
     *
     * @param string message
     * @param array content
     * @return \Scene\Logger\AdapterInterface
     */
    public function emergency(string! message, array! context = null) -> <AdapterInterface>
    {
        return this->log(Logger::EMERGENCY, message, context);
    }

    /**
     * Sends/Writes a debug message to the log
     *
     * @param string message
     * @param array content
     * @return \Scene\Logger\AdapterInterface
     */
    public function debug(string! message, array! context = null) -> <AdapterInterface>
    {
        return this->log(Logger::DEBUG, message, context);
    }

    /**
     * Sends/Writes an error message to the log
     *
     * @param string message
     * @param array content
     * @return \Scene\Logger\AdapterInterface
     */
    public function error(string! message, array! context = null) -> <AdapterInterface>
    {
        return this->log(Logger::ERROR, message, context);
    }

    /**
     * Sends/Writes an info message to the log
     *
     * @param string message
     * @param array content
     * @return \Scene\Logger\AdapterInterface
     */
    public function info(string! message, array! context = null) -> <AdapterInterface>
    {
        return this->log(Logger::INFO, message, context);
    }

    /**
     * Sends/Writes a notice message to the log
     *
     * @param string message
     * @param array content
     * @return \Scene\Logger\AdapterInterface
     */
    public function notice(string! message, array! context = null) -> <AdapterInterface>
    {
        return this->log(Logger::NOTICE, message, context);
    }

    /**
     * Sends/Writes a warning message to the log
     *
     * @param string message
     * @param array content
     * @return \Scene\Logger\AdapterInterface
     */
    public function warning(string! message, array! context = null) -> <AdapterInterface>
    {
        return this->log(Logger::WARNING, message, context);
    }

    /**
     * Sends/Writes an alert message to the log
     *
     * @param string message
     * @param array content
     * @return \Scene\Logger\AdapterInterface
     */
    public function alert(string! message, array! context = null) -> <AdapterInterface>
    {
        return this->log(Logger::ALERT, message, context);
    }

    /**
     * Logs messages to the internal logger. Appends logs to the logger
     *
     * @param int|null type
     * @param string message
     * @param array|null type
     * @return \Scene\Logger\AdapterInterface
     */
    public function log(var type, var message = null, array! context = null) -> <AdapterInterface>
    {
        var timestamp, toggledMessage, toggledType;

        /**
         * PSR3 compatibility
         */
        if typeof type == "string" && typeof message == "integer" {
            let toggledMessage = type, toggledType = message;
        } else {
            if typeof type == "string" && typeof message == "null" {
                let toggledMessage = type, toggledType = message;
            } else {
                let toggledMessage = message, toggledType = type;
            }
        }

        if typeof toggledType == "null" {
            let toggledType = Logger::DEBUG;
        }

        /**
         * Checks if the log is valid respecting the current log level
         */
        if this->_logLevel >= toggledType {
            let timestamp = time();
            if this->_transaction {
                let this->_queue[] = new Item(toggledMessage, toggledType, timestamp, context);
            } else {
                this->{"logInternal"}(toggledMessage, toggledType, timestamp, context);
            }
        }

        return this;
    }
}
