package
{
	import org.flixel.*;
	
	public class GameScreen extends FlxState
	{
		
		public static var overlay:FlxSprite;
		public static var infoTextBackdrop:FlxSprite;
		public static var infoText:FlxText;
		
		public function GameScreen()
		{
			super();
		}
		
		override public function create():void
		{
			super.create();
			FlxG.bgColor = 0xff808080;
			FlxG.flash(0xff000000, 0.5);
			
			add(new Entity(50, 50));
		}
		
		override public function update():void
		{	
			super.update();
			
		}
		
		public static function playRandomSound(Sounds:Array, VolumeMultiplier:Number = 1.0):void
		{
			var _seed:Number = Math.floor(Sounds.length * Math.random());
			FlxG.play(Sounds[_seed], VolumeMultiplier, false, false);
		}
	}
}