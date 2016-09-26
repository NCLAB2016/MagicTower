package 
{

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	import aeon.animators.Tweener;
	import aeon.AnimationSequence;

	public class BottleShow extends MovieClip
	{


		private var _isShowOver:Boolean;

		public function BottleShow()
		{
			message.text = "";
			bottle.alpha = 0;
			title.alpha = 0;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(event:Event)
		{
			x =  0;
			y = 0;
			init();
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		private function onRemovedFromStage(event:Event)
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		private function init()
		{
			var timer:Timer = new Timer(200);
			var i:int = 0;
			var msg:String = "        相传灵图部族庶芝湍城主"+
			                 "单长浩早年痴迷于空间位移之术，曾"+
			 "孤身行至昆仑绝顶寻求神仙之道。众"+
			 "星之子有感于其诚心，摘星相赠。借助"+
			 "星的力量，欲往某处，只要事先标记，"+
			 "顷刻之间，便可到达。";

			_isShowOver = false;
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();

			new AnimationSequence([new Tweener(bottle,{alpha:0,y:-173},{alpha:1,y:320},1000),
								   new Tweener(title,{alpha:0},{alpha:1},1000)]).start();

			function onTimer(event:TimerEvent)
			{
				if (i < msg.length)
				{
					message.appendText(msg.charAt(i));
				}

				if (i >= msg.length + 5)
				{
					timer.stop();
					timer.removeEventListener(TimerEvent.TIMER, onTimer);
					timer = null;
					_isShowOver = true;
				}
				
				++i;
				//trace(message.text);
			}

		}

		public function get isShowOver():Boolean
		{
			return _isShowOver;
		}

	}

}