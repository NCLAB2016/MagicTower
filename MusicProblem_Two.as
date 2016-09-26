package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	public class MusicProblem_Two extends MovieClip {
		
		
		
		public static const SUCCESS:uint = 1;
		public static const FAILURE:uint = 0;
		public static const WAIT:uint = 2;
		
		private var _channel:SoundChannel = new SoundChannel;
		
		private var _mpDou:MP_Dou = new MP_Dou;
		private var _mpRe:MP_Re = new MP_Re;
		private var _mpMi:MP_Mi = new MP_Mi;
		private var _mpFa:MP_Fa = new MP_Fa;
		private var _mpSou:MP_Sou = new MP_Sou;
		private var _mpLa:MP_La = new MP_La;
		private var _mpSi:MP_Si = new MP_Si;
		private var _mpHDou:MP_HDou = new MP_HDou;
		
		private var _mode:uint;
		private var _hasPressed:String;
		
		public function MusicProblem_Two() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event)
		{
			_mode = WAIT;
			_hasPressed = "";
			
			x = stage.stageWidth;
			y = stage.stageHeight / 2;
			
			douButton.addEventListener(MouseEvent.CLICK, onDouButtonClick);
			reButton.addEventListener(MouseEvent.CLICK, onReButtonClick);
			miButton.addEventListener(MouseEvent.CLICK, onMiButtonClick);
			faButton.addEventListener(MouseEvent.CLICK, onFaButtonClick);
			souButton.addEventListener(MouseEvent.CLICK, onSouButtonClick);
			laButton.addEventListener(MouseEvent.CLICK, onLaButtonClick);
			siButton.addEventListener(MouseEvent.CLICK, onSiButtonClick);
			hDouButton.addEventListener(MouseEvent.CLICK, onHDouButtonClick);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		private function onRemovedFromStage(event:Event)
		{
			douButton.removeEventListener(MouseEvent.CLICK, onDouButtonClick);
			reButton.removeEventListener(MouseEvent.CLICK, onReButtonClick);
			miButton.removeEventListener(MouseEvent.CLICK, onMiButtonClick);
			faButton.removeEventListener(MouseEvent.CLICK, onFaButtonClick);
			souButton.removeEventListener(MouseEvent.CLICK, onSouButtonClick);
			laButton.removeEventListener(MouseEvent.CLICK, onLaButtonClick);
			siButton.removeEventListener(MouseEvent.CLICK, onSiButtonClick);
			hDouButton.removeEventListener(MouseEvent.CLICK, onHDouButtonClick);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onDouButtonClick(event:MouseEvent)
		{
			_channel = _mpDou.play();
			_hasPressed += "1";
			if(_hasPressed.length == 19)
			{
				if(_hasPressed == "5345567875876565432")
				{
					_mode = SUCCESS;
				}
				else
				{
					_mode = FAILURE;
				}
			}
		}
		
		private function onReButtonClick(event:MouseEvent)
		{
			_channel = _mpRe.play();
			_hasPressed += "2";
			if(_hasPressed.length == 19)
			{
				if(_hasPressed == "5345567875876565432")
				{
					_mode = SUCCESS;
				}
				else
				{
					_mode = FAILURE;
				}
			}
		}
		
		private function onMiButtonClick(event:MouseEvent)
		{
			_channel = _mpMi.play();
			_hasPressed += "3";
			if(_hasPressed.length == 19)
			{
				if(_hasPressed == "5345567875876565432")
				{
					_mode = SUCCESS;
				}
				else
				{
					_mode = FAILURE;
				}
			}
		}
		
		private function onFaButtonClick(event:MouseEvent)
		{
			_channel = _mpFa.play();
			_hasPressed += "4";
			if(_hasPressed.length == 19)
			{
				if(_hasPressed == "5345567875876565432")
				{
					_mode = SUCCESS;
				}
				else
				{
					_mode = FAILURE;
				}
			}
		}
		
		private function onSouButtonClick(event:MouseEvent)
		{
			_channel = _mpSou.play();
			_hasPressed += "5";
			if(_hasPressed.length == 19)
			{
				if(_hasPressed == "5345567875876565432")
				{
					_mode = SUCCESS;
				}
				else
				{
					_mode = FAILURE;
				}
			}
		}
		
		private function onLaButtonClick(event:MouseEvent)
		{
			_channel = _mpLa.play();
			_hasPressed += "6";
			if(_hasPressed.length == 19)
			{
				if(_hasPressed == "5345567875876565432")
				{
					_mode = SUCCESS;
				}
				else
				{
					_mode = FAILURE;
				}
			}
		}
		private function onSiButtonClick(event:MouseEvent)
		{
			_channel = _mpSi.play();
			_hasPressed += "7";
			if(_hasPressed.length == 19)
			{
				if(_hasPressed == "5345567875876565432")
				{
					_mode = SUCCESS;
				}
				else
				{
					_mode = FAILURE;
				}
			}
		}
		private function onHDouButtonClick(event:MouseEvent)
		{
			_channel = _mpHDou.play();
			_hasPressed += "8";
			if(_hasPressed.length == 19)
			{
				if(_hasPressed == "5345567875876565432")
				{
					_mode = SUCCESS;
				}
				else
				{
					_mode = FAILURE;
				}
			}
		}
		
		public function get musicState():uint
		{
			return _mode;
		}
	}
	
}
