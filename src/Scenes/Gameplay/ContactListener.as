package Scenes.Gameplay 
{
	import AssetMgr.AssetManager;
	
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.b2Fixture;
	
//	import Playtomic.Log;
	
	import Scenes.Gameplay.*;
	
	/**
	 * ...
	 * @author fakhir
	 */
	public class ContactListener extends b2ContactListener 
	{
		
		public function ContactListener() 
		{
			
		}
		
		public function RegisterDeathCoordinates(x:int, y:int):void{
//			Log.Heatmap("Level"+LevelObj.currentLevelNumber + " Deaths", "PlankDeath", x, y);
		}
		
		override public function BeginContact(contact:b2Contact):void {
			// getting the fixtures that collided
			var fixtureA:b2Fixture = contact.GetFixtureA();
			var fixtureB:b2Fixture = contact.GetFixtureB();
			
			var blockA:BlockObj = fixtureA.GetBody().GetUserData() as BlockObj;
			var blockB:BlockObj = fixtureB.GetBody().GetUserData() as BlockObj;

			// Collision of Plank with the floor
			if (blockA.GetBlockType() == Constants.BLOCKTYPE_PLANK && blockB.GetBlockType() == Constants.BLOCKTYPE_STATIC) {
				//trace("You lose!!!");
				Registry.deathCounter++;
				
				Gameplay.gameLost = true;
				Gameplay.ChangePlankTexture(blockA, AssetManager.PlankDeadGFXClass);
				RegisterDeathCoordinates(blockA.blockBody.GetPosition().x * Constants.PTM_RATIO, blockA.blockBody.GetPosition().y * Constants.PTM_RATIO);
				//trace("Death at: (" + blockA.blockBody.GetPosition().x * Constants.PTM_RATIO + "," + blockA.blockBody.GetPosition().y * Constants.PTM_RATIO +")");
			}
			else if (blockB.GetBlockType() == Constants.BLOCKTYPE_PLANK && blockA.GetBlockType() == Constants.BLOCKTYPE_STATIC) {
				//trace("You lose!!!");
				Registry.deathCounter++;
				
				Gameplay.gameLost = true;
				Gameplay.ChangePlankTexture(blockB, AssetManager.PlankDeadGFXClass);
				RegisterDeathCoordinates(blockB.blockBody.GetPosition().x * Constants.PTM_RATIO, blockB.blockBody.GetPosition().y * Constants.PTM_RATIO);
				//trace("Death at: (" + blockB.blockBody.GetPosition().x * Constants.PTM_RATIO + "," + blockB.blockBody.GetPosition().y * Constants.PTM_RATIO +")");
			}
			
			// Collision of Plank with the spike block
			if (blockA.GetBlockType() == Constants.BLOCKTYPE_PLANK && blockB.GetBlockType() == Constants.BLOCKTYPE_SPIKE) {
				//trace("You lose!!!");
				Registry.deathCounter++;
				
				Gameplay.gameLost = true;
				Gameplay.ChangePlankTexture(blockA, AssetManager.PlankDeadGFXClass);
				RegisterDeathCoordinates(blockA.blockBody.GetPosition().x * Constants.PTM_RATIO, blockA.blockBody.GetPosition().y * Constants.PTM_RATIO);
				//trace("Death at: (" + blockA.blockBody.GetPosition().x * Constants.PTM_RATIO + "," + blockA.blockBody.GetPosition().y * Constants.PTM_RATIO +")");
			}
			else if (blockB.GetBlockType() == Constants.BLOCKTYPE_PLANK && blockA.GetBlockType() == Constants.BLOCKTYPE_SPIKE) {
				//trace("You lose!!!");
				Registry.deathCounter++;
				
				Gameplay.gameLost = true;
				Gameplay.ChangePlankTexture(blockB, AssetManager.PlankDeadGFXClass);
				RegisterDeathCoordinates(blockB.blockBody.GetPosition().x * Constants.PTM_RATIO, blockB.blockBody.GetPosition().y * Constants.PTM_RATIO);
				//trace("Death at: (" + blockB.blockBody.GetPosition().x * Constants.PTM_RATIO + "," + blockB.blockBody.GetPosition().y * Constants.PTM_RATIO +")");
			}
			
			// Collision of Plank with the Hidden offscreen sensors
			if (blockA.GetBlockType() == Constants.BLOCKTYPE_PLANK && blockB.GetBlockType() == Constants.BLOCKTYPE_SENSOR) {
				//trace("Collision with sensor");
				Gameplay.gameLost = true;
			}
			else if (blockB.GetBlockType() == Constants.BLOCKTYPE_PLANK && blockA.GetBlockType() == Constants.BLOCKTYPE_SENSOR) {
				//trace("Collision with sensor");
				Gameplay.gameLost = true;
			}
			
			
			// Blocks falling out of the screen and hence being destroyed!
			if (fixtureA.GetBody().GetType() == b2Body.b2_dynamicBody && blockB.GetBlockType() == Constants.BLOCKTYPE_SENSOR) {
				//trace("Destroy block");
				var block:BlockObj = fixtureA.GetBody().GetUserData() as BlockObj;
				Gameplay.destroyBlocksList.push(block);
			}
			else if (fixtureB.GetBody().GetType() == b2Body.b2_dynamicBody && blockA.GetBlockType() == Constants.BLOCKTYPE_SENSOR) {
				//trace("Destroy block");
				var block2:BlockObj = fixtureB.GetBody().GetUserData() as BlockObj;
				Gameplay.destroyBlocksList.push(block2);
			}
			
			
		}
		
	}
	
}