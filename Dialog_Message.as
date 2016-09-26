package 
{

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class Dialog_Message extends MovieClip
	{


		private var _timer:Timer;
		private var _lastGameMode:String;

		public function Dialog_Message(msg:String = "")
		{
			message.text = msg;

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(event:Event):void
		{
			x = stage.stageWidth / 2;
			y = stage.stageHeight / 2;

			_timer = new Timer(1000,1);
			_timer.start();
			_lastGameMode = MagicTower.gameMode;
			MagicTower.gameMode = "showdialog";
			_timer.addEventListener(TimerEvent.TIMER, onTimer);

			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}

		private function onKeyDown(event:KeyboardEvent)
		{
			if (event.keyCode == Keyboard.SPACE || event.keyCode == Keyboard.ENTER || event.keyCode == Keyboard.DOWN)
			{
				if (_timer != null)
				{
					_timer.stop();
					_timer.removeEventListener(TimerEvent.TIMER, onTimer);
					_timer = null;
					parent.removeChild(this);
				}
			}
		}

		private function onMouseClick(event:MouseEvent)
		{
			if (_timer != null)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, onTimer);
				_timer = null;
			    parent.removeChild(this);
			}
		}

		private function onTimer(event:TimerEvent)
		{
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			_timer = null;
			parent.removeChild(this);
		}

		private function onRemovedFromStage(event:Event):void
		{
			MagicTower.gameMode = _lastGameMode;
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			removeEventListener(MouseEvent.CLICK, onMouseClick);
			//removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}



		public function change(msg:String = ""):void
		{
			message.text = msg;
			
		}

	}

}