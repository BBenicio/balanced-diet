package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

using flixel.util.FlxSpriteUtil;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{	
	public static var Best:Int = 0;
	public static var Last:Int = 0;
	
	private var title:FlxText;
	private var controls:FlxText;
	//private var sound:FlxButton;
	private var score:FlxText;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		FlxG.camera.bgColor = 0xff50a0cc;
		
		title = new FlxText(0, 80, 0, "Balanced Diet", 64);
		title.screenCenter(true, false);
		
		controls = new FlxText(0, FlxG.height - 80, 0, "hit Any key to play\nuse Left/Right to move", 16);
		controls.screenCenter(true, false);
		controls.alignment = "center";
		
		score = new FlxText(0, 0, 0, "Best Score: " + Best + "\nLast Score: " + Last, 8);
		
		add(title);
		add(controls);
		add(score);
		
		super.create();
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
		if (FlxG.keys.pressed.ANY)
		{
			FlxG.switchState(new PlayState());
		}
		
		super.update();
	}	
}