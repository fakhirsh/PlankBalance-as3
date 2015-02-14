package GameUtility 
{
	import AssetMgr.AssetManager;
	import AssetMgr.SoundManager;
	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.*;
	
	import CoreGameEngine.GameEngine;
	import CoreGameEngine.GameState;
	
	import Scenes.Credits.Credits;
	import Scenes.GameComplete.GameComplete;
	import Scenes.Gameplay.*;
	import Scenes.LevelSelection.LevelSelection;
	import Scenes.MainMenu.MainMenu;
	import Scenes.Splash.SplashScreen1;
	import Scenes.Test.Test;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;

	
	/**
	 * ...
	 * @author fakhir
	 */
	public class Utility 
	{
		
		public function Utility() 
		{
			
		}

		public static function DegressToRadius(angle:Number):Number{
			return angle*(Math.PI/180);
		}
		
		public static function RadiusToDegress(angle:Number):Number{
			return angle*(180/Math.PI);
		}
		
		public static function CreateDebugView(world:b2World, container:Sprite):void 
		{
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			var debugSprite:Sprite = new Sprite();
			container.addChild(debugSprite);
			debugDraw.SetSprite(debugSprite);
			debugDraw.SetDrawScale(Constants.PTM_RATIO);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit);
			world.SetDebugDraw(debugDraw);
		}

		public static function LaunchBomb(pos:Point, maxForceParam:Number, blastRadius:int, doSuction:Boolean, world:b2World):void{
			//var doSuction:Boolean = false; // Very cool looking implosion effect instead of explosion.
			
			//In Box2D the bodies are a linked list, so keep getting the next one until it doesn't exist.
			for (var b:b2Body = world.GetBodyList(); b; b = b.GetNext())
			{
				//Box2D uses meters, there's 32 pixels in one meter. PTM_RATIO is defined somewhere in the class.
				var b2TouchPosition:b2Vec2 = new b2Vec2(pos.x/Constants.PTM_RATIO, pos.y/Constants.PTM_RATIO);
				var b2BodyPosition:b2Vec2 = new b2Vec2(b.GetPosition().x, b.GetPosition().y);
				
				//Don't forget any measurements always need to take PTM_RATIO into account
				var maxDistance:Number = blastRadius / Constants.PTM_RATIO // In your head don't forget this number is low because we're multiplying it by 32 pixels;
				var maxForce:int = maxForceParam;
				var distance:Number; // Why do i want to use CGFloat vs float - I'm not sure, but this mixing seems to work fine for this little test.
				var strength:Number;
				var force:Number;
				var angle:Number;
				
				if(doSuction) // To go towards the press, all we really change is the atanf function, and swap which goes first to reverse the angle
				{
					// Get the distance, and cap it
					distance = Math.sqrt((b2BodyPosition.x - b2TouchPosition.x) * (b2BodyPosition.x - b2TouchPosition.x) + (b2BodyPosition.y - b2TouchPosition.y) * (b2BodyPosition.y - b2TouchPosition.y));
					
					if(distance > maxDistance) distance = maxDistance - 0.01;
					// Get the strength
					//strength = distance / maxDistance; // Uncomment and reverse these two. and ones further away will get more force instead of less
					strength = (maxDistance - distance) / maxDistance; // This makes it so that the closer something is - the stronger, instead of further
					force  = strength * maxForce;
					
					// Get the angle
					angle = Math.atan2(b2TouchPosition.y - b2BodyPosition.y, b2TouchPosition.x - b2BodyPosition.x);
					//NSLog(@" distance:%0.2f,force:%0.2f", distance, force);
					// Apply an impulse to the body, using the angle
					b.ApplyImpulse(new b2Vec2(Math.cos(angle) * force, Math.sin(angle) * force), b.GetPosition());
				}
				else
				{
					//distance = b2Distance(b2BodyPosition, b2TouchPosition);
					distance = Math.sqrt((b2BodyPosition.x - b2TouchPosition.x) * (b2BodyPosition.x - b2TouchPosition.x) + (b2BodyPosition.y - b2TouchPosition.y) * (b2BodyPosition.y - b2TouchPosition.y));
					//if(distance > maxDistance) distance = maxDistance - 0.01;
					
					if (distance > maxDistance) return;
					
					// Normally if distance is max distance, it'll have the most strength, this makes it so the opposite is true - closer = stronger
					strength = (maxDistance - distance) / maxDistance; // This makes it so that the closer something is - the stronger, instead of further
					force = strength * maxForce;
					angle = Math.atan2(b2BodyPosition.y - b2TouchPosition.y, b2BodyPosition.x - b2TouchPosition.x);
					//NSLog(@" distance:%0.2f,force:%0.2f,angle:%0.2f", distance, force, angle);
					// Apply an impulse to the body, using the angle
					b.ApplyImpulse(new b2Vec2(Math.cos(angle) * force, Math.sin(angle) * force), b.GetPosition());
				}
			}
		}
		
		public static function ChangeLevel(levelName:String):void {
			
			var gs:GameState = null;
			
			switch(levelName) {
				case "Gameplay":
					gs = new Gameplay();
					break;
				case "SplashScreen1":
					gs = new SplashScreen1();
					break;
				case "LevelSelection":
					gs = new LevelSelection();
					break;
				case "MainMenu":
					gs = new MainMenu();
					break;
				case "Credits":
					gs = new Credits();
					break;
				case "GameComplete":
					gs = new GameComplete();
					break;
				case "Test":
					gs = new Test();
					break;
				default:
					break;
			}
			
			if(gs != null)
				GameEngine.ChangeState(gs);
		}

		
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////// *********     SVG Transform Matrix parser and decoding routines !!! **********************
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public static function SplitNumericArgs(input:String):Vector.<String> {
			var returnData:Vector.<String> = new Vector.<String>();
			
			var matchedNumbers:Array = input.match(/(?:\+|-)?\d+(?:\.\d+)?(?:e(?:\+|-)?\d+)?/g);
			for each(var numberString:String in matchedNumbers){
				returnData.push(numberString);
			}
			
			return returnData;
		}
		
		public static function ParseTransformation(m:String):Matrix{
			if(m.length == 0) {
				return new Matrix();
			}
			
			var transformations:Array = m.match(/(\w+?\s*\([^)]*\))/g);
			
			var mat:Matrix = new Matrix();
			
			if(transformations is Array){
				for(var i:int = transformations.length - 1; i >= 0; i--)
				{
					var parts:Array = /(\w+?)\s*\(([^)]*)\)/.exec(transformations[i]);
					if(parts is Array){
						var name:String = parts[1].toLowerCase();
						var args:Vector.<String> = SplitNumericArgs(parts[2]);
						
						switch(name){
							case "matrix" :
								mat.concat(new Matrix(Number(args[0]), Number(args[1]), Number(args[2]), Number(args[3]), Number(args[4]), Number(args[5])));
								break;
							case "translate" :
								mat.translate(Number(args[0]), args.length > 1 ? Number(args[1]) : Number(args[0]));
								break;
							case "scale" :
								mat.scale(Number(args[0]), args.length > 1 ? Number(args[1]) : Number(args[0]));
								break;
							case "rotate" :
								if(args.length > 1){
									var tx:Number = args.length > 1 ? Number(args[1]) : 0;
									var ty:Number = args.length > 2 ? Number(args[2]) : 0;
									mat.translate(-tx, -ty);
									mat.rotate(DegressToRadius(Number(args[0])));
									mat.translate(tx, ty);
								} else {
									mat.rotate(DegressToRadius(Number(args[0])));
								}
								break;
							case "skewx" :
								var skewXMatrix:Matrix = new Matrix();
								skewXMatrix.c = Math.tan(DegressToRadius(Number(args[0])));
								mat.concat(skewXMatrix);
								break;
							case "skewy" :
								var skewYMatrix:Matrix = new Matrix();
								skewYMatrix.b = Math.tan(DegressToRadius(Number(args[0])));
								mat.concat(skewYMatrix);
								break;
						}
					}
				}
			}
			
			return mat;
		}
		
		/**
		 *  Takes SVG transform matrix as a string description and returns values like X,Y,angle,sx,sy wrapped in a container object!
		*/
		public static function DecodeSVGTransformMatrix(matrixString:String, container:Object):void{
			
			var mat:Matrix = ParseTransformation(matrixString);
			// get angle
			container.angle = RadiusToDegress(Math.atan2(mat.c, mat.d));
						
			// Sometimes there is a chance of division by zero, like cos(90), so we have to check for sin(90) instead
			// Use the higher of [cos(A), sin(A)]
			if(Math.cos(DegressToRadius(container.angle)) < 0.5){
				container.sx = -mat.b/Math.sin(DegressToRadius(container.angle));
			}
			else{
				container.sx = mat.a/Math.cos(DegressToRadius(container.angle));
			}
			
			// Same is also true for sy
			if(Math.sin(DegressToRadius(container.angle)) < 0.5){
				container.sy = mat.d/Math.cos(DegressToRadius(container.angle));	
			}
			else{
				container.sy = mat.c/Math.sin(DegressToRadius(container.angle));
			}
			
			var oldcenter:Point = new Point(container.sx*container.W/2, container.sy*container.H/2);
			var newCenter:Point = new Point();
			var angleRad:Number = DegressToRadius(container.angle);
			// Feeding in -ve angle because the AS3 stage has +ve y axis going down, not up
			container.X = Math.cos(-angleRad)*oldcenter.x - Math.sin(-angleRad)*oldcenter.y + mat.tx;
			container.Y = Math.sin(-angleRad)*oldcenter.x + Math.cos(-angleRad)*oldcenter.y + mat.ty;
			
			// finally scale the width and height
			container.W = container.sx*container.W;
			container.H = container.sy*container.H;
			
		}
		
		/**
		 * Since all the input level SVG files are 960*640 retina resolution, we need to scale them to native Flash AS3 699*466 resolution
		*/
		public static function ConvertiOStoAS3LevelCoordinates(container:Object):void{
			container.X = container.X/960.0*Registry.gameplayLayer.stage.stageWidth;
			container.W = container.W/960.0*Registry.gameplayLayer.stage.stageWidth;
			
			container.Y = container.Y/640.0*Registry.gameplayLayer.stage.stageHeight;
			container.H = container.H/640.0*Registry.gameplayLayer.stage.stageHeight;
		}
		
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//		GUI Related routines
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/**
		 * For a given integer this function returns a "sprite" version of the number
		 * @param position Point to put the sprite at
		 * @param number Actual number to convert to a bitmap label. Can't be less than -1 or greater than 999.
		 * @param useLargeFont Whether to use large digitsor not
		 * @return bitmapFont A sprite object containing bitmap font 
		*/
		public static function SpriteFromNumber(pos:Point, number:int, useLargeFont:Boolean):Sprite {
			
			var btnBGBitmap1:Bitmap;
			var btnBGBitmap2:Bitmap;
			var btnBGBitmap3:Bitmap;
			var sprite:Sprite = new Sprite();
			
			var offset:int = 7;
			var offset2:int = 15;
			
			if (useLargeFont == true) {
				offset = 13;
				offset2 = 22;
			}
			
			var n1:int;
			var n2:int;
			var n3:int;
			
			if (number == -1) {
				//btnBGBitmap1 = new AssetManager.LevelSelectLockGFXClass();
				//btnBGBitmap1.x = -btnBGBitmap1.width / 2;
				//btnBGBitmap1.y = -btnBGBitmap1.height / 2;
				//sprite.addChild(btnBGBitmap1);
			}
			else if (number < 10) {
				if (useLargeFont == true) {
					btnBGBitmap1 = new AssetManager.m_LargeFont[number]();
				}
				else{
					btnBGBitmap1 = new AssetManager.m_SmallFont[number]();
				}
				btnBGBitmap1.x = -btnBGBitmap1.width / 2;
				btnBGBitmap1.y = -btnBGBitmap1.height / 2;
				sprite.addChild(btnBGBitmap1);
			}
			else {
				if(number < 100){
					n1 = number / 10;
					n2 = number % 10;
					
					if(useLargeFont == true){
						btnBGBitmap1 = new AssetManager.m_LargeFont[n1]();
						btnBGBitmap2 = new AssetManager.m_LargeFont[n2]();
					}
					else{
						btnBGBitmap1 = new AssetManager.m_SmallFont[n1]();
						btnBGBitmap2 = new AssetManager.m_SmallFont[n2]();
					}
					btnBGBitmap1.x = -btnBGBitmap1.width/2 - offset;
					btnBGBitmap1.y = -btnBGBitmap1.height / 2;
					sprite.addChild(btnBGBitmap1);
					btnBGBitmap2.x = -btnBGBitmap2.width/2 + offset;
					btnBGBitmap2.y = -btnBGBitmap2.height / 2;
					sprite.addChild(btnBGBitmap2);
				}
				else if(number < 1000){
					n1 = number / 100;
					n2 = (number % 100) / 10;
					n3 = number % 10;
					
					if (useLargeFont == true) {
						btnBGBitmap1 = new AssetManager.m_LargeFont[n1]();
						btnBGBitmap2 = new AssetManager.m_LargeFont[n2]();
						btnBGBitmap3 = new AssetManager.m_LargeFont[n3]();
					}
					else {
						btnBGBitmap1 = new AssetManager.m_SmallFont[n1]();
						btnBGBitmap2 = new AssetManager.m_SmallFont[n2]();
						btnBGBitmap3 = new AssetManager.m_SmallFont[n3]();
					}
					
					btnBGBitmap1.x = -btnBGBitmap1.width/2 - offset2;
					btnBGBitmap1.y = -btnBGBitmap1.height / 2;
					sprite.addChild(btnBGBitmap1);
					btnBGBitmap2.x = -btnBGBitmap2.width/2;
					btnBGBitmap2.y = -btnBGBitmap2.height / 2;
					sprite.addChild(btnBGBitmap2);
					btnBGBitmap3.x = -btnBGBitmap3.width/2 + offset2;
					btnBGBitmap3.y = -btnBGBitmap3.height / 2;
					sprite.addChild(btnBGBitmap3);
				}
				else {
					throw("ERROR: NO. CAN'T BE GREATER THAN 1000");
				}
			}
			
			sprite.x = pos.x;
			sprite.y = pos.y;

			return sprite;
		}
		
		/**
		 * 
		*/
		public static function CreateSpriteButton(bitmapUp:Bitmap, pos:Point, mouseOverFn:Function, mouseOutFn:Function, mouseClickFn:Function):Sprite {
			
			var button:Sprite = TextureManager.BitmapToSprite(bitmapUp);
			button.x = pos.x;
			button.y = pos.y;
			
			if(mouseOverFn != null){
				button.addEventListener(MouseEvent.MOUSE_OVER, mouseOverFn);
			}
			else{
				button.addEventListener(MouseEvent.MOUSE_OVER, DefaultMouseOverFn);
			} 
			
			if(mouseOutFn != null){
				button.addEventListener(MouseEvent.MOUSE_OUT, mouseOutFn);
			}
			else{
				button.addEventListener(MouseEvent.MOUSE_OUT, DefaultMouseOutFn);
			} 
			
			if(mouseClickFn != null){
				button.addEventListener(MouseEvent.CLICK, mouseClickFn);
			}
			else{
				button.addEventListener(MouseEvent.CLICK, DefaultMouseClickFn);
			} 
			
			return button;
		}

		public static function RemoveSpriteButtonFromParent(parent:DisplayObjectContainer, child:DisplayObject, mouseOutFn:Function, mouseOverFn:Function, mouseClickFn:Function):void{
			if(child == null) return;
			
			if(mouseOverFn != null){
				child.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverFn);
			}
			else{
				child.removeEventListener(MouseEvent.MOUSE_OVER, DefaultMouseOverFn);
			} 
			
			if(mouseOutFn != null){
				child.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutFn);
			}
			else{
				child.removeEventListener(MouseEvent.MOUSE_OUT, DefaultMouseOutFn);
			} 
			
			if(mouseClickFn != null){
				child.removeEventListener(MouseEvent.CLICK, mouseClickFn);
			}
			else{
				child.removeEventListener(MouseEvent.CLICK, DefaultMouseClickFn);
			} 
			TweenLite.killTweensOf(child);
			parent.removeChild(child);
		}
		
		public static function RemoveSpriteChildrenFromParent(parent:DisplayObjectContainer):void {
			//trace("REMOVING " + parent.numChildren + " ITEMS");
			while (parent.numChildren > 0) {
				TweenLite.killTweensOf(parent.getChildAt(0));
				parent.removeChild(parent.getChildAt(0));
			}
		}

		public static function RemoveAllSpriteButtonsFromParent(parent:DisplayObjectContainer, mouseOutFn:Function, mouseOverFn:Function, mouseClickFn:Function):void{
			while (parent.numChildren > 0) {
				TweenLite.killTweensOf(parent.getChildAt(0));
				RemoveSpriteButtonFromParent(parent, parent.getChildAt(0), mouseOutFn, mouseOverFn, mouseClickFn); 
			}
		}
		
		/**
		 * Remove sprites with Animations
		*/
		//private function RemoveChildFromParentWithFadeOut(parent:DisplayObjectContainer, child:DisplayObject, duration:Number, delay:Number):void{
			//if(child.hasEventListener(MouseEvent.MOUSE_OVER)) child.removeEventListener(MouseEvent.MOUSE_OVER, ButtonMouseOverFn);
			//if(child.hasEventListener(MouseEvent.MOUSE_OUT)) child.removeEventListener(MouseEvent.MOUSE_OUT, ButtonMouseOutFn);
			//if(child.hasEventListener(MouseEvent.CLICK)) child.removeEventListener(MouseEvent.CLICK, ButtonMouseClickFn);
			
			//TweenMax.to(child, duration, {scaleX:0.6, scaleY:0.6, alpha:0.0, ease:Expo.easeOut, delay:delay,
			//	onComplete: function(_parent:DisplayObjectContainer, _child:DisplayObject):void {
			//		_parent.removeChild(_child);
			//	},
			
			//	onCompleteParams: [parent, child]
			//	}
			//);
		//}

		
		/**
		 * DEFAULT CALLBACKS: OVERRIDE !!!
		 * Called when ever the mouse hovers over a sprite/button.
		 * @param event The event data structure containing the reference to the caller sprite/object.
		 */
		private static function DefaultMouseOverFn(e:Event):void { 
			SoundManager.PlayMouseOverSFX();
			TweenMax.to(e.target, 0.6, {scaleX:1.1, scaleY:1.1, ease:Elastic.easeOut});
		}
		
		private static function DefaultMouseOutFn(e:Event):void { 
			TweenMax.to(e.target, 0.4, {scaleX:1.0, scaleY:1.0, ease:Elastic.easeOut});
		}
		
		private static function DefaultMouseClickFn(e:Event):void { 
						
		}
		
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
	}

}