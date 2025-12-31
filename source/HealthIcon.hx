package;

import flixel.FlxSprite;

using StringTools;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	var char:String = '';
	var isPlayer:Bool = false;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();

		this.isPlayer = isPlayer;

		changeIcon(char);
		antialiasing = true;
		scrollFactor.set();
	}

	public var isOldIcon:Bool = false;

	public function swapOldIcon():Void
	{
		isOldIcon = !isOldIcon;

		if (isOldIcon)
			changeIcon('bf-old');
		else
			changeIcon(PlayState.SONG.player1);
	}

	public var baseScale:Float = 1;
	public var bopScaleMult:Float = 1.2;
	public var bopLerp:Float = 10;

	public function bump()
	{
		scale.set(baseScale * bopScaleMult, baseScale * bopScaleMult);
		updateHitbox();
	}

	public function updateBump()
	{
		scale.set(CoolUtil.fpsLerp(baseScale, scale.x, bopLerp), CoolUtil.fpsLerp(baseScale, scale.y, bopLerp));
		updateHitbox();
	}

	public function changeIcon(newChar:String):Void
	{
		if (newChar != 'bf-pixel' && newChar != 'bf-old' && newChar != 'bf-holding-gf')
			newChar = newChar.split('-')[0].trim();

		if (newChar != char)
		{
			if (animation.getByName(newChar) == null)
			{
				loadGraphic(Paths.image('icons/icon-' + newChar));
				loadGraphic(Paths.image('icons/icon-' + newChar), true, Math.floor(width / 2), Math.floor(height));
				animation.add(newChar, [0, 1], 0, false, isPlayer);
			}
			animation.play(newChar);
			char = newChar;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
