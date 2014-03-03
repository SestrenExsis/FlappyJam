package
{
	import flash.events.Event;
	import flash.display.LoaderInfo;
	import org.flixel.FlxGame;
	import org.flixel.FlxG;
	
	[SWF(width="640", height="360", backgroundColor="#666666")]
	//[Frame(factoryClass="Preloader")]
	
	public class FlappyJam extends FlxGame
	{
		private var _userName:String;
		private var _tokenId:String;
		private var userDetails:Object;
		
		public function FlappyJam()
		{
			super(640, 360, GameScreen, 1.0, 60, 60, true);
			//forceDebugger = true;
		}
		
		override protected function create(FlashEvent:Event):void
		{
			super.create(FlashEvent);
			
			for (var theName:String in this.loaderInfo.parameters )
			{
				var theValue:String = this.loaderInfo.parameters [theName];
			}
			
			userDetails = LoaderInfo(this.root.loaderInfo).parameters.gjapi_username;
			_userName = String(userDetails);
			userDetails = LoaderInfo(this.root.loaderInfo).parameters.gjapi_token;
			_tokenId = String(userDetails);
			
			GameJoltConnect.instance.authUser(_userName, _tokenId);
		}
		
		private function loaderComplete(e:Event):void 
		{
			FlxG.log("loaderComplete");
			//by querying the LoaderInfo object, set the value of paramObj to the 
			//value of the variable named myVariable passed from FlashVars in the HTML
			for ( var theName:String in this.loaderInfo.parameters )
			{
				var theValue:String = this.loaderInfo.parameters [theName];
			}
			userDetails = LoaderInfo(this.root.loaderInfo).parameters.gjapi_username;
			_userName = String(userDetails);
			userDetails = LoaderInfo(this.root.loaderInfo).parameters.gjapi_token;
			_tokenId = String(userDetails);
			
			GameJoltConnect.instance.authUser(_userName, _tokenId);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
	}
}