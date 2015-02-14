package GameElements
{
	import AssetMgr.AssetManager;
	
	import GameUtility.TextureManager;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.Bitmap;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	
	public class Background
	{
		public function Background(container:Sprite)
		{
			// Background
			var background:Bitmap = new AssetManager.BackgroundGFX();
			container.addChild(background);
			
			CreateClouds(container);
			CreateRays(container);
			CreateHills(container);
		}
		
		private function CreateClouds(container:Sprite):void{
			// add some clouds
			var cloud2:Sprite = GameUtility.TextureManager.BitmapToSprite(new AssetManager.Cloud2GFX());
			container.addChild(cloud2);
			cloud2.x = Registry.gameplayLayer.stage.stageWidth + cloud2.width/2;
			cloud2.y = 90;
			TweenMax.to(cloud2, 80, {x:-cloud2.width/2, repeat:-1, ease:Linear.easeNone});
			
			var cloud1:Sprite = GameUtility.TextureManager.BitmapToSprite(new AssetManager.Cloud1GFX());
			container.addChild(cloud1);
			cloud1.x = Registry.gameplayLayer.stage.stageWidth + cloud1.width/2;
			cloud1.y = 55;
			TweenMax.to(cloud1, 40, {x:-cloud1.width/2, repeat:-1, ease:Linear.easeNone});
			
			var cloud3:Sprite = GameUtility.TextureManager.BitmapToSprite(new AssetManager.Cloud3GFX());
			container.addChild(cloud3);
			cloud3.x = Registry.gameplayLayer.stage.stageWidth + cloud3.width/2;
			cloud3.y = 121;
			TweenMax.to(cloud3, 15, {x:-cloud3.width/2, repeat:-1, ease:Linear.easeNone});
		}
		
		private function CreateRays(container:Sprite):void{
			var ray:Sprite = GameUtility.TextureManager.BitmapToSprite(new AssetManager.RayGFX());
			container.addChild(ray);
			ray.x = Registry.gameplayLayer.stage.stageWidth/2;
			ray.y = Registry.gameplayLayer.stage.stageHeight;
			ray.scaleX = 3.7;
			ray.scaleY = 3.7;
			TweenMax.to(ray, 100, {rotation:360, repeat:-1, ease:Linear.easeNone});
		}
		
		private function CreateHills(container:Sprite):void{
			var hills:Sprite = GameUtility.TextureManager.BitmapToSprite(new AssetManager.HillsGFX());
			container.addChild(hills);
			hills.x = Registry.gameplayLayer.stage.stageWidth/2;
			hills.y = Registry.gameplayLayer.stage.stageHeight - hills.height/2;
		}
		
	}
}