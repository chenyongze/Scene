
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

use Scene\Mvc\Collection\ManagerInterface;
use Scene\Mvc\Collection\MessageInterface;

/**
 * Scene\Mvc\CollectionInterface
 *
 * Interface for Scene\Mvc\Collection
 */
interface CollectionInterface
{

    /**
     * Sets a value for the _id propery, creates a MongoId object if needed
     *
     * @param mixed id
     */
    public function setId(id);

    /**
     * Returns the value of the _id property
     *
     * @return MongoId
     */
    public function getId();

    /**
     * Returns an array with reserved properties that cannot be part of the insert/update
     *
     * @return array
     */
    public function getReservedAttributes() -> array;

    /**
     * Returns collection name mapped in the collection
     *
     * @return string
     */
    public function getSource() -> string;

    /**
     * Sets a service in the services container that returns the Mongo database
     *
     * @param string connectionService
     */
    public function setConnection(string! connectionService);

    /**
     * Retrieves a database connection
     *
     * @return MongoDb
     */
    public function getConnection();

    /**
     * Returns a cloned collection
     *
     * @param \Scene\Mvc\CollectionInterface collection
     * @param object document
     * @return \Scene\Mvc\CollectionInterface
     */
    public static function cloneResult(<CollectionInterface> collection, object document) -> <CollectionInterface>;

    /**
     * Fires an event, implicitly calls behaviors and listeners in the events manager are notified
     *
     * @param string eventName
     * @return boolean
     */
    public function fireEvent(string! eventName) -> boolean;

    /**
     * Fires an event, implicitly listeners in the events manager are notified
     * This method stops if one of the callbacks/listeners returns boolean false
     *
     * @param string eventName
     * @return boolean
     */
    public function fireEventCancel(string! eventName) -> boolean;

    /**
     * Check whether validation process has generated any messages
     *
     * @return boolean
     */
    public function validationHasFailed() -> boolean;

    /**
     * Returns all the validation messages
     *
     * @return \Scene\Mvc\collection\MessageInterface[]
     */
    public function getMessages() -> <MessageInterface[]>;

    /**
     * Appends a customized message on the validation process
     *
     * @param \Scene\Mvc\Collection\MessageInterface message
     */
    public function appendMessage(<MessageInterface> message);

    /**
     * Creates/Updates a collection based on the values in the attributes
     *
     * @return boolean
     */
    public function save() -> boolean;

    /**
     * Find a document by its id
     *
     * @param string id
     * @return \Scene\Mvc\CollectionInterface
     */
    public static function findById(id) -> <CollectionInterface>;

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param array parameters
     * @return array
     */
    public static function findFirst(array parameters = null);

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param   array parameters
     * @return  array
     */
    public static function find(array parameters = null);

    /**
     * Perform a count over a collection
     *
     * @param array parameters
     * @return array
     */
    public static function count(array parameters = null);

    /**
     * Deletes a collection instance. Returning true on success or false otherwise
     *
     * @return boolean
     */
    public function delete() -> boolean;

    /**
     * Returns the instance as an array representation
     * 
     * @return array
     */
    public function toArray() -> array;
}
