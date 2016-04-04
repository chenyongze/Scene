
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

namespace Scene\Session\Adapter;

use Scene\Session\Adapter;
use Scene\Cache\Backend\Redis as BackendRedis;
use Scene\Cache\Frontend\None as FrontendNone;

/**
 * Scene\Session\Adapter\Redis
 *
 * This adapter store sessions in Redis
 *
 *<code>
 * use Scene\Session\Adapter\Redis;
 *
 * $session = new Redis([
 *    'uniqueId'   => 'my-private-app',
 *    'host'       => 'localhost',
 *    'port'       => 6379,
 *    'auth'       => 'foobared',
 *    'persistent' => false,
 *    'lifetime'   => 3600,
 *    'prefix'     => 'my_'
 * ]);
 *
 * $session->start();
 *
 * $session->set('var', 'some-value');
 *
 * echo $session->get('var');
 *</code>
 */
class Redis extends Adapter
{
     
    /**
     * Redis
     *
     * @var null|object
     * @access protected
    */
    protected _redis = null { get };

    /**
     * Lifetime
     *
     * @var null|int
     * @access protected
    */
    protected _lifetime = 8600 { get };

    /**
     * Scene\Session\Adapter\Redis constructor
     *
     * @param array options
     */
    public function __construct(array options = [])
    {
        var lifetime;

        if !isset options["host"] {
            let options["host"] = "127.0.0.1";
        }

        if !isset options["port"] {
            let options["port"] = 6379;
        }

        if !isset options["persistent"] {
            let options["persistent"] = false;
        }

        if fetch lifetime, options["lifetime"] {
            let this->_lifetime = lifetime;
        }

        let this->_redis = new BackendRedis(
            new FrontendNone(["lifetime": this->_lifetime]),
            options
        );

        session_set_save_handler(
            [this, "open"],
            [this, "close"],
            [this, "read"],
            [this, "write"],
            [this, "destroy"],
            [this, "gc"]
        );

        parent::__construct(options);
    }

    public function open() -> boolean
    {
        return true;
    }

    public function close() -> boolean
    {
        return true;
    }

    /**
     * Read a session variable from an application context
     *
     * <code>
     *  $session->read('auth', 'yes');
     *</code>
     *
     * @param string sessionId
     * @return mixed
     */
    public function read(sessionId) -> var
    {
        return this->_redis->get(sessionId, this->_lifetime);
    }

    /**
     * Write a session variable in an application context
     *
     *<code>
     *  $session->write('auth', 'yes');
     *</code>
     *
     * @param string $sessionId
     * @param mixed $data
     */
    public function write(string sessionId, string data)
    {
        this->_redis->save(sessionId, data, this->_lifetime);
    }

    /**
     * Destroy a session variable from an application context
     *
     *<code>
     *  $session->destroy('auth');
     *</code>
     *
     * @param string $sessionId
     * @return boolean
     */
    public function destroy(string sessionId = null) -> boolean
    {
        var id;

        if sessionId === null {
            let id = this->getId();
        } else {
            let id = sessionId;
        }

        return this->_redis->delete(id);
    }

    public function gc() -> boolean
    {
        return true;
    }
}
