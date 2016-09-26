package 
{
	import flash.display.MovieClip;
	import flash.events.Event;

	public class Ticket extends MovieClip
	{
		private var _exist:Boolean;
		public function Ticket()
		{
			visible = false;
			_exist = false;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(event:Event):void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		private function onRemovedFromStage(event:Event):void
		{
			if (parent == null)
			{
				removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		//用于无尽之境
		public function notCheckExist()
		{
			_exist = true;
		}

		private function onEnterFrame(event:Event):void
		{
			if (! _exist)
			{
				MovieClip(parent).checkExist(this);
			}
			if (parent != null)
			{
				_exist = true;
				visible = true;
				MovieClip(parent).checkCollisionWithPlayer_Ticket(this);
			}
		}
	}
}