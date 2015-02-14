package GameElements
{
	import AssetMgr.AssetManager;
	
	import GameUtility.*;
	
	import LevelSVGLoader.SVGLevelList;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.*;
	import flash.geom.Point;
	
	public class HUD
	{
		private var hudContainer:Sprite;
		private var blocksToDestroyLbl:Sprite;
		private var timerLbl:Sprite;
		private var levelNumber:Sprite;
		private var checkingStabilityTimerLbl:Sprite;
		
		private var checkingSprite:Sprite;
		
		// For internal book-keeping
		private var lblArray:Vector.<Sprite>;
		
		public function HUD(_container:Sprite)
		{
			hudContainer = _container;

			DisplayBlocksLeftLBL();
			DisplayGameTimeLBL();
			DisplayLevelNumberLBL();
			
			lblArray = new Vector.<Sprite>;
			
			lblArray.push(blocksToDestroyLbl);
			lblArray.push(timerLbl);
			lblArray.push(levelNumber);
			lblArray.push(checkingStabilityTimerLbl);
		}
		
		/**
		 * Displays a sprite onto the screen
		 * @param animate Initial sprite animation
		 * @param deleteAfterTime Delete the sprite from screen after specified amount of seconds
		*/
		public function DisplayGameTimeLBL():void{
			var timeLBL:Sprite = GameUtility.TextureManager.BitmapToSprite(new AssetManager.TimeLBLGFX());
			hudContainer.addChild(timeLBL);
			timeLBL.x = 318;
			timeLBL.y = 25;
		}

		public function DisplayCheckingStabilityLBL():void{
			if(checkingSprite != null) return;
			
			checkingSprite = GameUtility.TextureManager.BitmapToSprite(new AssetManager.CheckingLbLGFX());
			hudContainer.addChild(checkingSprite);
			checkingSprite.x = 350;
			checkingSprite.y = 200;
			checkingSprite.alpha = 0.0;
			checkingSprite.scaleX = 0.5;
			checkingSprite.scaleY = 0.5;
			TweenMax.to(checkingSprite, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut});
		}

		public function RemoveCheckingStabilityLBL():void{
			if(checkingSprite == null) return;
			hudContainer.removeChild(checkingSprite);
		}
		
		public function DisplayBlocksLeftLBL():void{
			var blocksLeftLBL:Sprite = GameUtility.TextureManager.BitmapToSprite(new AssetManager.BlocksLeftLBLGFX());
			hudContainer.addChild(blocksLeftLBL);
			blocksLeftLBL.x = 630;
			blocksLeftLBL.y = 26;
		}

		public function DisplayLevelNumberLBL():void{
			var levelLBL:Sprite = GameUtility.TextureManager.BitmapToSprite(new AssetManager.LevelLBLGFX());
			hudContainer.addChild(levelLBL);
			levelLBL.x = 150;
			levelLBL.y = 25;
		}

		private function DisplayVolatileLBL(lblGFX:Class, location:Point, duration:Number, initialDelay:Number, finalDelay:Number):TimelineMax{
			var lbl:Sprite = GameUtility.TextureManager.BitmapToSprite(new lblGFX());
			hudContainer.addChild(lbl);
			lbl.x = location.x;
			lbl.y = location.y;
			lbl.alpha = 0.0;
			lbl.scaleX = 0.5;
			lbl.scaleY = 0.5;
			
			var myTimeline:TimelineMax = new TimelineMax({
				onComplete:function(_parent:DisplayObjectContainer, _child:DisplayObject):void {
					if(_parent.contains(_child)) _parent.removeChild(_child);
				},
				onCompleteParams: [hudContainer, lbl]
			}
			);
			
			myTimeline.append(new TweenMax(lbl, initialDelay, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Bounce.easeOut, delay:0.0}));
			myTimeline.append(new TweenMax(lbl, finalDelay, {scaleX:0.5, scaleY:0.5, alpha:0.0, ease:Expo.easeOut, delay:duration - initialDelay - finalDelay}));
			
			return myTimeline;
		}
		
		public function DisplayLevelFailedLBL(delay:Number):void{
			var levelFailed:Sprite = GameUtility.TextureManager.BitmapToSprite(new AssetManager.LevelFailedLBLGFX());
			hudContainer.addChild(levelFailed);
			levelFailed.x = 350;
			levelFailed.y = 160;
			levelFailed.alpha = 0.0;
			levelFailed.scaleX = 0.5;
			levelFailed.scaleY = 0.5;
			TweenMax.to(levelFailed, 0.8, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut});
		}

		public function DisplayLevelCompleteLBL(delay:Number, offsetY:int = 0 ):void {
			//DisplayVolatileLBL(AssetManager.LevelCompleteLBLGFX, new Point(350,200), delay, 0.6, 0.2);
			var levelComplete:Sprite = GameUtility.TextureManager.BitmapToSprite(new AssetManager.LevelCompleteLBLGFX());
			hudContainer.addChild(levelComplete);
			levelComplete.x = 350;
			levelComplete.y = 160 + offsetY;
			levelComplete.alpha = 0.0;
			levelComplete.scaleX = 0.5;
			levelComplete.scaleY = 0.5;
			TweenMax.to(levelComplete, 0.8, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut});
		}

		
		public function DisplayGetReadySequence(delay:Number):void{
			var delta:Number = 0.8;
			var getReadyTL:TimelineMax = DisplayVolatileLBL(AssetManager.GetReadyLBLGFX, new Point(350,200), delay, 0.6, 0.2);
			var goTL:TimelineMax = DisplayVolatileLBL(AssetManager.GoLBLGFX, new Point(350,200), delay*delta, 0.2, 0.1);
			
			var myTimeline:TimelineMax = new TimelineMax();
			myTimeline.append(getReadyTL);
			myTimeline.append(goTL);
		}
		
		// WARNING ::: EXTREMELY CRAPPY DESIGN
		private function UpdateLbl(spriteIndex:int, newVal:int, location:Point, useLargeFont:Boolean):void {
			
			if(lblArray[spriteIndex] != null)
				hudContainer.removeChild(lblArray[spriteIndex]);
			
			// -1 essentially means delete the current label from the screen !!!
			if (newVal <= -1) return;
			
			lblArray[spriteIndex] = Utility.SpriteFromNumber(new Point(0, 0), newVal, useLargeFont);
			lblArray[spriteIndex].x = location.x;
			lblArray[spriteIndex].y = location.y;
			hudContainer.addChild(lblArray[spriteIndex]);
		}
		
		public function UpdateBlocksLeftLabel(newVal:int):void {
			if (newVal < 0) return;
			UpdateLbl(0, newVal, new Point(652, 68), true);
			
			lblArray[0].scaleX = 0.5;
			lblArray[0].scaleY = 0.5;
			TweenMax.to(lblArray[0], 0.6, {scaleX:1.0, scaleY:1.0, ease:Elastic.easeOut});
		}
		
		public function UpdateTimerLabel(newVal:int):void {
			// timer label is at index 1 within the array
			UpdateLbl(1, newVal, new Point(365, 26), false);
		}

		public function UpdateLevelNumberLabel(newVal:int):void {
			// timer label is at index 1 within the array
			UpdateLbl(2, newVal, new Point(190, 26), false);
		}

		public function UpdateCheckingStabilityTimerLabel(newVal:int):void {
			// stability timer label is at index 2 within the array
			UpdateLbl(3, newVal, new Point(300, 140), true);
		}
		
		public function DisplayStars(currentTimer:int, currentLevel:int, Y:int, container:Sprite):void{
			var star1:Sprite;
			var star2:Sprite;
			var star3:Sprite;
			var FACTOR2:Number = 3;
			var FACTOR3:Number = 2.5;
			
			if(currentTimer <= SVGLevelList.GetThreeStarTime(currentLevel)){
				star1 = GameUtility.TextureManager.BitmapToSprite(new AssetManager.StarSmallGFX());
				container.addChild(star1);
				star1.x = Registry.gameplayLayer.stage.stageWidth/2 - star1.width/FACTOR3;
				star1.y = Y;
				star1.alpha = 0.0;
				star1.scaleX = 0.4;
				star1.scaleY = 0.4;
				TweenMax.to(star1, 0.6, {scaleX:0.6, scaleY:0.6, alpha:1.0, ease:Elastic.easeOut, delay:0.3});
				
				star2 = GameUtility.TextureManager.BitmapToSprite(new AssetManager.StarSmallGFX());
				container.addChild(star2);
				star2.x = Registry.gameplayLayer.stage.stageWidth/2 + star2.width/FACTOR3;
				star2.y = Y;
				star2.alpha = 0.0;
				star2.scaleX = 0.4;
				star2.scaleY = 0.4;
				TweenMax.to(star2, 0.6, {scaleX:0.6, scaleY:0.6, alpha:1.0, ease:Elastic.easeOut, delay:0.4});
				
				star2 = GameUtility.TextureManager.BitmapToSprite(new AssetManager.StarSmallGFX());
				container.addChild(star2);
				star2.x = Registry.gameplayLayer.stage.stageWidth/2;
				star2.y = 20 + Y;
				star2.alpha = 0.0;
				star2.scaleX = 0.4;
				star2.scaleY = 0.4;
				TweenMax.to(star2, 0.6, {scaleX:0.8, scaleY:0.8, alpha:1.0, ease:Elastic.easeOut, delay:0.5});
			}
			else if(currentTimer <= SVGLevelList.GetTwoStarTime(currentLevel)){
				star1 = GameUtility.TextureManager.BitmapToSprite(new AssetManager.StarSmallGFX());
				container.addChild(star1);
				star1.x = Registry.gameplayLayer.stage.stageWidth/2 - star1.width/FACTOR2;
				star1.y = Y;
				star1.alpha = 0.0;
				star1.scaleX = 0.4;
				star1.scaleY = 0.4;
				TweenMax.to(star1, 0.6, {scaleX:0.6, scaleY:0.6, alpha:1.0, ease:Elastic.easeOut, delay:0.3});
				
				star2 = GameUtility.TextureManager.BitmapToSprite(new AssetManager.StarSmallGFX());
				container.addChild(star2);
				star2.x = Registry.gameplayLayer.stage.stageWidth/2 + star2.width/FACTOR2;
				star2.y = Y;
				star2.alpha = 0.0;
				star2.scaleX = 0.4;
				star2.scaleY = 0.4;
				TweenMax.to(star2, 0.6, {scaleX:0.6, scaleY:0.6, alpha:1.0, ease:Elastic.easeOut, delay:0.4});
			}
			else{
				star1 = GameUtility.TextureManager.BitmapToSprite(new AssetManager.StarSmallGFX());
				container.addChild(star1);
				star1.x = Registry.gameplayLayer.stage.stageWidth/2;
				star1.y = Y;
				star1.alpha = 0.0;
				star1.scaleX = 0.4;
				star1.scaleY = 0.4;
				
				TweenMax.to(star1, 0.6, {scaleX:0.6, scaleY:0.6, alpha:1.0, ease:Elastic.easeOut, delay:0.3});
			}
			
			/*
			if(currentTimer > SVGLevelList.GetOneStarTime(currentLevel)){
				star1 = GameUtility.TextureManager.BitmapToSprite(new AssetManager.StarSmallGFX());
				container.addChild(star1);
				star1.x = Registry.gameplayLayer.stage.stageWidth/2;
				star1.y = Y;
				star1.alpha = 0.0;
				star1.scaleX = 0.4;
				star1.scaleY = 0.4;
				
				TweenMax.to(star1, 0.6, {scaleX:0.6, scaleY:0.6, alpha:1.0, ease:Elastic.easeOut, delay:0.3});
			}
			else if(currentTimer > SVGLevelList.GetTwoStarTime(currentLevel)){
				star1 = GameUtility.TextureManager.BitmapToSprite(new AssetManager.StarSmallGFX());
				container.addChild(star1);
				star1.x = Registry.gameplayLayer.stage.stageWidth/2 - star1.width/FACTOR2;
				star1.y = Y;
				star1.alpha = 0.0;
				star1.scaleX = 0.4;
				star1.scaleY = 0.4;
				TweenMax.to(star1, 0.6, {scaleX:0.6, scaleY:0.6, alpha:1.0, ease:Elastic.easeOut, delay:0.3});
				
				star2 = GameUtility.TextureManager.BitmapToSprite(new AssetManager.StarSmallGFX());
				container.addChild(star2);
				star2.x = Registry.gameplayLayer.stage.stageWidth/2 + star2.width/FACTOR2;
				star2.y = Y;
				star2.alpha = 0.0;
				star2.scaleX = 0.4;
				star2.scaleY = 0.4;
				TweenMax.to(star2, 0.6, {scaleX:0.6, scaleY:0.6, alpha:1.0, ease:Elastic.easeOut, delay:0.4});
			}
			else{
				star1 = GameUtility.TextureManager.BitmapToSprite(new AssetManager.StarSmallGFX());
				container.addChild(star1);
				star1.x = Registry.gameplayLayer.stage.stageWidth/2 - star1.width/FACTOR3;
				star1.y = Y;
				star1.alpha = 0.0;
				star1.scaleX = 0.4;
				star1.scaleY = 0.4;
				TweenMax.to(star1, 0.6, {scaleX:0.6, scaleY:0.6, alpha:1.0, ease:Elastic.easeOut, delay:0.3});
				
				star2 = GameUtility.TextureManager.BitmapToSprite(new AssetManager.StarSmallGFX());
				container.addChild(star2);
				star2.x = Registry.gameplayLayer.stage.stageWidth/2 + star2.width/FACTOR3;
				star2.y = Y;
				star2.alpha = 0.0;
				star2.scaleX = 0.4;
				star2.scaleY = 0.4;
				TweenMax.to(star2, 0.6, {scaleX:0.6, scaleY:0.6, alpha:1.0, ease:Elastic.easeOut, delay:0.4});
				
				star2 = GameUtility.TextureManager.BitmapToSprite(new AssetManager.StarSmallGFX());
				container.addChild(star2);
				star2.x = Registry.gameplayLayer.stage.stageWidth/2;
				star2.y = 20 + Y;
				star2.alpha = 0.0;
				star2.scaleX = 0.4;
				star2.scaleY = 0.4;
				TweenMax.to(star2, 0.6, {scaleX:0.8, scaleY:0.8, alpha:1.0, ease:Elastic.easeOut, delay:0.5});
				
			}
			*/
			
		}

	}
}