
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

namespace Scene\Image\Adapter;

use Scene\Image\Adapter;
use Scene\Image\Exception;
use Scene\Image\AdapterInterface;

/**
 * Scene\Image\Adapter\Imagick
 *
 * Image manipulation support. Allows images to be resized, cropped, etc.
 *
 *<code>
 * $image = new Scene\Image\Adapter\Imagick("upload/test.jpg");
 * $image->resize(200, 200)->rotate(90)->crop(100, 100);
 * if ($image->save()) {
 *     echo 'success';
 * }
 *</code>
 */
class Imagick extends Adapter implements AdapterInterface
{
    protected static _version = 0;
    protected static _checked = false;

    /**
     * Checks if Imagick is enabled
     *
     * @return boolean
     */
    public static function check() -> boolean
    {
        if self::_checked {
            return true;
        }

        if !class_exists("imagick") {
            throw new Exception("Imagick is not installed, or the extension is not loaded");
        }

        if defined("Imagick::IMAGICK_EXTNUM") {
            let self::_version = constant("Imagick::IMAGICK_EXTNUM");
        }

        let self::_checked = true;

        return self::_checked;
    }

    /**
     * \Scene\Image\Adapter\Imagick constructor
     * 
     * @param string $file
     * @param int $width
     * @param int $height
     */
    public function __construct(string! file, int width = null, int height = null)
    {
        var image;

        if !self::_checked {
            self::check();
        }

        let this->_file = file;

        let this->_image = new \Imagick();

        if file_exists(this->_file) {
            let this->_realpath = realpath(this->_file);

            if !this->_image->readImage(this->_realpath) {
                throw new Exception("Imagick::readImage ".this->_file." failed");
            }

            if !this->_image->getImageAlphaChannel() {
                this->_image->setImageAlphaChannel(constant("Imagick::ALPHACHANNEL_SET"));
            }

            if this->_type == 1 {
                let image = this->_image->coalesceImages();
                this->_image->clear();
                this->_image->destroy();

                let this->_image = image;
            }
        } else {
            if !width || !height {
                throw new Exception("Failed to create image from file " . this->_file);
            }

            this->_image->newImage(width, height, new \ImagickPixel("transparent"));
            this->_image->setFormat("png");
            this->_image->setImageFormat("png");

            let this->_realpath = this->_file;
        }

        let this->_width = this->_image->getImageWidth();
        let this->_height = this->_image->getImageHeight();
        let this->_type = this->_image->getImageType();
        let this->_mime = "image/" . this->_image->getImageFormat();
    }

    /**
     * Execute a resize.
     * 
     * @param  int width
     * @param  int height
     */
    protected function _resize(int width, int height)
    {
        var image;
        let image = this->_image;

        image->setIteratorIndex(0);

        loop {
            image->scaleImage(width, height);
            if image->nextImage() === false {
                break;
            }
        }

        let this->_width = image->getImageWidth();
        let this->_height = image->getImageHeight();
    }

    /**
     * This method scales the images using liquid rescaling method. Only support Imagick
     *
     * @param int width   new width
     * @param int height  new height
     * @param int deltaX How much the seam can traverse on x-axis. Passing 0 causes the seams to be straight.
     * @param int rigidity Introduces a bias for non-straight seams. This parameter is typically 0.
     */
    protected function _liquidRescale(int width, int height, int deltaX, int rigidity)
    {
        var ret, image;
        let image = this->_image;

        image->setIteratorIndex(0);

        loop {
            let ret = image->liquidRescaleImage(width, height, deltaX, rigidity);
            if ret !== true {
                throw new Exception("Imagick::liquidRescale failed");
            }

            if image->nextImage() === false {
                break;
            }
        }

        let this->_width = image->getImageWidth();
        let this->_height = image->getImageHeight();
    }

    /**
     * Crop an image to the given size
     *
     * @param int width
     * @param int height
     * @param int offsetX
     * @param int offsetY
     */
    protected function _crop(int width, int height, int offsetX, int offsetY)
    {
        var image;
        let image = this->_image;

        image->setIteratorIndex(0);

        loop {

            image->cropImage(width, height, offsetX, offsetY);
            image->setImagePage(width, height, 0, 0);

            if !image->nextImage() {
                break;
            }
        }

        let this->_width  = image->getImageWidth();
        let this->_height = image->getImageHeight();
    }

    /**
     * Rotate the image by a given amount
     *
     * @param int degress
     */
    protected function _rotate(int degrees)
    {
        var pixel;

        this->_image->setIteratorIndex(0);

        let pixel = new \ImagickPixel();

        loop {
            this->_image->rotateImage(pixel, degrees);
            this->_image->setImagePage(this->_width, this->_height, 0, 0);
            if this->_image->nextImage() === false {
                break;
            }
        }

        let this->_width = this->_image->getImageWidth();
        let this->_height = this->_image->getImageHeight();
    }

    /**
     * Flip the image along the horizontal or vertical axis
     *
     * @param int direction
     */
    protected function _flip(int direction)
    {
        var func;

        let func = "flipImage";
        if direction == \Scene\Image::HORIZONTAL {
           let func = "flopImage";
        }

        this->_image->setIteratorIndex(0);

        loop {
            this->_image->{func}();
            if this->_image->nextImage() === false {
                break;
            }
        }
    }

    /**
     * Sharpen the image by a given amount
     *
     * @param int amount
     */
    protected function _sharpen(int amount)
    {
        let amount = (amount < 5) ? 5 : amount;
        let amount = (amount * 3.0) / 100;

        this->_image->setIteratorIndex(0);

        loop {
            this->_image->sharpenImage(0, amount);
            if this->_image->nextImage() === false {
                break;
            }
        }
    }

    /**
     * Add a reflection to an image
     *
     * @param int height
     * @param int opacity
     * @param boolean fadeIn
     */
    protected function _reflection(int height, int opacity, boolean fadeIn)
    {
        var reflection, fade, pseudo, image, pixel, ret;

        let reflection = clone this->_image;

        reflection->setIteratorIndex(0);

        loop {
            reflection->flipImage();
            reflection->cropImage(reflection->getImageWidth(), height, 0, 0);
            reflection->setImagePage(reflection->getImageWidth(), height, 0, 0);
            if reflection->nextImage() === false {
                break;
            }
        }

        let pseudo = fadeIn ? "gradient:black-transparent" : "gradient:transparent-black",
            fade = new \Imagick();

        fade->newPseudoImage(reflection->getImageWidth(), reflection->getImageHeight(), pseudo);

        let opacity /= 100;

        reflection->setIteratorIndex(0);

        loop {
            let ret = reflection->compositeImage(fade, constant("Imagick::COMPOSITE_DSTOUT"), 0, 0);
            if ret !== true {
                throw new Exception("Imagick::compositeImage failed");
            }

            reflection->evaluateImage(constant("Imagick::EVALUATE_MULTIPLY"), opacity, constant("Imagick::CHANNEL_ALPHA"));
            if reflection->nextImage() === false {
                break;
            }
        }

        fade->destroy();

        let image = new \Imagick(),
            pixel = new \ImagickPixel(),
            height = this->_image->getImageHeight() + height;

        this->_image->setIteratorIndex(0);

        loop {
            image->newImage(this->_width, height, pixel);
            image->setImageAlphaChannel(constant("Imagick::ALPHACHANNEL_SET"));
            image->setColorspace(this->_image->getColorspace());
            image->setImageDelay(this->_image->getImageDelay());
            let ret = image->compositeImage(this->_image, constant("Imagick::COMPOSITE_SRC"), 0, 0);

            if ret !== true {
                throw new Exception("Imagick::compositeImage failed");
            }

            if this->_image->nextImage() === false {
                break;
            }
        }

        image->setIteratorIndex(0);
        reflection->setIteratorIndex(0);

        loop {
            let ret = image->compositeImage(reflection, constant("Imagick::COMPOSITE_OVER"), 0, this->_height);

            if ret !== true {
                throw new Exception("Imagick::compositeImage failed");
            }

            if image->nextImage() === false || reflection->nextImage() === false {
                break;
            }
        }

        reflection->destroy();

        this->_image->clear();
        this->_image->destroy();

        let this->_image = image;
        let this->_width = this->_image->getImageWidth();
        let this->_height = this->_image->getImageHeight();
    }

    /**
     * Add a watermark to an image with the specified opacity
     *
     * @param \Scene\Image\Adapter image
     * @param int offsetX
     * @param int offsetY
     * @param int opacity
     */
    protected function _watermark(<Adapter> image, int offsetX, int offsetY, int opacity)
    {
        var watermark, ret;

        let opacity = opacity / 100,
            watermark = new \Imagick();

        watermark->readImageBlob(image->render());
        watermark->setImageOpacity(opacity);

        this->_image->setIteratorIndex(0);

        loop {
            let ret = this->_image->compositeImage(watermark, constant("Imagick::COMPOSITE_OVER"), offsetX, offsetY);

            if ret !== true {
                throw new Exception("Imagick::compositeImage failed");
            }

            if this->_image->nextImage() === false {
                break;
            }
        }

        watermark->clear();
        watermark->destroy();
    }

    /**
     * Add a text to an image with a specified opacity
     *
     * @param string text
     * @param maxed offetX
     * @param maxed offsetY
     * @param int opacity
     * @param int r
     * @param int g
     * @param int b
     * @param int size
     * @param string fontfile
     */
    protected function _text(string text, var offsetX, var offsetY, int opacity, int r, int g, int b, int size, string fontfile)
    {
        var x, y, draw, color, gravity;

        let opacity = opacity / 100,
            draw = new \ImagickDraw(),
            color = sprintf("rgb(%d, %d, %d)", r, g, b);

        draw->setFillColor(new \ImagickPixel(color));

        if fontfile {
            draw->setFont(fontfile);
        }

        if size {
            draw->setFontSize(size);
        }

        if opacity {
            draw->setfillopacity(opacity);
        }

        let gravity = null;

        if typeof offsetX == "bool" {
            if typeof offsetY == "bool" {
                if offsetX && offsetY {
                    let gravity = constant("Imagick::GRAVITY_SOUTHEAST");
                } else {
                    if offsetX {
                        let gravity = constant("Imagick::GRAVITY_EAST");
                    } else {
                        if offsetY {
                            let gravity = constant("Imagick::GRAVITY_SOUTH");
                        } else {
                            let gravity = constant("Imagick::GRAVITY_CENTER");
                        }
                    }
                }
            } else {
                if typeof offsetY == "int" {
                    let y = (int) offsetY;
                    if offsetX {
                        if y < 0 {
                            let offsetX = 0,
                                offsetY = y * -1,
                                gravity = constant("Imagick::GRAVITY_SOUTHEAST");
                        } else {
                            let offsetX = 0,
                                gravity = constant("Imagick::GRAVITY_NORTHEAST");
                        }
                    } else {
                        if y < 0 {
                            let offsetX = 0,
                                offsetY = y * -1,
                                gravity = constant("Imagick::GRAVITY_SOUTH");
                        } else {
                            let offsetX = 0,
                                gravity = constant("Imagick::GRAVITY_NORTH");
                        }
                    }
                }
            }
        } else {
            if typeof offsetX == "int" {
                let x = (int) offsetX;
                if offsetX {
                    if typeof offsetY == "bool" {
                        if offsetY {
                            if x < 0 {
                                let offsetX = x * -1,
                                    offsetY = 0,
                                    gravity = constant("Imagick::GRAVITY_SOUTHEAST");
                            } else {
                                let offsetY = 0,
                                    gravity = constant("Imagick::GRAVITY_SOUTH");
                            }
                        } else {
                            if x < 0 {
                                let offsetX = x * -1,
                                    offsetY = 0,
                                    gravity = constant("Imagick::GRAVITY_EAST");
                            } else {
                                let offsetY = 0,
                                    gravity = constant("Imagick::GRAVITY_WEST");
                            }
                        }
                    } else {
                        if typeof offsetY == "int" {
                            let x = (int) offsetX,
                                y = (int) offsetY;

                            if x < 0 {
                                if y < 0 {
                                    let offsetX = x * -1,
                                        offsetY = y * -1,
                                        gravity = constant("Imagick::GRAVITY_SOUTHEAST");
                                } else {
                                    let offsetX = x * -1,
                                        gravity = constant("Imagick::GRAVITY_NORTHEAST");
                                }
                            } else {
                                if y < 0 {
                                    let offsetY = y * -1,
                                        gravity = constant("Imagick::GRAVITY_SOUTHWEST");
                                } else {
                                    let gravity = constant("Imagick::GRAVITY_NORTHWEST");
                                }
                            }
                        }
                    }
                }
            }
        }

        draw->setGravity(gravity);

        this->_image->setIteratorIndex(0);

        loop {
            this->_image->annotateImage(draw, offsetX, offsetY, 0, text);
            if this->_image->nextImage() === false {
                break;
            }
        }

        draw->destroy();
    }

    /**
     * Composite one image onto another
     *
     * @param \Scene\Image\Adapter watermark
     */
    protected function _mask(<Adapter> image)
    {
        var mask, ret;

        let mask = new \Imagick();

        mask->readImageBlob(image->render());
        this->_image->setIteratorIndex(0);

        loop {
            this->_image->setImageMatte(1);
            let ret = this->_image->compositeImage(mask, constant("Imagick::COMPOSITE_DSTIN"), 0, 0);

            if ret !== true {
                throw new Exception("Imagick::compositeImage failed");
            }

            if this->_image->nextImage() === false {
                break;
            }
        }

        mask->clear();
        mask->destroy();
    }

    /**
     * Set the background color of an image
     *
     * @param int r
     * @param int g
     * @param int a
     * @param int opacity
     */
    protected function _background(int r, int g, int b, int opacity)
    {
        var background, color, pixel1, pixel2, ret;

        let color = sprintf("rgb(%d, %d, %d)", r, g, b);
        let pixel1 = new \ImagickPixel(color);
        let opacity = opacity / 100;

        let pixel2 = new \ImagickPixel("transparent");

        let background = new \Imagick();
        this->_image->setIteratorIndex(0);

        loop {
            background->newImage(this->_width, this->_height, pixel1);
            if !background->getImageAlphaChannel() {
                background->setImageAlphaChannel(constant("Imagick::ALPHACHANNEL_SET"));
            }
            background->setImageBackgroundColor(pixel2);
            background->evaluateImage(constant("Imagick::EVALUATE_MULTIPLY"), opacity, constant("Imagick::CHANNEL_ALPHA"));
            background->setColorspace(this->_image->getColorspace());
            let ret = background->compositeImage(this->_image, constant("Imagick::COMPOSITE_DISSOLVE"), 0, 0);

            if ret !== true {
                throw new Exception("Imagick::compositeImage failed");
            }

            if this->_image->nextImage() === false {
                break;
            }
        }

        this->_image->clear();
        this->_image->destroy();

        let this->_image = background;
    }

    /**
     * Blur image
     *
     * @param int radius Blur radius
     */
    protected function _blur(int radius)
    {
        this->_image->setIteratorIndex(0);

        loop {
            this->_image->blurImage(radius, 100);
            if this->_image->nextImage() === false {
                break;
            }
        }
    }

    /**
     * Pixelate image
     *
     * @param int amount amount to pixelate
     */
    protected function _pixelate(int amount)
    {
        int width, height;

        let width = this->_width / amount;
        let height = this->_height / amount;

        this->_image->setIteratorIndex(0);

        loop {
            this->_image->scaleImage(width, height);
            this->_image->scaleImage(this->_width, this->_height);
            if this->_image->nextImage() === false {
                break;
            }
        }
    }

    /**
     * Save the image
     *
     * @param string file
     * @param int quality
     */
    protected function _save(string file, int quality)
    {
        var ext, fp;

        let ext = pathinfo(file, PATHINFO_EXTENSION);

        this->_image->setFormat(ext);
        this->_image->setImageFormat(ext);

        let this->_type = this->_image->getImageType();
        let this->_mime = "image/" . this->_image->getImageFormat();

        if strcasecmp(ext, "gif") == 0 {
            this->_image->optimizeImageLayers();
            let fp= fopen(file, "w");
            this->_image->writeImagesFile(fp);
            fclose(fp);
            return;
        } else {
            if strcasecmp(ext, "jpg") == 0 || strcasecmp(ext, "jpeg") == 0 {
                this->_image->setImageCompression(constant("Imagick::COMPRESSION_JPEG"));
            }

            if quality >= 0 {
                if quality < 1 {
                    let quality = 1;
                } elseif quality > 100 {
                    let quality = 100;
                }
                this->_image->setImageCompressionQuality(quality);
            }
            this->_image->writeImage(file);
        }
    }

    /**
     * Execute a render.
     * @param  string $extension
     * @param  int $quality
     * @return string
     */
    protected function _render(string extension, int quality) -> string
    {
        var image;

        let image = this->_image;

        image->setFormat(extension);
        image->setImageFormat(extension);
        image->stripImage();

        let this->_type = image->getImageType(),
            this->_mime = "image/" . image->getImageFormat();

        if strcasecmp(extension, "gif") == 0 {
            image->optimizeImageLayers();
        } else {
            if strcasecmp(extension, "jpg") == 0 || strcasecmp(extension, "jpeg") == 0 {
                image->setImageCompression(constant("Imagick::COMPRESSION_JPEG"));
            }
            image->setImageCompressionQuality(quality);
        }

        return image->getImageBlob();
    }

    /**
     * Destroys the loaded image to free up resources.
     */
    public function __destruct()
    {
        if this->_image instanceof \Imagick {
            this->_image->clear();
            this->_image->destroy();
        }
    }

    /**
     * Get instance
     */
    public function getInternalImInstance() -> <\Imagick>
    {
        return this->_image;
    }

    /**
     * Sets the limit for a particular resource in megabytes
     *
     * @link http://php.net/manual/ru/imagick.constants.php#imagick.constants.resourcetypes
     */
    public function setResourceLimit(int type, int limit)
    {
        this->_image->setResourceLimit(type, limit);
    }
}
