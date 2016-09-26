package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class CatMove extends MovieClip {
		
		
		protected var _v:int;
		protected var _stageWidth:int;
		protected var _halfWidth:int;
		
		public static var hasMeet:Boolean;
		
		protected var _enemyType:uint = Enemy.CAT;
		protected var _blood:int = 500;
		protected var _attack:uint;
		protected var _defence:uint;
		protected var _gold:uint;
		protected var _exp:uint;
		
		public function CatMove() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(event:Event)
		{
			init();
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onRemovedFromStage(event:Event)
		{
			if(_blood <= 0)
			{
				hasMeet = true;
			}
		    removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		protected function init()
		{
			_stageWidth = stage.stageWidth;
			_halfWidth = width / 2;
			x = _stageWidth - _halfWidth;
			y = height / 2;
			_v = -3;
		}
		
		public function stopMove()
		{
			stop();
			_v = 0;
		    removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event)
		{
			x += _v;
			if(x <= 200 + _halfWidth)
			{
				x = 200 + _halfWidth;
				scaleX = -scaleX;
				_v = -_v;
			}
			else if(x + _halfWidth >= _stageWidth)
			{
				x = _stageWidth - _halfWidth;
				scaleX = -scaleX;
				_v = - _v;
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
