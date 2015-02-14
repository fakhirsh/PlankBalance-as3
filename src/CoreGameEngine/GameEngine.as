package CoreGameEngine
{
	import Box2D.Dynamics.b2World;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	/**
	 * ...
	 * @author fakhir
	 */
	public class GameEngine extends Sprite
	{
		public static const PTM_RATIO:Number = 50;		
		private static var stateVector:Vector.<GameState>;
		public static var _container:Sprite;
		public static var isLevelLocked:Vector.<Boolean> = new Vector.<Boolean>;

		function GameEngine(container:Sprite) 
		{
			//mainStage = stageParam;
			_container = container;
		}

		public static function Init():void {
			stateVector = new Vector.<GameState>;
			
			for (var i:int = 0; i < 28; i++ ) {
				isLevelLocked.push(false);
			}
			
			isLevelLocked[0] = false;
			
			//trace(isLevelLocked);
		}
		
		public static function PushState(gs:GameState):void {			
			stateVector.push(gs);
			gs.Load();
			gs.Init();
		}
		
		public static function PopState():void {
			var gs:GameState = stateVector.pop();
			gs.Free();
			gs.UnLoad();
		}
		
		public static function ChangeState(gs:GameState):void {
			if (!stateVector) {
				Init();
			}
			
			if (stateVector.length != 0) {
				PopState();
			}
			PushState(gs);
		}
		
		public static function Update():void { 
			stateVector[stateVector.length - 1].Update();
		}
		
		public static function Draw():void { 
			stateVector[stateVector.length - 1].Draw();
		}
		
		/*
		public function Loop(e:Event):void { 
			Update();
			Draw();
		}
		*/
	}

}