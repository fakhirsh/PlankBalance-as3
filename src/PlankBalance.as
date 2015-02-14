package
{
	import AssetMgr.*;
	import com.google.analytics.GATracker;
	
	import CoreGameEngine.GameEngine;
	
	import GameElements.Cursor;
	
	import GameUtility.Utility;
	
	import com.google.analytics.AnalyticsTracker;
	
	import flash.display.*;
	import flash.events.*;
	import flash.media.Sound;
	import flash.net.*;
	import flash.text.TextField;
	
	//import mochi.as3.MochiServices;
	
	[SWF(width = 699, height = 466, frameRate = 60)]
	[Frame(factoryClass = "Preloader")]
	public class PlankBalance extends Sprite
	{
		private var domainList:Vector.<String> = new Vector.<String>;
		
		//private var _mochiads_game_id:String = "07e2ee80a2c0f043";
		//public static var mainStage:Stage;
		
		public function PlankBalance()
		{
			if (stage) Init();
			else addEventListener(Event.ADDED_TO_STAGE, Init);
		}
		
		public function Init(e:Event=null):void{
			
			domainList.push("");	// ONLY FOR TESTING: Local execution
			//domainList.push("byterender.com");
			//domainList.push("http://www.flashgamelicense.com");
			//domainList.push("https://www.flashgamelicense.com");
			//domainList.push("flashgamelicense.com");
			//domainList.push("fgl.com");
			//domainList.push("games.mochiads.com");
			//domainList.push("mochiads.com");
			//domainList.push("newgrounds.com");
			//domainList.push("kongregate.com");
			
			
			if(CheckDomains() == false){
				//navigateToURL(new URLRequest("http://www.byterender.com/"), "_blank");
				return;
			}
			else{
				//mainStage = this.stage;
				// Remove everything that is on the stage Including secureSWF nag screen :P 
				//Utility.RemoveSpriteChildrenFromParent(mainStage);
				
				//************************************************************************
				//   Playtomic, Mochi Analytics
				//************************************************************************
//				Log.View(951797, "c305a629fdf84800", "3ee65a8f97ee4adda5c3e48fba3788", root.loaderInfo);
				//MochiServices.connect("07e2ee80a2c0f043", root, onMochiConnectError);
				//************************************************************************
				
				removeEventListener(Event.ADDED_TO_STAGE, init);
				// entry point
				
				Registry.bgLayer = new Sprite();
				Registry.gameplayLayer = new Sprite();
				Registry.guiLayer = new Sprite();
				Registry.playerLayer = new Sprite();
				
				this.addChild(Registry.bgLayer);
				this.addChild(Registry.gameplayLayer);
				this.addChild(Registry.guiLayer);
				this.addChild(Registry.playerLayer);
				
				
				//MochiServices.connect(_mochiads_game_id, root, onMochiConnectError);
				//MochiBot.track(this, "5f800639");
				var _gamerSafe:GamerSafe = new GamerSafe(this);
		
				// Initialize Asset manager 
				Registry.assetMgr = new AssetManager();
				Registry.soundMgr = new SoundManager();
				
				addEventListener(Event.ENTER_FRAME, Loop);
				
				Registry.game = new GameEngine(Registry.gameplayLayer);
				
				Utility.ChangeLevel("SplashScreen1");
				//Utility.ChangeLevel("MainMenu");
				//Utility.ChangeLevel("LevelSelection");
				//Utility.ChangeLevel("Gameplay");
				//Utility.ChangeLevel("GameComplete");
				
				GamerSafe.api.addEventListener("networking_error", NetworkErrorFn);
				GamerSafe.api.addEventListener("login", LoginFn);
			}
			Registry.cursor = new Cursor();
			
			InitGATracking();

			Registry.LoadGameData();
			
		}
		
		private function LoginFn(e:Event):void 
		{	
			var savedGame:String = GamerSafe.api.savedGame;
			if (savedGame != null)
			{
				// Restore game settings...	
			}
			
		}
		
		private function NetworkErrorFn(e:Event):void 
		{
			GamerSafe.api.showMessageBox("Connection error...", "Please make sure interenet is working", false);
		}
		
		public function Loop(e:Event):void { 
			GameEngine.Update();
			GameEngine.Draw();
		}
		
		
		private function IsDomainValid(allowed_site:String):Boolean{
			var domain:String = this.root.loaderInfo.url.split("/")[2];
			if (domain.indexOf(allowed_site) == (domain.length - allowed_site.length)) {
				// Everything's okay.  Proceed.
				return true;
			} else {
				// Nothing's okay.  Go away.
				var text:TextField = new TextField();
				this.addChild(text);
				text.x = 10;
				text.y = 10;
				text.text = "Domain: " + domain;
				text.scaleX = 1.5;
				text.scaleY = 1.5;
				
				return false;
			}
		}
		
		private function CheckDomains():Boolean{
			
			var flag:Boolean = false;
			
			for(var i:int = 0; i < domainList.length; i++){
				if(IsDomainValid(domainList[i])){
					flag = true;
				}
			}
			
			return flag;
		}
		
		
		private function onMochiConnectError(status:String):void
		{
			trace("Error: Couldn't connect to Mochi");
		}
		
		private function InitGATracking():void{
			Registry.gaTracker = new GATracker( Registry.bgLayer, "UA-00000000-1", "AS3", false );
			Registry.gaTracker.trackPageview( "/tracker-initated" );
		}
		
	}
}