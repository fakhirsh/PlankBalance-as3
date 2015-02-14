package Scenes.Credits
{
	import AssetMgr.AssetManager;
	
	import CoreGameEngine.GameState;
	
	import GameUtility.Utility;
	
//	import Playtomic.Log;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.net.*;
	
	public class Credits extends GameState
	{
		private var container:Sprite = new Sprite();
		
		public function Credits()
		{
			super();
		}
		
		override public function Load():void {
			
			container = Registry.gameplayLayer;
			
//			Log.CustomMetric("Credits");
			
			// Credits List
			var credits:Sprite = GameUtility.TextureManager.BitmapToSprite(new AssetManager.CreditsGFX());
			container.addChild(credits);
			credits.x = Registry.gameplayLayer.stage.stageWidth/2;
			credits.y = 161;
			credits.alpha = 0.0;
			credits.scaleX = 0.6;
			credits.scaleY = 0.6;
			TweenMax.to(credits, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:0.1});
			
			// Credits List
			var mcredits:Sprite = GameUtility.TextureManager.BitmapToSprite(new AssetManager.MusicCreditsGFX());
			container.addChild(mcredits);
			mcredits.x = Registry.gameplayLayer.stage.stageWidth/2;
			mcredits.y = 371;
			mcredits.alpha = 0.0;
			mcredits.scaleX = 0.6;
			mcredits.scaleY = 0.6;
			TweenMax.to(mcredits, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:0.3});
			
			
			// Add delagames logo
			var logo:Sprite = Utility.CreateSpriteButton(new AssetManager.delagamesLogoSmallGFX(), new Point(197,285), null, null, ButtonMouseClickFn);
			logo.x = 629;
			logo.y = 429;
			container.addChild(logo);
			logo.scaleX = 0.5;
			logo.scaleY = 0.5;
			logo.alpha = 0.0;
			logo.name = "delaGamesLogoSmall";
			TweenMax.to(logo, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:0.4});

			// Add back button
			var backBtn:Sprite = Utility.CreateSpriteButton(new AssetManager.BackBtnGFX(), new Point(66,416), null, null, ButtonMouseClickFn);
			container.addChild(backBtn);
			backBtn.x = 70;
			backBtn.y = 406;
			backBtn.scaleX = 0.6;
			backBtn.scaleY = 0.6;
			backBtn.alpha = 0.0;
			backBtn.name = "backBtn";
			TweenMax.to(backBtn, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:0.5});
			
			Registry.gaTracker.trackPageview( "/CreditsScreenLoaded");
			
			
		}
		
		public function ButtonMouseClickFn(e:Event):void { 
			
			Registry.IncrementClickCounter();
			
			if(e.target.name == "delaGamesLogoSmall"){
//				Log.CustomMetric("byteRenderLogo Pressed");
				Registry.gaTracker.trackPageview( "/CreditsLogoSmallClick");
				//navigateToURL(new URLRequest("http://www.delagames.com/"), "_blank");
				navigateToURL(new URLRequest("https://www.facebook.com/gamesbyfakhir"), "_blank");
				Registry.CompleteAchievement("Click on sponsor logo");
			}
			else if(e.target.name == "backBtn"){
				Utility.ChangeLevel("MainMenu");
				Registry.gaTracker.trackPageview( "/CreditsBackBtnClick");
			}
		}
		
		override public function UnLoad():void { 
			Utility.RemoveSpriteChildrenFromParent(container);
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
			//trace("SplashScreen1.Draw()");
		}

	}
}