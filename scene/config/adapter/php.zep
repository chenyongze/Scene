
/**
 * php Adapter
 *
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
