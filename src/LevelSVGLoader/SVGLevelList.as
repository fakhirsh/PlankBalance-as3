package LevelSVGLoader
{
	import AssetMgr.AssetManager;
	
	public class SVGLevelList
	{
		
		[Embed(source="../../levelData/AAA.svg", mimeType="application/octet-stream")] private static const LevelAAASVG:Class;
		[Embed(source="../../levelData/AAB.svg", mimeType="application/octet-stream")] private static const LevelAABSVG:Class;
		[Embed(source="../../levelData/AAC.svg", mimeType="application/octet-stream")] private static const LevelAACSVG:Class;
		[Embed(source="../../levelData/AAD.svg", mimeType="application/octet-stream")] private static const LevelAADSVG:Class;
		[Embed(source="../../levelData/AAE.svg", mimeType="application/octet-stream")] private static const LevelAAESVG:Class;
		[Embed(source="../../levelData/AAF.svg", mimeType="application/octet-stream")] private static const LevelAAFSVG:Class;
		[Embed(source="../../levelData/AAG.svg", mimeType="application/octet-stream")] private static const LevelAAGSVG:Class;
		[Embed(source="../../levelData/AAH.svg", mimeType="application/octet-stream")] private static const LevelAAHSVG:Class;
		[Embed(source="../../levelData/AAI.svg", mimeType="application/octet-stream")] private static const LevelAAISVG:Class;
		[Embed(source="../../levelData/AAJ.svg", mimeType="application/octet-stream")] private static const LevelAAJSVG:Class;
		[Embed(source="../../levelData/AAK.svg", mimeType="application/octet-stream")] private static const LevelAAKSVG:Class;
		[Embed(source="../../levelData/AAL.svg", mimeType="application/octet-stream")] private static const LevelAALSVG:Class;
		[Embed(source="../../levelData/AAM.svg", mimeType="application/octet-stream")] private static const LevelAAMSVG:Class;
		[Embed(source="../../levelData/AAN.svg", mimeType="application/octet-stream")] private static const LevelAANSVG:Class;
		[Embed(source="../../levelData/AAO.svg", mimeType="application/octet-stream")] private static const LevelAAOSVG:Class;
		[Embed(source="../../levelData/AAP.svg", mimeType="application/octet-stream")] private static const LevelAAPSVG:Class;
		[Embed(source="../../levelData/AAQ.svg", mimeType="application/octet-stream")] private static const LevelAAQSVG:Class;
		[Embed(source="../../levelData/AAR.svg", mimeType="application/octet-stream")] private static const LevelAARSVG:Class;
		[Embed(source="../../levelData/AAS.svg", mimeType="application/octet-stream")] private static const LevelAASSVG:Class;
		[Embed(source="../../levelData/AAT.svg", mimeType="application/octet-stream")] private static const LevelAATSVG:Class;
		[Embed(source="../../levelData/AAU.svg", mimeType="application/octet-stream")] private static const LevelAAUSVG:Class;
		[Embed(source="../../levelData/AAV.svg", mimeType="application/octet-stream")] private static const LevelAAVSVG:Class;
		[Embed(source="../../levelData/AAW.svg", mimeType="application/octet-stream")] private static const LevelAAWSVG:Class;
		[Embed(source="../../levelData/AAX.svg", mimeType="application/octet-stream")] private static const LevelAAXSVG:Class;
		[Embed(source="../../levelData/AAY.svg", mimeType="application/octet-stream")] private static const LevelAAYSVG:Class;
		[Embed(source="../../levelData/AAZ.svg", mimeType="application/octet-stream")] private static const LevelAAZSVG:Class;
		[Embed(source="../../levelData/ABA.svg", mimeType="application/octet-stream")] private static const LevelABASVG:Class;
		[Embed(source="../../levelData/ABB.svg", mimeType="application/octet-stream")] private static const LevelABBSVG:Class;
		[Embed(source="../../levelData/ABC.svg", mimeType="application/octet-stream")] private static const LevelABCSVG:Class;
		
		//[Embed(source="../../TMPLVLDATA/levelTemplate.svg", mimeType="application/octet-stream")] private static const LevelTESTSVG:Class;
		
		private static var levelList:Vector.<Class> = null;
		private static var levelTimeLimits:Vector.<Object> = null;
		private static var levelThumbList:Vector.<Class> = null;
		
		public function SVGLevelList()
		{
		
		}
		
		public static function GetLevelClass(levelNumber:int):Class{
			return levelList[levelNumber-1];
		}

		public static function GetLevelThumbClass(levelNumber:int):Class{
			return levelThumbList[levelNumber-1];
		}

		
		public static function GetThreeStarTime(levelNumber:int):int{
			return levelTimeLimits[levelNumber-1].threeStar;
		}
		public static function GetTwoStarTime(levelNumber:int):int{
			return levelTimeLimits[levelNumber-1].twoStar;
		}
		//public static function GetOneStarTime(levelNumber:int):int{
		//	return levelTimeLimits[levelNumber-1].oneStar;
		//}

		
		public static function InitLevelList():void{
			levelList = new Vector.<Class>;
			levelTimeLimits = new Vector.<Object>;
			levelThumbList = new Vector.<Class>;
			
			InsertLevelSVGToList();
		}
		
		private static function InsertLevelSVGToList():void{

			//********* TESTING **********
			//levelList.push(LevelTESTSVG);
			//****************************
			
			levelList.push(LevelAAASVG);		// 1
			levelThumbList.push(AssetManager.LevelSelectionAAAGFX);
			levelTimeLimits.push({threeStar:5, twoStar:12});
			
			levelList.push(LevelAABSVG);		// 2
			levelThumbList.push(AssetManager.LevelSelectionAABGFX);
			levelTimeLimits.push({threeStar:5, twoStar:9});
			
			levelList.push(LevelAACSVG);		// 3
			levelThumbList.push(AssetManager.LevelSelectionAACGFX);
			levelTimeLimits.push({threeStar:6, twoStar:11});
			
			levelList.push(LevelABBSVG);		// 4
			levelThumbList.push(AssetManager.LevelSelectionABBGFX);
			levelTimeLimits.push({threeStar:6, twoStar:11});
			
			levelList.push(LevelAADSVG);		// 5
			levelThumbList.push(AssetManager.LevelSelectionAADGFX);
			levelTimeLimits.push({threeStar:4, twoStar:8});
			
			levelList.push(LevelAAHSVG);		// 6
			levelThumbList.push(AssetManager.LevelSelectionAAHGFX);
			levelTimeLimits.push({threeStar:8, twoStar:14});
			
			levelList.push(LevelAAESVG);		// 7
			levelThumbList.push(AssetManager.LevelSelectionAAEGFX);
			levelTimeLimits.push({threeStar:8, twoStar:15});
			
			levelList.push(LevelAAZSVG);		// 8
			levelThumbList.push(AssetManager.LevelSelectionAAZGFX);
			levelTimeLimits.push({threeStar:13, twoStar:17});
			
			levelList.push(LevelAAFSVG);		// 9
			levelThumbList.push(AssetManager.LevelSelectionAAFGFX);
			levelTimeLimits.push({threeStar:11, twoStar:18});
			
			levelList.push(LevelAAGSVG);		// 10
			levelThumbList.push(AssetManager.LevelSelectionAAGGFX);
			levelTimeLimits.push({threeStar:7, twoStar:12});
			
			levelList.push(LevelABCSVG);		// 11
			levelThumbList.push(AssetManager.LevelSelectionABCGFX);
			levelTimeLimits.push({threeStar:8, twoStar:12});
			
			levelList.push(LevelAAISVG);		// 12
			levelThumbList.push(AssetManager.LevelSelectionAAIGFX);
			levelTimeLimits.push({threeStar:7, twoStar:11});
			
			levelList.push(LevelAAJSVG);		// 13
			levelThumbList.push(AssetManager.LevelSelectionAAJGFX);
			levelTimeLimits.push({threeStar:8, twoStar:11});
			
			levelList.push(LevelAAKSVG);		// 14
			levelThumbList.push(AssetManager.LevelSelectionAAKGFX);
			levelTimeLimits.push({threeStar:9, twoStar:13});
			
			levelList.push(LevelAALSVG);		// 15
			levelThumbList.push(AssetManager.LevelSelectionAALGFX);
			levelTimeLimits.push({threeStar:11, twoStar:16});
			
			levelList.push(LevelAAXSVG);		// 16
			levelThumbList.push(AssetManager.LevelSelectionAAXGFX);
			levelTimeLimits.push({threeStar:8, twoStar:13});

			levelList.push(LevelAANSVG);		// 17
			levelThumbList.push(AssetManager.LevelSelectionAANGFX);
			levelTimeLimits.push({threeStar:16, twoStar:21});
			
			levelList.push(LevelAARSVG);		// 18
			levelThumbList.push(AssetManager.LevelSelectionAARGFX);
			levelTimeLimits.push({threeStar:9, twoStar:14});
			
			levelList.push(LevelAAYSVG);		// 19
			levelThumbList.push(AssetManager.LevelSelectionAAYGFX);
			levelTimeLimits.push({threeStar:13, twoStar:19});
			
			levelList.push(LevelAASSVG);		// 20
			levelThumbList.push(AssetManager.LevelSelectionAASGFX);
			levelTimeLimits.push({threeStar:1, twoStar:19});
			
			levelList.push(LevelAATSVG);		// 21
			levelThumbList.push(AssetManager.LevelSelectionAATGFX);
			levelTimeLimits.push({threeStar:9, twoStar:14});
			
			levelList.push(LevelAAPSVG);		// 22
			levelThumbList.push(AssetManager.LevelSelectionAAPGFX);
			levelTimeLimits.push({threeStar:10, twoStar:14});
			
			levelList.push(LevelAAOSVG);		// 23
			levelThumbList.push(AssetManager.LevelSelectionAAOGFX);
			levelTimeLimits.push({threeStar:7, twoStar:12});
			
			levelList.push(LevelABASVG);		// 24
			levelThumbList.push(AssetManager.LevelSelectionABAGFX);
			levelTimeLimits.push({threeStar:13, twoStar:19});
			
			levelList.push(LevelAAWSVG);		// 25
			levelThumbList.push(AssetManager.LevelSelectionAAWGFX);
			levelTimeLimits.push({threeStar:18, twoStar:25});
			
			levelList.push(LevelAAVSVG);		// 26
			levelThumbList.push(AssetManager.LevelSelectionAAVGFX);
			levelTimeLimits.push({threeStar:13, twoStar:18});
			
			levelList.push(LevelAAMSVG);		// 27
			levelThumbList.push(AssetManager.LevelSelectionAAMGFX);
			levelTimeLimits.push({threeStar:20, twoStar:26});
			
			levelList.push(LevelAAQSVG);		// 28
			levelThumbList.push(AssetManager.LevelSelectionAAQGFX);
			levelTimeLimits.push({threeStar:12, twoStar:18});
			
			levelList.push(LevelAAUSVG);		// 29
			levelThumbList.push(AssetManager.LevelSelectionAAUGFX);
			levelTimeLimits.push({threeStar:16, twoStar:21});

			
		}
		
	}
}