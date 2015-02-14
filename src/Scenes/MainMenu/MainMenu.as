package Scenes.MainMenu
{
	import AssetMgr.*;
	import CoreGameEngine.GameState;
	import GameElements.Background;
	import GameUtility.TextureManager;
	import GameUtility.Utility;
	import com.greensock.*;
	import com.greensock.easing.*;
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class MainMenu extends GameState
	{
		//private var profiler:Profiler;
		private var container:Sprite;
		private var playBtn:Sprite;
		private var creditsBtn:Sprite;
		private var walkthroughBtn:Sprite;
		private var logoBtn:Sprite;
		private var plankBtn:Sprite;
		private var soundBtn:Sprite;
		private var musicBtn:Sprite;
		private var facebook1Btn:Sprite;
		private var hostThisGameBtn:Sprite;
		
		public function MainMenu()
		{
			
		}
		
		override public function Load():void { 
			
			container = Registry.gameplayLayer;
			
//			Log.CustomMetric("MainMenu");
			
			// Place DECORATIVE scene elements like background, blocks and Plank, main title etc etc
			InitScene();
			// Initialize Main menu buttons etc
			InitMenuButtons();
			
			// Add a FPS and Memory profiler
			//profiler = new Profiler(600,50,container);
			
			Registry.gaTracker.trackPageview( "/MainMenuLoaded");
			
			GamerSafe.api.showStatusBar();
		}
		/**
		 * Unloads all assets and frees memory
		 * @param none
		*/
		override public function UnLoad():void { 
			//trace("MainMenu.Unload()");
			// First remove the buttons
			Utility.RemoveSpriteButtonFromParent(container, playBtn, null, null, ButtonMouseClickFn);
			Utility.RemoveSpriteButtonFromParent(container, creditsBtn, null, null, ButtonMouseClickFn);
			Utility.RemoveSpriteButtonFromParent(container, logoBtn, null, null, ButtonMouseClickFn);
			Utility.RemoveSpriteButtonFromParent(container, facebook1Btn, null, null, ButtonMouseClickFn);
			Utility.RemoveSpriteButtonFromParent(container, hostThisGameBtn, null, null, ButtonMouseClickFn);
			Utility.RemoveSpriteButtonFromParent(container, plankBtn, null, null, null);
			
			DeleteSoundButton();
			DeleteMusicButton();
			
			// Now remove normal children
			Utility.RemoveSpriteChildrenFromParent(container);
			
			//trace("Container contains: " + container.numChildren);
			//PlankBalance.mainStage.removeChild(container);
		}
		
		override public function Init():void { 
			//trace("MainMenu.Init()");
		}
		
		override public function Free():void { 
			//trace("MainMenu.Free()");
		}
		
		override public function Update():void { 
			//trace("MainMenu.Update()");
			//profiler.Update();
		}
		
		override public function Draw():void { 
			//trace("MainMenu.Draw()");
		}
		
		/**
		 * Initializes main menu scene and puts decorative elements like random blocks, Plank, main title etc
		*/
		private function InitScene():void{
			// ...
			// Background: We already loaded that in the SplashScreen scene
			// ...			
			
			// Create Floor
			var floor:Bitmap = new AssetManager.FloorGFX();
			floor.y = Registry.gameplayLayer.stage.stageHeight - floor.height;
			container.addChild(floor);
			
			// Main Title: PLANK
			var titleBalance:Sprite = GameUtility.TextureManager.BitmapToSprite(new AssetManager.MainMenuTitleBalanceGFX());
			container.addChild(titleBalance);
			titleBalance.x = 234;
			titleBalance.y = 183;
			TweenMax.to(titleBalance, 2.5, {y:183+5, repeat:-1, yoyo:true});
			
			// Main Title: BALANCE
			var titlePlank:Sprite = GameUtility.TextureManager.BitmapToSprite(new AssetManager.MainMenuTitlePlankGFX());
			container.addChild(titlePlank);
			titlePlank.x = 234;
			titlePlank.y = 93;
			TweenMax.to(titlePlank, 3.5, {x:234+5, repeat:-1, yoyo:true});
			
			// Add some blocks
			var dirtBlock1:Sprite = GameUtility.TextureManager.CreateRectTexture(0,0,183,45,1.0,AssetManager.DirtTileGFX, true, true);
			dirtBlock1.x = 559;
			dirtBlock1.y = 314;
			container.addChild(dirtBlock1);
			
			var steelBlock1:Sprite = GameUtility.TextureManager.CreateRectTexture(0,0,183,45,1.0,AssetManager.SteelTileGFX, true, true);
			steelBlock1.x = 559;
			steelBlock1.y = 405;
			container.addChild(steelBlock1);
			
			var iceBlock1:Sprite = GameUtility.TextureManager.CreateRectTexture(0,0,80,46,1.0,AssetManager.IceTileGFX, true, true, true);
			iceBlock1.x = 491;
			iceBlock1.y = 360;
			container.addChild(iceBlock1);
			
			var iceBlock2:Sprite = GameUtility.TextureManager.CreateRectTexture(0,0,40,162,1.0,AssetManager.IceTileGFX, true, true, true);
			iceBlock2.x = 420;
			iceBlock2.y = 346;
			container.addChild(iceBlock2);
			
			var rubberBlock1:Sprite = GameUtility.TextureManager.CreateRectTexture(0,0,90,46,1.0,AssetManager.RubberTileGFX, true, true);
			rubberBlock1.x = 630;
			rubberBlock1.y = 360;
			container.addChild(rubberBlock1);
			
			var roundDirtBlock1:Sprite = GameUtility.TextureManager.CreateRoundTexture(0,0,46/2,1.0,AssetManager.DirtTileGFX, true, true);
			roundDirtBlock1.x = 555;
			roundDirtBlock1.y = 360;
			container.addChild(roundDirtBlock1);

			// Add Plank character
			//plankBtn = Utility.CreateSpriteButton(new AssetManager.MainMenuPlankCharacterGFX(), new Point(559,187), null, null, null);
			var b:Bitmap = new AssetManager.MainMenuPlankCharacterGFX();
			b.x = -b.width / 2;
			b.y = -b.height / 2;
			plankBtn = new Sprite();
			plankBtn.addChild(b);
			plankBtn.x = 559;
			plankBtn.y = 187;
			container.addChild(plankBtn);

			// Add byteRender logo
			logoBtn = Utility.CreateSpriteButton(new AssetManager.delagamesLogoSmallGFX(), new Point(629,429), null, null, ButtonMouseClickFn);
			container.addChild(logoBtn);
			logoBtn.name = "delagamesLogoSmall";

		}
	
		/**
		 * Initializes menu buttons and their animations.
		*/
		private function InitMenuButtons():void{
			
			var OFFSETX:int = -30;
						
			// Play BTN BG
			var playBtnBG:Sprite = GameUtility.TextureManager.BitmapToSprite(new AssetManager.MainMenuPlayBtnBGGFX());
			container.addChild(playBtnBG);
			playBtnBG.x = -playBtnBG.width/2;
			playBtnBG.y = 285;
			TweenMax.to(playBtnBG, 0.4, {x:OFFSETX+197, ease:Cubic.easeInOut});

			// Credits BTN BG
			var creditsBtnBG:Sprite = GameUtility.TextureManager.BitmapToSprite(new AssetManager.MainMenuCreditsBtnBGGFX());
			container.addChild(creditsBtnBG);
			creditsBtnBG.x = -creditsBtnBG.width/2;
			creditsBtnBG.y = 352;
			TweenMax.to(creditsBtnBG, 0.6, {x:OFFSETX+196, ease:Cubic.easeInOut});

			// Walkthrough BTN BG
			var walkthroughBtnBG:Sprite = GameUtility.TextureManager.BitmapToSprite(new AssetManager.MainMenuWalkthroughBtnBGGFX());
			container.addChild(walkthroughBtnBG);
			walkthroughBtnBG.x = -walkthroughBtnBG.width/2;
			walkthroughBtnBG.y = 396;
			TweenMax.to(walkthroughBtnBG, 0.8, {x:OFFSETX+195, ease:Cubic.easeInOut});

			
			// Play BTN
			playBtn = Utility.CreateSpriteButton(new AssetManager.MainMenuPlayBtnLBLGFX(), new Point(OFFSETX+197,285), null, null, ButtonMouseClickFn);
			container.addChild(playBtn);
			playBtn.scaleX = 0.5;
			playBtn.scaleY = 0.5;
			playBtn.alpha = 0.0;
			playBtn.name = "PlayBtnLBL";
			TweenMax.to(playBtn, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:0.6});
			
			// Credits BTN
			creditsBtn = Utility.CreateSpriteButton(new AssetManager.MainMenuCreditsBtnLBLGFX(), new Point(OFFSETX+196,352), null, null, ButtonMouseClickFn);
			container.addChild(creditsBtn);
			creditsBtn.scaleX = 0.5;
			creditsBtn.scaleY = 0.5;
			creditsBtn.alpha = 0.0;
			creditsBtn.name = "CreditsBtnLBL";
			TweenMax.to(creditsBtn, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:0.8});

			// Credits BTN
			walkthroughBtn = Utility.CreateSpriteButton(new AssetManager.MainMenuWalkthroughBtnLBLGFX(), new Point(OFFSETX+195,396), null, null, ButtonMouseClickFn);
			container.addChild(walkthroughBtn);
			walkthroughBtn.scaleX = 0.5;
			walkthroughBtn.scaleY = 0.5;
			walkthroughBtn.alpha = 0.0;
			walkthroughBtn.name = "WalkthroughBtnLBL";
			TweenMax.to(walkthroughBtn, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:0.9});

			// Facebook BTN
			facebook1Btn = Utility.CreateSpriteButton(new AssetManager.FacebookIconGFX(), new Point(340,360), null, null, ButtonMouseClickFn);
			container.addChild(facebook1Btn);
			facebook1Btn.scaleX = 0.5;
			facebook1Btn.scaleY = 0.5;
			facebook1Btn.alpha = 0.0;
			facebook1Btn.name = "facebook1BtnLBL";
			TweenMax.to(facebook1Btn, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:0.9});


			// Host this game BTN
			//hostThisGameBtn = Utility.CreateSpriteButton(new AssetManager.MainMenuHostThisGameGFX(), new Point(350,450), null, null, ButtonMouseClickFn);
			//container.addChild(hostThisGameBtn);
			//hostThisGameBtn.scaleX = 0.5;
			//hostThisGameBtn.scaleY = 0.5;
			//hostThisGameBtn.alpha = 0.0;
			//hostThisGameBtn.name = "hostThisGameBtnLBL";
			//TweenMax.to(hostThisGameBtn, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:1.1});

			
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

		}
		
		private function CreateSoundButton(BtnGFX:Class, animated:Boolean=false):void{
			soundBtn = Utility.CreateSpriteButton(new BtnGFX(), new Point(490+50,24), null, null, ButtonMouseClickFn);
			container.addChild(soundBtn);
			soundBtn.name = "sound";
			if(animated){
				soundBtn.scaleX = 0.5;
				soundBtn.scaleY = 0.5;
				soundBtn.alpha = 0.0;
				TweenMax.to(soundBtn, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:0.2});
			}
		}
		
		private function CreateMusicButton(BtnGFX:Class, animated:Boolean=false):void{
			musicBtn = Utility.CreateSpriteButton(new BtnGFX(), new Point(538+50,24), null, null, ButtonMouseClickFn);
			container.addChild(musicBtn);
			musicBtn.name = "music";
			if(animated){
				musicBtn.scaleX = 0.5;
				musicBtn.scaleY = 0.5;
				musicBtn.alpha = 0.0;
				TweenMax.to(musicBtn, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:0.2});
			}
		}
		private function DeleteSoundButton():void{
			Utility.RemoveSpriteButtonFromParent(container, soundBtn, null, null, ButtonMouseClickFn);
		}		
		
		private function DeleteMusicButton():void{
			Utility.RemoveSpriteButtonFromParent(container, musicBtn, null, null, ButtonMouseClickFn);
		}		

		
		/**
		 * Called when ever the mouse hovers over a sprite/button.
		 * @param event The event data structure containing the reference to the caller sprite/object.
		*/
		
		private function ButtonMouseClickFn(e:Event):void { 
			
			Registry.IncrementClickCounter();
			
			if(e.target.name == "delagamesLogoSmall"){
//				Log.CustomMetric("byteRenderLogo Pressed");
				//navigateToURL(new URLRequest("http://www.delagames.com/"), "_blank");
				navigateToURL(new URLRequest("https://www.facebook.com/gamesbyfakhir"), "_blank");
				Registry.gaTracker.trackPageview( "/MainMenuLogoSmallClick");
				Registry.CompleteAchievement("Click on sponsor logo");
			}
			else if(e.target.name == "CreditsBtnLBL"){
				Utility.ChangeLevel("Credits");
				Registry.gaTracker.trackPageview( "/MainMenuCreditsBtnClick");
			}
			else if(e.target.name == "PlayBtnLBL"){
				Utility.ChangeLevel("LevelSelection");
				Registry.gaTracker.trackPageview( "/MainMenuPlayBtnClick");
			}
			else if(e.target.name == "WalkthroughBtnLBL"){
//				Log.CustomMetric("WalkthroughBtn Pressed");
				Registry.gaTracker.trackPageview( "/MainMenuWalkthroughBtnClick");
				navigateToURL(new URLRequest("http://fakhir.heliohost.org/solutions/plankbalance/levelsolution.html"), "_blank");
			}
			else if(e.target.name == "facebook1BtnLBL"){
//				Log.CustomMetric("WalkthroughBtn Pressed");
				Registry.gaTracker.trackPageview( "/MainMenufacebook1BtnClick");
				navigateToURL(new URLRequest("https://www.facebook.com/gamesbyfakhir"), "_blank");
				Registry.CompleteAchievement("Like us on facebook");
			}
			else if(e.target.name == "hostThisGameBtnLBL"){
//				Log.CustomMetric("WalkthroughBtn Pressed");
				Registry.gaTracker.trackPageview( "/MainMenuHostThisBtnClick");
				//navigateToURL(new URLRequest("http://flashgamedistribution.com/profile/fakhir"), "_blank");
				//navigateToURL(new URLRequest("http://www.mochimedia.com/games/play/plank-balance_v753214"), "_blank");
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
		
		
	}
}