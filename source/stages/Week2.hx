package stages;

import flixel.FlxSprite;
import flixel.FlxG;

class Week2 extends BaseStage
{
    public var halloweenBG:FlxSprite;
	override public function create()
	{
		var hallowTex = Paths.getSparrowAtlas('halloween_bg');

		halloweenBG = new FlxSprite(-200, -100);
		halloweenBG.frames = hallowTex;
		halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
		halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
		halloweenBG.animation.play('idle');
		halloweenBG.antialiasing = true;
		add(halloweenBG);
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	function lightningStrikeShit(curBeat):Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		bf.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	override function beatHit(curBeat:Int = 0)
	{
		super.beatHit(curBeat);
		if (FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
			lightningStrikeShit(curBeat);
	}
}
