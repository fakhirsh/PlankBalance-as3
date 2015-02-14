package GameUtility 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.getTimer;
	import flash.system.System;
	
	/**
	 * ...
	 * @author fakhir
	 */
	public class Profiler 
	{
		private var m_container:Sprite;

		private var m_memory:Number;
		private var m_previousMemory:Number;
		private var m_previousTime:int;
		private var m_fps:Number;
		
		private var m_memText:TextField;
		private var m_fpsText:TextField;
		
		private var m_ticks:uint = 0;
		
		public function Profiler(x:int, y:int, container:Sprite) 
		{
			Init(x, y, container);
		}

		private function Init(x:int, y:int, container:Sprite):void {
			m_memText = new TextField();
			container.addChild(m_memText);
			m_memText.x = x;
			m_memText.y = y;
			
			m_fpsText = new TextField();
			container.addChild(m_fpsText);
			m_fpsText.x = x;
			m_fpsText.y = y+13;
		}
		
		
		public function Update():void {
			m_ticks++;
			
			var _time:int = getTimer();
			var delta:Number = _time - m_previousTime;
			if (delta >= 1000) {
                m_fps = m_ticks / delta * 1000;
                m_ticks = 0;
				m_previousTime = getTimer();
            }
			
			var mb:Number = System.totalMemory / 1024 / 1024;
			m_memory = Math.round(mb * 100) / 100;

			m_memText.text = "Mem:" + m_memory;
			m_fpsText.text = "fps:" + m_fps.toFixed(1);
		}
		
	}

}