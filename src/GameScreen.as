package
{
	import flash.geom.Rectangle;
	
	import org.flixel.*;
	
	public class GameScreen extends FlxState
	{
		[Embed(source="../assets/images/interface.png")] protected var imgInterface:Class;
		
		public static const BIRD_JUMP_SPEED:Number = 250;
		public static const SKY_SPEED:Number = 1;
		public static const GROUND_SPEED:Number = 5;
		public static const FOREGROUND_SPEED:Number = 10;
		public static const PIPE_SPAWN_COOLDOWN:Number = 0.65;

		public static const GET_READY:int = 0;
		public static const PLAYING:int = 1;
		public static const GAME_OVER:int = 2;
		
		public static var scrollSpeed:Number = 1;
		
		protected var _gameState:int = GET_READY;
		
		private var bird:Bird;
		private var entities:FlxGroup;
		private var spawnTimer:FlxTimer;
		private var menuOverlay:FlxSprite;
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
			add(new ScrollingSprite(0, 0, _rect, SKY_SPEED, 0));
			_rect.setTo(0, 131, 640, 38);
			add(new ScrollingSprite(0, 131, _rect, GROUND_SPEED, 0));
			_rect.setTo(0, 169, 640, 71);
			add(new ScrollingSprite(0, 169, _rect, FOREGROUND_SPEED, 0));
			
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
			
			menuOverlay = new FlxSprite(270, 92);
			menuOverlay.loadGraphic(imgInterface, true, false, 99, 28);
			menuOverlay.addAnimation("Game Over", [0]);
			menuOverlay.addAnimation("Get Ready", [1]);
			menuOverlay.play("Get Ready");
			add(menuOverlay);
			
			spawnTimer = new FlxTimer();
		}
		
		public function get gameState():int
		{
			return _gameState;
		}
		
		public function set gameState(Value:int):void
		{
			var _priorState:int = _gameState;	
			_gameState = Value;
			
			if (_gameState == GET_READY)
			{
				menuOverlay.play("Get Ready");
				menuOverlay.visible = true;
				scrollSpeed = 1;
				spawnTimer.stop();
				bird.inputDisabled = true;
			}
			else if (_gameState == PLAYING)
			{
				menuOverlay.visible = false;
				scrollSpeed = 1;
				spawnTimer.stop();
				spawnTimer.start(1, 1, nextObstacle);
				bird.inputDisabled = false;
			}
			else if (_gameState == GAME_OVER)
			{
				menuOverlay.play("Game Over");
				menuOverlay.visible = true;
				scrollSpeed = 0;
				spawnTimer.stop();
				bird.inputDisabled = true;
			}
		}
		
		override public function update():void
		{	
			super.update();
			
			if (gameState == GET_READY && FlxG.mouse.justPressed())
				gameState = PLAYING;
			
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
			
			var _topType:int = (Object2 as Obstacle).topType;
			var _bottomType:int = (Object2 as Obstacle).bottomType;
			
			// Bird hit the top pipe
			if (_topType > Obstacle.NONE && hitboxRect.overlaps(Obstacle.TOP_PIPE_RECT))
			{
				if (_topType == Obstacle.TALL || (Object1 as Bird).z < Obstacle.SHORT_PIPE_Z)
				{
					if (Object1.alive)
					{
						gameState = GAME_OVER;
						(Object1 as Bird).hitPipe(Object2 as Obstacle, 0);
					}
					return true;
				}
			}
			
			// Bird hit the bottom pipe
			if (_bottomType > Obstacle.NONE && hitboxRect.overlaps(Obstacle.BOTTOM_PIPE_RECT))
			{
				if (_bottomType == Obstacle.TALL || (Object1 as Bird).z < Obstacle.SHORT_PIPE_Z)
				{
					if (Object1.alive)
					{
						gameState = GAME_OVER;
						(Object1 as Bird).hitPipe(Object2 as Obstacle, 1);
					}
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
			
			Timer.start(PIPE_SPAWN_COOLDOWN, 1, nextObstacle);
		}
		
		public static function playRandomSound(Sounds:Array, VolumeMultiplier:Number = 1.0):void
		{
			var _seed:Number = Math.floor(Sounds.length * Math.random());
			FlxG.play(Sounds[_seed], VolumeMultiplier, false, false);
		}
	}
}