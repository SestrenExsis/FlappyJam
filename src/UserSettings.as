package
{
	import org.flixel.*;
	
	public class UserSettings
	{
		private static var _save:FlxSave;
		private static var _tempBestScore:int;
		private static var _loaded:Boolean = false;
		
		public static function get bestScore():int
		{
			if (_loaded) return _save.data.fewestActions;
			else return _tempBestScore;
		}
		
		public static function set bestScore(Value:int):void
		{
			if (_loaded) _save.data.bestScore = Value;
			else _tempBestScore = Value;
			
			FlxG.log("Best Score: " + Value);
		}

		public static function load():void
		{
			_save = new FlxSave();
			_loaded = _save.bind("FlappyJamSettings");
			
			if (_loaded)
			{
				if(_save.data.bestScore == null)
				{
					_save.data.bestScore = 0;
					FlxG.log("Clearing best score ...");
				}
				else
				{
					FlxG.log("Loading best score ...");
				}
			}
		}
		
		public static function save():void
		{
			_save.flush();
		}
		
		public static function erase():void
		{
			_save.erase();
			FlxG.log("Saved data erased ...");
		}
	}
}