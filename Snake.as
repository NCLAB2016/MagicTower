package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;

	public class Snake extends MovieClip
	{
		public static var hasMeet:Boolean;

		public static var bloodPercent:uint;

		private var _enemyType:uint = Enemy.SNAKE;
		private var _blood:int = 2000;
		private var _attack:uint = 40;
		private var _defence:uint = 15;
		private var _gold:uint = 5;
		private var _exp:uint = 4;

		private var _exist:Boolean;


		public function Snake()
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
			if (_blood <= 0)
			{
				hasMeet = true;
				removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
			if (parent == null)
			{
				removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
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
				visible  = true;
				MovieClip(parent).checkCollisionWithPlayer_Enemy(this);

				if (bloodPercent <= 10 && bloodPercent >= 0)
				{
					label.textColor = 0x00FF00;
				}
				else if (bloodPercent <= 50)
				{
					label.textColor = 0xFF00FF;
				}
				else if (bloodPercent <= 100)
				{
					label.textColor = 0xFF0000;
				}
				else
				{
					label.textColor = 0x000000;
				}
			}
		}

		public function get enemyType():uint
		{
			return _enemyType;
		}
		public function get blood():int
		{
			return _blood;
		}
		public function set blood(b:int)
		{
			_blood = b;
		}
		public function get attack():uint
		{
			return _attack;
		}
		public function get defence():uint
		{
			return _defence;
		}
		public function get gold():uint
		{
			return _gold;
		}
		public function get EXP():uint
		{
			return _exp;
		}
		public function get hasMeeted():Boolean
		{
			return hasMeet;
		}
		public function get needPercent():uint
		{
			return bloodPercent;
		}
		public function set needPercent(np:uint)
		{
			bloodPercent = np;
		}
	}
}