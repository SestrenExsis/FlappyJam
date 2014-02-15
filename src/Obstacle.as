package
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	
	import org.flixel.*;
	
	public class Obstacle extends Entity
	{	
		[Embed(source="../assets/images/obstacles.png")] protected var imgObstacles:Class;
		
		public static const NONE:int = 0;
		public static const SHORT:int = 1;
		public static const TALL:int = 2;
		
		public static const animations:Array = ["none","short_bottom","tall_bottom","short_top","short_both","none","tall_top","none","none"];
		
		public static const SHORT_PIPE_Z:Number = 24;
		public static const TALL_PIPE_Z:Number = 55;
		
		public static const TOP_PIPE_RECT:FlxRect = new FlxRect(0, 54, 32, 16);
		public static const BOTTOM_PIPE_RECT:FlxRect = new FlxRect(10, 70, 32, 16);
		
		protected var _type:int = 0;
		protected var _topType:int = 0;
		protected var _bottomType:int = 0;
		
		public function Obstacle(X:Number, Y:Number)
		{
			super(X, Y);
			
			loadGraphic(imgObstacles, true, false, 42, 86);
			addAnimation("none", [0]);
			addAnimation("short_both", [1]);
			addAnimation("short_bottom", [2]);
			addAnimation("short_top", [3]);
			addAnimation("tall_bottom", [4]);
			addAnimation("tall_top", [5]);
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function set type(Value:int):void
		{
			_type = Value;
			_topType = _type / 3;
			_bottomType = _type % 3;
			play(animations[_type]);
		}
		
		public function get topType():int
		{
			return _topType;
		}
		
		public function set topType(Value:int):void
		{
			_topType = Value;
			_type = 3 * _topType + _bottomType;;
			play(animations[_type]);
		}
		
		public function get bottomType():int
		{
			return _bottomType;
		}
		
		public function set bottomType(Value:int):void
		{
			_bottomType = Value;
			_type = 3 * _topType + _bottomType;;
			play(animations[_type]);
		}
		
		public function respawn():void
		{
			reset(FlxG.width - width, 68 + 12);
			var _seed:Number = FlxG.random();
			
			//"none","short_bottom","tall_bottom","short_top","short_both","none","tall_top","none","none"
			if (_seed < 0.75)
				type = 0;
			else if (_seed < 0.8)
				type = 1;
			else if (_seed < 0.85)
				type = 2;
			else if (_seed < 0.9)
				type = 3;
			else if (_seed < 0.95)
				type = 4;
			else
				type = 6;
			
			velocity.x = -400;
			FlxG.log(type);
		}
		
		override public function update():void
		{	
			super.update();
			
			if (x + width < 0)
				kill();
		}
		
		override public function draw():void
		{
			super.draw();
		}
	}
}