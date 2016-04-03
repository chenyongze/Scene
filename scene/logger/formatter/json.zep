
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

namespace Scene\Logger\Formatter;

use Scene\Logger\Formatter;

/**
 * Scene\Logger\Formatter\Json
 *
 * Formats messages using JSON encoding
 */
class Json extends Formatter
{

	/**
	 * Applies a format to a message before sent it to the internal log
	 *
	 * @param string message
	 * @param int type
	 * @param int timestamp
	 * @param array context
	 * @return string
	 */
	public function format(string message, int type, int timestamp, var context = null) -> string
	{
		if typeof context === "array" {
			let message = this->interpolate(message, context);
		}

		return json_encode([
			"type": this->getTypeString(type),
			"message": message,
			"timestamp": timestamp
		]) . PHP_EOL;
	}
}