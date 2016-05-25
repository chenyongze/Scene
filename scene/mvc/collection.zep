
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

use Scene\Di;
use Scene\DiInterface;
use Scene\Di\InjectionAwareInterface;
use Scene\Mvc\Collection\ManagerInterface;
use Scene\Mvc\Collection\Exception;
use Scene\Mvc\Collection\Message;
use Scene\Mvc\Collection\MessageInterface;
use Scene\ValidationInterface;
use Scene\Validation\Message\Group;
use Scene\Events\ManagerInterface as EventsManagerInterface;
use MongoDB\Driver\BulkWrite;
use MongoDB\Driver\Query;
use MongoDB\Driver\Command;
use MongoDB\BSON\ObjectId;

/**
 * Scene\Mvc\Collection
 *
 * This component implements a high level abstraction for NoSQL databases which
 * works with documents
 */
abstract class Collection implements CollectionInterface, EntityInterface, InjectionAwareInterface, \Serializable, \JsonSerializable
{

    /**
     * Operation: None
     *
     * @var int
    */
    const OP_NONE = 0;

    /**
     * Operation: Create
     *
     * @var int
    */
    const OP_CREATE = 1;

    /**
     * Operation: Update
     *
     * @var int
    */
    const OP_UPDATE = 2;

    /**
     * Operation: Delete
     *
     * @var int
    */
    const OP_DELETE = 3;

    /**
     * ID
     *
     * @var null
     * @access public
    */
    public _id;

    /**
     * Dependency Injector
     *
     * @var \Scene\DiInterface|null
     * @access protected
    */
    protected _dependencyInjector;

    /**
     * collection Manager
     *
     * @var null|\Scene\Mvc\Collection\ManagerInterface
     * @access protected
    */
    protected _collectionManager;

    /**
     * Source
     *
     * @var null|string
     * @access protected
    */
    protected _source;

    /**
     * Operations Made
     *
     * @var int
     * @access protected
    */
    protected _operationMade = 0;

    /**
     * Connection
     *
     * @var null
     * @access protected
    */
    protected _connection;

    /**
     * Error Messages
     *
     * @var null|array
     * @access protected
    */
    protected _errorMessages;

    /**
     * Reserved
     *
     * @var null|array
     * @access protected
    */
    protected static _reserved;

    /**
     * Disable Events
     *
     * @var boolean
     * @access protected
    */
    protected static _disableEvents = false;

    /**
     * Skipped
     *
     * @var boolean
     * @access protected
    */
    protected _skipped = false;

    /**
     * Scene\Mvc\Collection constructor
     */
    public final function __construct(<DiInterface> dependencyInjector = null, <ManagerInterface> collectionManager = null)
    {
        /**
         * We use a default DI if the user doesn't define one
         */
        if typeof dependencyInjector != "object" {
            let dependencyInjector = Di::getDefault();
        }

        if typeof dependencyInjector != "object" {
            throw new Exception("A dependency injector container is required to obtain the services related to the ORM");
        }

        let this->_dependencyInjector = dependencyInjector;

        /**
         * Inject the manager service from the DI
         */
        if typeof collectionManager != "object" {
            let collectionManager = dependencyInjector->getShared("collectionManager");
        }

        if typeof collectionManager != "object" {
            throw new Exception("The injected service 'collectionManager' is not valid");
        }

        /**
         * Update the models-manager
         */
        let this->_collectionManager = collectionManager;

        /**
         * The manager always initializes the object
         */
        collectionManager->initialize(this);

        /**
         * This allows the developer to execute initialization stuff every time an instance is created
         */
        if method_exists(this, "onConstruct") {
            this->{"onConstruct"}();
        }
    }

    /**
     * Sets the dependency injection container
     *
     * @param \Scene\DiInterface $dependencyInjector
     */
    public function setDI(<DiInterface> dependencyInjector)
    {
        let this->_dependencyInjector = dependencyInjector;
    }

    /**
     * Returns the dependency injection container
     *
     * @return \Scene\DiInterface|null
     */
    public function getDI() -> <DiInterface>
    {
        var dependencyInjector;

        let dependencyInjector = this->_dependencyInjector;
        if typeof dependencyInjector != "object" {
            let dependencyInjector = Di::getDefault();
        }
        return dependencyInjector;
    }

    /**
     * Sets a custom events manager
     *
     * @param \Scene\Events\ManagerInterface eventsManager
     */
    protected function setEventsManager(<EventsManagerInterface> eventsManager)
    {
        this->_collectionManager->setCustomEventsManager(this, eventsManager);
    }

    /**
     * Returns the custom events manager
     *
     * @return \Scene\Events\ManagerInterface|null
     */
    protected function getEventsManager() -> <EventsManagerInterface>
    {
        return this->_collectionManager->getCustomEventsManager(this);
    }

    /**
     * Returns the models manager related to the entity instance
     *
     * @return \Scene\Mvc\Collection\ManagerInterface|null
     */
    public function getCollectionManager() -> <ManagerInterface>
    {
        return this->_collectionManager;
    }

    /**
     * Returns an array with reserved properties that cannot be part of the insert/update
     *
     * @return array
     */
    public function getReservedAttributes() -> array
    {
        var reserved;

        let reserved = self::_reserved;
        if reserved === null {
            let reserved = [
                "_connection": true,
                "_dependencyInjector": true,
                "_source": true,
                "_operationMade": true,
                "_errorMessages": true,
                "_modelsManager": true,
                "_skipped":true
            ];
            let self::_reserved = reserved;
        }
        
        return reserved;
    }

    /**
     * Sets if a model must use implicit objects ids
     *
     * @param boolean useImplicitObjectIds
     */
    protected function useImplicitObjectIds(boolean useImplicitObjectIds)
    {
        this->_collectionManager->useImplicitObjectIds(this, useImplicitObjectIds);
    }

    /**
     * Sets collection name which model should be mapped
     *
     * @param string source
     * @return \Scene\Mvc\CollectionInterface
     */
    public function setSource(string! source) -> <CollectionInterface>
    {
        let this->_source = source;
        return this;
    }

    /**
     * Returns collection name mapped in the model
     *
     * @return string
     */
    public function getSource() -> string
    {
        var source, collection;

        let source = this->_source;
        if !source {
            let collection = this;
            let source = uncamelize(get_class_ns(collection));
            let this->_source = source;
        }
        return source;
    }

    /**
     * Sets the DependencyInjection connection service name
     *
     * @param string connectionService
     * @return \Scene\Mvc\CollectionInterface
     */
    public function setConnection(string! connectionService) -> <CollectionInterface>
    {
        this->_collectionManager->setConnectionService(this, connectionService);
        return this;
    }

    /**
     * Returns DependencyInjection connection service
     *
     * @return \MongoDB\Driver\Manager
     */
    public function getConnection() -> string
    {
        return this->_collectionManager->getConnection(this);
    }

    /**
     * Reads an attribute value by its name
     *
     *<code>
     *  echo $robot->readAttribute('name');
     *</code>
     *
     * @param string attribute
     * @return mixed
     */
    public function readAttribute(string! attribute)
    {
        if !isset this->{attribute} {
            return null;
        }

        return this->{attribute};
    }

    /**
     * Writes an attribute value by its name
     *
     *<code>
     *  $robot->writeAttribute('name', 'Rosey');
     *</code>
     *
     * @param string attribute
     * @param mixed value
     */
    public function writeAttribute(string! attribute, var value)
    {
        let this->{attribute} = value;
    }

    /**
     * Returns a cloned collection
     *
     * @param \Scene\Mvc\CollectionInterface collection
     * @param object document
     * @return \Scene\Mvc\CollectionInterface
     */
    public static function cloneResult(<CollectionInterface> collection, object! document) -> <CollectionInterface>
    {
        var clonedCollection, key, value;
        
        let clonedCollection = clone collection;
        
        for key, value in get_object_vars(document) {
            clonedCollection->writeAttribute(key, value);
        }

        if method_exists(clonedCollection, "afterFetch") {
            clonedCollection->{"afterFetch"}();
        }

        return clonedCollection;
    }

    /**
     * Returns a collection resultset
     *
     * @param array filter
     * @param array options
     * @param \Scene\Mvc\CollectionInterface collection
     * @param boolean unique
     * @return array|boolean|\Scene\Mvc\CollectionInterface|\Scene\Mvc\Collection\Document
     * @throws Exception
     */
    protected static function _getResultset(array filter = null, array options = null, <CollectionInterface> collection, boolean unique)
    {
        var source, query, cursor, result, base, collections, document;
        
        let source = collection->getSource();
        if empty source {
            throw new Exception("Method getSource() returns empty string");
        }

        let query = new Query(filter, options);

        let cursor = collection->getCollectionManager()->executeQuery(collection, source, query);

        let result = cursor->toArray();

        if empty result {
            return null;
        }

        if (isset(options["simple"]) && options["simple"]) {
            
            if (unique === true) {
                return result[0];
            } else {
                return result;
            }
            
        } else {
            let base = collection;
        }

        if (unique === true) {

            /**
             * Assign the values to the base object
             */
            return static::cloneResult(base, result[0]);
        }

        /**
         * Requesting a complete resultset
         */
        let collections = [];

        for document in result {

            /**
             * Assign the values to the base object
             */
            let collections[] = static::cloneResult(base, document);
        }

        return collections;
        
    }

    /**
     * Executes internal hooks before save a document
     *
     * @param \Scene\DiInterface dependencyInjector
     * @param boolean disableEvents
     * @param boolean exists
     * @return boolean
     */
    protected final function _preSave(dependencyInjector, boolean disableEvents, boolean exists) -> boolean
    {
        var eventName;

        /**
         * Run Validation Callbacks Before
         */
        if !disableEvents {

            if this->fireEventCancel("beforeValidation") === false {
                return false;
            }

            if !exists {
                let eventName = "beforeValidationOnCreate";
            } else {
                let eventName = "beforeValidationOnUpdate";
            }

            if this->fireEventCancel(eventName) === false {
                return false;
            }

        }

        /**
         * Run validation
         */
        if this->fireEventCancel("validation") === false {
            if !disableEvents {
                this->fireEvent("onValidationFails");
            }
            return false;
        }

        if !disableEvents {

            /**
             * Run Validation Callbacks After
             */
            if !exists {
                let eventName = "afterValidationOnCreate";
            } else {
                let eventName = "afterValidationOnUpdate";
            }

            if this->fireEventCancel(eventName) === false {
                return false;
            }

            if this->fireEventCancel("afterValidation") === false {
                return false;
            }

            /**
             * Run Before Callbacks
             */
            if this->fireEventCancel("beforeSave") === false {
                return false;
            }

            if !exists {               
                let eventName = "beforeCreate";
            } else {
                let eventName = "beforeUpdate";
            }

            if this->fireEventCancel(eventName) === false {
                return false;
            }

        }

        return true;
    }

    /**
     * Executes internal events after save a document
     *
     * @param boolean disableEvents
     * @param boolean success
     * @param boolean exists
     * @return boolean
     */
    protected final function _postSave(boolean disableEvents, boolean success, boolean exists) -> boolean
    {
        var eventName;

        if success {
            if !disableEvents {

                if !exists {
                    let eventName = "afterCreate";
                } else {                  
                    let eventName = "afterUpdate";
                }
                this->fireEvent(eventName);

                this->fireEvent("afterSave");
            }
            return success;
        }

        if !disableEvents {
            this->fireEvent("notSave");
        }

        this->_cancelOperation(disableEvents);
        return false;
    }

    /**
     * Fires an internal event
     *
     * @param string eventName
     * @return boolean
     */
    public function fireEvent(string! eventName) -> boolean
    {
        /**
         * Check if there is a method with the same name of the event
         */
        if method_exists(this, eventName) {
            this->{eventName}();
        }

        /**
         * Send a notification to the events manager
         */
        return this->_collectionManager->notifyEvent(eventName, this);
    }

    /**
     * Fires an internal event that cancels the operation
     *
     * @param string eventName
     * @return boolean
     */
    public function fireEventCancel(string! eventName) -> boolean
    {
        /**
         * Check if there is a method with the same name of the event
         */
        if method_exists(this, eventName) {
            if this->{eventName}() === false {
                return false;
            }
        }

        /**
         * Send a notification to the events manager
         */
        if this->_collectionManager->notifyEvent(eventName, this) === false {
            return false;
        }

        return true;
    }

    /**
     * Cancel the current operation
     *
     * @param boolean disableEvents
     * @return boolean
     */
    protected function _cancelOperation(boolean disableEvents) -> boolean
    {
        var eventName;

        if !disableEvents {
            if this->_operationMade == self::OP_DELETE {
                let eventName = "notDeleted";
            } else {
                let eventName = "notSaved";
            }
            this->fireEvent(eventName);
        }
        return false;
    }

    /**
     * Executes validators on every validation call
     *
     *<code>
     *use Scene\Validation;
     *use Scene\Validation\Validator\ExclusionIn;
     *
     *class Subscriptors extends \Scene\Mvc\Collection
     *{
     *
     *  public function validation()
     *  {
     *      $validator = new Validation();
     *      $validator->add('status', new ExclusionIn(array(
     *          'domain' => array('A', 'I')
     *      )));
     *
     *      return $this->validate($validator);
     *  }
     *
     *}
     *</code>
     *
     * @param \Scene\ValidationInterface validator
     */
    protected function validate(<ValidationInterface> validator)
    {
        var messages, message;
        let messages = validator->validate(null, this);

        // Call the validation, if it returns not the boolean we append the messages to the current object
        if typeof messages != "boolean" {
            // for message in iterator(messages) {
            messages->rewind();
            while messages->valid() {
                let message = messages->current();
                this->appendMessage(new Message(message->getMessage(), message->getField(), message->getType()));
            }

            // If there is a message, it returns false otherwise true
            return !count(messages);
        }

        return messages;
    }

    /**
     * Check whether validation process has generated any messages
     *
     * @return boolean
     */
    public function validationHasFailed() -> boolean
    {
        var errorMessages;

        let errorMessages = this->_errorMessages;
        if typeof errorMessages == "array" {
            if count(errorMessages) {
                return true;
            }
        }
        return false;
    }

    /**
     * Find a document by its id (_id)
     *
     * @param string|\MongoDB\BSON\ObjectId id
     * @param array options
     * @return \Scene\Mvc\CollectionInterface
     * @throws Exception
     */
    public static function findById(var id, array options = []) {
        var className, collection, id, filter, options;

        let className = get_called_class(),
            collection = new {className}();

        let filter = ["_id": id],
            options = array_merge(options, ["limit": 1]);

        return static::_getResultset(filter, options, collection, true);

    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param array filter
     * @param array options
     * @return \Scene\Mvc\CollectionInterface
     * @throws Exception
     */
    public static function findFirst(array filter = [], array options = [])
    {
        var className, collection;

        let className = get_called_class(),
            collection = new {className}();

        let options = array_merge(options, ["limit": 1]);

        return static::_getResultset(filter, options, collection, true);
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param array filter
     * @param array options
     * @return array
     * @throws Exception
     */
    public static function find(array filter = [], array options = [])
    {
        var className, collection;

        let className = get_called_class(),
            collection = new {className}();

        return static::_getResultset(filter, options, collection, false);
    }

    /**
     * Creates/Updates a collection based on the values in the atributes
     *
     * @return boolean|\Scene\Mvc\CollectionInterface
     * @throws Exception
     */
    public function save()
    {
        var dependencyInjector, source, data, exists, bulk, filter, options, disableEvents,
            success, result;

        let dependencyInjector = this->_dependencyInjector;
        if typeof dependencyInjector != "object" {
            throw new Exception("A dependency injector container is required to obtain the services related to the ORM");
        }

        let source = this->getSource();
        if empty source {
            throw new Exception("Method getSource() returns empty string");
        }

        /**
         * The messages added to the validator are reset here
         */
        let this->_errorMessages = [];

        let disableEvents = self::_disableEvents;

        /**
         * Check the dirty state of the current operation to update the current operation
         */
        let exists = this->_exists(this);

        /**
         * Execute the preSave hook
         */
        if this->_preSave(dependencyInjector, disableEvents, exists) === false {
            return false;
        }

        let bulk = new BulkWrite();

        if !exists {
            let this->_operationMade = self::OP_CREATE;
            
            let this->_id = (string) new ObjectId();
            bulk->insert(this->toArray());
        } else {
            let this->_operationMade = self::OP_UPDATE;

            let filter = ["_id": this->_id];
            let data = ["$set": this->toArray()];
            let options = ["multi": false, "upsert": false];

            bulk->update(filter, data, options);
        }

        let success = false;

        let result = this->_collectionManager->executeBulkWrite(this, source, bulk);

        if empty result->getWriteErrors() {

            if !exists {
                if result->getInsertedCount() > 0 {
                    let success = true;
                }
            } else {
                let success = true;
            }
        }

        /**
         * Call the postSave hooks
         */
        return this->_postSave(disableEvents, success, exists);     
    }

    /**
     * Creates/Updates a collection based on the values in the atributes
     *
     * @param array filter
     * @param array options
     * @return boolean
     * @throws Exception
     */
    public function update(array filter = [], array options = [])
    {
        var source, update, bulk, result;

        let source = this->getSource();
        if empty source {
            throw new Exception("Method getSource() returns empty string");
        }

        let update = ["$set": this->toArray()];

        if empty options {
            let options = ["multi": true, "upsert": false];
        }

        let bulk = new BulkWrite();
            bulk->update(filter, update, options);

        let result = this->getCollectionManager()->executeBulkWrite(this, source, bulk);

        if empty result->getWriteErrors() {
            return true;
        } else {
            return false;
        }

        return false;
    }

 
    /**
     * Deletes a model instance. Returning true on success or false otherwise.
     *
     * <code>
     *  $robot = Robots::findFirst();
     *  $robot->delete();
     *
     *  foreach (Robots::find() as $robot) {
     *      $robot->delete();
     *  }
     * </code>
     *
     * @return boolean
     */
    public function delete() -> boolean
    {
        var id, disableEvents, source, success, filter, options, bulk, result;
        
        if !fetch id, this->_id {
            throw new Exception("The document cannot be deleted because it doesn't exist");
        }

        let disableEvents = self::_disableEvents;

        if !disableEvents {
            if this->fireEventCancel("beforeDelete") === false {
                return false;
            }
        }

        if this->_skipped === true {
            return true;
        }

        let source = this->getSource();
        if empty source {
            throw new Exception("Method getSource() returns empty string");
        }

        let success = false;

        // Specify the search criteria
        let filter = ["_id": id];

        /* Specify some command options for the update:
         *
         *  * limit (integer): Deletes all matching documents when 0 (false). Otherwise,
         *    only the first matching document is deleted. */
        let options = ["limti": 1];
        
        // Create a bulk write object and add our delete operation
        let bulk = new BulkWrite();
            bulk->delete(filter, options);

        /* Specify the full namespace as the first argument, followed by the bulk
         * write object and an optional write concern. MongoDB\Driver\WriteResult is
         * returned on success; otherwise, an exception is thrown. */
        let result = this->getCollectionManager()->executeBulkWrite(this, source, bulk);

        if (result->getDeletedCount() > 0) && empty (result->getWriteErrors()) {
            let success = true;
            if !disableEvents {
                this->fireEvent("afterDelete");
            }
        } else {
            let success = false;
        }

        return success;
    }

    /**
     * Deletes some collections instance. Returning true on success or false otherwise.
     *
     * @param array filter
     * @param array options
     * @param boolean mode
     * @return boolean|int
     */
    public static function deleteMany(array filter = null, array options = null, boolean mode = true)
    {
        var documents, document, className, collection, source, bulk, result;

        if mode {
            let documents = static::find(filter, options);

            if documents {
                for document in documents {
                    document->delete();
                }
            }

            return count(documents);
        } else {

            let className = get_called_class(),
                collection = new {className}();
            
            let source = collection->getSource();
            if empty source {
                throw new Exception("Method getSource() returns empty string");
            }

            /* Specify some command options for the update:
             *
             *  * limit (integer): Deletes all matching documents when 0 (false). Otherwise,
             *    only the first matching document is deleted. */
            if empty options {
                let options = ["limit": 0];
            }

            // Create a bulk write object and add our delete operation
            let bulk = new BulkWrite();
                bulk->delete(filter, options);

            /* Specify the full namespace as the first argument, followed by the bulk
             * write object and an optional write concern. MongoDB\Driver\WriteResult is
             * returned on success; otherwise, an exception is thrown. */
            let result = collection->getCollectionManager()->executeBulkWrite(collection, source, bulk);

            if empty result->getWriteErrors() {
                return result->getDeletedCount();
            } else {
                return false;
            }
        }
    }

    /**
     * Perform a count over a collection
     *
     *<code>
     * echo 'There are ', Robots::count(), ' robots';
     *</code>
     *
     * @param array filter
     * @param array options
     * @return int
     * @throws Exception
     */
    public static function count(array filter = null, array options = null)
    {
        var className, collection, source, cmd, option, command, result;

        let className = get_called_class(),
            collection = new {className}();

        let source = collection->getSource();
        if empty source {
            throw new Exception("Method getSource() returns empty string");
        }

        let cmd = ["count": source];

        if !empty filter {
            let cmd["query"] = (object) filter;
        }

        for option in ["hint", "limit", "maxTimeMS", "skip"] {
            if isset options[option] {
                let cmd[option] = options[option];
            }
        }

        let command = new Command(cmd);

        let result = collection->getCollectionManager()->executeCommand(collection, command);

        return (int) result->n;
    }
    


    /**
     * Checks if the document exists in the collection
     *
     * @param \Scene\Mvc\CollectionInterface collection
     * @return boolean
     * @throws Exception
     */
    protected function _exists(<CollectionInterface> collection) -> boolean
    {
        var id;

        if !fetch id, collection->_id {
            return false;
        }

        /**
         * Perform the count using the function provided by the driver
         */
        return collection->count(["_id": id]) > 0;
    }

    /**
     * Returns the instance as an array representation
     *
     *<code>
     * print_r($robot->toArray());
     *</code>
     *
     * @return array
     */
    public function toArray() -> array
    {
        var data, reserved, key, value;

        let reserved = this->getReservedAttributes();

        /**
         * Get an array with the values of the object
         * We only assign values to the public properties
         */
        let data = [];
        for key, value in get_object_vars(this) {
            if key == "_id" {
                if value {
                    let data[key] = value;
                }
            } else {
                if !isset reserved[key] {
                    let data[key] = value;
                }
            }
        }

        return data;
    }

    /**
    * Serializes the object for json_encode
    *
    *<code>
    * echo json_encode($robot);
    *</code>
    *
    * @return array
    */
    public function jsonSerialize()
    {
        return this->toArray();
    }

    /**
     * Returns a simple representation of the object that can be used with var_dump
     *
     *<code>
     * var_dump($robot->dump());
     *</code>
     *
     * @return array
     */
    public function dump()
    {
        return get_object_vars(this);
    }

    /**
     * Serializes the object ignoring connections or protected properties
     *
     * @return string
     */
    public function serialize() -> string
    {
        /**
         * Use the standard serialize function to serialize the array data
         */
        return serialize(this->toArray());
    }

    /**
     * Unserializes the object from a serialized string
     *
     * @param string data
     */
    public function unserialize(string! data)
    {
        var attributes, dependencyInjector, manager, key, value;

        let attributes = unserialize(data);
        if typeof attributes == "array" {

            /**
             * Obtain the default DI
             */
            let dependencyInjector = Di::getDefault();
            if typeof dependencyInjector != "object" {
                throw new Exception("A dependency injector container is required to obtain the services related to the ODM");
            }

            /**
             * Update the dependency injector
             */
            let this->_dependencyInjector = dependencyInjector;

            /**
             * Gets the default modelsManager service
             */
            let manager = dependencyInjector->getShared("collectionManager");
            if typeof manager != "object" {
                throw new Exception("The injected service 'collectionManager' is not valid");
            }

            /**
             * Update the models manager
             */
            let this->_modelsManager = manager;

            /**
             * Update the objects attributes
             */
            for key, value in attributes {
                let this->{key} = value;
            }
        }
    }

    /**
     * Returns all the validation messages
     *
     * <code>
     * $robot = new Robots();
     * $robot->type = 'mechanical';
     * $robot->name = 'Astro Boy';
     * $robot->year = 1952;
     * if ($robot->save() == false) {
     *  echo "Umh, We can't store robots right now ";
     *  foreach ($robot->getMessages() as message) {
     *      echo message;
     *  }
     *} else {
     *  echo "Great, a new robot was saved successfully!";
     *}
     * </code>
     *
     * @return \Scene\Mvc\Collection\MessageInterface[]|null
     */
    public function getMessages(filter = null) -> <MessageInterface[]>
    {
        var filtered, message;

        if typeof filter == "string" && !empty filter {
            let filtered = [];
            for message in this->_errorMessages {
                if message->getField() == filter {
                    let filtered[] = message;
                }
            }
            return filtered;
        }

        return this->_errorMessages;
    }

    /**
     * Appends a customized message on the validation process
     *
     *<code>
     *  use \Scene\Mvc\Collection\Message as Message;
     *
     *  class Robots extends \Scene\Mvc\Collection
     *  {
     *
     *      public function beforeSave()
     *      {
     *          if ($this->name == 'Peter') {
     *              message = new Message("Sorry, but a robot cannot be named Peter");
     *              $this->appendMessage(message);
     *          }
     *      }
     *  }
     *</code>
     */
    public function appendMessage(<MessageInterface> message)
    {
        let this->_errorMessages[] = message;
    }

    /**
     * Skips the current operation forcing a success state
     *
     * @param boolean skip
     */
    public function skipOperation(boolean skip)
    {
        let this->_skipped = skip;
    }

    /**
     * Returns NULL if the property is not set.
     * 
     * @param  mixed param
     * @return null
     */
    public function __get(var param)
    {
        return null;
    }
}
