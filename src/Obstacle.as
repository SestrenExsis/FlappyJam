package
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	
	import org.flixel.*;
	
	public class Obstacle extends Entity
	{	
		[Embed(source="../assets/images/obstacles.png")] protected var imgObstacles:Class;
		[Embed(source="assets/sounds/Pickup01.mp3")] public static var sndScore:Class;
		
		public static const NONE:int = 0;
		public static const SHORT:int = 1;
		public static const TALL:int = 2;
		public static const animations:Array = [
				"none", "short_top", "tall_top",
				"short_bottom", "short_both", "short_bottom_tall_top",
				"tall_bottom", "short_top_tall_bottom", "tall_both"
		];
		public static const SHORT_PIPE_Z:Number = 24;
		public static const TALL_PIPE_Z:Number = 55;
		public static const TOP_PIPE_RECT:FlxRect = new FlxRect(0, 54, 32, 16);
		public static const BOTTOM_PIPE_RECT:FlxRect = new FlxRect(10, 70, 32, 16);
		
		public static var lastTypeSpawned:int = -1;
		
		protected var _type:int = 0;
		protected var _topType:int = 0;
		protected var _bottomType:int = 0;
		
		private var scored:Boolean = false;
		
		public function Obstacle(X:Number, Y:Number)
		{
			super(X, Y);
			
			loadGraphic(imgObstacles, true, false, 42, 86);
			addAnimation("none", [0]);
			addAnimation("short_top", [1]);
			addAnimation("tall_top", [2]);
			addAnimation("short_bottom", [3]);
			addAnimation("short_both", [4]);
			addAnimation("short_bottom_tall_top", [5]);
			addAnimation("tall_bottom", [6]);
			addAnimation("short_top_tall_bottom", [7]);
			addAnimation("tall_both", [8]);
			
			layer = 1;
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function set type(Value:int):void
		{
			_type = Value;
			_topType = _type % 3;
			_bottomType = _type / 3;
			play(animations[_type]);
		}
		
		public function get topType():int
		{
			return _topType;
		}
		
		public function set topType(Value:int):void
		{
			_topType = Value;
			_type = 3 * _bottomType + _topType;
			play(animations[_type]);
		}
		
		public function get bottomType():int
		{
			return _bottomType;
		}
		
		public function set bottomType(Value:int):void
		{
			_bottomType = Value;
			_type = 3 * _bottomType + _topType;
			play(animations[_type]);
		}
		
		public function respawn():void
		{
			reset(FlxG.width, 80);
			
			var _pipes:Array;
			if (lastTypeSpawned == -1 || lastTypeSpawned == 0 || lastTypeSpawned == 4)
			{
				_pipes = [0, 1, 2, 3, 4, 5, 6, 7];
			}
			else if (lastTypeSpawned <= 2 || lastTypeSpawned == 5)
			{
				_pipes = [3, 4, 5, 6, 7];
			}
			else if (lastTypeSpawned == 3 || lastTypeSpawned == 6 || lastTypeSpawned == 7)
			{
				_pipes = [1, 2, 4, 5, 7];
			}
			
			var _seed:Number = Math.floor(_pipes.length * Math.random());
			type = _pipes[_seed];
			lastTypeSpawned = type;
			scored = false;
		}
		
		override public function update():void
		{	
			super.update();
			x -= GameScreen.GROUND_SPEED * GameScreen.scrollSpeed;
			if (x + width < 0)
				kill();
			else if (x <= 0 && type > 0 && !scored)
			{
				FlxG.score += 1;
				scored = true;
				FlxG.play(sndScore, 0.5);
			}
		}
		
		override public function draw():void
		{
			super.draw();
			
			// Draw hitboxes
			/*_flashRect.x = TOP_PIPE_RECT.x + x;
			_flashRect.y = TOP_PIPE_RECT.y + y;
			_flashRect.width = TOP_PIPE_RECT.width;
			_flashRect.height = TOP_PIPE_RECT.height;
			FlxG.camera.buffer.fillRect(_flashRect, 0xffffffff);
			
			_flashRect.x = BOTTOM_PIPE_RECT.x + x;
			_flashRect.y = BOTTOM_PIPE_RECT.y + y;
			_flashRect.width = BOTTOM_PIPE_RECT.width;
			_flashRect.height = BOTTOM_PIPE_RECT.height;
			
			FlxG.camera.buffer.fillRect(_flashRect, 0xffffffff);*/
		}
	}
}