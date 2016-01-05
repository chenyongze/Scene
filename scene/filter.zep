
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

use Scene\FilterInterface;
use Scene\Filter\Exception;

/**
 * Scene\Filter
 *
 * The Scene\Filter component provides a set of commonly needed data filters. It provides
 * object oriented wrappers to the php filter extension. Also allows the developer to
 * define his/her own filters
 *
 *<code>
 *  $filter = new Scene\Filter();
 *  $filter->sanitize("some(one)@exa\\mple.com", "email"); // returns "someone@example.com"
 *  $filter->sanitize("hello<<", "string"); // returns "hello"
 *  $filter->sanitize("!100a019", "int"); // returns "100019"
 *  $filter->sanitize("!100a019.01a", "float"); // returns "100019.01"
 *</code>
 *
 */
class Filter implements FilterInterface
{
    const FILTER_EMAIL      = "email";

    const FILTER_ABSINT     = "absint";

    const FILTER_INT        = "int";

    const FILTER_INT_CAST   = "int!";

    const FILTER_STRING     = "string";

    const FILTER_FLOAT      = "float";

    const FILTER_FLOAT_CAST = "float!";

    const FILTER_ALPHANUM   = "alphanum";

    const FILTER_TRIM       = "trim";

    const FILTER_STRIPTAGS  = "striptags";

    const FILTER_LOWER      = "lower";

    const FILTER_UPPER      = "upper";

    /**
     * Filters
     *
     * @var null|array
     * @access protected
    */
    protected _filters;

    /**
     * Adds a user-defined filter
     *
     * @param string name
     * @param object|callable handler
     * @return \Scene\FilterInterface
     * @throws Exception
     */
    public function add(string! name, handler) -> <FilterInterface>
    {
        if typeof handler != "object" && !is_callable(handler) {
            throw new Exception("Filter must be an object or callable");
        }

        let this->_filters[name] = handler;
        return this;
    }

    /**
     * Sanitizes a value with a specified single or set of filters
     *
     * @param mixed value
     * @param mixed filters
     * @return mixed
     */
    public function sanitize(var value, var filters, boolean noRecursive = false)
    {
        var filter, arrayValue, itemKey, itemValue, sanitizedValue;

        /**
         * Apply an array of filters
         */
        if typeof filters == "array" {
            if value !== null {
                for filter in filters {
                    /**
                     * If the value to filter is an array we apply the filters recursively
                     */
                    if typeof value == "array" && !noRecursive {
                        let arrayValue = [];
                        for itemKey, itemValue in value {
                            let arrayValue[itemKey] = this->_sanitize(itemValue, filter);
                        }
                        let value = arrayValue;
                    } else {
                        let value = this->_sanitize(value, filter);
                    }
                }
            }
            return value;
        }

        /**
         * Apply a single filter value
         */
        if typeof value == "array" && !noRecursive {
            let sanitizedValue = [];
            for itemKey, itemValue in value {
                let sanitizedValue[itemKey] = this->_sanitize(itemValue, filters);
            }
            return sanitizedValue;
        }

        return this->_sanitize(value, filters);
    }

    /**
     * Internal sanitize wrapper to filter_var
     *
     * @param mixed value
     * @param string filter
     * @return mixed
     * @throws Exception
     */
    protected function _sanitize(var value, string! filter)
    {
        var filterObject;

        if fetch filterObject, this->_filters[filter] {

            /**
             * If the filter is a closure we call it in the PHP userland
             */
            if filterObject instanceof \Closure || is_callable(filterObject) {
                return call_user_func_array(filterObject, [value]);
            }

            return filterObject->filter(value);
        }

        switch filter {

            case self::FILTER_EMAIL:
                /**
                 * The 'email' filter uses the filter extension
                 */
                return filter_var(value, constant("FILTER_SANITIZE_EMAIL"));

            case self::FILTER_INT:
                /**
                 * 'int' filter sanitizes a numeric input
                 */
                return filter_var(value, FILTER_SANITIZE_NUMBER_INT);

            case self::FILTER_INT_CAST:

                return intval(value);

            case self::FILTER_ABSINT:

                return abs(intval(value));

            case self::FILTER_STRING:

                return filter_var(value, FILTER_SANITIZE_STRING);

            case self::FILTER_FLOAT:
                /**
                 * The 'float' filter uses the filter extension
                 */
                return filter_var(value, FILTER_SANITIZE_NUMBER_FLOAT, ["flags": FILTER_FLAG_ALLOW_FRACTION]);

            case self::FILTER_FLOAT_CAST:

                return doubleval(value);

            case self::FILTER_ALPHANUM:

                return preg_replace("/[^A-Za-z0-9]/", "", value);

            case self::FILTER_TRIM:

                return trim(value);

            case self::FILTER_STRIPTAGS:

                return strip_tags(value);

            case self::FILTER_LOWER:

                if function_exists("mb_strtolower") {
                    /**
                     * 'lower' checks for the mbstring extension to make a correct lowercase transformation
                     */
                    return mb_strtolower(value);
                }
                return strtolower(value);

            case self::FILTER_UPPER:

                if function_exists("mb_strtoupper") {
                    /**
                     * 'upper' checks for the mbstring extension to make a correct lowercase transformation
                     */
                    return mb_strtoupper(value);
                }
                return strtoupper(value);

            default:
                throw new Exception("Sanitize filter '" . filter . "' is not supported");
        }
    }

    /**
     * Return the user-defined filters in the instance
     *
     * @return array
     */
    public function getFilters() -> array
    {
        return this->_filters;
    }
}
