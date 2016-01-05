
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

/**
 * Scene\Version
 *
 * This class allows to get the installed version of the framework
 *
 */
class Version
{
    /**
     * The constant referencing the major version. Returns 0
     * <code>
     * echo Scene\Version::getPart(Scene\Version::VERSION_MAJOR);
     * </code>
     */
    const VERSION_MAJOR = 0;

    /**
     * The constant referencing the major version. Returns 1
     * <code>
     * echo Scene\Version::getPart(Scene\Version::VERSION_MEDIUM);
     * </code>
     */
    const VERSION_MEDIUM = 1;

    /**
     * The constant referencing the major version. Returns 2
     * <code>
     * echo Scene\Version::getPart(Scene\Version::VERSION_MINOR);
     * </code>
     */
    const VERSION_MINOR = 2;

    /**
     * The constant referencing the major version. Returns 3
     * <code>
     * echo Scene\Version::getPart(Scene\Version::VERSION_SPECIAL);
     * </code>
     */
    const VERSION_SPECIAL = 3;

    /**
     * The constant referencing the major version. Returns 4
     * <code>
     * echo Scene\Version::getPart(Scene\Version::VERSION_SPECIAL_NUMBER);
     * </code>
     */
    const VERSION_SPECIAL_NUMBER = 4;

    /**
     * Area where the version number is set. The format is as follows:
     * ABBCCDE
     *
     * A - Major version
     * B - Med version (two digits)
     * C - Min version (two digits)
     * D - Special release: 1 = Alpha, 2 = Beta, 3 = RC, 4 = Stable
     * E - Special release version i.e. RC1, Beta2 etc.
     *
     * @return attay
     */
    protected static function _getVersion() -> array
    {
        return [0, 1, 0, 2, 1];
    }

    /**
     * Translates a number to a special release
     *
     * If Special release = 1 this function will return ALPHA
     *
     * @return  array
     */
    protected final static function _getSpecial(int special) -> string
    {
        var suffix = "";

        switch special {
            case 1:
                let suffix = "ALPHA";
                break;
            case 2:
                let suffix = "BETA";
                break;
            case 3:
                let suffix = "RC";
                break;
        }

        return suffix;
    }

    /**
     * Returns the active version (string)
     *
     * <code>
     * echo \Scene\Version::get();
     * </code>
     *
     * @return string
     */
    public static function get() -> string
    {
        var version, major, medium, minor,
            special, specialNumber, result, suffix;

        let version       = static::_getVersion();

        let major         = version[self::VERSION_MAJOR],
            medium        = version[self::VERSION_MEDIUM],
            minor         = version[self::VERSION_MINOR],
            special       = version[self::VERSION_SPECIAL],
            specialNumber = version[self::VERSION_SPECIAL_NUMBER];

        let result  = major . "." . medium . "." . minor . " ";
        let suffix  = static::_getSpecial(special);

        if suffix != "" {
            let result .= suffix . " " . specialNumber;
        }

        return trim(result);
    }

    /**
     * Returns the numeric active version
     *
     * <code>
     * echo \Scene\Version::getId();
     * </code>
     *
     * @return string
     */
    public static function getId() -> string
    {
        var version, major, medium, minor,
            special, specialNumber;

        let version       = static::_getVersion();

        let major         = version[self::VERSION_MAJOR],
            medium        = version[self::VERSION_MEDIUM],
            minor         = version[self::VERSION_MINOR],
            special       = version[self::VERSION_SPECIAL],
            specialNumber = version[self::VERSION_SPECIAL_NUMBER];

        return major . sprintf("%02s", medium) . sprintf("%02s", minor) . special . specialNumber;
    }

    /**
     * Returns a specific part of the version. If the wrong parameter is passed
     * it will return the full version
     *
     * <code>
     * echo Scene\Version::getPart(Scene\Version::VERSION_MAJOR);
     * </code>
     *
     * @return  string
     */
    public static function getPart(int part) -> string
    {
        var version, result;

        let version = static::_getVersion();

        switch part {

            case self::VERSION_MAJOR:
            case self::VERSION_MEDIUM:
            case self::VERSION_MINOR:
            case self::VERSION_SPECIAL_NUMBER:
                let result = version[part];
                break;

            case self::VERSION_SPECIAL:
                let result = static::_getSpecial(version[self::VERSION_SPECIAL]);
                break;

            default:
                let result = static::get();
                break;
        }

        return result;
    }

}