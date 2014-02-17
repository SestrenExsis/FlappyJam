package
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	
	import org.flixel.*;
	
	public class Entity extends FlxSprite
	{
		
		public var z:Number = 0;
		public var lastZ:Number = 0;
		public var velocityZ:Number = 0;
		public var accelerationZ:Number = 0;
		public var gravity:Number = 1000;
		
		protected var _lane:Number = 0;
		protected var _position:FlxPoint;
		
		public var layer:int = 0;
		
		public function Entity(X:Number, Y:Number)
		{
			super(X, Y);
			
			_position = new FlxPoint();
		}
		
		public function get position():FlxPoint
		{
			_position.x = x + 0.5 * width;
			_position.y = y + 0.5 * height;
			return _position;
		}
		
		override public function preUpdate():void
		{
			super.preUpdate();
			
			lastZ = z;
		}
		
		override public function update():void
		{	
			super.update();
			
			if (z <= 0)
			{
				z = 0;
				velocityZ = 0;
			}
			else
			{
				velocityZ -= gravity * FlxG.elapsed;
			}
			
			offset.y = z;
		}
		
		override protected function updateMotion():void
		{
			super.updateMotion();
			
			// Add the z-axis to our calculations.
			var velocityDelta:Number = (FlxU.computeVelocity(velocityZ, accelerationZ, 0, 10000) - velocityZ)/2;
			velocityZ += velocityDelta;
			var delta:Number = velocityZ*FlxG.elapsed;
			velocityZ += velocityDelta;
			z += delta;
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