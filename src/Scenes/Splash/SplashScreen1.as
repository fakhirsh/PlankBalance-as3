package Scenes.Splash 
{
	import AssetMgr.AssetManager;
	import AssetMgr.SoundManager;
	
	import CoreGameEngine.GameState;
	
	import GameElements.Background;
	
	import GameUtility.Utility;
	
	import LevelSVGLoader.SVGLevelList;
	
//	import Playtomic.Log;
	
	import Scenes.LevelSelection.LevelSelection;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author fakhir
	 */
	public class SplashScreen1 extends GameState
	{
		
		private var splashTimer:Timer;
		//private var splash:MovieClip;
		//private var container:Sprite = new Sprite();
		
		public function SplashScreen1() 
		{
		}

		override public function Load():void { 
			//trace("SplashScreen::Load");
			
			// Add a Common background that will serve for ALLL the screens in the game
			//PlankBalance.bgContainer = new Sprite();
			var background:Background = new Background(Registry.bgLayer);

			var logoLarge:Sprite = GameUtility.TextureManager.BitmapToSprite(new AssetManager.delagamesLogoLargeGFX());
			Registry.gameplayLayer.addChild(logoLarge);
			logoLarge.x = 348;
			logoLarge.y = 203;
			logoLarge.alpha = 0.0;
			logoLarge.name = "logoLarge";
			TweenMax.to(logoLarge, 2, {alpha:1.0, delay:0.0});
			
			logoLarge.addEventListener(MouseEvent.MOUSE_OVER, ButtonMouseOverFn);
			logoLarge.addEventListener(MouseEvent.MOUSE_OUT, ButtonMouseOutFn);
			logoLarge.addEventListener(MouseEvent.CLICK, ButtonMouseClickFn);
			
			splashTimer = new Timer(4000, 1);
			//splashTimer = new Timer(500, 1);
			splashTimer.addEventListener(TimerEvent.TIMER, runOnce);
			splashTimer.start();
			
			//PlankBalance.mainStage.addChild(PlankBalance.bgContainer);
			//PlankBalance.mainStage.addChild(container);
			
		}

		/**
		 * Called when ever the mouse hovers over a sprite/button.
		 * @param event The event data structure containing the reference to the caller sprite/object.
		 */
		public function ButtonMouseOverFn(e:Event):void { 
			TweenMax.to(e.target, 0.6, {scaleX:1.1, scaleY:1.1, ease:Elastic.easeOut});
		}
		
		public function ButtonMouseOutFn(e:Event):void { 
			TweenMax.to(e.target, 0.4, {scaleX:1.0, scaleY:1.0, ease:Elastic.easeOut});
		}
		
		public function ButtonMouseClickFn(e:Event):void { 
			//navigateToURL(new URLRequest("http://www.delagames.com/"), "_blank");	
			navigateToURL(new URLRequest("https://www.facebook.com/gamesbyfakhir"), "_blank");
			Registry.gaTracker.trackPageview( "/SplashLogoClicked");
		}

		
		private function RemoveChildFromParent(parent:DisplayObjectContainer, child:DisplayObject):void{
			
			if(child.hasEventListener(MouseEvent.MOUSE_OVER)) child.removeEventListener(MouseEvent.MOUSE_OVER, ButtonMouseOverFn);
			if(child.hasEventListener(MouseEvent.MOUSE_OUT)) child.removeEventListener(MouseEvent.MOUSE_OUT, ButtonMouseOutFn);
			if(child.hasEventListener(MouseEvent.CLICK)) child.removeEventListener(MouseEvent.CLICK, ButtonMouseClickFn);
			
			parent.removeChild(child);
		}
		
		private function RemoveChildren(parent:DisplayObjectContainer):void {
			while (parent.numChildren > 0) {
				RemoveChildFromParent(parent, parent.getChildAt(0));
			}
		}
		

		
		private function runOnce(event:TimerEvent):void {
			Utility.ChangeLevel("MainMenu");
		}
		
		override public function UnLoad():void { 
			//trace("SplashScreen1.Unload()");
			RemoveChildren(Registry.gameplayLayer);
			splashTimer.removeEventListener(TimerEvent.TIMER, runOnce);
			//PlankBalance.mainStage.removeChild(splash);
			
			SoundManager.PlayMusic();
			LevelSelection.LoadLevelLockList();
			SVGLevelList.InitLevelList();
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