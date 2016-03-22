
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

namespace Scene;

/**
 * Scene\Logger
 *
 * Scene\Logger is a component whose purpose is create logs using
 * different backends via adapters, generating options, formats and filters
 * also implementing transactions.
 *
 *<code>
 *  $logger = new \Scene\Logger\Adapter\File("app/logs/test.log");
 *  $logger->log("This is a message");
 *  $logger->log(\Scene\Logger::ERROR, "This is an error");
 *  $logger->error("This is another error");
 *</code>
 */
abstract class Logger
{
    
    /**
     * Special
     *
     * @var int
    */
    const SPECIAL = 9;

    /**
     * Custom
     *
     * @var int
    */
    const CUSTOM = 8;

    /**
     * Debug
     *
     * @var int
    */
    const DEBUG = 7;

    /**
     * Info
     *
     * @var int
    */
    const INFO = 6;

    /**
     * Notice
     *
     * @var int
    */
    const NOTICE = 5;

    /**
     * Warning
     *
     * @var int
    */
    const WARNING = 4;

    /**
     * Error
     *
     * @var int
    */
    const ERROR = 3;

    /**
     * Alert
     *
     * @var int
    */
    const ALERT = 2;

    /**
     * Critical
     *
     * @var int
    */
    const CRITICAL = 1;

    /**
     * Emergence
     *
     * @var int
    */
    const EMERGENCE = 0;
}
