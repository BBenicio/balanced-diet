package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.nape.FlxNapeState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import nape.constraint.DistanceJoint;
import flixel.plugin.MouseEventManager;

using flixel.util.FlxSpriteUtil;

/**
 * A FlxState which can be used for the game's menu.
 */
//class MenuState extends FlxState
class MenuState extends FlxNapeState
{
	public static var Best:Int = 0;
	public static var Last:Int = 0;
	
	private var title:FlxText;
	private var controls:FlxText;
	private var sound:FlxSprite;
	private var score:FlxText;
	private var buildings:FlxSprite;
	private var bgTint:FlxSprite;
	private var ground:FlxSprite;
	
	private var unicycle:Unicycle;
	private var joint:DistanceJoint;
	
	private var unicycleImpulseInterval:Float = 0;
	
	private var music:FlxSound;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		#if flash
		music = FlxG.sound.load(AssetPaths.background__mp3, 0.25, true, false, true);
		#else
		music = FlxG.sound.load(AssetPaths.background__ogg, 0.25, true, false, true);
		#end
		
		FlxG.camera.antialiasing = true;
		FlxG.camera.bgColor = 0xff50a0cc;
		
		buildings = new FlxSprite(0, 0, AssetPaths.buildings__png);
		buildings.x = FlxG.width - buildings.width - 30;
		buildings.y = FlxG.height - buildings.height - 100;
		
		bgTint = new FlxSprite(0, 0);
		bgTint.makeGraphic(FlxG.width, FlxG.height, 0x6500b6b6);
		
		ground = new FlxSprite(0, 0);
		ground.loadGraphic(AssetPaths.ground__png, false, FlxG.width, 0);
		ground.y = FlxG.height - 100;
		
		title = new FlxText(0, 80, 0, "Balanced Diet", 64);
		title.screenCenter(true, false);
		
		controls = new FlxText(0, FlxG.height - 80, 0, "hit Any key to play\nuse Left/Right to move", 16);
		controls.screenCenter(true, false);
		controls.alignment = "center";
		
		score = new FlxText(0, 0, 0, "Best Score: " + Best + "\nLast Score: " + Last, 8);
		
		sound = new FlxSprite(0, 0);
		sound.loadGraphic(AssetPaths.sound__png, true, 40, 50);
		if (FlxG.sound.muted)
		{
			sound.animation.frameIndex = 1;
		}
		sound.x = FlxG.width - sound.width - 10;
		MouseEventManager.add(sound, function (S:FlxSprite)
		{
			sound.animation.frameIndex += 1;
			sound.animation.frameIndex %= 2;
			FlxG.sound.muted = !FlxG.sound.muted;
		});
		
		FlxG.sound.muteKeys = null;
		FlxG.sound.soundTrayEnabled = false;
		FlxG.sound.volumeDownKeys = null;
		FlxG.sound.volumeUpKeys = null;
		
		super.create();
		
		add(buildings);
		add(bgTint);
		add(ground);
		
		initUnicycle();
		
		add(title);
		add(controls);
		add(score);
		add(sound);
	}
	
	function initUnicycle():Void
	{
		unicycle = new Unicycle(-128, 236);
		createWalls( -192, 0, FlxG.width * 2, FlxG.height - 100);
		
		FlxNapeState.space.gravity.setxy(0, 500);
		add(unicycle);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		if (FlxG.keys.justPressed.ANY)
		{
			FlxG.switchState(new PlayState());
		}
		else if ((unicycleImpulseInterval += FlxG.elapsed) >= 0.64)
		{
			unicycle.move(1);
			unicycleImpulseInterval = 0;
		}
		
		super.update();
		
		if (unicycle.x > FlxG.width * 2 - 64)
		{
			unicycle.body.position.x = -unicycle.width * 2;
		}
	}	
}