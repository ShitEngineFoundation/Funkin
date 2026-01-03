package;

import flixel.graphics.FlxGraphic;
import animate.FlxAnimateFrames;
import openfl.media.Sound;
import haxe.extern.EitherType;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;

class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;

	static var currentLevel:String;
	public static var cachedImages:haxe.ds.StringMap<FlxGraphic> = new haxe.ds.StringMap<FlxGraphic>();

	static public function setCurrentLevel(name:String)
	{
		currentLevel = name.toLowerCase();
	}

	public static function getPath(file:String, ?type:AssetType, ?library:Null<String>)
	{
		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath = getLibraryPathForce(file, currentLevel);
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;

			levelPath = getLibraryPathForce(file, "shared");
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
		}

		return getPreloadPath(file);
	}

	static public function getLibraryPath(file:String, library = "preload")
	{
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);
	}

	inline static function getLibraryPathForce(file:String, library:String)
	{
		return '$library:assets/$library/$file';
	}

	inline static function getPreloadPath(file:String)
	{
		return 'assets/$file';
	}

	inline static public function file(file:String, type:AssetType = TEXT, ?library:String)
	{
		return getPath(file, type, library);
	}

	inline static public function txt(key:String, ?library:String)
	{
		return getPath('data/$key.txt', TEXT, library);
	}

	inline static public function xml(key:String, ?library:String)
	{
		return getPath('data/$key.xml', TEXT, library);
	}

	inline static public function json(key:String, ?library:String)
	{
		return getPath('data/$key.json', TEXT, library);
	}

	static public function sound(key:String, ?library:String)
	{
		return getPath('sounds/$key.$SOUND_EXT', SOUND, library);
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), library);
	}

	static public function music(key:String, allowStream:Bool = true, ?library:String):EitherType<String, Sound>
	{
		var path = getPath('music/$key.$SOUND_EXT', MUSIC, library);
		return FlxG.assets.canStreamSound(path) && allowStream ? FlxG.assets.streamSound(path) : path;
	}

	static public function voices(song:String, ?allowStream:Bool = true):EitherType<String, Sound>
	{
		var path = 'songs:assets/songs/${song.toLowerCase()}/Voices.$SOUND_EXT';
		return FlxG.assets.canStreamSound(path) && allowStream ? FlxG.assets.streamSound(path) : path;
	}

	static public function inst(song:String, ?allowStream:Bool = true):EitherType<String, Sound>
	{
		var path = 'songs:assets/songs/${song.toLowerCase()}/Inst.$SOUND_EXT';
		return FlxG.assets.canStreamSound(path) && allowStream ? FlxG.assets.streamSound(path) : path;
	}

	inline static public function image(key:String, ?library:String)
	{
		return getPath('images/$key.png', IMAGE, library);
	}

	public static function getGraphic(path:String):EitherType<FlxGraphic, String>
	{
		if (cachedImages.exists(path))
			return cachedImages.get(path);

		if (!OpenFLAssets.exists(path))
			return path;

		var bitmap = OpenFLAssets.getBitmapData(path);
		bitmap.disposeImage();
		var graphic = FlxGraphic.fromBitmapData(bitmap, false, path, false);
		graphic.persist = true;
		cachedImages.set(path, graphic);
		return graphic;
	}

	// dangerous ahh thing, only execute in middle of state switches
	public static function clearGraphics()
	{
		for (key in cachedImages.keys())
		{
			var graphic = cachedImages.get(key);
			FlxG.bitmap.remove(graphic);
			OpenFLAssets.cache.removeBitmapData(key);
			graphic.destroy();
			graphic.persist = false;

			cachedImages.remove(key);
			graphic = null;

			trace(' erased shiity  graphic ' + key);
		}
	}

	inline static public function font(key:String)
	{
		return 'assets/fonts/$key';
	}

	inline static public function getSparrowAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSparrow(getGraphic(image(key, library)), file('images/$key.xml', library));
	}

	static public function getAnimateAtlas(key:String, ?library:String)
	{
		var atlas = FlxAnimateFrames.fromAnimate(getPath('images/$key', null, library));
		if (atlas != null && atlas.parent != null)
			atlas.parent.bitmap.disposeImage();
		return atlas;
	}

	inline static public function getPackerAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
	}
}
