package objects;

import flixel.FlxSprite;

class Strum extends FlxSprite
{
	public var data:Int = 0;

	public static var directions:Array<String> = ['Left', 'Down', 'Up', 'Right'];

	public function reloadSkin(?texture:String = "default", pixel:Bool = false)
	{
		var path = 'game/notes/$texture';
		if (pixel)
			path = StringTools.replace(path, 'notes/', 'notes/pixel/');
		antialiasing = !pixel;

		var openFLPath = Paths.image(path);
		var dir = directions[data % directions.length];

		if (pixel)
		{
			loadGraphic(Paths.getGraphic(openFLPath), true, 17, 17);
			animation.add('static', [data % 4], 12);
			animation.add('confirm', [data + 12, 14], 12, false);
			animation.add('pressed', [data + 4, data + 8], 12, false);
			playAnim("static", true);
			scale.set(6, 6);
			updateHitbox();
		}
		else
		{
			frames = Paths.getSparrowAtlas(path);
			animation.addByPrefix("static", 'arrow' + dir.toUpperCase(), 24);
            dir = dir.toLowerCase();
			animation.addByPrefix("confirm", '$dir confirm', 24, false);
			animation.addByPrefix("pressed", '$dir press', 24, false);
			playAnim("static");
			scale.set(0.7, 0.7);
			updateHitbox();
		}
		playAnim("static", true);
	}

	public function playAnim(anim:String, ?force:Bool = true)
	{
		animation.play(anim, force);
		centerOffsets();
		centerOrigin();
	}
}
