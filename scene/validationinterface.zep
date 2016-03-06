
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

use Scene\Validation\MessageInterface;
use Scene\Validation\Message\Group;
use Scene\Validation\ValidatorInterface;

/**
 * Scene\ValidationInterface
 *
 * Interface for the Scene\Validation component
 */
interface ValidationInterface
{
    /**
     * Validate a set of data according to a set of rules
     *
     * @param array|object data
     * @param object entity
     * @return \Phalcon\Validation\Message\Group
     */
    public function validate(var data = null, var entity = null) -> <Group>;

    /**
     * Adds a validator to a field
     *
     * @param string field
     * @param \Scene\Validation\ValidatorInterface
     * @return \Scene\ValidationInterface
     */
    public function add(string field, <ValidatorInterface> validator) -> <ValidationInterface>;

    /**
     * Alias of `add` method
     *
     * @param string field
     * @param \Scene\Validation\ValidatorInterface
     * @return \Scene\ValidationInterface
     */
    public function rule(string field, <ValidatorInterface> validator) -> <ValidationInterface>;

    /**
     * Adds the validators to a field
     */
    public function rules(string! field, array! validators) -> <ValidationInterface>;

    /**
     * Adds filters to the field
     *
     * @param string field
     * @param array|string filters
     * @return \Scene\ValidationInterface
     */
    public function setFilters(string field, filters) -> <ValidationInterface>;

    /**
     * Returns all the filters or a specific one
     *
     * @param string|null field
     * @return mixed
     */
    public function getFilters(string field = null);

    /**
     * Returns the validators added to the validation
     *
     * @return array
     */
    public function getValidators() -> <array>;

    /**
     * Returns the bound entity
     *
     * @return object
     */
    public function getEntity();

    /**
     * Adds default messages to validators
     *
     * @param array messages
     * @return array
     */
    public function setDefaultMessages(array messages = []) -> <array>;

    /**
     * Get default message for validator type
     *
     * @param string type
     * @return string
     */
    public function getDefaultMessage(string! type);

    /**
     * Returns the registered validators
     *
     * @return \Scene\Validation\Message\Group
     */
    public function getMessages() -> <Group>;

    /**
     * Adds labels for fields
     *
     * @param array labels
     */
    public function setLabels(array! labels);

    /**
     * Get label for field
     *
     * @param string field
     * @return string
     */
    public function getLabel(string! field);

   /**
     * Appends a message to the messages list
     *
     * @param \Scene\Validation\MessageInterface message
     * @return \Scene\ValidationInterface
     */
    public function appendMessage(<MessageInterface> message) -> <ValidationInterface>;

    /**
     * Assigns the data to an entity
     * The entity is used to obtain the validation values
     *
     * @param object entity
     * @param array|object data
     * @return \Scene\ValidationInterface
     */
    public function bind(entity, data) -> <ValidationInterface>;

    /**
     * Gets the a value to validate in the array/object data source
     *
     * @param string field
     * @return mixed
     */
    public function getValue(string field);
}
