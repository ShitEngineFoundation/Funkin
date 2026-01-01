package stages;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.group.FlxGroup;

@:access(PlayState)
class BaseStage extends FlxBasic
{
	public var dad(get, null):Character;
	public var bf(get, null):Character;
	public var gf(get, null):Character;

	public function get_dad():Character
		return PlayState.instance?.dad;

	public function get_gf():Character
		return PlayState.instance?.gf;

	public function get_bf():Character
		return PlayState.instance?.boyfriend;

	public function add(b:FlxBasic)
	{
		return FlxG.state.add(b);
	}

	public function remove(b:FlxBasic, splice = false)
	{
		return FlxG.state.remove(b, splice);
	}

	public function insert(b:FlxBasic, index:Int)
	{
		return FlxG.state.insert(index, b);
	}

	public function new()
	{
		super();
	}

	public function beatHit(beat:Int = 0) {}

	public function stepHit(beat:Int = 0) {}

	public function sectionHit(section:Int = 0) {}

	public function create() {}

	public function createPost() {}
}
