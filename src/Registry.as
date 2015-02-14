package  
{
	import AssetMgr.AssetManager;
	import AssetMgr.SoundManager;
	import com.google.analytics.AnalyticsTracker;
	import CoreGameEngine.GameEngine;
	import flash.display.Sprite;
	import flash.net.SharedObject;
	import GameElements.Cursor;
	import GameUtility.Profiler;
	import Scenes.LevelSelection.LevelSelection;
	/**
	 * ...
	 * @author fakhir
	 */
	public class Registry 
	{
		public static var bgLayer:Sprite;
		public static var gameplayLayer:Sprite;
		public static var guiLayer:Sprite;
		public static var playerLayer:Sprite;
		public static var profiler:Profiler;
		public static var soundMgr:SoundManager;
		public static var assetMgr:AssetManager;
		public static var gaTracker:AnalyticsTracker;
		public static var cursor:Cursor;
		public static var game:GameEngine;
		public static var clickCounter:int = 0;
		public static var deathCounter:int = 0;
		public static var levelLocked:Vector.<Boolean>;
		public static var saveDataObject:SharedObject = SharedObject.getLocal("saves");
		
		public function Registry() 
		{
			
		}
		
		public static function GetAchievementID(title:String):int
		{
			for (var i:int = 0; i < GamerSafe.api.achievements.length; i++ )
			{
				if (GamerSafe.api.achievements[i].title == title)
				{
					return GamerSafe.api.achievements[i].id;
				}
			}
			return -1;
		}
		
		public static function CompleteAchievement(title:String):void
		{
			
			var id:int = GetAchievementID(title);
			
			if (id != -1)
			{
				GamerSafe.api.bestowAchievement(id);
			}
			
		}
		
		public static function IncrementClickCounter():void
		{
			clickCounter++;
			trace("Clock counter: " + clickCounter);
			if(clickCounter == 500)
			{
				Registry.CompleteAchievement("Click 500 times");
			}
		}
		
		public static function SerializeGameState():void
		{
			
		}
		
		public static function SaveGameData():void
		{
			saveDataObject.data.clickCounter = clickCounter;
			saveDataObject.data.deathCounter = deathCounter;
			
			saveDataObject.data.lvl1 = levelLocked[1];
			saveDataObject.data.lvl2 = levelLocked[2];
			saveDataObject.data.lvl3 = levelLocked[3];
			saveDataObject.data.lvl4 = levelLocked[4];
			saveDataObject.data.lvl5 = levelLocked[5];
			saveDataObject.data.lvl6 = levelLocked[6];
			saveDataObject.data.lvl7 = levelLocked[7];
			saveDataObject.data.lvl8 = levelLocked[8];
			saveDataObject.data.lvl9 = levelLocked[9];
			saveDataObject.data.lvl10 = levelLocked[10];
			saveDataObject.data.lvl11 = levelLocked[11];
			saveDataObject.data.lvl12 = levelLocked[12];
			saveDataObject.data.lvl13 = levelLocked[13];
			saveDataObject.data.lvl14 = levelLocked[14];
			saveDataObject.data.lvl15 = levelLocked[15];
			saveDataObject.data.lvl16 = levelLocked[16];
			saveDataObject.data.lvl17 = levelLocked[17];
			saveDataObject.data.lvl18 = levelLocked[18];
			saveDataObject.data.lvl19 = levelLocked[19];
			saveDataObject.data.lvl20 = levelLocked[20];
			saveDataObject.data.lvl21 = levelLocked[21];
			saveDataObject.data.lvl22 = levelLocked[22];
			saveDataObject.data.lvl23 = levelLocked[23];
			saveDataObject.data.lvl24 = levelLocked[24];
			saveDataObject.data.lvl25 = levelLocked[25];
			saveDataObject.data.lvl26 = levelLocked[26];
			saveDataObject.data.lvl27 = levelLocked[27];
			saveDataObject.data.lvl28 = levelLocked[28];
			saveDataObject.data.lvl29 = levelLocked[29];
			
			saveDataObject.flush();
		}

		public static function LoadGameData():void
		{
			levelLocked = new Vector.<Boolean>;
			
			if (saveDataObject.data.clickCounter == null)
			{
				clickCounter = 0;
				
				levelLocked.push(true);	// Level 0  ,non Existant
				levelLocked.push(false);	// First level: 1
				for(var i:int = 1; i < LevelSelection.NUMBER_OF_LEVELS+1; i++){
					levelLocked.push(true);
					//Registry.levelLocked.push(false);	// FOR TESTING ONLY
				}
				
				return;
			}
			
			clickCounter = saveDataObject.data.clickCounter;
			deathCounter = saveDataObject.data.deathCounter;
			
			for (i = 0; i < LevelSelection.NUMBER_OF_LEVELS + 1; i++ )
			{
				levelLocked.push(true);
			}
			
			levelLocked[1] = saveDataObject.data.lvl1;
			levelLocked[2] = saveDataObject.data.lvl2;
			levelLocked[3] = saveDataObject.data.lvl3;
			levelLocked[4] = saveDataObject.data.lvl4;
			levelLocked[5] = saveDataObject.data.lvl5;
			levelLocked[6] = saveDataObject.data.lvl6;
			levelLocked[7] = saveDataObject.data.lvl7;
			levelLocked[8] = saveDataObject.data.lvl8;
			levelLocked[9] = saveDataObject.data.lvl9;
			levelLocked[10] = saveDataObject.data.lvl10;
			levelLocked[11] = saveDataObject.data.lvl11;
			levelLocked[12] = saveDataObject.data.lvl12;
			levelLocked[13] = saveDataObject.data.lvl13;
			levelLocked[14] = saveDataObject.data.lvl14;
			levelLocked[15] = saveDataObject.data.lvl15;
			levelLocked[16] = saveDataObject.data.lvl16;
			levelLocked[17] = saveDataObject.data.lvl17;
			levelLocked[18] = saveDataObject.data.lvl18;
			levelLocked[19] = saveDataObject.data.lvl19;
			levelLocked[20] = saveDataObject.data.lvl20;
			levelLocked[21] = saveDataObject.data.lvl21;
			levelLocked[22] = saveDataObject.data.lvl22;
			levelLocked[23] = saveDataObject.data.lvl23;
			levelLocked[24] = saveDataObject.data.lvl24;
			levelLocked[25] = saveDataObject.data.lvl25;
			levelLocked[26] = saveDataObject.data.lvl26;
			levelLocked[27] = saveDataObject.data.lvl27;
			levelLocked[28] = saveDataObject.data.lvl28;
			levelLocked[29] = saveDataObject.data.lvl29;
		}
		
	}

}