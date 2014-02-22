package
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	
	import org.flixel.*;
	
	public class Scoreboard extends FlxSprite
	{
		[Embed(source="../assets/images/numbers.png")] protected var imgNumbers:Class;
		
		public var tallyInterval:Number = 0;
		private var tallyProgress:Number = 0;
		public var score:int = 0;
		public var targetScore:int = 0;
		
		public function Scoreboard(X:Number, Y:Number)
		{
			super(X, Y);
			
			loadGraphic(imgNumbers, true, false, 20, 34);
		}
		
		override public function update():void
		{	
			super.update();
			
			if (tallyInterval > 0 && score < targetScore)
			{
				tallyProgress += FlxG.elapsed;
				if (tallyProgress >= tallyInterval)
				{
					tallyProgress -= tallyInterval;
					score++;
					FlxG.log(score);
				}
			}
		}
		
		override public function destroy():void
		{
			super.destroy();
		}
		
		override public function draw():void
		{
			//super.draw();
			
			// Draw the score to the screen
			var _numDigits:int = 1;
			for (var i:int = 1; i < 4; i++)
			{
				if (score >= Math.pow(10, i))
					_numDigits++;
			}
			var _digit:int;
			for (i = 0; i < 4; i++)
			{
				_digit = (score / (int)(Math.pow(10, 3 - i))) % 10;
				if (4 - i <= _numDigits)
				{
					_flashRect.x = frameWidth * _digit;
					_flashRect.y = 0;
					_flashPoint.x = x + frameWidth * (i - 0.5 * (4 - _numDigits));
					_flashPoint.y = y;
					
					FlxG.camera.buffer.copyPixels(_pixels, _flashRect, _flashPoint, null, null, true);
				}
			}
		}
	}
}