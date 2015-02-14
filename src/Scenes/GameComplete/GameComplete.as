package Scenes.GameComplete
{
	import AssetMgr.AssetManager;
	import AssetMgr.SoundManager;
	
	import CoreGameEngine.GameState;
	
	import GameUtility.Utility;
	
//	import Playtomic.Log;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.net.*;

	
	public class GameComplete extends GameState
	{
		private var container:Sprite = new Sprite();
		
		public function GameComplete()
		{
			
		}
		override public function Load():void { 
			
//			Log.CustomMetric("GameComplete");
			Registry.gaTracker.trackPageview( "/GameComplete");
			Registry.CompleteAchievement("FInish Game");
			
			// Plank
			var plank:Sprite = GameUtility.TextureManager.BitmapToSprite(new AssetManager.GameCompletePlankGFX());
			Registry.gameplayLayer.addChild(plank);
			plank.x = Registry.gameplayLayer.stage.stageWidth/2;
			plank.y = 114;
			plank.alpha = 0.0;
			plank.scaleX = 0.6;
			plank.scaleY = 0.6;
			TweenMax.to(plank, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:0.1});

			// Cup
			var cup:Sprite = GameUtility.TextureManager.BitmapToSprite(new AssetManager.GameCompleteCupGFX());
			Registry.gameplayLayer.addChild(cup);
			cup.x = 290;
			cup.y = 164;
			cup.alpha = 0.0;
			cup.scaleX = 0.6;
			cup.scaleY = 0.6;
			TweenMax.to(cup, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:0.4});

			// Lbl1
			var lbl1:Sprite = GameUtility.TextureManager.BitmapToSprite(new AssetManager.GameCompleteLbl1GFX());
			Registry.gameplayLayer.addChild(lbl1);
			lbl1.x = Registry.gameplayLayer.stage.stageWidth/2;
			lbl1.y = 247;
			lbl1.alpha = 0.0;
			lbl1.scaleX = 0.6;
			lbl1.scaleY = 0.6;
			TweenMax.to(lbl1, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:0.2});

			// Lbl2
			var lbl2:Sprite = GameUtility.TextureManager.BitmapToSprite(new AssetManager.GameCompleteLbl2GFX());
			Registry.gameplayLayer.addChild(lbl2);
			lbl2.x = Registry.gameplayLayer.stage.stageWidth/2;
			lbl2.y = 298;
			lbl2.alpha = 0.0;
			lbl2.scaleX = 0.6;
			lbl2.scaleY = 0.6;
			TweenMax.to(lbl2, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:0.3});
			
			// Add byteRender logo
			var logo:Sprite = Utility.CreateSpriteButton(new AssetManager.delagamesLogoSmallGFX(), new Point(197,285), null, null, ButtonMouseClickFn);
			logo.x = 629;
			logo.y = 429;
			Registry.gameplayLayer.addChild(logo);
			logo.scaleX = 0.5;
			logo.scaleY = 0.5;
			logo.alpha = 0.0;
			logo.name = "delagamesLogoSmall";
			TweenMax.to(logo, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:0.9});
			
			// Add back button
			var backBtn:Sprite = Utility.CreateSpriteButton(new AssetManager.BackBtnGFX(), new Point(66,416), null, null, ButtonMouseClickFn);
			Registry.gameplayLayer.addChild(backBtn);
			backBtn.x = 70;
			backBtn.y = 406;
			backBtn.scaleX = 0.6;
			backBtn.scaleY = 0.6;
			backBtn.alpha = 0.0;
			backBtn.name = "backBtn";
			TweenMax.to(backBtn, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:1.0});
			
			//PlankBalance.mainStage.addChild(container);
			//container = Registry.gameplayLayer;
			
			SoundManager.PlayGameCompleteSFX();
			
		}

		public function ButtonMouseClickFn(e:Event):void { 
			
			if(e.target.name == "delagamesLogoSmall"){
//				Log.CustomMetric("byteRenderLogo Pressed");
				Registry.gaTracker.trackPageview( "/GameCompleteSmallLogoPressed");
				//navigateToURL(new URLRequest("http://www.delagames.com/"), "_blank");
				navigateToURL(new URLRequest("http://www.facebook.com/delagames"), "_blank");
			}
			else if(e.target.name == "backBtn"){
				Utility.ChangeLevel("MainMenu");
			}
		}
		
		
		override public function UnLoad():void { 
			Utility.RemoveSpriteChildrenFromParent(Registry.gameplayLayer);
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