package;

import haxe.Http;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class OutdatedSubState extends MusicBeatState
{
	public static var leftState:Bool = false;
	public static var latestVer = #if (!web) Http.requestUrl("https://raw.githubusercontent.com/ShitEngineFoundation/Funkin/legacy/0.2.x/.version") #else "0.2.9" #end;

	override function create()
	{
		super.create();

		var ver = "v" + Application.current.meta.get('version');
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"HEY! You're running an outdated version of the game!\nCurrent version is "
			+ ver
			+ " while the most recent version is "
			+ latestVer
			+ "! Press Space to go to github.com, or ESCAPE to ignore this!!",
			32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
			FlxG.openURL("https://github.com/ShitEngineFoundation/Funkin/releases");

		if (controls.BACK)
		{
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}
}
