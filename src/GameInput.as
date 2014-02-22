package
{
	import org.flixel.*;
	
	public class GameInput
	{
		public static var action:int;
		public static var bufferedInput:Array = [-1, -1, -1, -1];
		public static var bufferPos:int = 0;
		public static var mouseClicked:int = -1;
		public static var mouseActive:Boolean = false;
		public static var mouseLastPos:FlxPoint = new FlxPoint();
		public static var keyPressed:int = -1;
		public static var enabled:Boolean = false;
		
		// Actions
		public static const NONE:int = -1;
		public static const SWITCH_LANE:int = 0;
		public static const JUMP:int = 1;
		public static const START:int = 2;
		
		public function GameInput()
		{
			super();
		}
		
		public static function update():void
		{
			action = NONE;
			mouseClicked = NONE;
			keyPressed = NONE;
			mouseActive = (FlxG.mouse.screenX != mouseLastPos.x || FlxG.mouse.screenY != mouseLastPos.y) ? true : false;
			
			var _click:Boolean = FlxG.mouse.justPressed();
			var _jump:Boolean = FlxG.keys.justPressed("SPACE");
			var _switch:Boolean = FlxG.keys.justPressed("CONTROL");
			
			if (enabled)
			{
				var _desiredLane:int;
				if (FlxG.mouse.screenY <= 0.5 * (FlxG.height + GameScreen.SCREEN_OFFSET_Y))
					_desiredLane = 0;
				else _desiredLane = 1;
				
				if (_click)
					mouseClicked = JUMP;
				else if (mouseActive && _desiredLane != Bird.currentLane)
					mouseClicked = SWITCH_LANE;
				
				if (_jump) keyPressed = JUMP;
				else if (_switch) keyPressed = SWITCH_LANE;
			}
			else if (_click)
				mouseClicked = START;
			else if (_jump || _switch)
				keyPressed = START;
			
			if (mouseClicked > NONE)
				action = mouseClicked;
			else
				action = keyPressed;
			
			bufferPos = (bufferPos >= bufferedInput.length) ? 0 : bufferPos++;
			bufferedInput[bufferPos] = action;
			
			mouseLastPos.make(FlxG.mouse.screenX, FlxG.mouse.screenY);
		}
		
		public static function bufferedJump():Boolean
		{
			var _index:int;
			for (var i:int = 0; i < bufferedInput.length; i++)
			{
				_index = bufferPos - i;
				if (_index < 0)
					_index += bufferedInput.length;
				
				if (bufferedInput[_index] == JUMP)
					return true;
			}
			return false;
		}
	}
}
