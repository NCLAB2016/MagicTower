package 
{
	import flash.display.MovieClip;
	import flash.events.Event;

	public class House extends MovieClip
	{
		
		public function House()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(event:Event):void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		private function onRemovedFromStage(event:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		private function onEnterFrame(event:Event):void
		{
				MovieClip(parent).checkCollisionWithPlayer_Shop(this);
		}
	}
}