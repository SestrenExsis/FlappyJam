package
{
	import org.flixel.FlxGame;
	[SWF(width="640", height="360", backgroundColor="#666666")]
	
	public class FlappyJam extends FlxGame
	{
		public function FlappyJam()
		{
			super(640, 240, GameScreen, 1.0, 60, 60, true);
			forceDebugger = true;
		}
	}
}