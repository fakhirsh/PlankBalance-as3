package GameUtility 
{
	import flash.display.*;
	import flash.filters.*;

	/**
	 * ...
	 * @author fakhir
	 */
	public class TextureManager 
	{
		private static var filterArray:Array;
		private static var filter:BitmapFilter;
		
		public function TextureManager() 
		{
			
		}
		
		public static function CreateTiledTexture(w:int, h:int, TileImage:Class):Sprite {
			var bitmap:Bitmap = new TileImage();
			var texture:Sprite = new Sprite();
			
			for (var r:int = 0; r < Math.ceil(h / bitmap.height); r++ ) {
				for (var c:int = 0; c < Math.ceil(w / bitmap.width); c++ ) {
					bitmap = new TileImage();
					bitmap.x = bitmap.width * c;
					bitmap.y = bitmap.height * r;		
					texture.addChild(bitmap);
				}
			}

			// Create a mask
			var mask:Sprite = CreateRectMask(w, h);
			texture.addChild(mask);
			texture.mask = mask;
			
			var finalSprite:Sprite = new Sprite();
			finalSprite.addChild(texture);
			
			return finalSprite;
		}
		
		public static function CreateRectTexture(dx:int, dy:int, w:int, h:int, opacity:Number, TileImage:Class, createOutline:Boolean=false, createCoreShadow:Boolean=false, createHighlight:Boolean=false):Sprite {
			var texture:Sprite = CreateTiledTexture(w, h, TileImage);
			texture.alpha = opacity;
			var mask:Sprite = CreateRectMask(w, h);
			var shadow:Sprite;
			var highlight:Sprite;
			var outline:Sprite;
			

			if (createCoreShadow) {
				shadow = CreateRectShadow(w, h);
				texture.addChild(shadow);
			}
			
			if (createHighlight) {
				highlight = CreateHighlight(w, h);
				texture.addChild(highlight);
			}
			
			if(createOutline){
				outline = CreateRectOutline(w, h, 2);
				texture.addChild(outline);
			}
			
			texture.mask = mask;
			texture.addChild(mask);

			var bitmap:Bitmap = SpriteToBitmap(w, h, texture);
			
			var container:Sprite = new Sprite();
			container.addChild(bitmap);

			return container;
		}
		
		public static function CreateRoundTexture(dx:int, dy:int, R:int, opacity:Number, TileImage:Class, createOutline:Boolean=false, createCoreShadow:Boolean=false, createHighlight:Boolean=false):Sprite {
			var texture:Sprite = CreateTiledTexture(2 * R, 2 * R, TileImage);
			texture.alpha = opacity;
			var mask:Sprite = CreateRoundMask(R);
			mask.x = R;
			mask.y = R;
			var shadow:Sprite;
			var highlight:Sprite;
			var outline:Sprite;

			if (createCoreShadow) {
				shadow = CreateRectShadow(2 * R, 2 * R);
				texture.addChild(shadow);
			}
			
			if (createHighlight) {
				highlight = CreateHighlight(2*R, 2*R);
				texture.addChild(highlight);
			}
			
			if(createOutline){
				outline = CreateRoundOutline(R, 2);
				outline.x = R;
				outline.y = R;
				texture.addChild(outline);
			}
			texture.mask = mask;
			texture.addChild(mask);

			var bitmap:Bitmap = SpriteToBitmap(R*2, R*2, texture);
			
			var container:Sprite = new Sprite();
			container.addChild(bitmap);
			
			return container;
		}

		public static function CreateRectShadow(w:int, h:int):Sprite {
			if (filterArray == null) {
				filterArray = new Array();
				filter = new BlurFilter(30, 30, 1);
				filterArray.push(filter);
			}
			var shadow:Sprite = new Sprite();
			shadow.graphics.beginFill(0x000000);
			shadow.graphics.drawRect(0, 0, w*2, h);
			shadow.x = -w / 2;
			shadow.y = h / 2;
			shadow.alpha = 0.3;
			shadow.filters = filterArray;
			return shadow;
		}
		
		public static function CreateHighlight(w:int, h:int):Sprite {
			var mask:Sprite = new Sprite();
			var highlight:Sprite = new Sprite();
			
			var max:int;
			if (w > h) {
				max = w;
			}
			else {
				max = h;
			}
			mask.graphics.beginFill(0xFFFFFF);
			mask.graphics.drawEllipse(0, 0, 2*max, h);
			mask.alpha = 0.5;
			mask.x = -max+w/2;
			mask.y = -h / 2;
			
			highlight.graphics.beginFill(0xFFFFFF);
			highlight.graphics.drawRect(0, 0, w, h);
			highlight.alpha = 0.3;
			highlight.addChild(mask);
			highlight.mask = mask;
			
			return highlight;
		}
		
		public static function CreateRectMask(w:int, h:int):Sprite {
			var mask:Sprite = new Sprite();
			mask.graphics.beginFill(0xFFFFFF);
			mask.graphics.drawRect(0, 0, w, h);
			return mask;
		}
		
		public static function CreateRoundMask(R:int):Sprite {
			var mask:Sprite = new Sprite();
			mask.graphics.beginFill(0xFFFFFF);
			mask.graphics.drawCircle(0, 0, R);
			return mask;
		}
		
		public static function CreateRectOutline(w:int, h:int, thikness:Number):Sprite {
			var outline:Sprite = new Sprite();
			outline.graphics.lineStyle(thikness, 0x000000);
			outline.graphics.drawRect(0, 0, w, h);
			return outline;
		}
		
		public static function CreateRoundOutline(R:int, thikness:Number):Sprite {
			var outline:Sprite = new Sprite();
			outline.graphics.lineStyle(thikness, 0x000000);
			outline.graphics.drawCircle(0, 0, R);
			return outline;
		}
		
		public static function CreateRowSpikes(w:int, SpikeImage:Class, rotation:Number = 0.0, flipped:Boolean = false):Sprite {
			
			var spikeRow:Sprite = new Sprite();
			var s:Bitmap = new SpikeImage();
			
			for (var r:int = 1; r < int(w / s.width) - 1; r++ ) {
				s = new SpikeImage();
				var offset:Number = (w - Math.floor(w / s.width) * s.width) / 2;
				var container:Sprite = new Sprite();
				s.x = -s.width / 2;
				s.y = -s.height / 2;
				container.x = offset + r * s.width + s.width / 2;
				container.y = s.height / 2;
				container.addChild(s);
				container.rotation = rotation;

				if (flipped) {
					container.scaleX = -1;
				}
				spikeRow.addChild(container);
			}
			
			return spikeRow;
		}

		public static function BitmapToSprite(bitmap:Bitmap):Sprite {
			bitmap.x = -bitmap.width / 2;
			bitmap.y = -bitmap.height / 2;
			bitmap.smoothing = true;
			var sprite:Sprite = new Sprite();
			sprite.addChild(bitmap);
			
			return sprite;
		}
		
		/*********************************************************
		*  Optimization... Convert sprite to raw bitmap
		* *******************************************************/
		public static function SpriteToBitmap(w:int, h:int, texture:Sprite):Bitmap {
			var bitmapData:BitmapData = new BitmapData(w, h, true, 0xFFFFFF);
			bitmapData.draw(texture);
			var bitmap:Bitmap = new Bitmap(bitmapData);
			bitmap.x = -bitmapData.width / 2;
			bitmap.y = -bitmapData.height / 2;
			bitmap.smoothing = true;
			return bitmap;
		}
		
	}
}