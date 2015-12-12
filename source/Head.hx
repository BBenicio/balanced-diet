package;

import flixel.addons.nape.FlxNapeSprite;
import flixel.util.FlxColor;
import flixel.FlxG;

/**
 * ...
 * @author 
 */
class Head extends FlxNapeSprite
{
	public function new(X:Float=0, Y:Float=0)
	{
		super(X, Y, null, false);
		//makeGraphic(64, 64, FlxColor.TRANSPARENT);
		loadGraphic(AssetPaths.head__png, true, 64, 64);
		
		createRectangularBody();
		setBodyMaterial(0);
		physicsEnabled = true;
		
		body.shapes.at(0).filter.collisionGroup = 1;
		
		animation.add("byte", [0, 1], 1);
		animation.play("byte");
	}
	
	override public function update():Void 
	{
		super.update();
		
		x = body.position.x - width / 2;
		y = body.position.y - height / 2;
		angle = body.rotation * 180 / Math.PI;
	}
}