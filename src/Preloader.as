package
{
	import org.flixel.system.FlxPreloader;
	import flash.display.LoaderInfo;
	import org.flixel.FlxG;
	import flash.events.Event;
	
	public class Preloader extends FlxPreloader
	{
		
		public function Preloader()
		{
			super();
			minDisplayTime = 1;
			className = "FlappyJam";
		}
	}
}