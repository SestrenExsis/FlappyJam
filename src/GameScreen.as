package
{
	import flash.geom.Rectangle;
	
	import org.flixel.*;
	
	public class GameScreen extends FlxState
	{
		[Embed(source="../assets/images/instructions.png")] protected var imgInstructions:Class;
		[Embed(source="../assets/images/interface.png")] protected var imgInterface:Class;
		[Embed(source="../assets/images/bird.png")] protected var imgExplosion:Class;
		
		public static const BIRD_JUMP_SPEED:Number = 250;
		public static const SKY_SPEED:Number = 1;
		public static const GROUND_SPEED:Number = 5;
		public static const FOREGROUND_SPEED:Number = 10;
		public static const PIPE_SPAWN_COOLDOWN:Number = 0.65;

		public static const INSTRUCTIONS:int = 0;
		public static const GET_READY:int = 1;
		public static const PLAYING:int = 2;
		public static const GAME_OVER:int = 3;
		public static const SHOW_SCORES:int = 3;
		
		public static var scrollSpeed:Number = 1;
		
		protected var _gameState:int;
		
		private var bird:Bird;
		private var entities:FlxGroup;
		private var explosion:FlxSprite;
		private var scoreboard:FlxSprite;
		private var spawnTimer:FlxTimer;
		private var instructionsOverlay:FlxSprite;
		private var menuOverlay:FlxSprite;
		private var hitboxRect:FlxRect;
		
		public function GameScreen()
		{
			super();
		}
		
		override public function create():void
		{
			super.create();
			UserSettings.load();
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
			for (var i:int = 0; i < 6; i++)
			{
				_obstacle = new Obstacle(-1000, -1000);
				_obstacle.kill();
				entities.add(_obstacle);
			}
			explosion = new FlxSprite();
			explosion.loadGraphic(imgExplosion, true, false, 32, 24);
			explosion.addAnimation("none", [6]);
			explosion.addAnimation("explode", [4, 5, 6], 6, false);
			explosion.play("none");
			bird = new Bird(Bird.TOP_LANE.x, Bird.TOP_LANE.y, explosion);
			entities.add(bird);
			add(entities);
			add(explosion);
			
			instructionsOverlay = new FlxSprite(192, 56);
			instructionsOverlay.loadGraphic(imgInstructions, true, false, 256, 128);
			instructionsOverlay.addAnimation("rules", [0, 1], 8, true);
			instructionsOverlay.play("rules");
			add(instructionsOverlay);
			
			menuOverlay = new FlxSprite(270, 92);
			menuOverlay.loadGraphic(imgInterface, true, false, 99, 28);
			menuOverlay.addAnimation("Game Over", [0]);
			menuOverlay.addAnimation("Get Ready", [1]);
			menuOverlay.play("Get Ready");
			add(menuOverlay);
			
			scoreboard = new Scoreboard();
			add(scoreboard);
			
			spawnTimer = new FlxTimer();
			gameState = INSTRUCTIONS;
		}
		
		public function get gameState():int
		{
			return _gameState;
		}
		
		public function set gameState(Value:int):void
		{
			var _priorState:int = _gameState;	
			_gameState = Value;
			
			if (_gameState == INSTRUCTIONS)
			{
				instructionsOverlay.x = FlxG.width;
				instructionsOverlay.visible = true;
				menuOverlay.visible = false;
				scrollSpeed = 1;
				spawnTimer.stop();
				bird.respawn();
				GameInput.enabled = false;
			}
			else if (_gameState == GET_READY)
			{
				instructionsOverlay.x = 191;
				menuOverlay.x = FlxG.width;
				menuOverlay.play("Get Ready");
				menuOverlay.visible = true;
				scrollSpeed = 1;
				spawnTimer.stop();
				spawnTimer.start(2, 1, beginPlaying);
				bird.respawn();
				GameInput.enabled = false;
				var _entity:Entity;
				for (var i:int = 0; i < entities.members.length; i++)
				{
					_entity = entities.members[i];
					if (_entity && (_entity is Obstacle))
						_entity.kill();
				}
			}
			else if (_gameState == PLAYING)
			{
				if (_priorState != PLAYING)
					FlxG.score = 0;
				instructionsOverlay.visible = false;
				menuOverlay.x = 269;
				scrollSpeed = 1;
				spawnTimer.stop();
				spawnTimer.start(1, 1, nextObstacle);
				GameInput.enabled = true;
			}
			else if (_gameState == GAME_OVER)
			{
				if (FlxG.score > UserSettings.bestScore)
					UserSettings.bestScore = FlxG.score;
				instructionsOverlay.visible = false;
				menuOverlay.x = FlxG.width;
				menuOverlay.play("Game Over");
				menuOverlay.visible = true;
				scrollSpeed = 0;
				spawnTimer.stop();
				GameInput.enabled = false;
			}
			else if (_gameState == SHOW_SCORES)
			{
				if (FlxG.score > UserSettings.bestScore)
					UserSettings.bestScore = FlxG.score;
				instructionsOverlay.visible = false;
				menuOverlay.visible = false;
				scrollSpeed = 0;
				spawnTimer.stop();
				GameInput.enabled = false;
				// show the current and high scores
			}
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
		
		public function beginPlaying(Timer:FlxTimer):void
		{
			menuOverlay.x = 269;
			gameState = PLAYING;
		}
		
		public function nextObstacle(Timer:FlxTimer):void
		{
			menuOverlay.visible = false;
			var _obstacle:Obstacle = Obstacle(entities.getFirstAvailable(Obstacle));
			if (_obstacle)
			{
				_obstacle.respawn();
			}
			Timer.stop();
			Timer.start(PIPE_SPAWN_COOLDOWN, 1, nextObstacle);
		}
		
		public static function playRandomSound(Sounds:Array, VolumeMultiplier:Number = 1.0):void
		{
			var _seed:Number = Math.floor(Sounds.length * Math.random());
			FlxG.play(Sounds[_seed], VolumeMultiplier, false, false);
		}
		
		override public function update():void
		{	
			GameInput.update();
			super.update();
			
			if (GameInput.action == GameInput.START)
			{
				if (gameState == INSTRUCTIONS)
					gameState = GET_READY;
				else if (gameState == GET_READY) 
					gameState = PLAYING;
				else if (gameState == GAME_OVER)
					gameState = GET_READY;
			}
			
			FlxG.overlap(entities, bird, hitTest);
			entities.sort("layer", ASCENDING);
			
			if (instructionsOverlay.visible)
			{
				if (instructionsOverlay.x < 192)
					instructionsOverlay.x = FlxTween.linear(0.9, -30, instructionsOverlay.x, 1);
				else if (instructionsOverlay.x < 193)
					instructionsOverlay.x = 192;
				else if (instructionsOverlay.x > 192)
					instructionsOverlay.x = FlxTween.linear(0.9, 192, instructionsOverlay.x - 192, 1);
			}
			
			if (menuOverlay.visible)
			{
				if (menuOverlay.x < 270)
					menuOverlay.x = FlxTween.linear(0.9, -30, menuOverlay.x, 1);
				else if (menuOverlay.x < 271)
					menuOverlay.x = 270;
				else if (menuOverlay.x > 270)
					menuOverlay.x = FlxTween.linear(0.9, 270, menuOverlay.x - 270, 1);
			}
		}
		
		override public function draw():void
		{
			super.draw();
		}
	}
}