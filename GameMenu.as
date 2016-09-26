package 
{


	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.fscommand;


	public class GameMenu extends MovieClip
	{

		public function GameMenu()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(event:Event)
		{
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			readButton.addEventListener(MouseEvent.CLICK, onReadClick);
			saveButton.addEventListener(MouseEvent.CLICK, onSaveClick);
			quitButton.addEventListener(MouseEvent.CLICK, onQuitClick);
		}

		private function onRemovedFromStage(event:Event)
		{
			readButton.addEventListener(MouseEvent.CLICK, onReadClick);
			saveButton.removeEventListener(MouseEvent.CLICK, onSaveClick);
			quitButton.removeEventListener(MouseEvent.CLICK, onQuitClick);
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}


		private function onQuitClick(event:MouseEvent)
		{
			fscommand("quit");
		}


		private function onSaveClick(event:MouseEvent)
		{
			MagicTower.gameMode = "selectsave";
		}

		private function onReadClick(event:MouseEvent)
		{
			MagicTower.gameMode = "selectload";
		}


	}

}