
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

namespace Scene\Config\Adapter;

use Scene\Config;
use Scene\Config\Exception;

/**
 * Scene\Config\Adapter\Php
 *
 * Reads php files and converts them to Scene\Config objects.
 *
 * Given the next configuration file:
 *
 *<code>
 *<?php
 *return array(
 * 'database' => array(
 *     'adapter' => 'Mysql',
 *     'host' => 'localhost',
 *     'username' => 'scott',
 *     'password' => 'cheetah',
 *     'dbname' => 'test_db'
 * ),
 *
 * 'Scene' => array(
 *    'controllersDir' => '../app/controllers/',
 *    'modelsDir' => '../app/models/',
 *    'viewsDir' => '../app/views/'
 *));
 *</code>
 *
 * You can read it as follows:
 *
 *<code>
 * $config = new Scene\Config\Adapter\Php("path/config.php");
 * echo $config->Scene->controllersDir;
 * echo $config->database->username;
 *</code>
 */
class Php extends Config
{

    /**
     * Scene\Config\Adapter\Php constructor
     *
     * @param string filePath
     */
    public function __construct(string! filePath)
    {
        if !file_exists(filePath) {
            throw new Exception("The file is not exists.");
        }

        parent::__construct(require filePath);
    }
}
