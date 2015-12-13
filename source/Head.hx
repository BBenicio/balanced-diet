package;

import flixel.addons.nape.FlxNapeSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.util.FlxPoint;
import nape.geom.Vec2;

/**
 * ...
 * @author 
 */
class Head extends FlxNapeSprite
{
	public static var Impulse:Float = 50;
	
	private var prevScale:FlxPoint;
	
	public function new(X:Float=0, Y:Float=0)
	{
		super(X, Y, null, false);
		loadGraphic(AssetPaths.head__png, true, 64, 64);
		
		createRectangularBody();
		setBodyMaterial(0);
		physicsEnabled = true;
		
		body.shapes.at(0).filter.collisionGroup = 1;
		
		animation.add("byte", [0, 1], 1);
		animation.play("byte");
	}
	
	public function move(mod:Float)
	{
		body.applyImpulse(new Vec2(Impulse * mod, 0));
	}
	
	override public function update():Void 
	{
		prevScale = scale;
		super.update();
		
		x = body.position.x - width / 2;
		y = body.position.y - height / 2;
		angle = body.rotation * 180 / Math.PI;
	}
}