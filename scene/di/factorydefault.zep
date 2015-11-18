
/**
 * Factory Default
 *
*/

namespace Scene\Di;

/**
 * Scene\Di\FactoryDefault
 *
 * This is a variant of the standard Scene\Di. By default it automatically
 * registers all the services provided by the framework. Thanks to this, the developer does not need
 * to register each service individually providing a full stack framework
 */
class FactoryDefault extends \Scene\Di
{

    /**
     * Scene\Di\FactoryDefault constructor
     */
    public function __construct()
    {
        parent::__construct();

        let this->_services = [
            "router":             new Service("router", "Scene\\Mvc\\Router", true),
            "dispatcher":         new Service("dispatcher", "Scene\\Mvc\\Dispatcher", true),
            "url":                new Service("url", "Scene\\Mvc\\Url", true),
            //"modelsManager":      new Service("modelsManager", "Scene\\Mvc\\Model\\Manager", true),
            //"modelsMetadata":     new Service("modelsMetadata", "Scene\\Mvc\\Model\\MetaData\\Memory", true),
            "response":           new Service("response", "Scene\\Http\\Response", true),
            "cookies":            new Service("cookies", "Scene\\Http\\Response\\Cookies", true),
            "request":            new Service("request", "Scene\\Http\\Request", true),
            "filter":             new Service("filter", "Scene\\Filter", true),
            "escaper":            new Service("escaper", "Scene\\Escaper", true),
            "security":           new Service("security", "Scene\\Security", true),
            "crypt":              new Service("crypt", "Scene\\Crypt", true),
            //"annotations":        new Service("annotations", "Scene\\Annotations\\Adapter\\Memory", true),
            //"flash":              new Service("flash", "Scene\\Flash\\Direct", true),
            //"flashSession":       new Service("flashSession", "Scene\\Flash\\Session", true),
            "tag":                new Service("tag", "Scene\\Tag", true),
            "session":            new Service("session", "Scene\\Session\\Adapter\\Files", true),
            "sessionBag":         new Service("sessionBag", "Scene\\Session\\Bag"),
            "eventsManager":      new Service("eventsManager", "Scene\\Events\\Manager", true)
            //"transactionManager": new Service("transactionManager", "Scene\\Mvc\\Model\\Transaction\\Manager", true),
            //"assets":             new Service("assets", "Scene\\Assets\\Manager", true)
        ];
    }
}
