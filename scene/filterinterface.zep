
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
 * Scene\FilterInterface initializer
 *
 * Interface for Scene\Filter
 */
interface FilterInterface
{

     /**
     * Adds a user-defined filter
     *
     * @param string name
     * @param callable handler
     * @return \Scene\FilterInterface
     */
     public function add(string! name, handler) -> <FilterInterface>;

     /**
     * Sanizites a value with a specified single or set of filters
     *
     * @param  mixed value
     * @param  mixed filters
     * @return mixed
     */
     public function sanitize(value, filters) -> var;

     /**
     * Return the user-defined filters in the instance
     *
     * @return array
     */
     public function getFilters() -> array;
}