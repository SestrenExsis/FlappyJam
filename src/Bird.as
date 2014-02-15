package
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	
	import org.flixel.*;
	
	public class Bird extends Entity
	{	
		[Embed(source="../assets/images/bird.png")] protected var imgBird:Class;
		
		public static const TOP_LANE:FlxPoint = new FlxPoint(64, 120);
		public static const BOTTOM_LANE:FlxPoint = new FlxPoint(86, 156);
		
		protected var _bob:Number = 0;
		protected var _bobSpeed:Number = 6;
		protected var _bobAmount:Number = 6;
		protected var _lane:Number = 0;
		
		public function Bird(X:Number, Y:Number)
		{
			super(X, Y);
			
			loadGraphic(imgBird, true, false, 32, 24);
			addAnimation("flap", [0,1], 8, true);
			play("flap");
			
			height = 12;
		}
		
		public function switchLane():void
		{
			if (_lane == 0)
			{
				_lane = 1;
				velocity.y = -200;
			}
			else
			{
				_lane = 0;
				velocity.y = 200;
			}
		}
		
		public function get bob():Number
		{
			_bob += _bobSpeed * FlxG.elapsed;
			if (_bob > 2 * Math.PI)
				_bob -= 2 * Math.PI;
			
			// Work in progress: While jumping, the bob should be gradually reduced to the "floor",
			// so that when the bird hits the ground, it will be at the lowest point in the bob.
			if (z > 0)
				_bob = FlxTween.linear(0, _bob, Math.PI, 0.2);
			return _bob;
		}
		
		override public function update():void
		{	
			super.update();
			
			if (y > BOTTOM_LANE.y)
			{
				x = BOTTOM_LANE.x;
				y = BOTTOM_LANE.y;
				velocity.y = 0;
				acceleration.y = 0;
			}
			else if (y < TOP_LANE.y)
			{
				x = TOP_LANE.x;
				y = TOP_LANE.y;
				velocity.y = 0;
				acceleration.y = 0;
			}
			
			var _laneProgress:Number = (y - TOP_LANE.y) / (BOTTOM_LANE.y - TOP_LANE.y);
			
			x = TOP_LANE.x + _laneProgress * (BOTTOM_LANE.x - TOP_LANE.x)
			offset.y += 24 + 0.5 * _bobAmount + _bobAmount * Math.cos(bob);
			
			if (z <= 0 && (FlxG.mouse.justPressed() || FlxG.keys.justPressed("UP")))
				velocityZ += 300;
			
			if (FlxG.keys.justPressed("DOWN"))
				switchLane();
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
			_flashPoint.x = x - offset.x;
			_flashPoint.y = y - height;
			
			FlxG.camera.buffer.copyPixels(_pixels, _flashRect, _flashPoint, null, null, true);
			
			_flashRect.x = _x;
			_flashRect.y = _y;
			_flashPoint.x = _xx;
			_flashPoint.y = _yy;
			
			super.draw();
		}
	}
}