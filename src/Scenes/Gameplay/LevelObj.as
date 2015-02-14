package Scenes.Gameplay
{
	import Box2D.Dynamics.b2World;
	
	import flash.display.Sprite;
	
	public class LevelObj
	{
		public var world:b2World;
		public var spriteContainer:Sprite;
		public static var blocksToDestroy:int;
		public static var currentLevelNumber:int;
		public var levelWidth:int;
		public var levelHeight:int;
		public var contactListener:ContactListener;
		
		public function LevelObj()
		{
		}
		
		public function Destroy():void{
			
		}

	}
}