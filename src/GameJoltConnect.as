package  
{
	import com.gamejolt.API;
	
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Faisal
	 */
	
	public class GameJoltConnect
	{
		private static var g_instance:GameJoltConnect;
		public var gameJoltApi:API;
		
		private var userVerified:Boolean = false;
		
		protected var _gameId:int = GameJoltKey.gameId;
		protected var _privateKey:String = GameJoltKey.privateKey;
		public var userName:String = "Guest";
		public var userToken:String = "000000";
		
		private var bronzeTrophyId:int = 6693;
		private var silverTrophyId:int = 6694;
		private var goldTrophyId:int = 6695;
		private var platinumTrophyId:int = 6696;
		
		public function GameJoltConnect()
		{
			FlxG.log("Gamejolt API initialized");
			gameJoltApi = new API();
		}
		
		public static function get instance():GameJoltConnect
		{
			if (g_instance == null)
			{
				g_instance = new GameJoltConnect();
			}
			return g_instance;
		}
		
		public function authUser(_uName:String, _uToken:String):void
		{
			FlxG.log("authenticating user...");
			userName = _uName;
			userToken = _uToken;
			gameJoltApi.authUser(_gameId, _privateKey, _uName, _uToken, onUserAuthCallback);
		}
		
		private function onUserAuthCallback(success:Boolean):void
		{
			if (success)
			{
				FlxG.log("user verified Success");
				userVerified = true;
			}
			else
			{
				FlxG.log("user verified Failed. Guest Login");
				userName = "Guest";
				userVerified = false;
			}
		}
		
		public function setKeyData(key:String, data:String):void
		{
			if (userVerified)
			{
				FlxG.log("SetData "+data+" with Key: "+key);
				gameJoltApi.setKeyData(_gameId, _privateKey, key, data, userName, userToken);
			}
			else
				FlxG.log("Not GameJolt User");
		}
		
		public function getKeyData(key:String):void
		{
			if (userVerified)
			{
				FlxG.log("getData with Key: "+key);
				gameJoltApi.getKeyData(_gameId, _privateKey, key, onGetDataCallback, userName, userToken);
			}
			else
				FlxG.log("Not GameJolt User");
		}
		
		private function onGetDataCallback(data:String):void
		{
			FlxG.log("GetData Callback recieved");
			if (data != null)
			{
				FlxG.log("Recieved Data:"+data);
			}
		}
		
		public function addHighScore(score:int = 0):void
		{
			FlxG.log("Score: " + score);
			if (userVerified)
			{
				FlxG.log("HighScore Send");
				gameJoltApi.setHighscore(_gameId, _privateKey, String(score), score, userName, userToken);
			}
			else
			{
				FlxG.log("HighScore Send - Guest");
				gameJoltApi.setHighscore(_gameId, _privateKey, String(score), score, userName, userToken, userName);
			}
		}
		
		public function addTrophy(id:int = 0):void
		{
			FlxG.log("Trophy: " + id);
			if (!userVerified)
			{
				FlxG.log("Trophy adding failed. invalid user data");
				return;
			}
			if (id == 0)
			{
				FlxG.log("Trophy added: Bronze.");
				gameJoltApi.addTrophyAchieved(_gameId, _privateKey, userName, userToken, bronzeTrophyId);
			}
			else if (id == 1)
			{      
				FlxG.log("Trophy added: Silver.");
				gameJoltApi.addTrophyAchieved(_gameId, _privateKey, userName, userToken, silverTrophyId);
			}
			else if (id == 2)
			{      
				FlxG.log("Trophy added: Gold.");
				gameJoltApi.addTrophyAchieved(_gameId, _privateKey, userName, userToken, goldTrophyId);
			}
			else if (id == 3)
			{      
				FlxG.log("Trophy added: Platinum.");
				gameJoltApi.addTrophyAchieved(_gameId, _privateKey, userName, userToken, platinumTrophyId);
			}
		}
		
	}
	
}