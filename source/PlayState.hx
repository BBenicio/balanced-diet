package;

import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import nape.callbacks.CbEvent;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.constraint.DistanceJoint;
import nape.constraint.MotorJoint;
import nape.phys.BodyType;
import flixel.util.FlxRandom;
import flixel.FlxCamera;
import flixel.util.FlxTimer;

using flixel.util.FlxSpriteUtil;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxNapeState
{
	private static inline var LEVEL_LEFT:Float = -800;
	private static inline var LEVEL_RIGHT:Float = 1600;
	
	//private var ground:FlxNapeSprite;
	private var unicycle:Unicycle;
	private var head:Head;
	private var joint:DistanceJoint;
	
	private var newFoodTimer:FlxTimer;
	
	private var foodGroup:FlxTypedGroup<Food>;
	private var scoreText:FlxText;
	
	
	private var score:Int = 0;
	
	private var fallenTime:Float = 0;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		FlxG.camera.antialiasing = true;
		
		super.create();
		napeDebugEnabled = true;
		
		createWalls(LEVEL_LEFT, 0, LEVEL_RIGHT, FlxG.height - 20);
		
		unicycle = new Unicycle(400, 346);
		//head = new Head(400, 346 - 64 - 16);
		head = new Head(400, 346 - 64);
		
		//joint = new DistanceJoint(unicycle.body, head.body, unicycle.body.localCOM, head.body.localCOM, 64 + 10, 64 + 10);
		joint = new DistanceJoint(unicycle.body, head.body, unicycle.body.localCOM, head.body.localCOM, 64, 64);
		joint.space = FlxNapeState.space;
		
		FlxNapeState.space.gravity.setxy(0, 500);
		
		scoreText = new FlxText(0, 40, 0, "0", 96);
		scoreText.scrollFactor.set();
		scoreText.screenCenter(true, false);
		
		foodGroup = new FlxTypedGroup<Food>();
		newFood(); newFood(); newFood();
		
		newFoodTimer = new FlxTimer(6, newFood, 0);
		
		add(scoreText);
		add(foodGroup);
		add(unicycle);
		add(head);
		
		FlxG.camera.follow(head, FlxCamera.STYLE_PLATFORMER, null, 10);
	}
	
	function getRandomX():Float
	{
		var min:Float = head.x - 360;
		if (min < LEVEL_LEFT)
		{
			min = LEVEL_LEFT + 64;
		}
		var max:Float = head.x + 360;
		if (max > LEVEL_RIGHT)
		{
			max = LEVEL_RIGHT - 64;
		}
		return FlxRandom.floatRanged(min, max);
	}
	
	function newFood(?T:FlxTimer):Void
	{
		foodGroup.add(new Food(getRandomX(), 250));
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		newFoodTimer.cancel();
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		if (head.y > 310)
		{
			fallenTime += FlxG.elapsed;
			if (fallenTime >= 1.5)
			{
				// Game Over
				MenuState.Last = score;
				if (MenuState.Best < score)
				{
					MenuState.Best = score;
				}
				FlxG.switchState(new MenuState());
			}
			
			super.update();
			return;
		}
		
		if (FlxG.keys.justPressed.R)
		{
			FlxG.resetState();
		}
		
		if (FlxG.keys.pressed.LEFT)
		{
			unicycle.move(-1);
		}
		else if (FlxG.keys.pressed.RIGHT)
		{
			unicycle.move(1);
		}
		
		foodGroup.forEachAlive(function (food:Food)
		{
			if (food.overlapsAABB(head.body.bounds))
			{
				food.destroy();
				foodGroup.remove(food);
				
				newFood();
				head.body.mass += head.body.mass * 0.01;
				head.scale.add(0.01, 0.01);
				scoreText.text = ++score + "";
			}
		});
		
		super.update();
	}
	
	override public function draw():Void 
	{
		
		super.draw();
	}
}