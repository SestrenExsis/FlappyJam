package
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	
	import org.flixel.*;
	
	public class Trophy extends FlxSprite
	{
		[Embed(source="../assets/images/trophies.png")] protected var imgTrophies:Class;
		
		public var timeBetweenSparkles:Number = 1;
		public var sparkleDuration:Number = 0.3;
		private var _sparkleProgress:Number = 0;
		private var _sparkleType:int = 0; //0, 1, 2, 3, 4, 5
		
		public function Trophy(X:Number, Y:Number, Animation:String)
		{
			super(X, Y);
			
			loadGraphic(imgTrophies, true, false, 32, 47);
			addAnimation("bronze",[1]);
			addAnimation("silver",[2]);
			addAnimation("gold",[3]);
			addAnimation("diamond",[4]);
			play(Animation);
		}
		
		public function showTrophy(Animation:String):void
		{
			visible = true;
			_sparkleProgress = 0;
			_sparkleType = 0;
			play(Animation);
		}
		
		override public function update():void
		{	
			super.update();
			_sparkleProgress += FlxG.elapsed;
			
			if (_sparkleProgress >= timeBetweenSparkles + sparkleDuration)
			{
				_sparkleProgress -= timeBetweenSparkles + sparkleDuration;
				_sparkleType = 0;
			}
			else if (_sparkleType == 0 && _sparkleProgress >= timeBetweenSparkles)
			{
				_sparkleType = (int)(FlxG.random() * 3) + 1;
			}
		}
		
		override public function destroy():void
		{
			super.destroy();
		}
		
		override public function draw():void
		{
			super.draw();
			// Draw sparkles
			if (_sparkleType > 0)
			{
				var _sparkleX:int = Math.floor((_sparkleProgress - timeBetweenSparkles) / 0.1);
				
				var _x:Number = _flashRect.x;
				var _y:Number = _flashRect.y;
				var _xx:Number = _flashPoint.x;
				var _yy:Number = _flashPoint.y;
				
				if (_sparkleX == 1)
					_flashRect.x = 96;
				else
					_flashRect.x = 64;
				
				_flashRect.y = _sparkleType * 47;
				_flashPoint.x = x;
				_flashPoint.y = y;
				
				FlxG.camera.buffer.copyPixels(_pixels, _flashRect, _flashPoint, null, null, true);
				
				_flashRect.x = _x;
				_flashRect.y = _y;
				_flashPoint.x = _xx;
				_flashPoint.y = _yy;
			}
			
		}
	}
}