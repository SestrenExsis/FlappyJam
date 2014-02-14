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
		public static const SHORT_BOTH:int = 1;
		public static const SHORT_BOTTOM:int = 2;
		public static const SHORT_TOP:int = 3;
		public static const TALL_BOTTOM:int = 2;
		public static const TALL_TOP:int = 3;
		
		public static const animations:Array = ["none","short_both","short_bottom","short_top","tall_bottom","tall_top"];
		
		protected var _type:int;
		public var heightZ:Number = 0;
		
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
		
		public function set type(Value:int):void
		{
			_type = Value;
			play(animations[_type]);
			
		}
		
		public function get type():int
		{
			return _type;
		}
		
		override public function update():void
		{	
			super.update();
		}
		
		override public function draw():void
		{
			super.draw();
		}
	}
}