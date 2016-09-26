package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;

	public class Rabbit extends MovieClip
	{
		//用于更新图鉴
		public static var hasMeet:Boolean;

		//耗血占角色血量百分比 用于怪物名称颜色更新
		public static var bloodPercent:uint;

		private var _enemyType:uint = Enemy.RABBIT;
		private var _blood:int = 700;
		private var _attack:uint = 25;
		private var _defence:uint = 8;
		private var _gold:uint = 3;
		private var _exp:uint = 4;

		private var _exist:Boolean;


		public function Rabbit()
		{
			//trace("small enchanter constructed");
			visible = false;
			_exist = false;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(event:Event):void
		{
			//trace("small enchanter be added to stage");
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		private function onRemovedFromStage(event:Event):void
		{
			//trace("small enchanter has been removed");
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
				//trace("parent check exist");
				MovieClip(parent).checkExist(this);
			}
			if (parent != null)
			{
				_exist = true;
				visible  = true;
				MovieClip(parent).checkCollisionWithPlayer_Enemy(this);

				if (bloodPercent <= 10 && bloodPercent >= 0)
				{
					//绿色
					label.textColor = 0x00FF00;
				}
				else if (bloodPercent <= 50)
				{
					//紫色
					label.textColor = 0xFF00FF;
				}
				else if (bloodPercent <= 100)
				{
					//红色
					label.textColor = 0xFF0000;
				}
				else
				{
					//黑色
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