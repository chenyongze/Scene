
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
use Scene\Image\AdapterInterface;
use Scene\Image\Exception;

/**
 * Scene\Image\Adapter\Gd
 *
 * Image manipulation support. Allows images to be resized, cropped, etc.
 *
 *<code>
 * $image = new Scene\Image\Adapter\Gd("upload/test.jpg");
 * $image->resize(200, 200)->rotate(90)->crop(100, 100);
 * if ($image->save()) {
 *     echo 'success';
 * }
 *</code>
 */
class Gd extends Adapter implements AdapterInterface
{
    protected static _checked = false;

    /**
     * Checks if GD is enabled
     * 
     * @return boolean
     */
    public static function check() -> boolean
    {
        var version, info, matches;

        if self::_checked {
            return true;
        }

        if !function_exists("gd_info") {
            throw new Exception("GD is either not installed or not enabled, check your configuration");
        }

        let version = null;
        if defined("GD_VERSION") {
            let version = GD_VERSION;
        } else {
            let info = gd_info(), matches = null;
            if preg_match("/\\d+\\.\\d+(?:\\.\\d+)?/", info["GD Version"], matches) {
                let version = matches[0];
            }
        }

        if !version_compare(version, "2.0.1", ">=") {
            throw new Exception("Scene\\Image\\Adapter\\GD requires GD version '2.0.1' or greater, you have " . version);
        }

        let self::_checked = true;

        return self::_checked;
    }

    /**
     * \Scene\Image\Adapter\Gd constructor
     * 
     * @param string $file
     * @param int $width
     * @param int $height
     */
    public function __construct(string! file, int width = null, int height = null)
    {
        var imageinfo;

        if !self::_checked {
            self::check();
        }

        let this->_file = file;

        if file_exists(this->_file) {

            let this->_realpath = realpath(this->_file);
            let imageinfo = getimagesize(this->_file);

            if imageinfo {
                let this->_width = imageinfo[0];
                let this->_height = imageinfo[1];
                let this->_type = imageinfo[2];
                let this->_mime = imageinfo["mime"];
            }

            switch this->_type {
                case 1:
                    let this->_image = imagecreatefromgif(this->_file);
                    break;
                case 2:
                    let this->_image = imagecreatefromjpeg(this->_file);
                    break;
                case 3:
                    let this->_image = imagecreatefrompng(this->_file);
                    break;
                default:
                    if this->_mime {
                        throw new Exception("Installed GD does not support " . this->_mime . " images");
                    } else {
                        throw new Exception("Installed GD does not support such images");
                    }
                    break;
            }

            imagesavealpha(this->_image, true);

        } else {
            if !width || !height {
                throw new Exception("Failed to create image from file " . this->_file);
            }

            let this->_image = imagecreatetruecolor(width, height);
            imagealphablending(this->_image, true);
            imagesavealpha(this->_image, true);

            let this->_realpath = this->_file;
            let this->_width    = width;
            let this->_height   = height;
            let this->_type     = 3;
            let this->_mime     = "image/png";
        }
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
       
        let image = imagescale(this->_image, width, height);
        imagedestroy(this->_image);
        let this->_image = image;
        let this->_width  = imagesx(image);
        let this->_height = imagesy(image);
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
    protected function _crop(int width, int height, int offsetX, int offsetY)
    {
        var image, rect;
  
        let rect = ["x": offsetX, "y": offsetY, "width": width, "height": height];
        let image = imagecrop(this->_image, rect);
        imagedestroy(this->_image);
        let this->_image = image;
        let this->_width  = imagesx(image);
        let this->_height = imagesy(image);
    }

    /**
     * Rotate the image by a given amount
     *
     * @param int degress
     * @return \Scene\Image\Adapter
     */
    protected function _rotate(int degrees)
    {
        var image, transparent, width, height;

        let transparent = imagecolorallocatealpha(this->_image, 0, 0, 0, 127);
        let image = imagerotate(this->_image, 360 - degrees, transparent, 1);

        imagesavealpha(image, TRUE);

        let width  = imagesx(image);
        let height = imagesy(image);

        if imagecopymerge(this->_image, image, 0, 0, 0, 0, width, height, 100) {
            imagedestroy(this->_image);
            let this->_image = image;
            let this->_width  = width;
            let this->_height = height;
        }
    }

    /**
     * Flip the image along the horizontal or vertical axis
     *
     * @param int direction
     * @return \Scene\Image\Adapter
     */
    protected function _flip(int direction)
    {
        if direction == \Scene\Image::HORIZONTAL {
            imageflip(this->_image, IMG_FLIP_HORIZONTAL);
        } else {
            imageflip(this->_image, IMG_FLIP_VERTICAL);
        }
    }

    /**
     * Sharpen the image by a given amount
     *
     * @param int amount
     * @return \Scene\Image\Adapter
     */
    protected function _sharpen(int amount)
    {
        var matrix;

        let amount = (int) round(abs(-18 + (amount * 0.08)), 2);

        let matrix = [
            [-1,   -1,    -1],
            [-1, amount, -1],
            [-1,   -1,    -1]
        ];

        if imageconvolution(this->_image, matrix, amount - 8, 0) {
            let this->_width  = imagesx(this->_image);
            let this->_height = imagesy(this->_image);
        }
    }

    /**
     * Add a reflection to an image
     *
     * @param int height
     * @param int opacity
     * @param boolean fadeIn
     * @return \Scene\Image\Adapter
     */
    protected function _reflection(int height, int opacity, boolean fadeIn)
    {
        var reflection, line;
        int stepping, offset, src_y, dst_y, dst_opacity;

        let opacity = (int) round(abs((opacity * 127 / 100) - 127));

        if opacity < 127 {
            let stepping = (127 - opacity) / height;
        } else {
            let stepping = 127 / height;
        }

        let reflection = this->_create(this->_width, this->_height + height);

        imagecopy(reflection, this->_image, 0, 0, 0, 0, this->_width, this->_height);

        let offset = 0;
        while height >= offset {

            let src_y = this->_height - offset - 1;
            let dst_y = this->_height + offset;

            if fadeIn {
                let dst_opacity = (int) round(opacity + (stepping * (height - offset)));
            } else {
                let dst_opacity = (int) round(opacity + (stepping * offset));
            }

            let line = this->_create(this->_width, 1);

            imagecopy(line, this->_image, 0, 0, 0, src_y, this->_width, 1);
            imagefilter(line, IMG_FILTER_COLORIZE, 0, 0, 0, dst_opacity);
            imagecopy(reflection, line, 0, dst_y, 0, 0, this->_width, 1);
            let offset++;
        }

        imagedestroy(this->_image);
        let this->_image = reflection;
        let this->_width  = imagesx(reflection);
        let this->_height = imagesy(reflection);
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
    protected function _watermark(<Adapter> watermark, int offsetX, int offsetY, int opacity)
    {
        var overlay, color;
        int width, height;

        let overlay = imagecreatefromstring(watermark->render());

        imagesavealpha(overlay, true);

        let width  = (int) imagesx(overlay);
        let height = (int) imagesy(overlay);

        if opacity < 100 {
            let opacity = (int) round(abs((opacity * 127 / 100) - 127));
            let color = imagecolorallocatealpha(overlay, 127, 127, 127, opacity);

            imagelayereffect(overlay, IMG_EFFECT_OVERLAY);

            imagefilledrectangle(overlay, 0, 0, width, height, color);
        }

        imagealphablending(this->_image, true);

        if imagecopy(this->_image, overlay, offsetX, offsetY, 0, 0, width, height) {
            imagedestroy(overlay);
        }
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
     * @return \Scene\Image\Adapter
     */
    protected function _text(string text, int offsetX, int offsetY, int opacity, int r, int g, int b, int size, string fontfile)
    {
        var space, color, angle;
        int s0 = 0, s1 = 0, s4 = 0, s5 = 0, width, height;

        let opacity = (int) round(abs((opacity * 127 / 100) - 127));

        if fontfile {

            let space = imagettfbbox(size, 0, fontfile, text);

            if isset space[0] {
                let s0 = (int) space[0];
                let s1 = (int) space[1];
                let s4 = (int) space[4];
                let s5 = (int) space[5];
            }

            if !s0 || !s1 || !s4 || !s5 {
                throw new Exception("Call to imagettfbbox() failed");
            }

            let width  = abs(s4 - s0) + 10;
            let height = abs(s5 - s1) + 10;

            if offsetX < 0 {
                let offsetX = this->_width - width + offsetX;
            }

            if offsetY < 0 {
                let offsetY = this->_height - height + offsetY;
            }

            let color = imagecolorallocatealpha(this->_image, r, g, b, opacity);
            let angle = 0;

            imagettftext(this->_image, size, angle, offsetX, offsetY, color, fontfile, text);
        } else {
            let width  = (int) imagefontwidth(size) * strlen(text);
            let height = (int) imagefontheight(size);

            if offsetX < 0 {
                let offsetX = this->_width - width + offsetX;
            }

            if offsetY < 0 {
                let offsetY = this->_height - height + offsetY;
            }

            let color = imagecolorallocatealpha(this->_image, r, g, b, opacity);
            imagestring(this->_image, size, offsetX, offsetY, text, color);
        }
    }

    /**
     * Composite one image onto another
     *
     * @param \Scene\Image\Adapter watermark
     * @return \Scene\Image\Adapter
     */
    protected function _mask(<Adapter> mask)
    {
        var maskImage, newimage, tempImage, color, index, r, g, b;
        int mask_width, mask_height, x, y, alpha;

        let maskImage   = imagecreatefromstring(mask->render());
        let mask_width  = (int) imagesx(maskImage);
        let mask_height = (int) imagesy(maskImage);
        let alpha = 127;

        imagesavealpha(maskImage, true);

        let newimage = this->_create(this->_width, this->_height);
        imagesavealpha(newimage, true);

        let color = imagecolorallocatealpha(newimage, 0, 0, 0, alpha);

        imagefill(newimage, 0, 0, color);

        if this->_width != mask_width || this->_height != mask_height {
            let tempImage = imagecreatetruecolor(this->_width, this->_height);

            imagecopyresampled(tempImage, maskImage, 0, 0, 0, 0, this->_width, this->_height, mask_width, mask_height);
            imagedestroy(maskImage);

            let maskImage = tempImage;
        }

        let x = 0;
        while x < this->_width {

            let y = 0;
            while y < this->_height {

                let index = imagecolorat(maskImage, x, y),
                    color = imagecolorsforindex(maskImage, index);

                if isset color["red"] {
                    let alpha = 127 - intval(color["red"] / 2);
                }

                let index = imagecolorat(this->_image, x, y),
                    color = imagecolorsforindex(this->_image, index),
                    r = color["red"], g = color["green"], b = color["blue"],
                    color = imagecolorallocatealpha(newimage, r, g, b, alpha);

                imagesetpixel(newimage, x, y, color);
                let y++;
            }
            let x++;
        }

        imagedestroy(this->_image);
        imagedestroy(maskImage);
        let this->_image = newimage;
    }

    protected function _background(int r, int g, int b, int opacity)
    {
        var background, color;

        let opacity = (opacity * 127 / 100) - 127;

        let background = this->_create(this->_width, this->_height);

        let color = imagecolorallocatealpha(background, r, g, b, opacity);
        imagealphablending(background, true);

        if imagecopy(background, this->_image, 0, 0, 0, 0, this->_width, this->_height) {
            imagedestroy(this->_image);
            let this->_image = background;
        }
    }

    protected function _blur(int radius)
    {
        int i;
        let i = 0;
        while i < radius {
            imagefilter(this->_image, IMG_FILTER_GAUSSIAN_BLUR);
            let i++;
        }
    }

    protected function _pixelate(int amount)
    {
        var color;
        int x, y, x1, y1, x2, y2;

        let x = 0;
        while x < this->_width {
            let y = 0;
            while y < this->_height {
                let x1 = x + amount/2;
                let y1 = y + amount/2;
                let color = imagecolorat(this->_image, x1, y1);

                let x2 = x + amount;
                let y2 = y + amount;
                imagefilledrectangle(this->_image, x, y, x2, y2, color);

                let y += amount;
            }
            let x += amount;
        }
    }

    protected function _save(string file, int quality)
    {
        var ext;

        let ext = pathinfo(file, PATHINFO_EXTENSION);

        // If no extension is given, revert to the original type.
        if !ext {
            let ext = image_type_to_extension(this->_type, false);
        }

        let ext = strtolower(ext);

        if strcmp(ext, "gif") == 0 {
            let this->_type = 1;
            let this->_mime = image_type_to_mime_type(this->_type);
            imagegif(this->_image, file);
            return true;
        }
        if strcmp(ext, "jpg") == 0 || strcmp(ext, "jpeg") == 0 {
            let this->_type = 2;
            let this->_mime = image_type_to_mime_type(this->_type);
            
            if quality >= 0 {
                if quality < 1 {
                    let quality = 1;
                } elseif quality > 100 {
                    let quality = 100;
                }
                imagejpeg(this->_image, file, quality);
            } else {
                imagejpeg(this->_image, file);
            }

            return true;
        }
        if strcmp(ext, "png") == 0 {
            let this->_type = 3;
            let this->_mime = image_type_to_mime_type(this->_type);

            if quality >= 0 {
                if quality < 1 {
                    let quality = 1;
                } elseif quality > 100 {
                    let quality = 100;
                }
                let quality /= 10;
                let quality = ceil(quality);
                if quality >= 9 {
                    let quality = 9;
                }
                imagepng(this->_image, file, quality);
            } else {
                imagepng(this->_image, file);
            }

            return true;
        }

        throw new Exception("Installed GD does not support '" . ext . "' images");
    }

    /**
     * Execute a render.
     * @param  string $extension
     * @param  int $quality
     * @return string
     */
    protected function _render(string ext, int quality)
    {
        ob_start();
        if strcasecmp(ext, "gif") === 0 {
            imagegif(this->_image);
            return ob_get_clean();
        }
        if strcasecmp(ext, "jpg") === 0 || strcasecmp(ext, "jpeg") === 0 {
            imagejpeg(this->_image, null, quality);
            return ob_get_clean();
        }
        if strcasecmp(ext, "png") === 0 {
            imagepng(this->_image);
            return ob_get_clean();
        }

        throw new Exception("Installed GD does not support '" . ext . "' images");
    }

    /**
     * Create
     * 
     * @param int width
     * @param int height
     * @return string
     */
    protected function _create(int width, int height)
    {
        var image;

        let image = imagecreatetruecolor(width, height);

        imagealphablending(image, false);
        imagesavealpha(image, true);

        return image;
    }

    /**
     * Destroys the loaded image to free up resources.
     */
    public function __destruct()
    {
        var image;

        let image = this->_image;
        if typeof image  == "resource" {
            imagedestroy(image);
        }
    }

}
