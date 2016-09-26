package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class SitCat extends MovieClip {
		
		public static var hasMeet:Boolean;
		
		protected var _enemyType:uint = Enemy.CAT;
		protected var _blood:int = 500;
		protected var _attack:uint;
		protected var _defence:uint;
		protected var _gold:uint;
		protected var _exp:uint;
		
		public function SitCat() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(event:Event)
		{
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		protected function onRemovedFromStage(event:Event)
		{
			if(_blood <= 0)
			{
				hasMeet = true;
			}
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
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
		public function set attack(a:uint)
		{
			_attack = a;
		}
		public function get defence():uint
		{
			return _defence;
		}
		public function set defence(d:uint)
		{
			_defence = d;
		}
		public function get gold():uint
		{
			return _gold;
		}
		public function set gold(g:uint)
		{
			_gold = g;
		}
		public function get EXP():uint
		{
			return _exp;
		}
		public function set EXP(e:uint)
		{
			_exp = e;
		}
		public function get hasMeeted():Boolean
		{
			return hasMeet;
		}
	}
	
}
