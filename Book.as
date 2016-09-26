package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class Book extends MovieClip
	{
		
		private var _player:Player;
		private var _currentPage:int;
		
		private const TOTALPAGE:int = 3;

		public function Book(player:Player)
		{
			_player = player;
			init();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(event:Event):void
		{
			x = y = 0;
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			exitButton.addEventListener(MouseEvent.CLICK, onExitButton);
			nextPage.addEventListener(MouseEvent.CLICK, onNextPage);
			lastPage.addEventListener(MouseEvent.CLICK, onLastPage);
		}
		private function onRemovedFromStage(event:Event):void
		{
			nextPage.removeEventListener(MouseEvent.CLICK, onNextPage);
			lastPage.removeEventListener(MouseEvent.CLICK, onLastPage);
			exitButton.removeEventListener(MouseEvent.CLICK, onExitButton);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			//removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
        
		private function onExitButton(event:Event)
		{
			MovieClip(parent).removeChild(this);
			_player.isReading = false;
			MagicTower.gameMode = "play";
		}

		private function init()
		{
			for (var i:int = 1; i <= Enemy.NUM_ENEMIES; ++i)
			{
				this.page["enemy" + i].visible = false;
				this.page["state" + i].visible = false;
				this.page["needBlood" + i].visible = false;
			}
			
			_currentPage = 1;
			lastPage.visible = false;
		}
		
		function onNextPage(event:Event)
		{
			if(_currentPage ==1)
			{
			    lastPage.visible = true;
			}
			if(_currentPage == TOTALPAGE - 1)
			{
				nextPage.visible = false;
			}
			if(_currentPage < TOTALPAGE)
			{
				page.y -= 590;
				++_currentPage;
			}
		}
		
		function onLastPage(event:Event)
		{
			
			if(_currentPage == TOTALPAGE)
			{
				nextPage.visible = true;
			}
			if(_currentPage == 2)
			{
				lastPage.visible = false;
			}
			if(_currentPage > 1)
			{
				page.y += 590;
				--_currentPage;
			}
		}
		
		function onKeyDown(event:KeyboardEvent)
		{
			if(event.keyCode == Keyboard.UP)
			{
				onLastPage(event);
			}
			if(event.keyCode == Keyboard.DOWN)
			{
				onNextPage(event);
			}
		}
		

	}
}