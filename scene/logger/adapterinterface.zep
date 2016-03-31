
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

/**
 * Scene\Logger\AdapterInterface
 *
 * Interface for Scene\Logger adapters
 */
interface AdapterInterface
{

    /**
     * Sets the message formatter
     *
     * @param \Scene\Logger\FormatterInterface $formatter
     * @return \Scene\Logger\AdapterInterface
     */
    public function setFormatter(<FormatterInterface> formatter) -> <AdapterInterface>;

    /**
     * Returns the internal formatter
     */
    public function getFormatter() -> <FormatterInterface>;

    /**
     * Filters the logs sent to the handlers that are less or equal than a specific level
     *
     * @param int level
     * @return \Scene\Logger\AdapterInterface
     */
    public function setLogLevel(int level) -> <AdapterInterface>;

    /**
     * Returns the current log level
     *
     * @return int
     */
    public function getLogLevel() -> int;

    /**
     * Logs messages to the internal logger. Appends logs to the logger
     *
     * @param int|null type
     * @param string message
     * @param array|null type
     * @return \Scene\Logger\AdapterInterface
     */
    public function log(var type, var message = null, array! context = null) -> <AdapterInterface>;

    /**
     * Starts a transaction
     *
     * @return \Scene\Logger\AdapterInterface
     */
    public function begin() -> <AdapterInterface>;

    /**
     * Commits the internal transaction
     *
     * @return \Scene\Logger\AdapterInterface
     */
    public function commit() -> <AdapterInterface>;

    /**
     * Rollbacks the internal transaction
     *
     * @return \Scene\Logger\AdapterInterface
     */
    public function rollback() -> <AdapterInterface>;

    /**
     * Closes the logger
     */
    public function close() -> boolean;

    /**
     * Sends/Writes a critical message to the log
     *
     * @param string message
     * @param array content
     * @return \Scene\Logger\AdapterInterface
     */
    public function critical(string! message, array! context = null) -> <AdapterInterface>;

    /**
     * Sends/Writes an emergency message to the log
     *
     * @param string message
     * @param array content
     * @return \Scene\Logger\AdapterInterface
     */
    public function emergency(string! message, array! context = null) -> <AdapterInterface>;

    /**
     * Sends/Writes a debug message to the log
     *
     * @param string message
     * @param array content
     * @return \Scene\Logger\AdapterInterface
     */
    public function debug(string! message, array! context = null) -> <AdapterInterface>;

    /**
     * Sends/Writes an error message to the log
     *
     * @param string message
     * @param array content
     * @return \Scene\Logger\AdapterInterface
     */
    public function error(string! message, array! context = null) -> <AdapterInterface>;

    /**
     * Sends/Writes an info message to the log
     *
     * @param string message
     * @param array content
     * @return \Scene\Logger\AdapterInterface
     */
    public function info(string! message, array! context = null) -> <AdapterInterface>;

    /**
     * Sends/Writes a notice message to the log
     *
     * @param string message
     * @param array content
     * @return \Scene\Logger\AdapterInterface
     */
    public function notice(string! message, array! context = null) -> <AdapterInterface>;

    /**
     * Sends/Writes a warning message to the log
     *
     * @param string message
     * @param array content
     * @return \Scene\Logger\AdapterInterface
     */
    public function warning(string! message, array! context = null) -> <AdapterInterface>;

    /**
     * Sends/Writes an alert message to the log
     *
     * @param string message
     * @param array content
     * @return \Scene\Logger\AdapterInterface
     */
    public function alert(string! message, array! context = null) -> <AdapterInterface>;

}
