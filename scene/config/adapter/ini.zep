
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
 * Scene\Config\Adapter\Ini
 *
 * Reads ini files and converts them to Scene\Config objects.
 *
 * Given the next configuration file:
 *
 *<code>
 * [database]
 * adapter = Mysql
 * host = localhost
 * username = scott
 * password = cheetah
 * dbname = test_db
 *
 * [Scene]
 * controllersDir = "../app/controllers/"
 * modelsDir = "../app/models/"
 * viewsDir = "../app/views/"
 * </code>
 *
 * You can read it as follows:
 *
 *<code>
 * $config = new Scene\Config\Adapter\Ini("path/config.ini");
 * echo $config->Scene->controllersDir;
 * echo $config->database->username;
 *</code>
 */
class Ini extends Config
{

    /**
     * \Scene\Config\Adapter\Ini constructor
     *
     * @param string filePath
     * @throws Exception
     */
    public function __construct(string! filePath)
    {        
        if !file_exists(filePath) {
            throw new Exception("The file is not exists.");
        }

        var iniConfig;

        let iniConfig = parse_ini_file(filePath, true);
        
        if iniConfig === false {
            throw new Exception("Configuration file " . basename(filePath) . " can't be loaded");
        }

        var config, section, sections, directives, path, lastValue;

        let config = [];

        for section, directives in iniConfig {
            if typeof directives == "array" {
                let sections = [];
                for path, lastValue in directives {
                    let sections[] = this->_parseIniString(path, lastValue);
                }
                if count(sections) {
                    let config[section] = call_user_func_array("array_merge_recursive", sections);
                }
            } else {
                let config[section] = directives;
            }
        }

        parent::__construct(config);
    }

    /**
     * Build multidimensional array from string
     *
     * <code>
     * $this->_parseIniString('path.hello.world', 'value for last key');
     *
     * // result
     * [
     *      'path' => [
     *          'hello' => [
     *              'world' => 'value for last key',
     *          ],
     *      ],
     * ];
     * </code>
     *
     * @param string path
     * @param mixed value
     * @return array
     */
    protected function _parseIniString(string! path, var value) -> array
    {
        var pos, key;
        let pos = strpos(path, ".");

        if pos === false {
            return [path: value];
        }

        let key = substr(path, 0, pos);
        let path = substr(path, pos + 1);

        return [key: this->_parseIniString(path, value)];
    }
}
