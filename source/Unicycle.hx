package;

import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxG;
import flixel.util.FlxPoint;
import nape.geom.Vec2;
import flixel.util.FlxColor;
import flixel.FlxCamera;

/**
 * ...
 * @author 
 */
class Unicycle extends FlxNapeSprite
{	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y, null, false);
		//makeGraphic(64, 64, FlxColor.TRANSPARENT);
		loadGraphic(AssetPaths.unicycle__png);	
		
		createCircularBody(64 / 2);
		
		setBodyMaterial(0.001);
		physicsEnabled = true;
		
		body.shapes.at(0).filter.collisionGroup = 1;
	}
	
	override public function update():Void 
	{
		if (FlxG.keys.pressed.LEFT)
		{
			body.applyImpulse(new Vec2(-50, 0));
		}
		else if (FlxG.keys.pressed.RIGHT)
		{
			body.applyImpulse(new Vec2(50, 0));
		}
		
		super.update();
		
		x = body.position.x - width / 2;
		y = body.position.y - height / 2;
		angle = body.rotation * 180 / Math.PI;
	}
}