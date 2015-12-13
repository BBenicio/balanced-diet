package;

import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.group.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.constraint.DistanceJoint;
import nape.phys.BodyType;
import flixel.util.FlxRandom;
import flixel.FlxCamera;
import flixel.util.FlxTimer;
import flixel.util.FlxDestroyUtil;

using flixel.util.FlxSpriteUtil;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxNapeState
{
	private static inline var LEVEL_LEFT:Float = -1600;
	private static inline var LEVEL_RIGHT:Float = 2400;
	
	private var unicycle:Unicycle;
	private var head:Head;
	private var joint:DistanceJoint;
	
	private var newFoodTimer:FlxTimer;
	
	private var foodGroup:FlxTypedGroup<Food>;
	private var scoreText:FlxText;
	
	private var buildings:FlxSprite;
	private var bgTint:FlxSprite;
	private var ground:FlxSprite;
	
	private var leftWall:FlxNapeSprite;
	private var rightWall:FlxNapeSprite;
	
	private var score:Int = 0;
	
	private var fallenTime:Float = 0;
	
	private var wallHit:FlxSound;
	private var eat:FlxSound;
	
	private static var CB_WALL:CbType = new CbType();
	private static var CB_HEAD:CbType = new CbType();
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		FlxG.camera.antialiasing = true;
		
		super.create();
		
		buildings = new FlxSprite(0, 0, AssetPaths.buildings__png);
		buildings.scrollFactor.set(0.05, 1);
		buildings.x = FlxG.width - buildings.width - 30;
		buildings.y = FlxG.height - buildings.height + 5;
		
		bgTint = new FlxSprite(LEVEL_LEFT, 0);
		bgTint.scrollFactor.set(0, 0);
		bgTint.makeGraphic(FlxG.width, FlxG.height, 0x6500b6b6);
		
		createWalls(LEVEL_LEFT - 500, 0, LEVEL_RIGHT + 500, FlxG.height);
		
		ground = new FlxSprite(LEVEL_LEFT, FlxG.height, AssetPaths.ground__png);
		
		leftWall = new FlxNapeSprite(LEVEL_LEFT - 77, FlxG.height - 200, AssetPaths.wall__png, false);
		leftWall.createRectangularBody(0, 0, BodyType.STATIC);
		leftWall.physicsEnabled = true;
		leftWall.body.cbTypes.add(CB_WALL);
		
		rightWall = new FlxNapeSprite(LEVEL_RIGHT + 77, FlxG.height - 200, AssetPaths.wall__png, false);
		rightWall.createRectangularBody(0, 0, BodyType.STATIC);
		rightWall.physicsEnabled = true;
		rightWall.body.cbTypes.add(CB_WALL);
		
		unicycle = new Unicycle(400, 366);
		head = new Head(400, 366 - 64 - 2);
		head.body.cbTypes.add(CB_HEAD);
		
		joint = new DistanceJoint(unicycle.body, head.body, unicycle.body.localCOM, head.body.localCOM, 64 + 2, 64 + 2);
		joint.space = FlxNapeState.space;
		
		FlxNapeState.space.gravity.setxy(0, 500);
		
		scoreText = new FlxText(0, 30, 0, "0", 96);
		scoreText.alignment = "center";
		scoreText.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.BLACK, 8, 1);
		scoreText.scrollFactor.set();
		scoreText.screenCenter(true, false);
		
		foodGroup = new FlxTypedGroup<Food>();
		newFood(); newFood(); newFood();
		
		newFoodTimer = new FlxTimer(6, newFood, 0);
		
		add(buildings);
		add(bgTint);
		add(ground);
		
		add(leftWall);
		add(rightWall);
		
		add(scoreText);
		add(foodGroup);
		add(unicycle);
		add(head);
		
		wallHit = FlxG.sound.load(AssetPaths.wall__wav);
		eat = FlxG.sound.load(AssetPaths.eat__wav, 0.3);
		
		FlxNapeState.space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, CB_HEAD, CB_WALL, head_wall_collision));
		
		FlxG.camera.follow(head, FlxCamera.STYLE_PLATFORMER, null, 10);
	}
	
	function head_wall_collision(i:InteractionCallback):Void
	{
		wallHit.play();
		score -= 5;
		if (score < 0)
		{
			score = 0;
		}
		scoreText.text = "" + score;
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
		
		return FlxRandom.chanceRoll() ? FlxRandom.floatRanged(min, head.x - 40) : FlxRandom.floatRanged(head.x + 40, max);
	}
	
	function newFood(?T:FlxTimer):Void
	{
		foodGroup.add(new Food(getRandomX(), 310, foodGroup));
		
		if (foodGroup.length > 10)
		{
			var first:Food = foodGroup.getFirstAlive();
			if (first != null)
			{
				first.destroy();
			}
		}
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		newFoodTimer.cancel();
		unicycle = FlxDestroyUtil.destroy(unicycle);
		head = FlxDestroyUtil.destroy(head);
		joint = null;
		foodGroup = FlxDestroyUtil.destroy(foodGroup);
		scoreText = FlxDestroyUtil.destroy(scoreText);
		buildings = FlxDestroyUtil.destroy(buildings);
		bgTint = FlxDestroyUtil.destroy(bgTint);
		ground = FlxDestroyUtil.destroy(ground);
		leftWall = FlxDestroyUtil.destroy(leftWall);
		rightWall = FlxDestroyUtil.destroy(rightWall);
		
		wallHit = FlxDestroyUtil.destroy(wallHit);
		eat = FlxDestroyUtil.destroy(eat);
		
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
			if (!food.eaten && food.overlapsAABB(head.body.bounds))
			{
				eat.play(true);
				
				food.eaten = true;
				food.destroy();
				
				newFood();
				head.body.mass += head.body.mass * 0.01;
				head.scale.add(0.01, 0.01);
				scoreText.text = ++score + "";
			}
		});
		
		super.update();
	}
}