package;

import flixel.addons.nape.FlxNapeSprite;
import nape.geom.AABB;
import nape.phys.BodyType;
import flixel.util.FlxColor;
import flixel.util.FlxRandom;

/**
 * ...
 * @author 
 */
class Food extends FlxNapeSprite
{

	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y, null, false);
		
		//makeGraphic(32, 32, FlxColor.TRANSPARENT);
		loadGraphic("assets/images/food" + FlxRandom.intRanged(1, 4) + ".png");
		
		createRectangularBody(0, 0, BodyType.STATIC);
		physicsEnabled = true;
		
		body.shapes.at(0).filter.collisionGroup = 2;
		body.shapes.at(0).filter.collisionMask = 0;
	}
	
	public function overlapsAABB(bounds:AABB):Bool
	{
		var ttl = body.bounds.min;
		var tbr = body.bounds.max;
		var otl = bounds.min;
		var obr = bounds.max;
		
		return ttl.x <= obr.x && tbr.x >= otl.x && ttl.y <= obr.y && tbr.y >= otl.y;
	}
	
}