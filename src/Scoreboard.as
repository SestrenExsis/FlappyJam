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
			super(0.5 * FlxG.width - 20, 8);
			
			loadGraphic(imgNumbers, true, false, 10, 17);
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
			var _drawZero:Boolean = false;
			var _digit:int;
			for (var i:int = 0; i < 4; i++)
			{
				//_digit = FlxG.score / Math.pow(10, i) - (FlxG.score / (Math.pow(10, i + 1) * Math.pow(10, i + 1)));
				_digit = (FlxG.score / (int)(Math.pow(10, 3 - i))) % 10;
				if (_digit > 0 || i == 3)
					_drawZero = true;
				if (_drawZero)
				{
					_flashRect.x = 10 * _digit;
					_flashRect.y = 0;
					_flashPoint.x = x + 10 * i;
					_flashPoint.y = y;
					
					FlxG.camera.buffer.copyPixels(_pixels, _flashRect, _flashPoint, null, null, true);
				}
			}
		}
	}
}