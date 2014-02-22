package
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	
	import org.flixel.*;
	
	public class Bird extends Entity
	{	
		[Embed(source="../assets/images/bird.png")] protected var imgBird:Class;
		[Embed(source="assets/sounds/Hit01.mp3")] public static var sndHit:Class;
		
		public static const TOP_LANE:FlxPoint = new FlxPoint(76, 134 + 2 + GameScreen.SCREEN_OFFSET_Y);
		public static const BOTTOM_LANE:FlxPoint = new FlxPoint(86, 150 + 2 + GameScreen.SCREEN_OFFSET_Y);
		
		public static var currentLane:int = 0;
		
		protected var _bob:Number = 0;
		protected var _bobSpeed:Number = 6;
		protected var _bobAmount:Number = 6;
		
		public var explosion:FlxSprite;
		public var hitTimer:FlxTimer;
		
		private var dying:Boolean = false;
		private var flipping:Boolean = false;
		private var timeSinceFirstFlip:Number = 0;
		private var jumpsInARow:int = 0;
		
		public function Bird(X:Number, Y:Number, Explosion:FlxSprite = null)
		{
			super(X, Y);
			
			loadGraphic(imgBird, true, false, 32, 24);
			addAnimation("flap", [0,1], 8, true);
			addAnimation("idle",[0]);
			play("flap");
			height = 12;
			
			hitTimer = new FlxTimer();
			hitTimer.start(0.01, 1);
			
			if (Explosion)
				explosion = Explosion;
		}
		
		public function switchLane():void
		{
			if (_lane == 0)
			{
				currentLane = 1;
				_lane = 1;
				layer = 2;
				velocity.y = 200;
			}
			else
			{
				currentLane = 0;
				_lane = 0;
				layer = 0;
				velocity.y = -200;
			}
		}
		
		public function get bob():Number
		{
			_bob += _bobSpeed * FlxG.elapsed;
			if (_bob > 2 * Math.PI)
				_bob -= 2 * Math.PI;
			
			// Work in progress: While jumping, the bob should be gradually reduced to the "floor",
			// so that when the bird hits the ground, it will be at the lowest point in the bob.
			if (z > 0 || !alive)
				_bob = FlxTween.linear(0, _bob, Math.PI, 0.2);
			return _bob;
		}
		
		public function hitPipe(Pipe:Obstacle, Lane:int):void
		{
			var _pipeRect:FlxRect = new FlxRect();
			var _pipeType:Number = 0;
			var _pipeHeight:Number = 0;
			if (Lane == 0)
			{
				_pipeRect.copyFrom(Obstacle.TOP_PIPE_RECT);
				_pipeType = Pipe.topType;
			}
			else if (Lane == 1)
			{
				_pipeRect.copyFrom(Obstacle.BOTTOM_PIPE_RECT);
				_pipeType = Pipe.bottomType;
			}
			
			if (_pipeType == 1)
				_pipeHeight = Obstacle.SHORT_PIPE_Z;
			else if (_pipeType == 2)
				_pipeHeight = Obstacle.TALL_PIPE_Z;
			
			_pipeRect.x += Pipe.x;
			_pipeRect.y += Pipe.y;
			
			if (explosion)
			{
				var _hitRect:FlxRect = new FlxRect();
				_hitRect.x = Math.max(x, _pipeRect.x);
				_hitRect.width = Math.min(x + width, _pipeRect.x + _pipeRect.width) - _hitRect.x;
				_hitRect.y = Math.max(y, _pipeRect.y);
				_hitRect.height = Math.min(y + height, _pipeRect.y + _pipeRect.height) - _hitRect.y;
				explosion.x = _hitRect.x + 0.5 * _hitRect.width - 0.5 * explosion.width;
				explosion.y = _hitRect.y + 0.5 * _hitRect.height - z - 0.5 * explosion.height;
				explosion.play("explode", true);
			}
			
			kill();
		}
		
		override public function kill():void
		{
			alive = false;
			dying = true;
			flipping = false;
			velocity.x = position.x - explosion.x - 0.5 * explosion.width;
			velocity.y = position.y - explosion.y - 0.5 * explosion.height;
			angularVelocity = (velocity.x > 0) ? 800 : -800;
			angularDrag = 800;
			drag.x = 25;
			drag.y = 100;
			play("idle");
			FlxG.shake(0.01, 0.15);
			FlxG.play(sndHit, 0.5);
		}
		
		public function respawn():void
		{
			reset(TOP_LANE.x, TOP_LANE.y);
			jumpsInARow = 0;
			timeSinceFirstFlip = 0;
			flipping = false;
			dying = false;
			z = 0;
			lastZ = z;
			velocityZ = 0;
			accelerationZ = 0;
			angularVelocity = angularDrag = drag.x = drag.y = 0;
			angle = 0;
			hitTimer.stop();
			hitTimer.start(0.01, 1);
			currentLane = 0;
			_lane = 0;
			layer = 0;
			_bob = 0;
			play("flap");
		}
		
		override public function update():void
		{	
			super.update();
			
			timeSinceFirstFlip += FlxG.elapsed;
			if (dying)
			{
				velocityZ = GameScreen.BIRD_JUMP_SPEED;
				dying = false;
			}
			else if (flipping && angularVelocity < 200 && angle >= 360)
			{
				flipping = false;
				angle = angularVelocity = angularDrag = 0;
			}
			
			if (!alive)
				return;
			
			if (y > BOTTOM_LANE.y)
			{
				x = BOTTOM_LANE.x;
				y = BOTTOM_LANE.y;
				velocity.y = 0;
				acceleration.y = 0;
			}
			else if (y < TOP_LANE.y)
			{
				x = TOP_LANE.x;
				y = TOP_LANE.y;
				velocity.y = 0;
				acceleration.y = 0;
			}
			
			var _laneProgress:Number = (y - TOP_LANE.y) / (BOTTOM_LANE.y - TOP_LANE.y);
			
			x = TOP_LANE.x + _laneProgress * (BOTTOM_LANE.x - TOP_LANE.x)
			offset.y += 24 + 0.5 * _bobAmount + _bobAmount * Math.cos(bob);
			
			if (z <= 0 && GameInput.bufferedJump())
			{
				if (jumpsInARow == 0)
					timeSinceFirstFlip = 0;
				jumpsInARow++;
				if (jumpsInARow >= 3)
				{
					jumpsInARow = 0;
					if (timeSinceFirstFlip < 2.5)
					{
						angularVelocity = 1200;
						angularDrag = 2000;
						flipping = true;
					}
				}
				velocityZ += GameScreen.BIRD_JUMP_SPEED;
			}
			
			if (GameInput.action == GameInput.SWITCH_LANE)
				switchLane();
		}
		
		override public function draw():void
		{
			// Draw shadow
			var _x:Number = _flashRect.x;
			var _y:Number = _flashRect.y;
			var _xx:Number = _flashPoint.x;
			var _yy:Number = _flashPoint.y;
			
			_flashRect.x = 64;
			_flashRect.y = 0;
			_flashPoint.x = x - offset.x;
			_flashPoint.y = y - height;
			
			FlxG.camera.buffer.copyPixels(_pixels, _flashRect, _flashPoint, null, null, true);
			
			_flashRect.x = _x;
			_flashRect.y = _y;
			_flashPoint.x = _xx;
			_flashPoint.y = _yy;
			
			super.draw();
		}
	}
}