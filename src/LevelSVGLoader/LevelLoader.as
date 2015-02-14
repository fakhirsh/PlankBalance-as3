package LevelSVGLoader
{
	import AssetMgr.*;
	
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.*;
	
	import GameUtility.TextureManager;
	import GameUtility.Utility;
	
	import Scenes.Gameplay.*;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;


	public class LevelLoader
	{
		public function LevelLoader(){
		
		}
		
		public static function LoadLevel(levelNumber:int):LevelObj
		{
			// Allocate level object
			var levelObj:LevelObj = new LevelObj();
			//levelObj.blocksToDestroy = 2;
			
			levelObj.spriteContainer = new Sprite();
			Registry.gameplayLayer.stage.addChild(levelObj.spriteContainer);
			var gravity:b2Vec2 = new b2Vec2(0,10);
			var doSleep:Boolean = false;
			levelObj.world = new b2World(gravity, doSleep);
			Utility.CreateDebugView(levelObj.world, levelObj.spriteContainer);
			
			// Initialize and read input SVG stream from embedded file
			var byteArray:ByteArray;
			var levelClass:Class = SVGLevelList.GetLevelClass(levelNumber);
			byteArray = new levelClass() as ByteArray;
			var level:XML = new XML(byteArray.readUTFBytes(byteArray.length));
			ParseSVG(level, levelObj);
			
			return levelObj;
		}
		
		private static function ParseSVG(level:XML, levelObj:LevelObj):void{
			// read SVG document width
			var string:String = level.attribute("width");
			// delete "px" from the number suffix
			levelObj.levelWidth = int(string.slice(0,-2));
			string = level.attribute("height");
			levelObj.levelHeight = int(string.slice(0,-2));
			
			
			var container:Object = {X:0.0, Y:0.0, sx:0.0, sy:0.0, angle:0.0, W:200, H:50};
			
			var c:XMLList = level.children();			
			for each (var levelChild:XML in c)
			{
				// BE VERY CAREFUL: It is CASE-SENSITIVE !!!
				if(levelChild.attribute("id") == "Floor"){
					var floorChildren:XMLList = levelChild.children();
					for each (var floorChild:XML in floorChildren){
						
						container.W = Number(floorChild.@width);
						container.H = Number(floorChild.@height);
						Utility.DecodeSVGTransformMatrix(floorChild.@transform, container);
						Utility.ConvertiOStoAS3LevelCoordinates(container);
						
						var floor:Sprite = GameUtility.TextureManager.CreateRectTexture(0,0,container.W,container.H,1.0,AssetManager.FloorGFX);
						floor.x = container.X;
						floor.y = container.Y;
						CreateRectBlock(container.X, container.Y, floor.width, floor.height, Constants.BLOCKTYPE_STATIC, floor, -container.angle, b2Body.b2_staticBody, levelObj.world, levelObj.spriteContainer, 1.0, 0.4, 0.2, false);
						
						//SENSORS
						// Floor Sensor
						CreateRectBlock(Registry.gameplayLayer.stage.stageWidth/2, Registry.gameplayLayer.stage.stageHeight-40/2+30, 4000, 40, Constants.BLOCKTYPE_SENSOR, null, 0, b2Body.b2_staticBody, levelObj.world, levelObj.spriteContainer, 1.0, 1.0, 1.0, true);
						var GAP:int = 300;
						// Left Sensor
						CreateRectBlock(-GAP, 700, 40, 2440, Constants.BLOCKTYPE_SENSOR, null, 0, b2Body.b2_staticBody, levelObj.world, levelObj.spriteContainer, 1.0, 1.0, 1.0, true);
						// Right Sensor
						CreateRectBlock(Registry.gameplayLayer.stage.stageWidth+GAP, 700, 40, 2440, Constants.BLOCKTYPE_SENSOR, null, 0, b2Body.b2_staticBody, levelObj.world, levelObj.spriteContainer, 1.0, 1.0, 1.0, true);
						//Top Sensor
						CreateRectBlock(Registry.gameplayLayer.stage.stageWidth/2, -700, 4000, 40, Constants.BLOCKTYPE_SENSOR, null, 0, b2Body.b2_staticBody, levelObj.world, levelObj.spriteContainer, 1.0, 1.0, 1.0, true);
						
						// Main Collision sensor... If bodies are not colliding with this sensor, simply delete the body
						//var CONST:int = 5;
						//CreateRectBlock(Registry.gameplayLayer.stage.stageWidth/2, Registry.gameplayLayer.stage.stageHeight*(1-CONST/2), Registry.gameplayLayer.stage.stageWidth+20, Registry.gameplayLayer.stage.stageHeight*CONST, Constants.BLOCKTYPE_SENSOR, null, 0, b2Body.b2_staticBody, levelObj.world, levelObj.spriteContainer, 1.0, 1.0, 1.0, true);
					}
					
				}
				else if(levelChild.attribute("id") == "gameObj"){
					var gameObjChildren:XMLList = levelChild.children();
					for each (var gameObjChild:XML in gameObjChildren){
						
						container.W = Number(gameObjChild.@width);
						container.H = Number(gameObjChild.@height);
						Utility.DecodeSVGTransformMatrix(gameObjChild.@transform, container);
						Utility.ConvertiOStoAS3LevelCoordinates(container);
						
						var tileSprite:Sprite = null;
						var blockType:uint;
						var isRectBlock:Boolean = false;
						
						var density:Number;
						var friction:Number;
						var restitution:Number;
						
						if(gameObjChild.@onclick == "blocksToDestroy"){
							LevelObj.blocksToDestroy = int(gameObjChild.toString());
						}
						else if(gameObjChild.@onclick == "plank"){
							var bitmap:Bitmap = new AssetManager.PlankGFXClass();
							bitmap.width = container.W;
							bitmap.height = container.H;
							//trace("Plank size: " + container.W + "," + container.H);
							tileSprite = TextureManager.BitmapToSprite(bitmap);
							blockType = Constants.BLOCKTYPE_PLANK;
							isRectBlock = true;
							density = 1.0;
							friction =  0.4;
							restitution = 0.2;
						}
						else if(gameObjChild.@onclick == "rect_dirt"){
							tileSprite = GameUtility.TextureManager.CreateRectTexture(0,0,container.W,container.H,1.0,AssetManager.DirtTileGFX, true, true);
							blockType = Constants.BLOCKTYPE_DIRT;
							isRectBlock = true;
							density = 1.0;
							friction = 1.0;
							restitution = 0.1;
						}
						else if(gameObjChild.@onclick == "rect_rubber"){
							tileSprite = GameUtility.TextureManager.CreateRectTexture(0,0,container.W,container.H,1.0,AssetManager.RubberTileGFX, true, true);
							blockType = Constants.BLOCKTYPE_RUBBER;
							isRectBlock = true;
							density = 0.7;
							friction = 0.7;
							restitution = 0.8;
						}
						else if(gameObjChild.@onclick == "rect_steel"){
							tileSprite = GameUtility.TextureManager.CreateRectTexture(0,0,container.W,container.H,1.0,AssetManager.SteelTileGFX, true, true);
							blockType = Constants.BLOCKTYPE_STEEL;
							isRectBlock = true;
							density = 2.0;
							friction = 0.2;
							restitution = 0.4;
						}
						else if(gameObjChild.@onclick == "rect_ice"){
							tileSprite = GameUtility.TextureManager.CreateRectTexture(0,0,container.W,container.H,1.0,AssetManager.IceTileGFX, true, true, true);
							blockType = Constants.BLOCKTYPE_ICE;
							isRectBlock = true;
							density = 1.0;
							friction = 0.1;
							restitution = 0.2;
						}
						else if(gameObjChild.@onclick == "rect_tnt"){
							tileSprite = GameUtility.TextureManager.CreateRectTexture(0,0,container.W,container.H,1.0,AssetManager.CrateTileGFX, true, true);
							blockType = Constants.BLOCKTYPE_TNT;
							isRectBlock = true;
							density = 1.0;
							friction = 0.4;
							restitution = 0.2;
						}
						else if(gameObjChild.@onclick == "rect_spikes"){
							tileSprite = CreateSpikeTexture(container.W,container.H);
							blockType = Constants.BLOCKTYPE_SPIKE;
							isRectBlock = true;
							density = 2.0;
							friction = 0.4;
							restitution = 0.2;
						}
						else if(gameObjChild.@onclick == "round_dirt"){
							tileSprite = GameUtility.TextureManager.CreateRoundTexture(0,0,container.W/2,1.0,AssetManager.DirtTileGFX, true, true);
							blockType = Constants.BLOCKTYPE_DIRT;
							isRectBlock = false;
							density = 1.0;
							friction = 0.8;
							restitution = 0.1;
						}
						else if(gameObjChild.@onclick == "round_rubber"){
							tileSprite = GameUtility.TextureManager.CreateRoundTexture(0,0,container.W/2,1.0,AssetManager.RubberTileGFX, true, true);
							blockType = Constants.BLOCKTYPE_RUBBER;
							isRectBlock = false;
							density = 0.7;
							friction = 0.5;
							restitution = 0.8;
						}
						else if(gameObjChild.@onclick == "round_steel"){
							tileSprite = GameUtility.TextureManager.CreateRoundTexture(0,0,container.W/2,1.0,AssetManager.SteelTileGFX, true, true);
							blockType = Constants.BLOCKTYPE_STEEL;
							isRectBlock = false;
							density = 2.0;
							friction = 0.2;
							restitution = 0.4;
						}
						else if(gameObjChild.@onclick == "round_ice"){
							tileSprite = GameUtility.TextureManager.CreateRoundTexture(0,0,container.W/2,1.0,AssetManager.IceTileGFX, true, true, true);
							blockType = Constants.BLOCKTYPE_ICE;
							isRectBlock = false;
							density = 1.0;
							friction = 0.1;
							restitution = 0.2;
						}
						else if(gameObjChild.@onclick == "round_tnt"){
							tileSprite = GameUtility.TextureManager.CreateRoundTexture(0,0,container.W/2,1.0,AssetManager.CrateTileGFX, true, true);
							blockType = Constants.BLOCKTYPE_TNT;
							isRectBlock = false;
							density = 1.0;
							friction = 0.4;
							restitution = 0.2;
						}
						
						if(tileSprite != null){
							// make sure the blocks spawn far off the screen so to prevent any VISUAL GLITCH
							tileSprite.x = -400;
							tileSprite.y = -400;
							tileSprite.name = gameObjChild.@onclick;
							
							if(isRectBlock == true){
								CreateRectBlock(container.X, container.Y, tileSprite.width, tileSprite.height, blockType, tileSprite, -container.angle, b2Body.b2_dynamicBody, levelObj.world, levelObj.spriteContainer, density, friction, restitution, false);
							}
							else{
								CreateRoundBlock(container.X, container.Y, tileSprite.width/2, blockType, tileSprite, -container.angle, b2Body.b2_dynamicBody, levelObj.world, levelObj.spriteContainer, density, friction, restitution, false);
							}
						}
					}
				}
			}
		}
		
		
		private static function CreateRectBlock(x:int, y:int, W:int, H:int, blockType:uint, texture:Sprite, angle:Number, bodyType:uint, world:b2World, spriteContainer:Sprite, density:Number, friction:Number, restitution:Number, isSensor:Boolean=false):void{

			var boxShape:b2PolygonShape = new b2PolygonShape();
			boxShape.SetAsBox(W/2/Constants.PTM_RATIO,H/2/Constants.PTM_RATIO);
			CreateBlock(x,y,blockType,texture,angle,bodyType,world,boxShape,spriteContainer,density,friction,restitution,isSensor);
		}
		
		private static function CreateRoundBlock(x:int, y:int, R:int, blockType:uint, texture:Sprite, angle:Number, bodyType:uint, world:b2World, spriteContainer:Sprite, density:Number, friction:Number, restitution:Number, isSensor:Boolean=false):void{
			
			var roundShape:b2CircleShape = new b2CircleShape();
			roundShape.SetRadius(R / Constants.PTM_RATIO);
			CreateBlock(x,y,blockType,texture,angle,bodyType,world,roundShape,spriteContainer,density,friction,restitution,isSensor);
		}
		
		private static function CreateBlock(x:int, y:int, blockType:uint, texture:Sprite, angle:Number, bodyType:uint, world:b2World, shape:b2Shape, spriteContainer:Sprite, density:Number, friction:Number, restitution:Number, isSensor:Boolean=false):void{
			
			var blockObj:BlockObj = new BlockObj();
			
			if(texture != null){
				spriteContainer.addChild(texture);
				blockObj.W = texture.width;
				blockObj.H = texture.height;
			} 
			
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(x/Constants.PTM_RATIO,y/Constants.PTM_RATIO);
			bodyDef.type = bodyType;
			bodyDef.userData = blockObj;
			//bodyDef.bullet = true; // DAMN TOO SLOWWWW
			var body:b2Body = world.CreateBody(bodyDef);
			body.SetAngle(angle*Constants.PI/180.0);
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = shape;
			fixtureDef.density = density;
			fixtureDef.friction = friction;
			fixtureDef.restitution = restitution;
			fixtureDef.isSensor = isSensor;
			body.CreateFixture(fixtureDef);
			
			blockObj.blockTexture = texture;
			blockObj.blockBody = body;
			blockObj.blockType = blockType;
		}

		private static function CreateSpikeTexture(width:int,height:int):Sprite{
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