package 
{

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;


	public class BottleChoose extends MovieClip
	{
		
		public static const NOTCHOOSE:uint = 0;
		public static const TRANSMIT:uint = 1;
		public static const REMARK:uint = 2;
		public static const CANCEL:uint = 3;

		//记录动画是否放完
		private var _choose:uint;
		private var _markFloor:int;

		public function BottleChoose(markFloor:int = -1)
		{
            _markFloor = markFloor;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(event:Event)
		{
			//注册点在元件右下角
			x = stage.stageWidth;
			y = stage.stageHeight / 2 + msg.height / 2;
			_choose = NOTCHOOSE;
			
			if(_markFloor == -1)
			{
				position.text = "无";
			}
			else
			{
				position.text = "第" + _markFloor +"层";
			}
			transmitButton.addEventListener(MouseEvent.CLICK, onTransmitButton);
			remarkButton.addEventListener(MouseEvent.CLICK, onRemarkButton);
			cancelButton.addEventListener(MouseEvent.CLICK, onCancelButton);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		private function onRemovedFromStage(event:Event)
		{
			transmitButton.removeEventListener(MouseEvent.CLICK, onTransmitButton);
			remarkButton.removeEventListener(MouseEvent.CLICK, onRemarkButton);
			cancelButton.removeEventListener(MouseEvent.CLICK, onCancelButton);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		
        private function onTransmitButton(event:Event)
		{
			_choose = TRANSMIT;
		}
		
		private function onRemarkButton(event:Event)
		{
			_choose = REMARK;
		}
		
		private function onCancelButton(event:Event)
		{
			_choose = CANCEL;
		}

        public function get choose():uint
		{
			return _choose;
		}
		
		public function set choose(c:uint)
		{
		    _choose = c;
		}
	}

}