
/**
 * View Interface
 *
*/

namespace Scene\Mvc;

/**
 * Scene\Mvc\ViewInterface
 *
 * Interface for Scene\Mvc\View
 */
interface ViewInterface extends ViewBaseInterface
{
    /**
     * Sets the layouts sub-directory. Must be a directory under the views directory. Depending of your platform, always add a trailing slash or backslash
     *
     * @param string layoutsDir
     */
    public function setLayoutsDir(string! layoutsDir);

    /**
     * Gets the current layouts sub-directory
     *
     * @return string
     */
    public function getLayoutsDir() -> string;

    /**
     * Sets a partials sub-directory. Must be a directory under the views directory. Depending of your platform, always add a trailing slash or backslash
     *
     * @param string partialsDir
     */
    public function setPartialsDir(string! partialsDir);

    /**
     * Gets the current partials sub-directory
     *
     * @return string
     */
    public function getPartialsDir() -> string;

    /**
     * Sets base path. Depending of your platform, always add a trailing slash or backslash
     *
     * @param string basePath
     */
    public function setBasePath(string! basePath);

    /**
     * Gets base path
     *
     * @return string
     */
    public function getBasePath() -> string;

    /**
     * Sets the render level for the view
     *
     * @param string level
     */
    public function setRenderLevel(string! level);

    /**
     * Sets default view name. Must be a file without extension in the views directory
     *
     * @param string viewPath
     */
    public function setMainView(string! viewPath);

    /**
     * Returns the name of the main view
     *
     * @return string
     */
    public function getMainView() -> string;

    /**
     * Change the layout to be used instead of using the name of the latest controller name
     *
     * @param string layout
     */
    public function setLayout(string! layout);

    /**
     * Returns the name of the main view
     *
     * @return string
     */
    public function getLayout() -> string;

    /**
     * Appends template before controller layout
     *
     * @param string|array templateBefore
     */
    public function setTemplateBefore(templateBefore);

    /**
     * Resets any template before layouts
     */
    public function cleanTemplateBefore();

    /**
     * Appends template after controller layout
     *
     * @param string|array templateAfter
     */
    public function setTemplateAfter(templateAfter);

    /**
     * Resets any template before layouts
     */
    public function cleanTemplateAfter();

    /**
     * Gets the name of the controller rendered
     *
     * @return string
     */
    public function getControllerName() -> string;

    /**
     * Gets the name of the action rendered
     *
     * @return string
     */
    public function getActionName() -> string;

    /**
     * Gets extra parameters of the action rendered
     *
     * @return string
     */
    public function getParams() -> array;

    /**
     * Starts rendering process enabling the output buffering
     */
    public function start();

    /**
     * Register templating engines
     *
     * @param array engines
     */
    public function registerEngines(array! engines);

    /**
     * Executes render process from dispatching data
     *
     * @param string controllerName
     * @param string actionName
     * @param array|null params
     */
    public function render(string! controllerName, string! actionName, params = null);

    /**
     * Choose a view different to render than last-controller/last-action
     *
     * @param string renderView
     */
    public function pick(string! renderView);

    /**
     * Finishes the render process by stopping the output buffering
     */
    public function finish();

    /**
     * Returns the path of the view that is currently rendered
     *
     * @return string
     */
    public function getActiveRenderPath() -> string;

    /**
     * Disables the auto-rendering process
     */
    public function disable();

    /**
     * Enables the auto-rendering process
     */
    public function enable();

    /**
     * Resets the view component to its factory default values
     */
    public function reset();

    /**
     * Whether the automatic rendering is disabled
     *
     * @return boolean
     */
    public function isDisabled() -> boolean;
}
