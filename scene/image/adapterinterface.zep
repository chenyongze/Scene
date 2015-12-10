
/**
 * Image Adapterinterface
 */

namespace Scene\Image;

interface AdapterInterface
{

    /**
     * Resize the image to the given size
     * 
     * @param int width
     * @param int height
     * @param int master
     * @return \Scene\Image\Adapter
     */
    public function resize(int width = null, int height = null, int master = \Scene\Image::AUTO);
    
    /**
     * Crop an image to the given size
     *
     * @param int width
     * @param int height
     * @param int offsetX
     * @param int offsetY
     * @return \Scene\Image\Adapter
     */
    public function crop(int width, int height, int offsetX = null, int offsetY = null);
    
    /**
     * Rotate the image by a given amount
     *
     * @param int degress
     * @return \Scene\Image\Adapter
     */
    public function rotate(int degrees);
    
    /**
     * Flip the image along the horizontal or vertical axis
     *
     * @param int direction
     * @return \Scene\Image\Adapter
     */
    public function flip(int direction);
    
    /**
     * Sharpen the image by a given amount
     *
     * @param int amount
     * @return \Scene\Image\Adapter
     */
    public function sharpen(int amount);
    
    /**
     * Add a reflection to an image
     *
     * @param int height
     * @param int opacity
     * @param boolean fadeIn
     * @return \Scene\Image\Adapter
     */
    public function reflection(int height, int opacity = 100, boolean fadeIn = false);
    
    /**
     * Add a watermark to an image with the specified opacity
     *
     * @param \Scene\Image\Adapter watermark
     * @param int offsetX
     * @param int offsetY
     * @param int opacity
     * @return \Scene\Image\Adapter
     */
    public function watermark(<\Scene\Image\Adapter> watermark, int offsetX = 0, int offsetY = 0, int opacity = 100);
    
    /**
     * Add a text to an image with a specified opacity
     *
     * @param string text
     * @param maxed offetX
     * @param maxed offsetY
     * @param int opacity
     * @param string color
     * @param int size
     * @param string fontfile
     * @return \Scene\Image\Adapter
     */
    public function text(string text, int offsetX = 0, int offsetY = 0, int opacity = 100, string color = "000000", int size = 12, string fontfile = null);
    
    /**
     * Composite one image onto another
     *
     * @param \Scene\Image\Adapter watermark
     * @return \Scene\Image\Adapter
     */
    public function mask(<\Scene\Image\Adapter> watermark);
    
    /**
     * Set the background color of an image
     *
     * @param string color
     * @param int opacity
     * @return \Scene\Image\Adapter
     */
    public function background(string color, int opacity = 100);
    
    /**
     * Blur image
     *
     * @param int radius
     * @return \Scene\Image\Adapter
     */
    public function blur(int radius);
    
    /**
     * Pixelate image
     *
     * @param int amount
     * @return \Scene\Image\Adapter
     */
    public function pixelate(int amount);

    /**
     * Save the image
     *
     * @param string file
     * @param int quality
     * @return \Scene\Image\Adapter
     */
    public function save(string file = null, int quality = 100);
    
    /**
     * Render the image and return the binary string
     *
     * @param string ext
     * @param int quality
     * @return string
     */
    public function render(string ext = null, int quality = 100);
}