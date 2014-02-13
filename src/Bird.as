package
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	
	import org.flixel.*;
	
	public class Bird extends Entity
	{	
		[Embed(source="../assets/images/bird.png")] protected var imgBird:Class;

		protected var _bob:Number = 0;
		protected var _bobSpeed:Number = 6;
		protected var _bobAmount:Number = 6;
		
		public function Bird(X:Number, Y:Number)
		{
			super(X, Y);
			
			loadGraphic(imgBird, true, false, 32, 24);
			addAnimation("flap", [0,1], 4, true);
			play("flap");
		}
		
		public function get bob():Number
		{
			_bob += _bobSpeed * FlxG.elapsed;
			if (_bob > 2 * Math.PI)
				_bob -= 2 * Math.PI;
			
			// Work in progress: While jumping, the bob should be gradually reduced to the "floor",
			// so that when the bird hits the ground, it will be at the lowest point in the bob.
			if (z > 0)
				_bob = FlxTween.linear(0, _bob, 0, 0.1);
			return _bob;
		}
		
		override public function update():void
		{	
			super.update();
			
			offset.y += 0.5 * _bobAmount + _bobAmount * Math.cos(bob);
			
			if (z <= 0 && FlxG.mouse.justPressed())
				velocityZ += 300;
		}
		
		override public function draw():void
		{
			// Draw shadow
			var _x:Number = _flashRect.x;
			var _y:Number = _flashRect.y;
			var _xx:Number = _flashPoint.x;
			var _yy:Number = _flashPoint.y;
			
			_flashRect.x = 64;
			_flashRect.y = 0;
			_flashPoint.x = x;
			_flashPoint.y = y + 0.5 * height;
			
			FlxG.camera.buffer.copyPixels(_pixels, _flashRect, _flashPoint, null, null, true);
			
			_flashRect.x = _x;
			_flashRect.y = _y;
			_flashPoint.x = _xx;
			_flashPoint.y = _yy;
			
			super.draw();
		}
	}
}