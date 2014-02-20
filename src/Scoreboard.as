package
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	
	import org.flixel.*;
	
	public class Scoreboard extends FlxSprite
	{
		[Embed(source="../assets/images/numbers.png")] protected var imgNumbers:Class;
		
		public function Scoreboard()
		{
			super(0, 8);
			
			loadGraphic(imgNumbers, true, false, 20, 34);
			x = 0.5 * FlxG.width - 2 * frameWidth;
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
			//super.draw();
			
			// Draw the score to the screen
			var _numDigits:int = 1;
			for (var i:int = 1; i < 4; i++)
			{
				if (FlxG.score >= Math.pow(10, i))
					_numDigits++;
			}
			//var _drawZero:Boolean = false;
			var _digit:int;
			for (i = 0; i < 4; i++)
			{
				//_digit = FlxG.score / Math.pow(10, i) - (FlxG.score / (Math.pow(10, i + 1) * Math.pow(10, i + 1)));
				_digit = (FlxG.score / (int)(Math.pow(10, 3 - i))) % 10;
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