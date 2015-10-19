
/**
 * Config
 *
 */

namespace Scene;

use Scene\Config\Exception;

/**
 * Scene\Config
 *
 * Scene\Config is designed to simplify the access to, and the use of, configuration data within applications.
 * It provides a nested object property based user interface for accessing this configuration data within
 * application code.
 *
 *<code>
 *  $config = new \Scene\Config(array(
 *      "database" => array(
 *          "adapter" => "Mysql",
 *          "host" => "localhost",
 *          "username" => "scott",
 *          "password" => "cheetah",
 *          "dbname" => "test_db"
 *      ),
 *      "Scene" => array(
 *          "controllersDir" => "../app/controllers/",
 *          "modelsDir" => "../app/models/",
 *          "viewsDir" => "../app/views/"
 *      )
 * ));
 *</code>
 *
 */
class Config implements \ArrayAccess, \Countable
{

    /**
     * Scene\Config constructor
     *
     * @param array arrayConfig
     */
    public function __construct(array! arrayConfig = null)
    {
        var key, value;

        for key, value in arrayConfig {
            this->offsetSet(key, value);
        }
    }

    /**
     * Allows to check whether an attribute is defined using the array-syntax
     *
     *<code>
     * var_dump(isset($config['database']));
     *</code>
     *
     * @param mixed index
     * @return boolean
     */
    public function offsetExists(var index) -> boolean
    {
        let index = strval(index);

        return isset this->{index};
    }

    /**
     * Gets an attribute from the configuration, if the attribute isn't defined returns null
     * If the value is exactly null or is not defined the default value will be used instead
     *
     *<code>
     * echo $config->get('controllersDir', '../app/controllers/');
     *</code>
     *
     * @param mixed index
     * @param mixed defaultValue
     * @return mixed
     */
    public function get(var index, var defaultValue = null)
    {
        let index = strval(index);

        if isset this->{index} {
            return this->{index};
        }

        return defaultValue;
    }

    /**
     * Gets an attribute using the array-syntax
     *
     *<code>
     * print_r($config['database']);
     *</code>
     *
     * @param mixed index
     * @return string
     */
    public function offsetGet(var index) -> string
    {
        let index = strval(index);

        return this->{index};
    }

    /**
     * Sets an attribute using the array-syntax
     *
     *<code>
     * $config['database'] = array('type' => 'Sqlite');
     *</code>
     *
     * @param mixed index
     * @param mixed value
     */
    public function offsetSet(var index, var value)
    {
        let index = strval(index);

        if typeof value === "array" {
            let this->{index} = new self(value);
        } else {
            let this->{index} = value;
        }
    }

    /**
     * Unsets an attribute using the array-syntax
     *
     *<code>
     * unset($config['database']);
     *</code>
     *
     * @param mixed index
     */
    public function offsetUnset(var index)
    {
        let index = strval(index);

        //unset(this->{index});
        let this->{index} = null;
    }

    /**
     * Merges a configuration into the current one
     *
     *<code>
     * $appConfig = new \Scene\Config(array('database' => array('host' => 'localhost')));
     * $globalConfig->merge($config2);
     *</code>
     */
    public function merge(<Config> config) -> <Config>
    {
        return this->_merge(config);
    }

    /**
     * Converts recursively the object to an array
     *
     *<code>
     *  print_r($config->toArray());
     *</code>
     *
     * @return array
     */
    public function toArray() -> array
    {
        var key, value, arrayConfig;

        let arrayConfig = [];
        for key, value in get_object_vars(this) {
            if typeof value === "object" {
                if method_exists(value, "toArray") {
                    let arrayConfig[key] = value->toArray();
                } else {
                    let arrayConfig[key] = value;
                }
            } else {
                let arrayConfig[key] = value;
            }
        }
        return arrayConfig;
    }

    /**
     * Returns the count of properties set in the config
     *
     *<code>
     * print count($config);
     *</code>
     *
     * or
     *
     *<code>
     * print $config->count();
     *</code>
     *
     * @return int
     */
    public function count() -> int
    {
        return count(get_object_vars(this));
    }

    /**
     * Restores the state of a Scene\Config object
     *
     * @param array data
     * @return \Scene\Config
     */
    public static function __set_state(array! data) -> <Config>
    {
        return new self(data);
    }

    /**
     * Helper method for merge configs (forwarding nested config instance)
     *
     * @param Config config
     * @param Config instance
     * @return Config merged config
     */
    protected final function _merge(<Config> config, var instance = null) -> <Config>
    {
        var key, value, number, localObject;

        if typeof instance !== "object" {
            let instance = this;
        }

        let number = instance->count();

        for key, value in get_object_vars(config) {

            if fetch localObject, instance->{key} {
                if typeof localObject === "object" && typeof value === "object" {
                    if localObject instanceof Config && value instanceof Config {
                        this->_merge(value, localObject);
                        continue;
                    }
                }
            }

            if typeof key == "integer" {
                let key = strval(number),
                    number++;
            }
            let instance->{key} = value;
        }

        return instance;
    }
}
