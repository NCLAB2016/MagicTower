package 
{

	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.ui.Keyboard;


	public class Dialog extends MovieClip
	{

		//记录动画是否放完
		private var _isShowOver:Boolean;
		private var _timer:Timer;
		private var _isWait:Boolean;
		private var i:int;
		private var _msg:String;

		public function Dialog()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(event:Event)
		{
			_isShowOver = false;
			_isWait = false;

			//注册点在元件右下角
			x = stage.stageWidth;
			y = stage.stageHeight;

			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			addEventListener(MouseEvent.CLICK, onMouseClick);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		private function onRemovedFromStage(event:Event)
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			removeEventListener(MouseEvent.CLICK, onMouseClick);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			//removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onKeyDown(event:KeyboardEvent)
		{
			if (event.keyCode == Keyboard.SPACE || event.keyCode == Keyboard.ENTER || event.keyCode == Keyboard.DOWN)
			{
				if (_isWait == true)
				{
					_isShowOver = true;
				}
				else
				{
					if (_timer != null)
					{
						_timer.stop();
						_timer.removeEventListener(TimerEvent.TIMER, onTimer);
						message.text = _msg;
						_timer = null;
						_isWait = true;
					}
				}
			}
		}

		private function onMouseClick(event:MouseEvent)
		{
			if (_isWait == true)
			{
				_isShowOver = true;
			}
			else
			{
				if (_timer != null)
				{
					_timer.stop();
					_timer.removeEventListener(TimerEvent.TIMER, onTimer);
					message.text = _msg;
					_timer = null;
					_isWait = true;
				}
			}

		}


		public function change(dialog:String = "")
		{
			_msg = dialog;

			message.text = "";
			_isShowOver = false;
			_isWait = false;

			if (_timer != null)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, onTimer);
				_timer = null;
			}

			_timer = new Timer(100);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
			_timer.start();

			i = 0;
		}

		function onTimer(event:TimerEvent)
		{
			message.appendText(_msg.charAt(i));
			++i;
			if (i == _msg.length)
			{
				//动画已经放完
				_isWait = true;
				//_isShowOver = true;
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, onTimer);
				_timer = null;
			}
		}




		public function get isShowOver():Boolean
		{
			return _isShowOver;
		}

	}

}