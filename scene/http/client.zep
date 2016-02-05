
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

namespace Scene\Http;

use Scene\Http\Client\Method;
use Scene\Http\Client\Response;
use Scene\Http\Client\Exception;

/**
 * Scene\Http\Client
 *
 * HTTP client
 *
 */
class Client
{

	/**
     * Cookie
     *
     * @var null|string
     * @access protected
    */
    protected static cookie = null;

    /**
     * Cookie File
     *
     * @var null|string
     * @access protected
    */
    protected static cookieFile = null;

    /**
     * Curl options
     *
     * @var null|array
     * @access protected
    */
    protected static curlOpts = [];

    /**
     * Default headers
     *
     * @var null|array
     * @access protected
    */
    protected static defaultHeaders = [];

    /**
     * Handle
     *
     * @var null|string
     * @access protected
    */
    protected static handle = null;

    /**
     * Json options
     *
     * @var null|array
     * @access protected
    */
    protected static jsonOpts = [];

    /**
     * Socket time out
     *
     * @var null|string
     * @access protected
    */
    protected static socketTimeout = null;

    /**
     * Verify peer
     *
     * @var boolean
     * @access protected
    */
    protected static verifyPeer = true;

    /**
     * Verify host
     *
     * @var boolean
     * @access protected
    */
    protected static verifyHost = true;

    /**
     * Auth
     *
     * @var array
     * @access protected
    */
    protected static auth = [
        "user" : "",
        "pass" : "",
        "method" : CURLAUTH_BASIC
    ];

    /**
     * Proxy
     *
     * @var array
     * @access protected
    */
    protected static proxy = [
        "port" : false,
        "tunnel" : false,
        "address" : false,
        "type" : CURLPROXY_HTTP,
        "auth" : [
            "user" : "",
            "pass" : "",
            "method" : CURLAUTH_BASIC
        ]
    ];

    
}