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
	public static var Impulse:Float = 50;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y, null, false);
		loadGraphic(AssetPaths.unicycle__png);	
		
		createCircularBody(64 / 2);
		
		setBodyMaterial(0.001);
		physicsEnabled = true;
		
		body.shapes.at(0).filter.collisionGroup = 1;
	}
	
	public function move(mod:Float)
	{
		body.applyImpulse(new Vec2(Impulse * mod, 0));
	}
	
	override public function update():Void 
	{super.update();
		
		x = body.position.x - width / 2;
		y = body.position.y - height / 2;
		angle = body.rotation * 180 / Math.PI;
	}
}