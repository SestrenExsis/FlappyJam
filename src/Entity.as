package
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	
	import org.flixel.*;
	
	public class Entity extends FlxSprite
	{	
		[Embed(source="../assets/images/bird.png")] protected var imgBird:Class;

		public var gravity:Number = 800;
		
		protected var _position:FlxPoint;
		
		public function Entity(X:Number, Y:Number)
		{
			super(X, Y);
			
			loadGraphic(imgBird, true, false, 32, 24);
			addAnimation("flap", [0,1], 2, true);
			play("flap");
			
			_position = new FlxPoint();
		}
		
		public function get position():FlxPoint
		{
			_position.x = x + 0.5 * width;
			_position.y = y + 0.5 * height;
			return _position;
		}
		
		override public function reset(X:Number, Y:Number):void
		{
			super.reset(X - width / 2, Y - height / 2);
		}
		
		override public function update():void
		{	
			super.update();
		}
		
		override public function destroy():void
		{
			super.destroy();
			
		}
		
		override public function draw():void
		{
			super.draw();
		}
	}
}