package Scenes.LevelSelection 
{
	import AssetMgr.AssetManager;
	import AssetMgr.SoundManager;
	
	import CoreGameEngine.GameState;
	
	import GameUtility.Profiler;
	import GameUtility.Utility;
	
	import LevelSVGLoader.SVGLevelList;
	
//	import Playtomic.Log;
	
	import Scenes.Gameplay.LevelObj;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.net.SharedObject;
	
	/**
	 * ...
	 * @author fakhir
	 */
	public class LevelSelection extends GameState
	{
		//private var profiler:Profiler;
		private var container:Sprite;
		private var activeThumbsContainer:Sprite = new Sprite();
		private var disableThumbsContainer:Sprite = new Sprite();
		
		private var backBtn:Sprite;
		private var forwardBtn:Sprite;
		
		private const MAXROW:int = 3;
		private const MAXCOL:int = 5;
		public static const NUMBER_OF_LEVELS:int = 29;
		private var currentPage:int = 0;
		private var maxPage:int = 0;
		private var gameStart:Boolean = false;
		
		
		public function LevelSelection() 
		{
		}

		public static function LoadLevelLockList():void{
			if(Registry.levelLocked == null){
				
				//Registry.levelLocked = new Vector.<Boolean>;
				
				Registry.levelLocked.push(true);	// Level 0  ,non Existant
				Registry.levelLocked.push(false);	// First level: 1
				for(var i:int = 1; i < NUMBER_OF_LEVELS+1; i++){
					Registry.levelLocked.push(true);
					//Registry.levelLocked.push(false);	// FOR TESTING ONLY
				}
			}
		}
		
		public static function UnlockLevel(lvlNo:int):void{
			Registry.levelLocked[lvlNo] = false;
		}
		
		override public function Load():void {
			
//			Log.CustomMetric("LevelSelection");
			
			container = Registry.gameplayLayer;
			
			// Main title			
			var title:Sprite = GameUtility.TextureManager.BitmapToSprite(new AssetManager.LevelSelectionTitleGFX());
			container.addChild(title);
			title.x = Registry.gameplayLayer.stage.stageWidth/2;
			title.y = 49;
			title.alpha = 0.0;
			title.scaleX = 0.6;
			title.scaleY = 0.6;
			TweenMax.to(title, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:0.1});			
			
			// Add back button
			backBtn = Utility.CreateSpriteButton(new AssetManager.BackBtnGFX(), new Point(66,416), null, null, ButtonMouseClickFn);
			container.addChild(backBtn);
			backBtn.scaleX = 0.6;
			backBtn.scaleY = 0.6;
			backBtn.alpha = 0.0;
			backBtn.name = "backBtn";
			TweenMax.to(backBtn, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:0.5});
			
			// Add forward button
			forwardBtn = Utility.CreateSpriteButton(new AssetManager.ForwardBtnGFX(), new Point(627,416), null, null, ButtonMouseClickFn);
			container.addChild(forwardBtn);
			forwardBtn.scaleX = 0.6;
			forwardBtn.scaleY = 0.6;
			forwardBtn.alpha = 0.0;
			forwardBtn.name = "forwardBtn";
			TweenMax.to(forwardBtn, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:0.5});

			//profiler = new Profiler(600,50,container);
			
			container.addChild(activeThumbsContainer);
			container.addChild(disableThumbsContainer);
			//PlankBalance.mainStage.addChild(container);
			
			maxPage = int(NUMBER_OF_LEVELS / (MAXROW * MAXCOL)) + 1;
			//trace("total number of pages: " + maxPage);
			ChangePage(0);
			
			//_cursorContainer = new Sprite();
			//container.addChild(_cursorContainer);
			//_cursor = new Cursor(_cursorContainer);
			
			Registry.gaTracker.trackPageview( "/LevelSelectionLoaded");
		}
		
		private function TintColor(sprite:Sprite):void {
			sprite.transform.colorTransform = new ColorTransform(0.4, 0.4, 0.4, 0.4, 0,0,0,0);
		}
		
		/**
		 * Add related level thumbnails to current page.
		 * @param pageNumber Tells which thumbnail should be loaded initially (upper left side) on current page. If pageNumber is 5, start thumbnail will be like 46 or so. 
		*/
		private function AddLevelThumbnailsToPage(pageNumber:int):void{
			
			var startCorner:Point = new Point(124, 135);
			var xIncrement:int = 112;
			var yIncrement:int = 98;
			var delay:Number = 0.0;

			var ROW:int;
			var COL:int;
			
			var difference:int = Math.abs(NUMBER_OF_LEVELS - (pageNumber)*(MAXROW*MAXCOL));
			
			if((pageNumber+1) >= Math.ceil(NUMBER_OF_LEVELS/(MAXROW*MAXCOL))){
				ROW = difference / MAXROW;
			}
			else{
				ROW = MAXROW;
			}
			COL = MAXCOL;
			
			// some pages might contain only partial thumbnails, like in case of 21 levels !

			
			for(var R:int = 0; R < ROW; R++){
				for(var C:int = 0; C < COL; C++){

					if(R*COL+C >= difference) return;
					
					var lvlThumb:Sprite;
					//////////////////////////////////////////////////////////////////////////////////////
					
					var lvlThumbNumber:int = pageNumber*MAXROW*COL + COL * R + C+1;
					var endAlpha:Number = 1.0;
					
					var lvlThumbGFX:Class = SVGLevelList.GetLevelThumbClass(lvlThumbNumber);
					
					if(!Registry.levelLocked[lvlThumbNumber]){
						lvlThumb = Utility.CreateSpriteButton(new lvlThumbGFX(), new Point(-100,-100), null, null, ButtonMouseClickFn);
						activeThumbsContainer.addChild(lvlThumb);
					}
					else{
						lvlThumb = GameUtility.TextureManager.BitmapToSprite(new lvlThumbGFX());
						TintColor(lvlThumb);
						endAlpha = 0.8;
						disableThumbsContainer.addChild(lvlThumb);
					}
					//////////////////////////////////////////////////////////////////////////////////////
					
					lvlThumb.x = startCorner.x + xIncrement*C;
					lvlThumb.y = startCorner.y + yIncrement*R;
					lvlThumb.alpha = 0.0;
					lvlThumb.name = ""+lvlThumbNumber;
					lvlThumb.scaleX = 0.6;
					lvlThumb.scaleY = 0.6;
					lvlThumb.alpha = 0.0;

					TweenMax.to(lvlThumb, 0.6, {scaleX:1.0, scaleY:1.0, alpha:endAlpha, ease:Elastic.easeOut, delay:delay + R*C/30});
					
				}
			}
		}
		
		/**
		 * Called when ever the mouse hovers over a sprite/button.
		 * @param event The event data structure containing the reference to the caller sprite/object.
		 */
		private function ButtonMouseClickFn(e:Event):void { 
			//trace("Btn Name: " + e.currentTarget.name);
			SoundManager.PlayMouseClickSFX();
			Registry.IncrementClickCounter();
			
			if(!isNaN(Number(e.target.name))){
				LevelObj.currentLevelNumber = int(e.currentTarget.name);
				Utility.ChangeLevel("Gameplay");
				//Utility.ChangeLevel("Level"+e.currentTarget.name);
			}
			else if(e.target.name == "backBtn"){
				if(currentPage <= 0){
					Utility.ChangeLevel("MainMenu");
				}
				else{
					currentPage--;
					ChangePage(currentPage);
					// show forward button , maybe opacity to 100% ?
					//forwardBtn.alpha = 1.0;
				}
			}
			else if(e.target.name == "forwardBtn"){
				//Utility.ChangeLevel("LevelSelection");
				if(currentPage >= maxPage - 1){
					// hide forward button , maybe opacity to 0% ?
					//TweenMax.to(forwardBtn, 0.6, {scaleX:0.6, scaleY:0.6, alpha:0.0, ease:Expo.easeOut, delay:0.0});
				}
				else{
					currentPage++;
					ChangePage(currentPage);
					
				}
			}
		}

		private function ChangePage(pageNumber:int):void{
			RemoveLevelThumbnailsFromCurrentPage();
			AddLevelThumbnailsToPage(pageNumber);
		}
		
		private function RemoveLevelThumbnailsFromCurrentPage():void{
			Utility.RemoveAllSpriteButtonsFromParent(activeThumbsContainer, null, null, ButtonMouseClickFn);
			Utility.RemoveSpriteChildrenFromParent(disableThumbsContainer);
		}

		override public function UnLoad():void { 
			//trace("LevelSelection.Unload()");
			// First remove the buttons
			Utility.RemoveSpriteButtonFromParent(container, backBtn, null, null, ButtonMouseClickFn);
			Utility.RemoveSpriteButtonFromParent(container, forwardBtn, null, null, ButtonMouseClickFn);
			RemoveLevelThumbnailsFromCurrentPage();
			
			// Now remove normal children
			container.removeChild(activeThumbsContainer);
			container.removeChild(disableThumbsContainer);
			Utility.RemoveSpriteChildrenFromParent(container);
			//PlankBalance.mainStage.removeChild(container);
		}
		
		
		override public function Init():void { 
			//trace("LevelSelection.Init()");
		}
		
		override public function Free():void { 
			//trace("LevelSelection.Free()");
		}
		
		override public function Update():void { 
			//trace("LevelSelection.Update()");
			if(currentPage >= maxPage - 1){
				forwardBtn.alpha = 0.4;
			}
			else{
				forwardBtn.alpha = 1.0;
			}
			
			//profiler.Update();
			//_cursor.Update(PlankBalance.mainStage.mouseX, PlankBalance.mainStage.mouseY); 
		}
		
		override public function Draw():void { 
			//trace("LevelSelection.Draw()");
		}
	}

}