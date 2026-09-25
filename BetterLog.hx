package zdxUtils;

import flixel.FlxG;
import flixel.FlxState;
import sys.FileSystem;
import sys.io.File;
import EReg;

/**
 * TextStyle enum defines different styles for log messages, such as normal, bold, underlined, and inversed.
 * This allows developers to easily format their log messages for better readability and emphasis.
 */
enum TextStyle
{
	NORMAL;
	BOLD;
	UNDERLINED;
	INVERSED;
}

/**
 * LogWarn types
 */
enum LogWarn
{
	SUCCESS;
	INFO;
	WARNING;
	ERROR;
	CRASH;
}

/**  BetterLog is a custom logging system for the game, designed to provide more detailed and organized logs for debugging purposes.
	It allows developers to log messages with different levels of severity (info, warning, error) and can be easily extended to include additional features such as log filtering or saving logs to a file.
	by zdx!
**/
class BetterLog
{
	private static var logs:Array<String> = [];

	/**
	 * the path where the logs will go
	 */
	public static var LOG_FILE_PATH = "BetterLog_logs.txt"
	/**
	 * determines whether the log will be added to the `LOG_FILE_PATH` file; if true, the `addLogToFile` function will be cancelled
	 */
	public static var ADD_LOG_TO_FILE:Bool = true;

	public static var colors:Map<String, Int> = // asci colors escape format!
		[
			"<color=orange>" => -999, // 38;5;208
			"<color=black>" => 30,
			"<color=red>" => 31,
			"<color=green>" => 32,
			"<color=blue>" => 34,
			"<color=yellow>" => 33,
			"<color=cyan>" => 36,
			"<color=magenta>" => 35,
			"<color=white>" => 37,
			"<reset>" => 0,
			"<bgcolor=black>" => 40,
			"<bgcolor=red>" => 41,
			"<bgcolor=green>" => 42,
			"<bgcolor=yellow>" => 43,
			"<bgcolor=blue>" => 44,
			"<bgcolor=magenta>" => 45,
			"<bgcolor=cyan>" => 46,
			"<bgcolor=white>" => 47,
		];

	/**
	 * color code to flxcolor int
	 */
	private static var colorToFlxColor:Map<String, Int> = [
		"<color=black>" => FlxColor.BLACK,
		"<color=red>" => FlxColor.RED,
		"<color=green>" => FlxColor.LIME,
		"<color=yellow>" => FlxColor.YELLOW,
		"<color=blue>" => FlxColor.BLUE,
		"<color=magenta>" => FlxColor.MAGENTA,
		"<color=cyan>" => FlxColor.CYAN,
		"<color=white>" => FlxColor.WHITE,
	];

	/**
	 * Adds a log message to the console where the game is running.
	 * @param message the message to be displayed
	 * @param warn the warning style
	 * @param style the style of the displayed message
	 */
	public static function log(message:Dynamic, warn:LogWarn = LogWarn.INFO, style:TextStyle = TextStyle.NORMAL)
	{
		var text:String = message;

		for (color in colors.keys())
		{
			if (StringTools.contains(text, color))
			{
				var code = colors.get(color);
				text = StringTools.replace(text, color, "\x1b[" + code + "m");
			}
		}

		switch (style)
		{
			case TextStyle.NORMAL:
				// No additional formatting needed - shut up haxe
			case TextStyle.BOLD:
				text = "\x1b[1m" + text + "\x1b[0m";
			case TextStyle.UNDERLINED:
				text = "\x1b[4m" + text + "\x1b[0m";
			case TextStyle.INVERSED:
				text = "\x1b[7m" + text + "\x1b[0m";
		}

		switch (warn)
		{
			case LogWarn.SUCCESS:
				text = "\x1b[32m" + text + "\x1b[0m";
			case LogWarn.INFO:
				text = "\x1b[34m" + text + "\x1b[0m";
			case LogWarn.WARNING:
				text = "\x1b[38;5;208m" + text + "\x1b[0m";
			case LogWarn.ERROR:
				text = "\x1b[31m" + text + "\x1b[0m";
			case LogWarn.CRASH:
				text = "\x1b[41m\x1b[37m" + text + "\x1b[0m";
		}

		logs.push(text);
		trace(text);
		addLogToFile(text, warn);
	}

	/**
	 * returns all logs array so far in a string format
	 * @param sep how the logs will be formatted
	 * @return String
	 */
	public static function getLogs(sep:String = "\n"):String
	{
		return logs.join(sep);
	}

	/**
	 * clear logs array
	 */
	public static function clearLogs():Void
	{
		logs = [];
	}

	/**
	 * clear console log
	 * @param silient There will be a notification after the cleanup
	 */
	public static function clearConsole(silient:Bool = false):Void
	{
		Sys.command("cls");
		if (!silient)
			log("<color=cyan>Console cleared!", TextStyle.UNDERLINED, LogWarn.SUCCESS);
	}

	/**
	 * adds the log to the `LOG_FILE_PATH` file
	 * @param message the message
	 * @param logStyle the logstyle
	 */

	public static function addLogToFile(message:Dynamic, logStyle:LogWarn):Void
	{
		if (!ADD_LOG_TO_FILE)
			return;
		
		var fileContent:String = Std.string(message);

		for (color in colors.keys())
		{
			fileContent = StringTools.replace(fileContent, color, "");
		}
		var ansi = new EReg("\x1b\\[[0-9;]*m", "g");
		fileContent = ansi.replace(fileContent, "");

		fileContent += " - [" + Std.string(logStyle).toUpperCase() + "] - " + Date.now().toString() + "\n";

		var file = File.append(LOG_FILE_PATH);
		file.writeString(fileContent);
		file.close();
	}
}
