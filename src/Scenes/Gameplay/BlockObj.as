﻿package Scenes.Gameplay{	import Box2D.Dynamics.*;		import GameUtility.Utility;		import flash.display.*;	import flash.geom.Point;
		public class BlockObj	{		public var blockTexture:Sprite;		public var blockBody:b2Body;		public var blockType:uint;		public var W:Number;		public var H:Number;		public function BlockObj()		{		}				public function IsDestructible():Boolean{						switch(blockType){				case Constants.BLOCKTYPE_PLANK:				case Constants.BLOCKTYPE_SENSOR:				case Constants.BLOCKTYPE_STATIC:				case Constants.BLOCKTYPE_SPIKE:				case Constants.BLOCKTYPE_STEEL:					return false;					break;				default:					return true;					break;			}		}				public function Destroy():void {						if(blockTexture != null){				var parent:DisplayObjectContainer = blockTexture.parent;				if(parent != null){					parent.removeChild(blockTexture);				}								//if(blockType == Constants.BLOCKTYPE_TNT){				//	trace("BOOOOOOOM !!!" + blockBody.GetMass());				//	var blastRadius:int = 550;				//	Utility.LaunchBomb(new Point(blockTexture.x, blockTexture.y), blockBody.GetMass()*Constants.EXPLOSION_FACTOR, blastRadius, false, blockBody.GetWorld());				//}			}						if(blockBody != null){				var world:b2World = blockBody.GetWorld();				world.DestroyBody(blockBody);			}		}		public function GetBlockType():uint{			return blockType;		}			}}