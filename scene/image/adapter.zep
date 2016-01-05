
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

namespace Scene\Image;

use Scene\Image;

/**
 * Scene\Image\Adapter
 *
 * All image adapters must use this class
 */
abstract class Adapter
{

    protected _image { get };

    protected _file;

    protected _realpath { get };

    /**
     * Image width
     *
     * @var int
     */
    protected _width { get };

    /**
     * Image height
     *
     * @var int
     */
    protected _height { get };

    /**
     * Image type
     *
     * Driver dependent
     *
     * @var int
     */
    protected _type { get };

    /**
     * Image mime type
     *
     * @var string
     */
    protected _mime { get };

    protected static _checked = false;

    /**
     * Resize the image to the given size
     * 
     * @param int width
     * @param int height
     * @param int master
     * @return \Scene\Image\Adapter
     */
    public function resize(int width = null, int height = null, int master = Image::AUTO) -> <Adapter>
    {
        var ratio;

        if master == Image::TENSILE {

            if !width || !height {
                throw new Exception("width and height must be specified");
            }

        } else {

            if master == Image::AUTO {

                if !width || !height {
                    throw new Exception("width and height must be specified");
                }

                let master = (this->_width / width) > (this->_height / height) ? Image::WIDTH : Image::HEIGHT;
            }

            if master == Image::INVERSE {

                if !width || !height {
                    throw new Exception("width and height must be specified");
                }

                let master = (this->_width / width) > (this->_height / height) ? Image::HEIGHT : Image::WIDTH;
            }

            switch master {

                case Image::WIDTH:
                    if !width {
                        throw new Exception("width must be specified");
                    }
                    
                    let height = this->_height * width / this->_width;
                    break;

                case Image::HEIGHT:
                    if !height {
                        throw new Exception("height must be specified");
                    }
                    
                    let width = this->_width * height / this->_height;
                    break;

                case Image::PRECISE:
                    if !width || !height {
                        throw new Exception("width and height must be specified");
                    }
                    let ratio = this->_width / this->_height;

                    if (width / height) > ratio {
                        let height = this->_height * width / this->_width;
                    } else {
                        let width = this->_width * height / this->_height;
                    }
                    break;

                case Image::NONE:
                    if !width {
                        let width = (int) this->_width;
                    }

                    if !height {
                        let width = (int) this->_height;
                    }
                    break;
            }
        }

        let width  = (int) max(round(width), 1);
        let height = (int) max(round(height), 1);

        this->{"_resize"}(width, height);

        return this;
    }

    /**
     * This method scales the images using liquid rescaling method. Only support Imagick
     *
     * @param int width   new width
     * @param int height  new height
     * @param int deltaX How much the seam can traverse on x-axis. Passing 0 causes the seams to be straight.
     * @param int rigidity Introduces a bias for non-straight seams. This parameter is typically 0.
     * @return \Scene\Image\Adapter
     */
    public function liquidRescale(int width, int height, int deltaX = 0, int rigidity = 0) -> <Adapter>
    {
        this->{"_liquidRescale"}(width, height, deltaX, rigidity);
        return this;
    }

    /**
     * Crop an image to the given size
     *
     * @param int width
     * @param int height
     * @param int offsetX
     * @param int offsetY
     * @return \Scene\Image\Adapter
     */
    public function crop(int width, int height, int offsetX = null, int offsetY = null) -> <Adapter>
    {
        if is_null(offsetX) {
            let offsetX = ((this->_width - width) / 2);
        } else {
            if offsetX < 0 {
                let offsetX = this->_width - width + offsetX;
            }

            if offsetX > this->_width {
                let offsetX = (int) this->_width;
            }
        }

        if is_null(offsetY) {
            let offsetY = ((this->_height - height) / 2);
        } else {
            if offsetY < 0 {
                let offsetY = this->_height - height + offsetY;
            }

            if offsetY > this->_height {
                let offsetY = (int) this->_height;
            }
        }

        if width > (this->_width - offsetX) {
            let width = this->_width - offsetX;
        }

        if height > (this->_height - offsetY) {
            let height = this->_height - offsetY;
        }

        this->{"_crop"}(width, height, offsetX, offsetY);

        return this;
    }

    /**
     * Rotate the image by a given amount
     *
     * @param int degress
     * @return \Scene\Image\Adapter
     */
    public function rotate(int degrees) -> <Adapter>
    {
        if degrees > 180 {
            let degrees %= 360;
            if degrees > 180 {
                let degrees -= 360;
            }
        } else {
            while degrees < -180 {
                let degrees += 360;
            }
        }

        this->{"_rotate"}(degrees);
        return this;
    }

    /**
     * Flip the image along the horizontal or vertical axis
     *
     * @param int direction
     * @return \Scene\Image\Adapter
     */
    public function flip(int direction) -> <Adapter>
    {
        if direction != Image::HORIZONTAL && direction != Image::VERTICAL {
            let direction = Image::HORIZONTAL;
        }

        this->{"_flip"}(direction);
        return this;
    }

    /**
     * Sharpen the image by a given amount
     *
     * @param int amount
     * @return \Scene\Image\Adapter
     */
    public function sharpen(int amount) -> <Adapter>
    {
        if amount > 100 {
            let amount = 100;
        } elseif amount < 1 {
            let amount = 1;
        }

        this->{"_sharpen"}(amount);
        return this;
    }

    /**
     * Add a reflection to an image
     *
     * @param int height
     * @param int opacity
     * @param boolean fadeIn
     * @return \Scene\Image\Adapter
     */
    public function reflection(int height, int opacity = 100, boolean fadeIn = false) -> <Adapter>
    {
        if height <= 0 || height > this->_height {
            let height = (int) this->_height;
        }

        if opacity < 0 {
            let opacity = 0;
        } elseif opacity > 100 {
            let opacity = 100;
        }

        this->{"_reflection"}(height, opacity, fadeIn);

        return this;
    }

    /**
     * Add a watermark to an image with the specified opacity
     *
     * @param \Scene\Image\Adapter watermark
     * @param int offsetX
     * @param int offsetY
     * @param int opacity
     * @return \Scene\Image\Adapter
     */
    public function watermark(<Adapter> watermark, int offsetX = 0, int offsetY = 0, int opacity = 100) -> <Adapter>
    {
        int tmp;

        let tmp = this->_width - watermark->getWidth();

        if offsetX < 0 {
            let offsetX = 0;
        } elseif offsetX > tmp {
            let offsetX = tmp;
        }

        let tmp = this->_height - watermark->getHeight();

        if offsetY < 0 {
            let offsetY = 0;
        } elseif offsetY > tmp {
            let offsetY = tmp;
        }

        if opacity < 0 {
            let opacity = 0;
        } elseif opacity > 100 {
            let opacity = 100;
        }

        this->{"_watermark"}(watermark, offsetX, offsetY, opacity);

        return this;
    }

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
    public function text(string text, var offsetX = false, var offsetY = false, int opacity = 100, string color = "000000", int size = 12, string fontfile = null) -> <Adapter>
    {
        var colors;

        if opacity < 0 {
            let opacity = 0;
        } else {
            if opacity > 100 {
                let opacity = 100;
            }
        }

        if strlen(color) > 1 && substr(color, 0, 1) === "#" {
            let color = substr(color, 1);
        }

        if strlen(color) === 3 {
            let color = preg_replace("/./", "$0$0", color);
        }

        let colors = array_map("hexdec", str_split(color, 2));

        this->{"_text"}(text, offsetX, offsetY, opacity, colors[0], colors[1], colors[2], size, fontfile);

        return this;
    }

    /**
     * Composite one image onto another
     *
     * @param \Scene\Image\Adapter watermark
     * @return \Scene\Image\Adapter
     */
    public function mask(<Adapter> watermark) -> <Adapter>
    {
        this->{"_mask"}(watermark);
        return this;
    }

    /**
     * Set the background color of an image
     *
     * @param string color
     * @param int opacity
     * @return \Scene\Image\Adapter
     */
    public function background(string color, int opacity = 100) -> <Adapter>
    {
        var colors;

        if strlen(color) > 1 && substr(color, 0, 1) === "#" {
            let color = substr(color, 1);
        }

        if strlen(color) === 3 {
            let color = preg_replace("/./", "$0$0", color);
        }

        let colors = array_map("hexdec", str_split(color, 2));

        this->{"_background"}(colors[0], colors[1], colors[2], opacity);
        return this;
    }

    /**
     * Blur image
     *
     * @param int radius
     * @return \Scene\Image\Adapter
     */
    public function blur(int radius) -> <Adapter>
    {
        if radius < 1 {
            let radius = 1;
        } elseif radius > 100 {
            let radius = 100;
        }

        this->{"_blur"}(radius);
        return this;
    }

    /**
     * Pixelate image
     *
     * @param int amount
     * @return \Scene\Image\Adapter
     */
    public function pixelate(int amount) -> <Adapter>
    {
        if amount < 2 {
            let amount = 2;
        }

        this->{"_pixelate"}(amount);
        return this;
    }

    /**
     * Save the image
     *
     * @param string file
     * @param int quality
     * @return \Scene\Image\Adapter
     */
    public function save(string file = null, int quality = 100) -> <Adapter>
    {
        if !file {
            let file = (string) this->_realpath;
        }

        if quality < 1 {
            let quality = 1;
        } elseif quality > 100 {
            let quality = 100;
        }

        this->{"_save"}(file, quality);
        return this;
    }

    /**
     * Render the image and return the binary string
     *
     * @param string ext
     * @param int quality
     * @return string
     */
    public function render(string ext = null, int quality = 100) -> string
    {
        if !ext {
            let ext = (string) pathinfo(this->_file, PATHINFO_EXTENSION);
        }

        if empty ext {
            let ext = "png";
        }

        if quality < 1 {
            let quality = 1;
        } elseif quality > 100 {
            let quality = 100;
        }

        return this->{"_render"}(ext, quality);
    }
}
