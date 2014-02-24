package
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import org.flixel.*;
	
	public class ScrollingSprite extends FlxSprite
	{
		[Embed(source="../assets/images/background.png")] public var imgBackground:Class;
		
		public var scrollPosition:FlxPoint;
		public var scrollSpeed:FlxPoint;
		
		public var maskWidth:Number;
		public var maskHeight:Number;
		
		public function ScrollingSprite(X:Number, Y:Number, SourceRect:Rectangle, ScrollSpeedX:Number, ScrollSpeedY:Number)
		{
			super(X, Y);
			
			loadGraphic(imgBackground, true, false, 640, 360);
			resetFramePixels(SourceRect);
			
			scrollPosition = new FlxPoint();
			scrollSpeed = new FlxPoint(ScrollSpeedX, ScrollSpeedY);
			maskWidth = frameWidth;
			maskHeight = frameHeight;
		}
		
		public function resetFramePixels(SourceRect:Rectangle):void
		{
			if((framePixels == null) || (framePixels.width != SourceRect.width) || (framePixels.height != SourceRect.height))
				framePixels = new BitmapData(SourceRect.width, SourceRect.height);
			_flashRect.x = SourceRect.x;
			_flashRect.y = SourceRect.y;
			_flashRect.width = SourceRect.width;
			_flashRect.height = SourceRect.height;
			framePixels.copyPixels(pixels, _flashRect, _flashPointZero, null, null, false);
			frameWidth = framePixels.width;
			frameHeight = framePixels.height;
		}
		
		override public function update():void
		{
			super.update();
			
			scrollPosition.x += scrollSpeed.x * GameScreen.scrollSpeed;
			scrollPosition.y += scrollSpeed.y * GameScreen.scrollSpeed;
			if (scrollPosition.x >= frameWidth)
				scrollPosition.x -= frameWidth;
			else if (scrollPosition.x < 0)
				scrollPosition.x += frameWidth;
			
			if (scrollPosition.y >= frameHeight)
				scrollPosition.y -= frameHeight;
			else if (scrollPosition.y < 0)
				scrollPosition.y += frameHeight;
		}
		
		override public function draw():void
		{
			// Draw the scrolling background in 1, 2, or 4 pieces depending on scrolling position.
			var _scrollX:Number = Math.floor(scrollPosition.x);
			var _scrollY:Number = Math.floor(scrollPosition.y);
			var _diffX:Number = Math.max(_scrollX - (frameWidth - maskWidth), 0);
			var _diffY:Number = Math.max(_scrollY - (frameHeight - maskHeight), 0);
			
			// Draw the upper-left quadrant of the scrolling background.
			_flashRect.x = _scrollX;
			_flashRect.y = _scrollY;
			_flashRect.width = maskWidth - _diffX;
			_flashRect.height = maskHeight - _diffY;
			_flashPoint.x = x;
			_flashPoint.y = y;
			FlxG.camera.buffer.copyPixels(framePixels, _flashRect, _flashPoint, null, null, true);
			
			// Split the background in half along the x-axis and/or y-axis if the scrollPosition is far enough along
			
			// Draw the upper-right quadrant of the scrolling background.
			if (_diffX > 0)
			{
				_flashRect.x = 0;
				_flashRect.y = _scrollY;
				_flashRect.width = _diffX;
				_flashRect.height = maskHeight - _diffY;
				_flashPoint.x = x + maskWidth - _diffX;
				_flashPoint.y = y;
				FlxG.camera.buffer.copyPixels(framePixels, _flashRect, _flashPoint, null, null, true);
			}
			
			// Draw the lower-left quadrant of the scrolling background.
			if (_diffY > 0)
			{
				_flashRect.x = _scrollX;
				_flashRect.y = 0;
				_flashRect.width = frameWidth - _diffX;
				_flashRect.height = _diffY;
				_flashPoint.x = x;
				_flashPoint.y = y + maskHeight - _diffY;
				FlxG.camera.buffer.copyPixels(framePixels, _flashRect, _flashPoint, null, null, true);
			}
			
			// Draw the lower-right quadrant of the scrolling background.
			if (_diffX > 0 && _diffY > 0)
			{
				_flashRect.x = 0;
				_flashRect.y = 0;
				_flashRect.width = _diffX;
				_flashRect.height = _diffY;
				_flashPoint.x = x + maskWidth - _diffX;
				_flashPoint.y = y + maskHeight - _diffY;
				FlxG.camera.buffer.copyPixels(framePixels, _flashRect, _flashPoint, null, null, true);
			}
			
			if(FlxG.visualDebug && !ignoreDrawDebug)
				drawDebug(FlxG.camera);
		}
	}
}