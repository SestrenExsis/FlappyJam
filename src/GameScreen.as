package
{
	import org.flixel.*;
	import flash.geom.Rectangle;
	
	public class GameScreen extends FlxState
	{
		public var bird:Bird;
		public var entities:FlxGroup;
		
		public var spawnTimer:FlxTimer;
		private var hitboxRect:FlxRect;
		
		public function GameScreen()
		{
			super();
		}
		
		override public function create():void
		{
			super.create();
			FlxG.flash(0xff000000, 0.5);
			
			hitboxRect = new FlxRect();
			
			FlxG.bgColor = 0xff808080;
			
			var _rect:Rectangle = new Rectangle(0, 0, 640, 131);
			add(new ScrollingSprite(0, 0, _rect, Entity.SKY_SPEED, 0));
			_rect.setTo(0, 131, 640, 38);
			add(new ScrollingSprite(0, 131, _rect, Entity.GROUND_SPEED, 0));
			_rect.setTo(0, 169, 640, 71);
			add(new ScrollingSprite(0, 169, _rect, Entity.FOREGROUND_SPEED, 0));
			
			var _obstacle:Obstacle;
			entities = new FlxGroup();
			for (var i:int = 0; i < 30; i++)
			{
				_obstacle = new Obstacle(-1000, -1000);
				_obstacle.kill();
				entities.add(_obstacle);
			}
			bird = new Bird(Bird.TOP_LANE.x, Bird.TOP_LANE.y);
			entities.add(bird);
			add(entities);
			
			spawnTimer = new FlxTimer();
			spawnTimer.start(2, 1, nextObstacle);
		}
		
		override public function update():void
		{	
			super.update();
			FlxG.overlap(entities, bird, hitTest);
			
			entities.sort("layer", ASCENDING);
		}
		
		public function hitTest(Object1:FlxObject, Object2:FlxObject):Boolean
		{
			if (Object2 is Bird)
			{
				hitTest(Object2, Object1);
				return hitTest(Object2, Object1);
			}
			
			hitboxRect.x = Object1.x - Object2.x;
			hitboxRect.y = Object1.y - Object2.y;
			hitboxRect.width = Object1.width;
			hitboxRect.height = Object1.height;
			
			if ((Object2 as Obstacle).topType > Obstacle.NONE && hitboxRect.overlaps(Obstacle.TOP_PIPE_RECT))
			{
				if ((Object2 as Obstacle).topType == Obstacle.TALL || (Object1 as Bird).z < Obstacle.SHORT_PIPE_Z)
				{
					Object1.kill();
					return true;
				}
			}
			if ((Object2 as Obstacle).bottomType > Obstacle.NONE && hitboxRect.overlaps(Obstacle.BOTTOM_PIPE_RECT))
			{
				if ((Object2 as Obstacle).bottomType == Obstacle.TALL || (Object1 as Bird).z < Obstacle.SHORT_PIPE_Z)
				{
					Object1.kill();
					return true;
				}
			}
			return false;
		}
		
		public function nextObstacle(Timer:FlxTimer):void
		{
			var _obstacle:Obstacle = Obstacle(entities.getFirstAvailable(Obstacle));
			if (_obstacle)
			{
				_obstacle.respawn();
			}
			
			Timer.start(Entity.PIPE_SPAWN_COOLDOWN, 1, nextObstacle);
		}
		
		public static function playRandomSound(Sounds:Array, VolumeMultiplier:Number = 1.0):void
		{
			var _seed:Number = Math.floor(Sounds.length * Math.random());
			FlxG.play(Sounds[_seed], VolumeMultiplier, false, false);
		}
	}
}