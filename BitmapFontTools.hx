package zdxUtils;

import flixel.text.FlxBitmapFont;
/**
 * Bitmap Font Tools is used to handle bitmap fonts without requiring extensive code; // TODO: add more font formats
 */
class BitmapFontTools
{
    /**
     * The path where the bitmap font will be found; for now, only AngelCode is supported
     */
    public static var PATH:String = "assets/AngelCodeFonts/";
	
	/**
	 * Returns an AngelCode font by the name `fontName`; it will be looked up at the path `PATH` + `fontName`. Use `BMFont` to generate a bitmap font: `https://www.angelcode.com/products/bmfont/`
	 * @param fontName bitmap font name, e.g., `minecraft`
	 * @return FlxBitmapFont
	 */
	public static function fromAngelCode(fontName:String):FlxBitmapFont
	{
		var font = FlxBitmapFont.fromAngelCode(PATH + fontName + ".png", PATH + fontName + ".fnt");
		if (font == null)
		{
			trace("Font: " + fontName + "not exists. path: " + PATH + fontName);
		}
        
		return font;
	}
}
