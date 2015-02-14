package Scenes.Gameplay
{
	import AssetMgr.AssetManager;
	
	import GameUtility.Utility;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.*;
	import flash.geom.Point;
	//import flash.net.*;
	
	public class Tutorials
	{
		private var _container:Sprite;
		
		private var lbl1:Sprite;
		private var arrow1:Sprite;
		private var circle1:Sprite;
		private var lbl2:Sprite;
		private var arrow2:Sprite;
		private var lbl3:Sprite;
		private var arrow3:Sprite;
		private var lbl4:Sprite;
		private var arrow4:Sprite;
		private var lbl5:Sprite;
		private var arrow5:Sprite;
		
		public function Tutorials(container:Sprite, levelNumber:int)
		{
			_container = container;
			
			switch(levelNumber){
				case 1:
					LoadLevel1Tutorial();
					break;
				case 4:
					LoadLevel4Tutorial();
					break;
				case 5:
					LoadLevel5Tutorial();
					break;
				default:
					break;
			}
		}
		
		private function LoadLevel1Tutorial():void{
			// Lbl1
			lbl1 = GameUtility.TextureManager.BitmapToSprite(new AssetManager.Lvl1Lbl1GFX());
			_container.addChild(lbl1);
			lbl1.x = 509;
			lbl1.y = 104;
			lbl1.alpha = 0.0;
			lbl1.scaleX = 0.6;
			lbl1.scaleY = 0.6;
			TweenMax.to(lbl1, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:3.5});

			arrow1 = GameUtility.TextureManager.BitmapToSprite(new AssetManager.Lvl1Arrow1GFX());
			_container.addChild(arrow1);
			arrow1.x = 598;
			arrow1.y = 109;
			arrow1.alpha = 0.0;
			arrow1.scaleX = 0.6;
			arrow1.scaleY = 0.6;
			TweenMax.to(arrow1, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:3.8});

			circle1 = GameUtility.TextureManager.BitmapToSprite(new AssetManager.Lvl1Circle1GFX());
			_container.addChild(circle1);
			circle1.x = 646;
			circle1.y = 70;
			circle1.alpha = 0.0;
			circle1.scaleX = 0.6;
			circle1.scaleY = 0.6;
			TweenMax.to(circle1, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:4.0});

			// Lbl2
			lbl2 = GameUtility.TextureManager.BitmapToSprite(new AssetManager.Lvl1Lbl2GFX());
			_container.addChild(lbl2);
			lbl2.x = 202;
			lbl2.y = 215;
			lbl2.alpha = 0.0;
			lbl2.scaleX = 0.6;
			lbl2.scaleY = 0.6;
			TweenMax.to(lbl2, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:4.5});
			
			arrow2 = GameUtility.TextureManager.BitmapToSprite(new AssetManager.Lvl1Arrow2GFX());
			_container.addChild(arrow2);
			arrow2.x = 266;
			arrow2.y = 260;
			arrow2.alpha = 0.0;
			arrow2.scaleX = 0.6;
			arrow2.scaleY = 0.6;
			TweenMax.to(arrow2, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:4.8});

			// Lbl3
			lbl3 = GameUtility.TextureManager.BitmapToSprite(new AssetManager.Lvl1Lbl3GFX());
			_container.addChild(lbl3);
			lbl3.x = 546;
			lbl3.y = 350;
			lbl3.alpha = 0.0;
			lbl3.scaleX = 0.6;
			lbl3.scaleY = 0.6;
			TweenMax.to(lbl3, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:5.1});
			
			arrow3 = GameUtility.TextureManager.BitmapToSprite(new AssetManager.Lvl1Arrow3GFX());
			_container.addChild(arrow3);
			arrow3.x = 626;
			arrow3.y = 387;
			arrow3.alpha = 0.0;
			arrow3.scaleX = 0.6;
			arrow3.scaleY = 0.6;
			TweenMax.to(arrow3, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:5.5});

		}
		
		private function LoadLevel4Tutorial():void{
			// Lbl1
			lbl1 = GameUtility.TextureManager.BitmapToSprite(new AssetManager.Lvl4Lbl1GFX());
			_container.addChild(lbl1);
			lbl1.x = 564;
			lbl1.y = 168;
			lbl1.alpha = 0.0;
			lbl1.scaleX = 0.6;
			lbl1.scaleY = 0.6;
			TweenMax.to(lbl1, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:3.5});
			
			arrow1 = GameUtility.TextureManager.BitmapToSprite(new AssetManager.Lvl4Arrow1GFX());
			_container.addChild(arrow1);
			arrow1.x = 499;
			arrow1.y = 232;
			arrow1.alpha = 0.0;
			arrow1.scaleX = 0.6;
			arrow1.scaleY = 0.6;
			TweenMax.to(arrow1, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:3.8});

		}

		private function LoadLevel5Tutorial():void{
			// Lbl1
			lbl1 = GameUtility.TextureManager.BitmapToSprite(new AssetManager.Lvl5Lbl1GFX());
			_container.addChild(lbl1);
			lbl1.x = 342;
			lbl1.y = 308;
			lbl1.alpha = 0.0;
			lbl1.scaleX = 0.6;
			lbl1.scaleY = 0.6;
			TweenMax.to(lbl1, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:3.5});
			
			arrow1 = GameUtility.TextureManager.BitmapToSprite(new AssetManager.Lvl5Arrow1GFX());
			_container.addChild(arrow1);
			arrow1.x = 359;
			arrow1.y = 365;
			arrow1.alpha = 0.0;
			arrow1.scaleX = 0.6;
			arrow1.scaleY = 0.6;
			TweenMax.to(arrow1, 0.6, {scaleX:1.0, scaleY:1.0, alpha:1.0, ease:Elastic.easeOut, delay:3.8});
			
		}
		
		
		public function RemoveAll():void{
			if(lbl1) _container.removeChild(lbl1);
			if(lbl2) _container.removeChild(lbl2);
			if(lbl3) _container.removeChild(lbl3);
			if(lbl4) _container.removeChild(lbl4);
			if(lbl5) _container.removeChild(lbl5);
			if(arrow1) _container.removeChild(arrow1);
			if(arrow2) _container.removeChild(arrow2);
			if(arrow3) _container.removeChild(arrow3);
			if(arrow4) _container.removeChild(arrow4);
			if(arrow5) _container.removeChild(arrow5);
			if(circle1) _container.removeChild(circle1);
		}
		
	}
}