package 
{

	import flash.display.MovieClip;
	import flash.events.Event;
	import aeon.AnimationSequence;
	import aeon.events.AnimationEvent;
	import aeon.animators.Tweener;


	public class Book_Show extends MovieClip
	{

		private var _isOver:Boolean;


		public function Book_Show()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(event:Event)
		{
			init();
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		private function onRemovedFromStage(event:Event)
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}


		private function init():void
		{

			_isOver = false;
			var animation:AnimationSequence = 
			new AnimationSequence(
			    [
			     new Tweener(msg0,{alpha:0},{alpha:1},2000),
			 new Tweener(msg1,{alpha:0},{alpha:1},2000),
			 new Tweener(msg2,{alpha:0},{alpha:1},2000),
			 new Tweener(msg3,{alpha:0},{alpha:1},2000),
			 new Tweener(msg4,{alpha:0},{alpha:1},2000),
			 new Tweener(msg5,{alpha:0},{alpha:1},2000),
			 new Tweener(msg6,{alpha:0},{alpha:1},2000),
			 new Tweener(msg7,{alpha:0},{alpha:1},2000),
			 new Tweener(msg8,{alpha:0},{alpha:1},2000),
			 new Tweener(msg9,{alpha:0},{alpha:1},2000),
			 
			 ]  
			);

			animation.addEventListener(AnimationEvent.END, onEnd);
			animation.start();
			function onEnd(event:Event)
			{
				animation.removeEventListener(AnimationEvent.END, onEnd);
				animation = null;
				_isOver = true;
			}
		}




		public function get isOver():Boolean
		{
			return _isOver;
		}
	}

}