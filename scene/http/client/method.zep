
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

namespace Scene\Http\Client;

/**
 * Scene\Http\Client\Method
 *
 * Method of HTTP client
 * 
 */
interface Method
{
    // RFC7231
    const GET = 'GET';
    const HEAD = 'HEAD';
    const POST = 'POST';
    const PUT = 'PUT';
    const DELETE = 'DELETE';
    const CONNECT = 'CONNECT';
    const OPTIONS = 'OPTIONS';
    const TRACE = 'TRACE';

    // RFC3253
    const BASELINE = 'BASELINE';

    // RFC2068
    const LINK = 'LINK';
    const UNLINK = 'UNLINK';

    // RFC3253
    const MERGE = 'MERGE';
    const BASELINECONTROL = 'BASELINE-CONTROL';
    const MKACTIVITY = 'MKACTIVITY';
    const VERSIONCONTROL = 'VERSION-CONTROL';
    const REPORT = 'REPORT';
    const CHECKOUT = 'CHECKOUT';
    const CHECKIN = 'CHECKIN';
    const UNCHECKOUT = 'UNCHECKOUT';
    const MKWORKSPACE = 'MKWORKSPACE';
    const UPDATE = 'UPDATE';
    const LABEL = 'LABEL';

    // RFC3648
    const ORDERPATCH = 'ORDERPATCH';

    // RFC3744
    const ACL = 'ACL';

    // RFC4437
    const MKREDIRECTREF = 'MKREDIRECTREF';
    const UPDATEREDIRECTREF = 'UPDATEREDIRECTREF';

    // RFC4791
    const MKCALENDAR = 'MKCALENDAR';

    // RFC4918
    const PROPFIND = 'PROPFIND';
    const LOCK = 'LOCK';
    const UNLOCK = 'UNLOCK';
    const PROPPATCH = 'PROPPATCH';
    const MKCOL = 'MKCOL';
    const COPY = 'COPY';
    const MOVE = 'MOVE';

    // RFC5323
    const SEARCH = 'SEARCH';

    // RFC5789
    const PATCH = 'PATCH';

    // RFC5842
    const BIND = 'BIND';
    const UNBIND = 'UNBIND';
    const REBIND = 'REBIND';
}
