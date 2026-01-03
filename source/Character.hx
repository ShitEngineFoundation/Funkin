package;

import animate.FlxAnimate;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import haxe.Json;
import openfl.utils.Assets;

typedef CharacterJSON =
{
	var time:Int; // how many steps it takes to go back to idle
	var scale:Float;

	var icon:String;
	var image:String;

	var antialiasing:Bool;
	var flipX:Bool;

	var cam_offset:Array<Float>;
	var pos_offset:Array<Float>;

	var animations:Array<Animation>;
}

typedef Animation =
{
	var name:String;
	var fps:Float;
	var prefix:String;
	var looped:Bool;

	var offsets:Array<Float>;
	@:optional var indices:Array<Int>;
}

class Character extends FlxAnimate
{
	// ✅ Instance fields
	public var animOffsets:Map<String, Array<Float>> = new Map<String, Array<Float>>();
	public var player:Bool = false;
	public var json:CharacterJSON;

	public var beat:Int = 0;
	public var isDancing:Bool = false;
	public var holdTimer:Float = 0;

	static public var sing = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];

	public var curCharacter = "N/A";

	public function new(x:Float = 0, y:Float = 0, char:String = "bf", player:Bool = false)
	{
		super(x, y);

		this.player = player;
		loadJson(char);

		useRenderTexture = true;
	}

	public function getAnimationName()
	{
		if (isAnimate)
			return anim.name;
		else
			return animation.name;
	}

	// this searches both in
	public function animExists(anim:String)
	{
		return this.anim.getByName(anim) != null || animation.getByName(anim) != null;
	}

	public function loadJson(char:String)
	{
		json = null;
		var path = Paths.getPath('data/characters/$char.json');
		if (!OpenFLAssets.exists(path, TEXT))
			path = Paths.getPath('data/characters/dad.json');
		curCharacter = char;
		json = Json.parse(OpenFLAssets.getText(path));

		flipX = (json.flipX != player);
		antialiasing = json.antialiasing;
		scale.set(json.scale, json.scale);

		var atlas = false;

		if (OpenFLAssets.exists(Paths.getPath('images/' + json.image + '/Animation.json', TEXT, 'shared')))
			atlas = true;

		if (!atlas)
		{
			frames = Paths.getSparrowAtlas(json.image, 'shared');

			// ✅ Load animations and animOffsets
			for (anim in json.animations)
			{
				if (anim.indices != null && anim.indices.length > 0)
					animation.addByIndices(anim.name, anim.prefix, anim.indices, '', anim.fps, anim.looped);
				else
					animation.addByPrefix(anim.name, anim.prefix, anim.fps, anim.looped);

				animOffsets.set(anim.name, anim.offsets);
			}
		}
		else
		{
			frames = Paths.getAnimateAtlas(json.image, 'shared');

			for (anim in json.animations)
			{
				if (anim.indices != null && anim.indices.length > 0)
					this.anim.addBySymbolIndices(anim.name, anim.prefix, anim.indices, anim.fps, anim.looped);
				else
					this.anim.addBySymbol(anim.name, anim.prefix, anim.fps, anim.looped);

				animOffsets.set(anim.name, anim.offsets);
			}
		}

		playAnim(animExists("danceRight") && animExists("danceLeft") ? 'danceRight' : 'idle');
		updateHitbox();
	}

	public function playAnim(anim:String, ?force:Bool = true)
	{
		if (animExists(anim))
		{
			(isAnimate ? this.anim : animation).play(anim, force);
			if (offset != null && animOffsets.exists(anim))
				offset.set(animOffsets.get(anim)[0], animOffsets.get(anim)[1]);
		}
		//trace(animOffsets);
	}

	public function hitNote(note:Note)
	{
		playAnim(sing[note.noteData % sing.length], true);
		holdTimer = (Conductor.stepCrochet * json.time) / 1000;
	}

	public function dance(beat:Int = 0)
	{
		this.beat = beat;
		if (holdTimer == 0)
		{
			// ✅ GF-style alternate dancing
			if (animOffsets.exists('danceLeft') && animOffsets.exists('danceRight'))
			{
				isDancing = !isDancing;
				playAnim(isDancing ? 'danceLeft' : 'danceRight');
			}
			// ✅ Idle dance fallback
			else if (beat % 2 == 0 && (animation.finished && animation.name == 'idle' || animation.name != 'idle'))
			{
				playAnim('idle', true);
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (holdTimer > 0)
		{
			holdTimer -= elapsed;
			if (holdTimer <= 0)
			{
				holdTimer = 0;
				dance(beat);
			}
		}
	}

	// ✅ Clean up memory
	override function destroy()
	{
		super.destroy();
		animOffsets = null;
		json = null;
	}
}
