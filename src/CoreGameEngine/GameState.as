package CoreGameEngine
{
	import flash.display.Sprite;
	import flash.display.Stage;
	/**
	 * ...
	 * @author fakhir
	 */
	public class GameState extends Sprite
	{
		public function GameState() 
		{
		}
		
		public function Load():void { 
			trace("GameState.Load()");
		}
		
		public function UnLoad():void { 
			trace("GameState.Unload()");
		}
		
		public function Init():void { 
			trace("GameState.Init()");
		}
		
		public function Free():void { 
			trace("GameState.Free()");
		}
		
		public function Update():void { 
			trace("GameState.Update()");
		}
		
		public function Draw():void { 
			trace("GameState.Draw()");
		}
	}

}