package GameElements 
{
	import AssetMgr.AssetManager;
	import flash.display.*;
	import flash.geom.Point;
	import flash.ui.*;
	
	/**
	 * ...
	 * @author fakhir
	 */
	public class Cursor
	{
	
		public function Cursor() 
		{
			RegisterCursorPtr("normalPtr", AssetManager.MousePtrNormalGFX);
			RegisterCursorPtr("waitPtr", AssetManager.MousePtrWaitGFX);
			
			ChangeToNormalCursor();
		}
		
		private function RegisterCursorPtr(cursorName:String, PtrGFX:Class):void{
			
			var bitmapDataList:Vector.<BitmapData>	= new Vector.<BitmapData>(1, true);
			var bitmap:Bitmap = new PtrGFX();
			bitmapDataList[0] = bitmap.bitmapData;
			
			var cursorData:MouseCursorData = new MouseCursorData();
			cursorData.hotSpot = new Point(0,0);
			cursorData.data = bitmapDataList;

			Mouse.registerCursor(cursorName, cursorData);
			
		}
		
		public function ChangeToNormalCursor():void {
			Mouse.cursor = "normalPtr";
		}
		
		public function ChangeToWaitCursor():void {
			Mouse.cursor = "waitPtr";
		}
	}

}