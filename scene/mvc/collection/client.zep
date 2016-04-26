
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

namespace Scene\Mvc\Collection;

use MongoDB\Driver\Manager as mongoManager;
use MongoDB\Driver\WriteConcern;
use MongoDB\Driver\ReadPreference;

class Client
{

	/**
     * Manager
     * 
     * @var MongoDB\Driver\Manager|null
     * @access protected
     */
    protected _manager;

    /**
     * Mongodb server uri
     * 
     * @var string|null
     * @access protected
     */
    protected _uri;

    /**
     * Mongodb server
     * 
     * @var MongoDB\Driver\Server|null
     * @access protected
     */
    protected _server;

    /**
     * Write Concern
     * 
     * @var MongoDB\Driver\WriteConcern|null
     * @access protected
     */
    protected _writeConcern;

    /**
     * Read Preference
     * 
     * @var MongoDB\Driver\ReadPreference|null
     * @access protected
     */
    protected _readPreference;

    /**
     * Database name
     * 
     * @var string|null
     * @access protected
     */
    protected _databaseName;

    /**
     * \Scene\Mvc\Collection\Client constructor
     * 
     * @param string uri
     * @param array options
     * @param array driverOptions
     */
    public function __construct(string! uri = "mongodb://localhost:27017", array options = [], array driverOptions = [])
    {
    	let this->_manager = new mongoManager(uri, options, driverOptions);
    	let this->_uri = uri;
    }

    /**
     * Select a server matching a read preference
     * 
     * @param  \MongoDB\Driver\ReadPreference readPreference
     * @param boolean $selectServer
     * @return \MongoDB\Driver\Server
     */
    public function getServer(var readPreference = null, boolean selectServer = false)
    {
    	var server;

        if selectServer {
            if !this->_server {
                if !readPreference {
                    let readPreference = new ReadPreference(ReadPreference::RP_PRIMARY_PREFERRED);
                }

                let server = this->_manager->selectServer(readPreference);
                let this->_server = server;
                return server;
            }

            return this->_server;
        } else {
            return this->_manager;
        }
    }

    /**
     * Set Write Concern
     * 
     * @param MongoDB\Driver\WriteConcern writeConcern
     */
    public function setWriteConcern(<WriteConcern> writeConcern)
    {
        let this->_writeConcern = writeConcern;
    }

    /**
     * Get Write Concern
     * 
     * @return MongoDB\Driver\WriteConcern
     */
    public function getWriteConcern() -> <WriteConcern>
    {
        var writeConcern, wc;

        let writeConcern = this->_writeConcern;

        if !writeConcern {
            // Construct a write concern
            let wc = new WriteConcern(
                // Guarantee that writes are acknowledged by a majority of our nodes
                WriteConcern::MAJORITY,
                // But only wait 1000ms because we have an application to run!
                1000
            );

            let this->_writeConcern = wc;
            return wc;
        }

        return writeConcern;
    }

    /**
     * Set Read Preference
     * 
     * @param MongoDB\Driver\ReadPreference readPreference
     */
    public function setReadPreference(<ReadPreference> readPreference)
    {
        let this->_readPreference = readPreference;
    }

    /**
     * Get read preference
     * 
     * @return MongoDB\Driver\ReadPreference;
     */
    public function getReadPreference() -> <ReadPreference>
    {
        var readPreference, rp;

        let readPreference = this->_readPreference;

        if !readPreference {
            // Construct a read preference
            let rp = new ReadPreference(
                ReadPreference::RP_PRIMARY_PREFERRED
            );

            let this->_readPreference = rp;
            return rp;
        }

        return readPreference;
    }

    /**
     * Set database name.
     * 
     * @param string $atabaseName
     * @return \Scene\Mvc\Collection\Client
     */
    public function setDatabaseName(string databaseName) -> <Client>
    {
        let this->_databaseName = databaseName;
        return this;
    }

    /**
     * Get database name
     * 
     * @return string
     */
    public function getDatabaseName() -> string
    {
        return this->_databaseName;
    }

    /**
     * Return the connection string (i.e. URI).
     *
     * @param string
     */
    public function __toString()
    {
        return this->_uri;
    }
    
    
}
