
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

namespace Scene\Mvc;

/**
 * Scene\Mvc\EntityInterface
 *
 * Interface for Scene\Mvc\Collection and Scene\Mvc\Model
 */
interface EntityInterface
{
    /**
     * Reads an attribute value by its name
     *
     * @param string attribute
     * @return mixed
     */
    public function readAttribute(string! attribute);

    /**
     * Writes an attribute value by its name
     *
     * @param string attribute
     * @param mixed value
     */
    public function writeAttribute(string! attribute, value);
}
