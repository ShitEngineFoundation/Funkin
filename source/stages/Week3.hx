package stages;

import flixel.FlxG;
import flixel.sound.FlxSound;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import shaderslmfao.BuildingShaders;

class Week3 extends BaseStage
{
	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;
	var lightFadeShader:BuildingShaders;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	override function create()
	{
		var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky'));
		bg.scrollFactor.set(0.1, 0.1);
		add(bg);

		var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city'));
		city.scrollFactor.set(0.3, 0.3);
		city.setGraphicSize(Std.int(city.width * 0.85));
		city.updateHitbox();
		add(city);

		lightFadeShader = new BuildingShaders();
		phillyCityLights = new FlxTypedGroup<FlxSprite>();

		add(phillyCityLights);

		for (i in 0...5)
		{
			var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i));
			light.scrollFactor.set(0.3, 0.3);
			light.visible = false;
			light.setGraphicSize(Std.int(light.width * 0.85));
			light.updateHitbox();
			light.antialiasing = true;
			light.shader = lightFadeShader.shader;
			phillyCityLights.add(light);
		}

		var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain'));
		add(streetBehind);

		phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train'));
		add(phillyTrain);

		trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
		FlxG.sound.list.add(trainSound);

		// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

		var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street'));
		add(street);
	}

	override function beatHit(curBeat:Int = 0)
	{
		super.beatHit(curBeat);
		if (!trainMoving)
			trainCooldown += 1;

		if (curBeat % 4 == 0)
		{
			lightFadeShader.reset();

			phillyCityLights.forEach(function(light:FlxSprite)
			{
				light.visible = false;
			});

			curLight = FlxG.random.int(0, phillyCityLights.length - 1);

			phillyCityLights.members[curLight].visible = true;
			// phillyCityLights.members[curLight].alpha = 1;
		}

		if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
		{
			trainCooldown = FlxG.random.int(-4, 0);
			trainStart();
		}
	}

	var curLight:Int = 0;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (trainMoving)
		{
			trainFrameTiming += elapsed;

			if (trainFrameTiming >= 1 / 24)
			{
				updateTrainPos();
				trainFrameTiming = 0;
			}
		}

		lightFadeShader.update((Conductor.crochet / 1000) * FlxG.elapsed * 1.5);
	}
}
