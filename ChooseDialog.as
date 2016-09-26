package 
{

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;


	public class ChooseDialog extends MovieClip
	{

		//记录动画是否放完
		private var _choose:uint;

		public function ChooseDialog(dialog:String = null)
		{
			message.text = dialog;
			_choose = 2;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(event:Event)
		{
			//注册点在元件右下角
			x = stage.stageWidth;
			y = stage.stageHeight / 2 + height / 2;
			
			yesButton.addEventListener(MouseEvent.CLICK, onYesButton);
			noButton.addEventListener(MouseEvent.CLICK, onNoButton);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		private function onRemovedFromStage(event:Event)
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			yesButton.removeEventListener(MouseEvent.CLICK, onYesButton);
			noButton.removeEventListener(MouseEvent.CLICK, onNoButton);
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		
		private function onYesButton(event:MouseEvent)
		{
			_choose = 1;
		}
		
		private function onNoButton(event:MouseEvent)
		{
			_choose = 0;
		}

		public function change(dialog:String = "")
		{
			message.text = dialog;
		}

        public function get choose():uint
		{
			return _choose;
		}
	}

}