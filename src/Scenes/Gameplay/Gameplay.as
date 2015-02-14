package Scenes.Gameplay
{
	import AssetMgr.*;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	//import mochi.as3.MochiEvents;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import CoreGameEngine.GameState;
	import GameElements.HUD;
	import GameUtility.*;
	import LevelSVGLoader.LevelLoader;
//	import Playtomic.Log;
	import Scenes.Gameplay.*;
	import Scenes.LevelSelection.LevelSelection;
	import com.greensock.*;
	import com.greensock.easing.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursorData;
	import flash.utils.Timer;
	import flash.net.navigateToURL;
	
	public class Gameplay extends GameState
	{
		private var gameTimer:Timer;
		private var readyTimer:Timer;
		private var clickTimer:Timer;
		private var enableHUDBtnTimer:Timer;
		private var levelFailTimer:Timer;
		private var levelCompleteTimer:Timer;
		private var pauseTimer:Timer;
		
		private var timer:int = 0;
		private static var levelObj:LevelObj;
		//private var profiler:Profiler;
		private var hudContainer:Sprite = new Sprite();
		private var hud:HUD;
		private var homeBtn:Sprite;
		private var resetBtn:Sprite;
		private var walkthroughBtn:Sprite;
		private var tutorials:Tutorials;
		private var soundBtn:Sprite;
		private var musicBtn:Sprite;
		
		private var gameRunning:Boolean;
		private var mouseClickWaiting:Boolean;
		private var allowTextureChange:Boolean;
		private var _gamePaused:Boolean;
		
		private var _worldStep:Number = 60;
		private var _container:Sprite;
		
		public static var gameLost:Boolean;
		public static var destroyBlocksList:Vector.<BlockObj> = new Vector.<BlockObj>;

		//public static var plankObj:BlockObj;
		//private var forwardBtn:Sprite;
		//private var facebookShareBtn:Sprite;
		//private var twitterShareBtn:Sprite;
		//private var emailShareBtn:Sprite;
		
		public function Gameplay()
		{
			
		}
		
		private function InitHUD():void{
			
			hud = new HUD(hudContainer);
			hud.UpdateTimerLabel(0);
			hud.UpdateBlocksLeftLabel(LevelObj.blocksToDestroy);
			
		}
		
		private function EnableHUDBtnTimerFn(event:TimerEvent):void{
			// Home button
			homeBtn = Utility.CreateSpriteButton(new AssetManager.HomeBtnGFX(), new Point(28,24), null, null, ButtonMouseClickFn);
			hudContainer.addChild(homeBtn);
			homeBtn.name = "home";
			homeBtn.scaleX = 0.5;
			homeBtn.scaleY = 0.5;
			homeBtn.alpha = 0.0;
			TweenMax.to(homeBtn, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:0.0});

			// Reset button
			resetBtn = Utility.CreateSpriteButton(new AssetManager.RestartBtnGFX(), new Point(68,24), null, null, ButtonMouseClickFn);
			hudContainer.addChild(resetBtn);
			resetBtn.name = "reset";
			resetBtn.scaleX = 0.5;
			resetBtn.scaleY = 0.5;
			resetBtn.alpha = 0.0;
			TweenMax.to(resetBtn, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:0.1});
			
			// Sound button
			if(SoundManager.isSoundOn){
				CreateSoundButton(AssetManager.SoundOnGFX, true);
			}
			else{
				CreateSoundButton(AssetManager.SoundOffGFX, true);
			}
			
			// Music button
			if(SoundManager.isMusicOn){
				CreateMusicButton(AssetManager.MusicOnGFX, true);
			}
			else{
				CreateMusicButton(AssetManager.MusicOffGFX, true);
			}
			
			
			enableHUDBtnTimer.stop();
		}
		
		private function CreateSoundButton(BtnGFX:Class, animated:Boolean=false):void{
			soundBtn = Utility.CreateSpriteButton(new BtnGFX(), new Point(490,24), null, null, ButtonMouseClickFn);
			hudContainer.addChild(soundBtn);
			soundBtn.name = "sound";
			if(animated){
				soundBtn.scaleX = 0.5;
				soundBtn.scaleY = 0.5;
				soundBtn.alpha = 0.0;
				TweenMax.to(soundBtn, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:0.2});
			}
		}

		private function CreateMusicButton(BtnGFX:Class, animated:Boolean=false):void{
			musicBtn = Utility.CreateSpriteButton(new BtnGFX(), new Point(538,24), null, null, ButtonMouseClickFn);
			hudContainer.addChild(musicBtn);
			musicBtn.name = "music";
			if(animated){
				musicBtn.scaleX = 0.5;
				musicBtn.scaleY = 0.5;
				musicBtn.alpha = 0.0;
				TweenMax.to(musicBtn, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:0.2});
			}
		}

		
		private function DeleteSoundButton():void{
			Utility.RemoveSpriteButtonFromParent(hudContainer, soundBtn, null, null, ButtonMouseClickFn);
		}		

		private function DeleteMusicButton():void{
			Utility.RemoveSpriteButtonFromParent(hudContainer, musicBtn, null, null, ButtonMouseClickFn);
		}		

		private function StartGetReadyDelay(delay:Number):void{
			readyTimer.start();
		}
		private function StartGetReadyDelayCallbackFn(event:TimerEvent):void{
			gameRunning = true;
			gameTimer.start();
			EnableMouseInput();
			_worldStep = 60;
			SoundManager.PlayGoSFX();
		}
		
		private function GameTimerListener(event:TimerEvent):void {
			if(_gamePaused) return;
			
			timer++;
			if(timer == 2) allowTextureChange = true;
			if(timer > 999) timer = 999;
			hud.UpdateTimerLabel(timer);
		}

		override public function Load():void { 
			//trace("Gameplay.Load()");
//			Log.Play();
//			Log.CustomMetric("Level"+LevelObj.currentLevelNumber);
			//Log.LevelCounterMetric("LevelStart",  "Level"+LevelObj.currentLevelNumber); // names must be alphanumeric
			
			//SoundManager.MusicOff();
			
			_container = Registry.gameplayLayer;
			
			//MochiEvents.startPlay();
			Registry.gaTracker.trackPageview( "/LevelStart-"+LevelObj.currentLevelNumber );
			
			tutorials = new Tutorials(Registry.gameplayLayer, LevelObj.currentLevelNumber);
			
			//trace("LevelObj.currentLevelNumber: " + LevelObj.currentLevelNumber);
			levelObj = LevelLoader.LoadLevel(LevelObj.currentLevelNumber);
			levelObj.spriteContainer.addChild(hudContainer);
			levelObj.contactListener = new ContactListener();
			levelObj.world.SetContactListener(levelObj.contactListener);
			//plankObj = GetPlankObject();
			//trace("Gameplay: Plank--> W: " +plankObj.blockTexture.width+ "-- H:" + plankObj.blockTexture.height);
			var delay:Number = 1.8;
			
			gameTimer = new Timer(1000);
			gameTimer.addEventListener(TimerEvent.TIMER, GameTimerListener);
			// Originally 400 ms...
			clickTimer = new Timer(600, 1);
			clickTimer.addEventListener(TimerEvent.TIMER, CkickTimerListener);
			readyTimer = new Timer(delay*1000, 1);
			readyTimer.addEventListener(TimerEvent.TIMER, StartGetReadyDelayCallbackFn);
			levelFailTimer = new Timer(4000, 1);
			levelFailTimer.addEventListener(TimerEvent.TIMER, LevelFailTimerListener);
			levelCompleteTimer = new Timer(3500, 1);
			levelCompleteTimer.addEventListener(TimerEvent.TIMER, LevelCompleteTimerListener);
			
			enableHUDBtnTimer = new Timer((delay*2.0)*100, 1);
			enableHUDBtnTimer.addEventListener(TimerEvent.TIMER, EnableHUDBtnTimerFn);
			enableHUDBtnTimer.start();
			
			_container.addEventListener(Event.ACTIVATE, GameInFocus); //check if focus is there
			_container.addEventListener(Event.DEACTIVATE, GameOutOfFocus); // check if focus is not there
			
			InitHUD();
			hud.UpdateLevelNumberLabel(LevelObj.currentLevelNumber);
			hud.DisplayGetReadySequence(delay);
			StartGetReadyDelay(delay);
			
			//profiler = new Profiler(600,100,levelObj.spriteContainer);
			
			gameRunning = false;
			gameLost = false;
			_gamePaused = false;
			//SoundManager.PlayReadySFX();
			
			//_worldStep = 9999999;
			
			GamerSafe.api.hideStatusBar();
		}
		
		private function GameInFocus(e:Event):void
		{
			
			_worldStep = 60;
			gameTimer.start();

			var lbl:Bitmap = levelObj.spriteContainer.getChildByName("_pauseLBL_Bitmap") as Bitmap;
			if(lbl) levelObj.spriteContainer.removeChild(lbl);
			
			//trace("in focus");
			_container.stage.frameRate = 60; // change this to whatever your normal frame rate is
			//pauseScreen_mc.x = 5000; // remove pause screen
			_gamePaused = false;
		}
		
		private function GameOutOfFocus(e:Event):void
		{
			_worldStep = 9999999;
			gameTimer.stop();
			
			var pauseLBL:Bitmap = new AssetManager.PauseLBLGFX();
			pauseLBL.name = "_pauseLBL_Bitmap";
			pauseLBL.x = _container.stage.stageWidth/2 - pauseLBL.width/2;
			pauseLBL.y = _container.stage.stageHeight/2 - pauseLBL.height/2;
			levelObj.spriteContainer.addChild(pauseLBL);
			
			_gamePaused = true;
			//trace("out of focus");
			//_container.frameRate = 0; // freezes everything pretty much
			//pauseScreen_mc.x = 0; // place the pause screen in screen
			//pauseScreen_mc.y = 0; // place the pause screen in screen
			
			pauseTimer = new Timer(0.2, 1);
			pauseTimer.addEventListener(TimerEvent.TIMER, onPauseTimer);
			pauseTimer.start();
		}
		
		private function onPauseTimer(e:TimerEvent):void{
			pauseTimer.removeEventListener(TimerEvent.TIMER, onPauseTimer);
			pauseTimer.stop();
			_container.stage.frameRate = 0;
		}
		
		override public function UnLoad():void {
			//trace("SplashScreen1.Unload()");
			
			if(gameTimer.hasEventListener(TimerEvent.TIMER)) gameTimer.removeEventListener(TimerEvent.TIMER, GameTimerListener);
			if(readyTimer.hasEventListener(TimerEvent.TIMER)) readyTimer.removeEventListener(TimerEvent.TIMER, StartGetReadyDelayCallbackFn);
			if(clickTimer.hasEventListener(TimerEvent.TIMER)) clickTimer.removeEventListener(TimerEvent.TIMER, CkickTimerListener);
			if(enableHUDBtnTimer.hasEventListener(TimerEvent.TIMER)) enableHUDBtnTimer.removeEventListener(TimerEvent.TIMER, EnableHUDBtnTimerFn);
			if(levelFailTimer.hasEventListener(TimerEvent.TIMER)) levelFailTimer.removeEventListener(TimerEvent.TIMER, LevelFailTimerListener);
			if(levelCompleteTimer.hasEventListener(TimerEvent.TIMER)) levelCompleteTimer.removeEventListener(TimerEvent.TIMER, LevelCompleteTimerListener);
			
			_container.removeEventListener(Event.ACTIVATE, GameInFocus);
			_container.removeEventListener(Event.DEACTIVATE, GameOutOfFocus);
			
			DisableMouseInput();
			
			Utility.RemoveSpriteButtonFromParent(hudContainer, homeBtn, null, null, ButtonMouseClickFn);
			Utility.RemoveSpriteButtonFromParent(hudContainer, resetBtn, null, null, ButtonMouseClickFn);
			
			if(walkthroughBtn){
				Utility.RemoveSpriteButtonFromParent(hudContainer, walkthroughBtn, null, null, ButtonMouseClickFn);
				walkthroughBtn = null;
			}
			
			//Utility.RemoveSpriteButtonFromParent(Registry.gameplayLayer, forwardBtn, null, null, NextLvlClickFn);
			//Utility.RemoveSpriteButtonFromParent(Registry.gameplayLayer, facebookShareBtn, null, null, ShareBtnFn);
			//Utility.RemoveSpriteButtonFromParent(Registry.gameplayLayer, twitterShareBtn, null, null, ShareBtnFn);
			//Utility.RemoveSpriteButtonFromParent(Registry.gameplayLayer, emailShareBtn, null, null, ShareBtnFn);
			
			DeleteSoundButton();
			DeleteMusicButton();
			tutorials.RemoveAll();
			
			Utility.RemoveSpriteChildrenFromParent(hudContainer);
			Utility.RemoveSpriteChildrenFromParent(Registry.guiLayer);
			Utility.RemoveSpriteChildrenFromParent(Registry.gameplayLayer);
			Utility.RemoveSpriteChildrenFromParent(levelObj.spriteContainer);
			//_container.removeChild(levelObj.spriteContainer);
			
			Registry.cursor.ChangeToNormalCursor();
		}
		
		override public function Init():void { 
			//trace("SplashScreen1.Init()");
		}
		
		override public function Free():void { 
			//trace("SplashScreen1.Free()");
		}
		
		override public function Update():void { 
			//trace("SplashScreen1.Update()");
		}
		
		override public function Draw():void {
			if(_gamePaused) return;
			
			levelObj.world.Step(1/worldStep, 10, 10);
			levelObj.world.ClearForces();
			//levelObj.world.DrawDebugData();
			if(allowTextureChange && !gameLost) ChangeMovingPlankTexture();
			//if(gameLost == true) allowTextureChange = false;
			
			//trace("Gameplay: Plank--> W: " +plankObj.blockTexture.width+ "-- H:" + plankObj.blockTexture.height);
			
			for (var b:b2Body = levelObj.world.GetBodyList(); b; b = b.GetNext()) {
				var block:BlockObj = b.GetUserData() as BlockObj;
				if (block != null && block.blockTexture != null){
					block.blockTexture.x = b.GetPosition().x * Constants.PTM_RATIO;
					block.blockTexture.y = b.GetPosition().y * Constants.PTM_RATIO;
					block.blockTexture.rotation = b.GetAngle() * 180 / Math.PI;
				}
			}

			DestroyPendingBlocks();
			
			//profiler.Update();
			
			if (gameLost == true && gameRunning == true) {
				if(Registry.deathCounter >= 100)
				{
					Registry.CompleteAchievement("Die 100 times");
				}	
				LevelFail();
			}
			
			if (LevelObj.blocksToDestroy <= 0 && gameRunning == true) {
				//trace("Checking Stability");
				hud.DisplayCheckingStabilityLBL();
				DisableMouseInput();
				if (AllPlanksStable() == true) {
					hud.RemoveCheckingStabilityLBL();
					//trace("All Planks stable");
					//gameRunning = false;
					LevelComplete();
				}
			}
			

		}
		
		private function DestroyPendingBlocks():void 
		{
			for (var i:int = destroyBlocksList.length - 1; i >= 0; i--) {
				var block:BlockObj = destroyBlocksList[i];
				block.Destroy();
				destroyBlocksList.pop();
				LevelObj.blocksToDestroy--;
				hud.UpdateBlocksLeftLabel(LevelObj.blocksToDestroy);
			}
		}
		
		/**
		 * Called when ever the mouse hovers over a sprite/button.
		 * @param event The event data structure containing the reference to the caller sprite/object.
		 */
		
		private function ButtonMouseClickFn(e:Event):void { 
			Registry.IncrementClickCounter();
			
			if(e.target.name == "home"){
				Utility.ChangeLevel("LevelSelection");
				Registry.gaTracker.trackPageview( "/Level-"+LevelObj.currentLevelNumber + " HomePressed");
			}
			else if(e.target.name == "reset"){
				Utility.ChangeLevel("Gameplay");
				Registry.gaTracker.trackPageview( "/Level-"+LevelObj.currentLevelNumber + " ResetPressed" );
			}
			else if (e.target.name == "walkthrough") {
				//navigateToURL(new URLRequest("http://www.facebook.com/delagames"), "_blank");	
				
				var address:String = "http://delagames.com/solutions/plankbalance/level" + LevelObj.currentLevelNumber + "sol.html";
				navigateToURL(new URLRequest(address), "_blank");
				Registry.gaTracker.trackPageview( "/gameplayWalkthrough" );
			}
			else if(e.target.name == "sound"){
				DeleteSoundButton();
				if(SoundManager.isSoundOn){
					SoundManager.SoundOff();
					CreateSoundButton(AssetManager.SoundOffGFX);
					Registry.gaTracker.trackPageview( "/SoundOff");
				}
				else{
					SoundManager.SoundOn();
					CreateSoundButton(AssetManager.SoundOnGFX);
					Registry.gaTracker.trackPageview( "/SoundOn");
				}
			}
			else if(e.target.name == "music"){
				DeleteMusicButton();
				if(SoundManager.isMusicOn){
					SoundManager.MusicOff();
					CreateMusicButton(AssetManager.MusicOffGFX);
					Registry.gaTracker.trackPageview( "/MusicOff");
				}
				else{
					SoundManager.MusicOn();
					CreateMusicButton(AssetManager.MusicOnGFX);
					Registry.gaTracker.trackPageview( "/MusicOn");
				}
			}


		}
		
		private function EnableMouseInput():void {
			_container.stage.addEventListener(MouseEvent.CLICK, MouseClick);
		}
		
		private function DisableMouseInput():void {
			_container.stage.removeEventListener(MouseEvent.CLICK, MouseClick);
		}
		
		private function MouseClick(e:MouseEvent):void 
		{
			Registry.IncrementClickCounter();
			
			// if the player has clicked the mouse and is waiting for X amount of time
			if (mouseClickWaiting) return;

			//trace("mouse clicked");
			
//			Log.Heatmap("Level"+LevelObj.currentLevelNumber + " Clicks", "MouseClick", mouseX, mouseY);
			
			var locationWorld:b2Vec2 = new b2Vec2(mouseX / Constants.PTM_RATIO,  mouseY / Constants.PTM_RATIO);
			
			for (var b:b2Body = levelObj.world.GetBodyList(); b; b = b.GetNext() )
			{
				if (b.GetUserData() as BlockObj) 
				{
					var fixture:b2Fixture = b.GetFixtureList();
					if (fixture.TestPoint(locationWorld)) 
					{	
						var blockObj:BlockObj = b.GetUserData() as BlockObj;
						if (blockObj != null)
						{
							if (blockObj.IsDestructible()) 
							{
								//trace("Gameplay::MouseClick()");
								mouseClickWaiting = true;
								clickTimer.start();
								Registry.cursor.ChangeToWaitCursor();
								SoundManager.PlayBlockDeleteSFX();
								blockObj.Destroy();
								LevelObj.blocksToDestroy--;
								hud.UpdateBlocksLeftLabel(LevelObj.blocksToDestroy);
								
							}
						}
					}
				}
			}
			
		}
		
		private function CkickTimerListener(e:TimerEvent):void 
		{
			clickTimer.stop();
			clickTimer.reset();
			mouseClickWaiting = false;
			Registry.cursor.ChangeToNormalCursor();
		}
		
		/*----------------------------------------------------------------------
		*----------------------------------------------------------------------*/
		
		private function SlowMotion(delay:Number):void{
			TweenMax.to(this, 2, {worldStep:delay, ease:Linear.easeIn});
		}
		
		private function LevelFail():void {
			SoundManager.PlayLevelFailSFX();
			
			DisableMouseInput();
			levelFailTimer.start();
			gameRunning = false;
			hud.RemoveCheckingStabilityLBL();
			hud.DisplayLevelFailedLBL(3);
			gameTimer.stop();
			
			// Walkthrough BTN BG
			var walkthroughBtnBG:Sprite = GameUtility.TextureManager.BitmapToSprite(new AssetManager.MainMenuWalkthroughBtnBGGFX());
			Registry.gameplayLayer.addChild(walkthroughBtnBG);
			walkthroughBtnBG.x = 699/2;
			walkthroughBtnBG.y = 300;
			TweenMax.to(walkthroughBtnBG, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:0.0});
			
			walkthroughBtn = Utility.CreateSpriteButton(new AssetManager.MainMenuWalkthroughBtnLBLGFX(), new Point(699/2,300), null, null, ButtonMouseClickFn);
			hudContainer.addChild(walkthroughBtn);
			walkthroughBtn.name = "walkthrough";
			walkthroughBtn.scaleX = 0.5;
			walkthroughBtn.scaleY = 0.5;
			walkthroughBtn.alpha = 0.0;
			TweenMax.to(walkthroughBtn, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:0.0});
			
//			Log.LevelCounterMetric("LevelFail",  "Level"+LevelObj.currentLevelNumber); // names must be alphanumeric
//			Log.LevelAverageMetric("Time", "Level"+LevelObj.currentLevelNumber, timer);
			Registry.gaTracker.trackPageview( "/LevelFail-"+LevelObj.currentLevelNumber );

			
			
			SlowMotion(660);
		}
		
		public function get worldStep():Number{
			return _worldStep;
		}
		public function set worldStep(val:Number):void{
			_worldStep = val;
		}
		
		private function LevelFailTimerListener(e:TimerEvent):void 
		{
			Utility.ChangeLevel("Gameplay");
		}
		
		private function NextLvlClickFn(e:Event):void { 
			if(LevelObj.currentLevelNumber > LevelSelection.NUMBER_OF_LEVELS){
				// Change to GameComplete Screen 
				Utility.ChangeLevel("GameComplete");
			}
			else{
				Utility.ChangeLevel("Gameplay");
			}
		}
		
		private function LevelComplete():void {
			
			var OFFSETY:int = 0;
			
			// Add BG:
			/*
			var b:Bitmap = new AssetManager.LevelOverBGGFX();
			b.x = -b.width / 2;
			b.y = -b.height / 2;
			var lvlOverBG:Sprite = new Sprite();
			lvlOverBG.addChild(b);
			lvlOverBG.x = 348;
			lvlOverBG.y = 248 + OFFSETY;
			lvlOverBG.scaleX = 1.05;
			Registry.gameplayLayer.addChild(lvlOverBG);
			*/
			
			// Add forward button
			//forwardBtn = Utility.CreateSpriteButton(new AssetManager.ForwardBtnGFX(), new Point(503, 416 + OFFSETY), null, null, NextLvlClickFn);
			//forwardBtn.name = "forwardBtn";
			//Registry.gameplayLayer.addChild(forwardBtn);
			
			SoundManager.PlayLevelCompleteSFX();
			Registry.SaveGameData();
			
			DisableMouseInput();
			// Reusing LevelFail timer
			levelCompleteTimer.start();
			LevelObj.currentLevelNumber++;
			
			gameRunning = false;
			hud.DisplayLevelCompleteLBL(3, OFFSETY);
			
			gameTimer.stop();
//			Log.LevelCounterMetric("LevelComplete",  "Level"+LevelObj.currentLevelNumber); // names must be alphanumeric
//			Log.LevelAverageMetric("Time", "Level"+LevelObj.currentLevelNumber, timer);
			Registry.gaTracker.trackPageview( "/LevelComplete-" + int(LevelObj.currentLevelNumber - 1) );
			
			LevelSelection.UnlockLevel(LevelObj.currentLevelNumber);
			
			if((LevelObj.currentLevelNumber - 1) == 1)
			{
				Registry.CompleteAchievement("Finish Level 1");
			}
			if((LevelObj.currentLevelNumber - 1) == 3)
			{
				Registry.CompleteAchievement("Finish Level 3"); 
				if(timer <= 6)
				{
					Registry.CompleteAchievement("Get 3 stars on Level 3");
				}
			}
			if((LevelObj.currentLevelNumber - 1) == 11)
			{
				Registry.CompleteAchievement("Finish Level 11"); 
			}
			if((LevelObj.currentLevelNumber - 1) == 23)
			{
				if(timer <= 7)
				{
					Registry.CompleteAchievement("Get 3 stars on Level 23");
				}
			}
			if((LevelObj.currentLevelNumber - 1) == 10)
			{
				Registry.CompleteAchievement("Complete first 10 levels"); 
			}
		
			SlowMotion(1000);
			
			hud.DisplayStars(timer, LevelObj.currentLevelNumber - 1, 250 + OFFSETY, levelObj.spriteContainer);
			
			/*
			facebookShareBtn = Utility.CreateSpriteButton(new AssetManager.FacebookShareGFX(), new Point(218, 349 + OFFSETY), null, null, ShareBtnFn);
			facebookShareBtn.name = "facebookShareBtn";
			Registry.gameplayLayer.addChild(facebookShareBtn);
			
			twitterShareBtn = Utility.CreateSpriteButton(new AssetManager.TwitterShareGFX(), new Point(347, 349 + OFFSETY), null, null, ShareBtnFn);
			twitterShareBtn.name = "twitterShareBtn";
			Registry.gameplayLayer.addChild(twitterShareBtn);

			emailShareBtn = Utility.CreateSpriteButton(new AssetManager.EmailShareGFX(), new Point(476, 349 + OFFSETY), null, null, ShareBtnFn);
			emailShareBtn.name = "emailShareBtn";
			Registry.gameplayLayer.addChild(emailShareBtn);
			*/
		}

		private function ShareBtnFn(e:Event):void { 
			if (e.target.name == "facebookShareBtn") 
			{
				var req:URLRequest = new URLRequest();
				req.url = "http://www.facebook.com/dialog/feed";
				var vars:URLVariables = new URLVariables();
				vars.app_id = "000000000000"; // your application's id
				vars.link = "http://YourSite.com";
				vars.picture = "https://www.google.com/intl/en_com/images/srpr/logo3w.png";
				vars.name = "name name";
				vars.caption = "caption caption caption";
				vars.description = "description description description";
				vars.message = "message message message message message";
				vars.redirect_uri = "http://YourSite.com";
				req.data = vars;
				req.method = URLRequestMethod.GET;
				navigateToURL(req, "_blank");
       
			}
			else if (e.target.name == "twitterShareBtn")
			{
				
			}
			else if (e.target.name == "emailShareBtn")
			{
				
			}
		}
		
		private function LevelCompleteTimerListener(e:TimerEvent):void 
		{
			if(LevelObj.currentLevelNumber > LevelSelection.NUMBER_OF_LEVELS){
				// Change to GameComplete Screen 
				Utility.ChangeLevel("GameComplete");
			}
			else{
				Utility.ChangeLevel("Gameplay");
				LevelSelection.UnlockLevel(LevelObj.currentLevelNumber);
			}
		}

		
		//----------------------------------------------------------------------
		//----------------------------------------------------------------------
		
		
		private function IsBodyInAir(blockObj:BlockObj):Boolean{
			//var isBodyInAir:Boolean = true;
			var edge:b2ContactEdge = blockObj.blockBody.GetContactList();
			while (edge) {
				var contact:b2Contact = edge.contact;
				if(contact){
					if(contact.IsTouching())
					{
						//isBodyInAir = false;
						return false;
					}
				}
				edge = edge.next;
			}
			//return isBodyInAir;
			return true;
		}
		
		private function AllPlanksStable():Boolean {
			const DELTA:Number = 0.01;
			var areTotemsStable:Boolean = false;
			
			for (var b:b2Body = levelObj.world.GetBodyList(); b; b = b.GetNext()) {
				var blockObj:BlockObj = b.GetUserData() as BlockObj;
				if(blockObj != null){
					if (blockObj.blockType == Constants.BLOCKTYPE_PLANK) {
						
						// check if plank is in air or touching some block
						if(this.IsBodyInAir(blockObj)){
							return false;
						}
						else{
							var plankVel:b2Vec2 = blockObj.blockBody.GetLinearVelocity();
							if(Math.abs(plankVel.x) < DELTA && Math.abs(plankVel.y) < DELTA){
								areTotemsStable = true;
							}
							else {
								// immediately return false if even one of the totems is not stable!
								return false;
							}
						}
					}
				}
			}
			
			return areTotemsStable;
		}

		private function ChangeMovingPlankTexture():void{
			const DELTA:Number = 0.4;
			var areTotemsStable:Boolean = false;
			
			for (var b:b2Body = levelObj.world.GetBodyList(); b; b = b.GetNext()) {
				var blockObj:BlockObj = b.GetUserData() as BlockObj;
				if(blockObj != null){
					if (blockObj.blockType == Constants.BLOCKTYPE_PLANK) {
						
						var plankVel:b2Vec2 = blockObj.blockBody.GetLinearVelocity();
						if(Math.abs(plankVel.x) < DELTA && Math.abs(plankVel.y) < DELTA){
							//areTotemsStable = true;
							ChangePlankTexture(blockObj, AssetManager.PlankGFXClass);
						}
						else {
							// Plank is moving, change its texture
							ChangePlankTexture(blockObj, AssetManager.PlankMovingGFXClass);
							//return false;
						}	
					}
				}
			}
		}

		
		public static function ChangePlankTexture(plankObj:BlockObj, TextureGFX:Class):void{
			levelObj.spriteContainer.removeChild(plankObj.blockTexture);
			var bitmap:Bitmap = new TextureGFX();
			//trace("Gameplay: Plank--> W: " +plankObj.W+ "-- H:" + plankObj.H);
			bitmap.width = plankObj.W;
			bitmap.height = plankObj.H;
			var sprite:Sprite = TextureManager.BitmapToSprite(bitmap);
			levelObj.spriteContainer.addChild(sprite);
			plankObj.blockTexture = sprite;	
		}
		
		private static function GetWalkthroughAddress(currentLevel:int):String
		{
			return "";
		}
		
	}
}