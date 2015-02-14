package Scenes.Test
{
	import AssetMgr.AssetManager;
	
	import CoreGameEngine.GameState;
	
	import GameElements.Background;
	
	import GameUtility.*;
	
	//import com.bit101.components.*;
	
	import flash.display.*;
	
	public class Test extends GameState
	{
		private var _container:Sprite;
		private var _profiler:Profiler;
		
		public function Test()
		{
		}
		
		override public function Load():void { 
			_container = Registry.gameplayLayer;
			//PlankBalance.mainStage.addChild(_container);
			
			var bgContainer:Sprite = new Sprite();
			var background:Background = new Background(bgContainer);
			_container.addChild(bgContainer);
			
			//var ns:NumericStepper = new NumericStepper(_container, 50, 50);
			
			_profiler = new Profiler(600,50, _container);
			
			CreateBlocksTMP();
		}
		
		public function CreateBlocksTMP():void{
			var d:Sprite = TextureManager.CreateRectTexture(0, 0, 150, 45, 1.0, AssetManager.DirtTileGFX, true, true);
			d.x = 100;
			d.y = 100;
			_container.addChild(d);
			var dr:Sprite = TextureManager.CreateRoundTexture(0, 0, 45/2, 1.0, AssetManager.DirtTileGFX, true, true);
			dr.x = 200;
			dr.y = 100;
			_container.addChild(dr);
			
			var r:Sprite = TextureManager.CreateRectTexture(0, 0, 150, 45, 1.0, AssetManager.RubberTileGFX, true, true);
			r.x = 100;
			r.y = 150;
			_container.addChild(r);
			var rr:Sprite = TextureManager.CreateRoundTexture(0, 0, 45/2, 1.0, AssetManager.RubberTileGFX, true, true);
			rr.x = 200;
			rr.y = 150;
			_container.addChild(rr);
			
			var s:Sprite = TextureManager.CreateRectTexture(0, 0, 150, 45, 1.0, AssetManager.SteelTileGFX, true, true);
			s.x = 100;
			s.y = 200;
			_container.addChild(s);
			var sr:Sprite = TextureManager.CreateRoundTexture(0, 0, 45/2, 1.0, AssetManager.SteelTileGFX, true, true);
			sr.x = 200;
			sr.y = 200;
			_container.addChild(sr);
			
			var c:Sprite = TextureManager.CreateRectTexture(0, 0, 150, 45, 1.0, AssetManager.CrateTileGFX, true, true);
			c.x = 100;
			c.y = 250;
			_container.addChild(c);
			var cr:Sprite = TextureManager.CreateRoundTexture(0, 0, 45/2, 1.0, AssetManager.CrateTileGFX, true, true);
			cr.x = 200;
			cr.y = 250;
			_container.addChild(cr);
			
			var i:Sprite = TextureManager.CreateRectTexture(0, 0, 150, 45, 1.0, AssetManager.IceTileGFX, true, true, true);
			i.x = 100;
			i.y = 300;
			_container.addChild(i);
			var ir:Sprite = TextureManager.CreateRoundTexture(0, 0, 45/2, 1.0, AssetManager.IceTileGFX, true, true, true);
			ir.x = 200;
			ir.y = 300;
			_container.addChild(ir);
			
			var sp:Sprite = CreateSpike(150,45);
			sp.x = 100;
			sp.y = 350;
			_container.addChild(sp);
			
		}
		
		override public function UnLoad():void { 
			//trace("SplashScreen1.Unload()");
			Utility.RemoveSpriteChildrenFromParent(_container);
			//PlankBalance.mainStage.removeChild(splash);
		}
		
		override public function Init():void { 
			//trace("SplashScreen1.Init()");
		}
		
		override public function Free():void { 
			//trace("SplashScreen1.Free()");
		}
		
		override public function Update():void { 
			//trace("SplashScreen1.Update()");
			_profiler.Update();
		}
		
		override public function Draw():void { 
			//trace("SplashScreen1.Draw()");
		}
		
		
		public function CreateSpike(width:int, height:int):Sprite {
			var s:Bitmap = new AssetManager.SpikeTileGFX();
			var offset:int = s.height;
			var m_sprite:Sprite = new Sprite();
			
			var texture:Sprite = TextureManager.CreateRectTexture(offset, offset, width - offset*2, height - offset*2, 1.0, AssetManager.SteelTileGFX, false, false, false);
			//texture.x -= offset;
			//texture.y -= offset;
			m_sprite.addChild(texture);
			
			var topRow:Sprite = TextureManager.CreateRowSpikes(width,  AssetManager.SpikeTileGFX, 0.0);
			topRow.x = - width/2;
			topRow.y = - height/2;
			m_sprite.addChild(topRow);
			
			var bottomRow:Sprite = TextureManager.CreateRowSpikes(width,  AssetManager.SpikeTileGFX, 180.0, true);
			bottomRow.x = - width/2;
			bottomRow.y = + height/2 - offset;
			m_sprite.addChild(bottomRow);
			
			var leftedge:Sprite = TextureManager.CreateRowSpikes(height,  AssetManager.SpikeTileGFX, 0.0, true);
			leftedge.x = - width / 2;
			leftedge.y = + height / 2;
			leftedge.rotation = -90;
			m_sprite.addChild(leftedge);
			
			var rightedge:Sprite = TextureManager.CreateRowSpikes(height,  AssetManager.SpikeTileGFX, 0.0, false);
			rightedge.x = + width / 2;
			rightedge.y = - height / 2;
			rightedge.rotation = 90;
			
			m_sprite.addChild(rightedge);
			
			return m_sprite;
		}
	}
}