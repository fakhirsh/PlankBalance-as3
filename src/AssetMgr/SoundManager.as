package AssetMgr
{
	import flash.media.*;

	public class SoundManager
	{
		private static var _loseSFX:Sound;
		private static var _winSFX:Sound;
		private static var _mouseOverSFX:Sound;
		private static var _mouseClickSFX:Sound;
		private static var _mouseClickHardSFX:Sound;
		private static var _blockDeleteSFX:Sound;
		private static var _readySFX:Sound;
		private static var _goSFX:Sound;
		private static var _gameCompleteSFX:Sound;
		private static var _music:Sound;
		private static var _musicChannel:SoundChannel;
		
		private static var _isSoundOn:Boolean;
		private static var _isMusicOn:Boolean;
		
		public function SoundManager()
		{
			_loseSFX = new AssetManager.LoseSFX();
			_winSFX = new AssetManager.WinSFX();
			_mouseOverSFX = new AssetManager.MouseOverSFX();
			_mouseClickSFX = new AssetManager.MouseClickSFX();
			_mouseClickHardSFX = new AssetManager.MouseClickHardSFX();
			_blockDeleteSFX = new AssetManager.BlockDeleteSFX();
			_readySFX = new AssetManager.ReadySFX();
			_goSFX = new AssetManager.GoSFX();
			_gameCompleteSFX = new AssetManager.GameCompleteSFX();
			
			_musicChannel = new SoundChannel();
			_music = new AssetManager.MusicSFX();
			
			_isSoundOn = true;
		}

		public static function get isSoundOn():Boolean{
			return _isSoundOn;
		}

		public static function get isMusicOn():Boolean{
			return _isMusicOn;
		}
		
		
		public static function PlayMusic():void {
			_musicChannel = _music.play(0, int.MAX_VALUE);
			_isMusicOn = true;
		}
		
		public static function StopMusic():void {
			_musicChannel.stop();
			_isMusicOn = false;
		}
		
		public static function SoundOff():void {
			_isSoundOn = false;
		}
		
		public static function SoundOn():void {
			_isSoundOn = true;
		}

		public static function MusicOff():void {
			_isMusicOn = false;
			StopMusic();
		}
		
		public static function MusicOn():void {
			_isMusicOn = true;
			PlayMusic();
		}
		
		public static function PlayLevelFailSFX():void{
			if(!_isSoundOn) return;
			
			_loseSFX.play();
		}
		
		public static function PlayLevelCompleteSFX():void{
			if(!_isSoundOn) return;
			
			_winSFX.play();
		}
		
		public static function PlayGameCompleteSFX():void{
			if(!_isSoundOn) return;
			
			_gameCompleteSFX.play();
		}
		
		public static function PlayMouseOverSFX():void{
			if(!_isSoundOn) return;
			
			_mouseOverSFX.play();
		}

		public static function PlayMouseClickSFX():void{
			if(!_isSoundOn) return;
			
			_mouseClickSFX.play();
		}

		public static function PlayMouseClickHardSFX():void{
			if(!_isSoundOn) return;
			
			_mouseClickHardSFX.play();
		}

		public static function PlayBlockDeleteSFX():void{
			if(!_isSoundOn) return;
			
			_blockDeleteSFX.play();
		}

		public static function PlayReadySFX():void{
			if(!_isSoundOn) return;
			
			_readySFX.play();
		}

		public static function PlayGoSFX():void{
			if(!_isSoundOn) return;
			
			_goSFX.play();
		}

	}
}