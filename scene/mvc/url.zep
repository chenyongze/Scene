
/**
 * URL
 *
*/

namespace Scene\Mvc;

use Scene\Mvc\UrlInterface;
use Scene\Mvc\Url\Exception;
use Scene\Di\InjectionAwareInterface;
use Scene\DiInterface;

/**
 * Scene\Mvc\Url
 *
 * This components helps in the generation of: URIs, URLs and Paths
 *
 *<code>
 *
 * //Generate a URL appending the URI to the base URI
 * echo $url->get('products/edit/1');
 *
 *
 *</code>
 */
class Url implements UrlInterface, InjectionAwareInterface
{
    /**
     * Dependency Injector
     *
     * @var null|\Scene\DiInterface
     * @access protected
    */
    protected _dependencyInjector;

    /**
     * Base URI
     *
     * @var string|null
     * @access protected
    */
    protected _baseUri = null;

    /**
     * Static Base URI
     *
     * @var string|null
     * @access protected
    */
    protected _staticBaseUri = null;

    /**
     * Base Path
     *
     * @var string|null
     * @access protected
    */
    protected _basePath = null;

    /**
     * Sets the DependencyInjector container
     *
     * @param \Scene\DiInterface dependencyInjector
     */
    public function setDI(<DiInterface> dependencyInjector)
    {
        let this->_dependencyInjector = dependencyInjector;
    }

    /**
     * Returns the DependencyInjector container
     *
     * @return \Scene\DiInterface|null
     */
    public function getDI() -> <DiInterface>
    {
        return this->_dependencyInjector;
    }

    /**
     * Sets a prefix for all the URIs to be generated
     *
     *<code>
     *  $url->setBaseUri('/invo/');
     *  $url->setBaseUri('/invo/index.php/');
     *</code>
     *
     * @param string $baseUri
     * @return \Scene\Mvc\Url
     * @throws Exception
     */
    public function setBaseUri(string! baseUri) -> <Url>
    {
        let this->_baseUri = baseUri;
        if this->_staticBaseUri === null {
            let this->_staticBaseUri = baseUri;
        }
        return this;
    }

    /**
     * Sets a prefix for all static URLs generated
     *
     *<code>
     *  $url->setStaticBaseUri('/invo/');
     *</code>
     *
     * @param string $staticBaseUri
     * @return \Scene\Mvc\Url
     * @throws Exception
     */
    public function setStaticBaseUri(string! staticBaseUri) -> <Url>
    {
        let this->_staticBaseUri = staticBaseUri;
        return this;
    }

    /**
     * Returns the prefix for all the generated urls. By default /
     *
     * @return string
     */
    public function getBaseUri() -> string
    {
        var baseUri, phpSelf, uri;

        let baseUri = this->_baseUri;
        if baseUri === null {

            if fetch phpSelf, _SERVER["PHP_SELF"] {
                //let uri = Scene_get_uri(phpSelf);
                let uri = self::getUri(phpSelf);
            } else {
                let uri = null;
            }

            if !uri {
                let baseUri = "/";
            } else {
                let baseUri = "/" . uri ."/";
            }

            let this->_baseUri = baseUri;
        }
        return baseUri;
    }

    /**
     * Returns the prefix for all the generated static urls. By default /
     *
     * @return string
     */
    public function getStaticBaseUri() -> string
    {
        var staticBaseUri;
        let staticBaseUri = this->_staticBaseUri;
        if staticBaseUri !== null {
            return staticBaseUri;
        }
        return this->getBaseUri();
    }

    /**
     * Sets a base path for all the generated paths
     *
     *<code>
     *  $url->setBasePath('/var/www/htdocs/');
     *</code>
     *
     * @param string basePath
     * @return \Scene\Mvc\Url
     * @throws Exception
     */
    public function setBasePath(string! basePath) -> <Url>
    {
        let this->_basePath = basePath;
        return this;
    }

    /**
     * Returns the base path
     *
     * @return string|null
     */
    public function getBasePath() -> string
    {
        return this->_basePath;
    }

    /**
     * Get URI
     *
     * @param string path
    */
    public static function getUri(string path)
    {
        var found, mark;
        int cursor;
        char ch;

        if typeof path != "string" {
            return "";
        }

        let found = 0,
            mark = 0;

        if !empty path {
            let cursor = strlen(path);
            while cursor > 0 {
                let ch = path[cursor - 1];
                if ch == '/' || ch == '\\' {
                    let found++;

                    if found === 1 {
                        let mark = cursor - 1;
                    } else {
                        return substr(path, 1, mark - cursor);
                    }
                }
                let cursor--;
            }
        }

        return "";
    }

    /**
     * Generates a URL
     *
     *<code>
     *
     * //Generate a URL appending the URI to the base URI
     * echo $url->get('products/edit/1');
     *
     *</code>
     *
     * @param string|array|null uri
     * @param array|object|null args Optional arguments to be appended to the query string
     * @param boolean local
     * @return string
     */
    public function get(var uri = null, var args = null, var local = null, var baseUri = null) -> string
    {
        string strUri;
        var queryString;

        if local == null {
            if typeof uri == "string" && (memstr(uri, "//") || memstr(uri, ":")) {
                if preg_match("#^(//)|([a-z0-9]+://)|([a-z0-9]+:)#i", uri) {
                    let local = false;
                } else {
                    let local = true;
                }
            } else {
                let local = true;
            }
        }

        if typeof baseUri != "string" {
            let baseUri = this->getBaseUri();
        }

        if typeof uri == "array" {
            throw new Exception("Invalid parameter type.");
        }

        if local {
            let strUri = (string) uri;
            if baseUri == "/" && strlen(strUri) > 2 && strUri[0] == '/' && strUri[1] != '/' {
                let uri = baseUri . substr(strUri, 1);
            } else {
                if baseUri == "/" && strlen(strUri) == 1 && strUri[0] == '/' {
                    let uri = baseUri;
                } else {
                    let uri = baseUri . strUri;
                }
            }
        }

        if args {
            let queryString = http_build_query(args);
            if typeof queryString == "string" && strlen(queryString) {
                if strpos(uri, "?") !== false {
                    let uri .= "&" . queryString;
                } else {
                    let uri .= "?" . queryString;
                }
            }
        }

        return uri;
    }

    /**
     * Generates a URL for a static resource
     *
     * <code>
     * // Generate a URL for a static resource
     * echo $url->getStatic("img/logo.png");
     *
     * </code>
     *
     * @param string|null uri
     * @return string
     */
    public function getStatic(var uri = null) -> string
    {
        return this->get(uri, null, null, this->getStaticBaseUri());
    }

    /**
     * Generates a local path
     *
     * @param string|null path
     * @return string
     */
    public function path(string path = null) -> string
    {
        return this->_basePath . path;
    }
}
