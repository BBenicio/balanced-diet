package;

import flixel.addons.nape.FlxNapeSprite;
import flixel.group.FlxTypedGroup;
import nape.geom.AABB;
import nape.phys.BodyType;
import flixel.util.FlxColor;
import flixel.util.FlxRandom;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

/**
 * ...
 * @author 
 */
class Food extends FlxNapeSprite
{
	private var group:FlxTypedGroup<Food>;
	private var destroying:Bool = false;
	public var eaten:Bool = false;
	
	public function new(X:Float=0, Y:Float=0, Group:FlxTypedGroup<Food>) 
	{
		super(X, Y, null, false);
		
		group = Group;
		
		//makeGraphic(32, 32, FlxColor.TRANSPARENT);
		loadGraphic("assets/images/food" + FlxRandom.intRanged(1, 4) + ".png");
		
		createRectangularBody(0, 0, BodyType.STATIC);
		physicsEnabled = true;
		
		body.shapes.at(0).filter.collisionGroup = 2;
		body.shapes.at(0).filter.collisionMask = 0;
		
		scale.set();
		FlxTween.tween(scale, { x: 1, y: 1 }, 0.4, { type: FlxTween.ONESHOT, ease: FlxEase.elasticInOut } );
	}
	
	public function overlapsAABB(bounds:AABB):Bool
	{
		var ttl = body.bounds.min;
		var tbr = body.bounds.max;
		var otl = bounds.min;
		var obr = bounds.max;
		
		return ttl.x <= obr.x && tbr.x >= otl.x && ttl.y <= obr.y && tbr.y >= otl.y;
	}
	
	override public function destroy():Void 
	{
		if (!destroying)
		{
			destroying = true;
			FlxTween.tween(scale, { x: 0, y: 0 }, eaten ? 0.2 : 0.4, { type: FlxTween.ONESHOT, ease: FlxEase.elasticInOut, complete: die } );
		}
	}
	
	private function die(T:FlxTween):Void
	{
		super.destroy();
		group.remove(this, true);
		group = null;
	}
}