package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.sound.FlxSound;

class OffsetTest extends ui.OptionsState.Page
{
	var txt:FlxText;
	var snd:FlxSound;

	// === Timing ===
	var bpm:Float = 120; // change if needed
	var beatLength:Float;
	var offsets:Array<Float> = [];

	public function new()
	{
		super();

		beatLength = 60000 / bpm;

		txt = new FlxText(0, 0, 0, "this is just a placeholder", 20);
		txt.screenCenter();
		add(txt);

		snd = FlxG.sound.load(Paths.sound("soundTest", "shared"), 1, true);
		snd.play();

		Conductor.songPosition = 0;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// Sync song position
		Conductor.songPosition = snd != null ? snd.time : 0;

	
		if(controls.BACK)
			exit();

	}

	
}
