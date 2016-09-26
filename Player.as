package 
{

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;

	public class Player extends MovieClip
	{


		//人物属性
		private var _level:uint;
		private var _blood:int;
		private var _attack:uint;
		private var _defence:uint;
		private var _speed:uint;
		private var _gold:uint;
		private var _exp:uint;

		//升级经验
		private var _levelUpExp:uint;

		//上一级升级经验
		private var _lastLevelUpExp:uint;

		//钥匙数量
		private var _numRedKeys:uint;
		private var _numBlueKeys:uint;
		private var _numYellowKeys:uint;

		//是否有图鉴
		private var _hasBook:Boolean;
		
		//是否有星之祝福
		private var _hasBottle:Boolean;
		
		//技能
		private var _hasYiBingSkill:Boolean;
		private var _hasLiYongSkill:Boolean;
		private var _hasLingTuSkill:Boolean;
		
		private var _yiBingSkillAttack:uint;
		private var _liYongSkillAttack:uint;
		private var _lingTuSkillAttack:uint;
		
		//通行券
		private var _numTickets:uint;
		
		private var _numSkillStones:uint;

		//怪物图鉴
		private var _book:Book;
		//图鉴是否正打开
		private var _isReading:Boolean;

		//怪物属性
		private var _enemyArray:Array;

        //记录已遇到之怪
		private var _enemyHasMeetVector:Vector.<Boolean>;
		
		//记录是否升级已刷新状态
		private var _isLevelUp:Boolean;

		//记录是否改变状态已刷新图鉴
		private var _isChanging:Boolean;

        //记录是否为读取数据
		private var _isLoad:Boolean;
		//记录储存数据中player坐标
		private var _saveX:int;
		private var _saveY:int;
		
		private var _vx:int;
		private var _vy:int;
		private var _stageWidth:uint;
		private var _stageHeight:uint;
		private var _halfWidth:uint;
		private var _halfHeight:uint;
		private const PLAYERSTATEWIDTH:uint = 200;
		
		//用于鼠标控制
		private var _targetX:int;
		private var _targetY:int;
		private var _isArrived:Boolean;
		
		//记录是否破解第六,七层音乐谜题
		private var _hasSolvedMusic:Boolean;
		private var _hasSolvedMusicTwo:Boolean;
		
		//记录是否拿走第七层翅膀
		private var _hasSwing:Boolean;
		
		//记录是否遇到过柴郡猫
		private var _hasMeetCheshireCat:Boolean;

		public function Player()
		{
			init();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(event:Event):void
		{
			_stageWidth = stage.stageWidth;
			_stageHeight = stage.stageHeight;
			
			_targetX = x;
			_targetY = y;
			
			if(MovieClip(parent).playerState)
			{
				MovieClip(parent).playerState.book.addEventListener(MouseEvent.CLICK, onBook);
			}
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseClick);
		}
		
		private function onRemovedFromStage(event:Event)
		{
			MovieClip(parent).playerState.book.removeEventListener(MouseEvent.CLICK, onBook);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			stage.removeEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function onMouseClick(event:MouseEvent)
		{
			if(MagicTower.gameMode == "play" && event.stageX > PLAYERSTATEWIDTH)
			{
				_targetX = event.stageX;
				_targetY = event.stageY;
				_isArrived = false;
			}
		}
		
		private function onBook(event:MouseEvent)
		{
		    openBook();
		}

		private function init():void
		{
			_vx = 0;
			_vy = 0;


			//角色初始属性
			_level = 1;
			_blood = 1000;
			_attack = 10;
			_defence = 10;
			_speed = 3;
			_gold = 0;
			_exp = 0;
			_levelUpExp = _level * (_level + 1) * 5;
			_lastLevelUpExp = 0;

			_numYellowKeys = 0;
			_numRedKeys = 0;
			_numBlueKeys = 0;
			_hasBook = false;
			_hasBottle = false;
//            //debug
//			_hasBottle = true;
			
			_halfHeight = height / 2;
			_halfWidth = width / 2;

			//怪物图鉴
			_book = new Book(this);
			_isReading = false;

			//怪物数组
			_enemyArray = new Array();
			_enemyArray = [new SmallGhost, new BigGhost, new SmallEnchanter, new Rabbit, new Scorpion, new BaiZe,
						   new Snake, new Firefly, new FlyPig, new Dog, new CheshireCat];
			
			_enemyHasMeetVector = new Vector.<Boolean>(Enemy.NUM_ENEMIES+1);

			_isLevelUp = false;

			_isChanging = false;
            
			_isLoad = false;
			_isArrived = true;
			
			_hasSolvedMusic = false;
			_hasSolvedMusicTwo = false;
			_numSkillStones = 0;
			_numTickets = 0;
			
			_hasMeetCheshireCat = false;
			
			_hasSwing = false;
		}
		
		//读取进度时用于刷新属性
		public function refreshLevelUpExp(){
			_levelUpExp =  _level * (_level + 1) * 5;
			_lastLevelUpExp = (_level-1) * _level * 5;
		}
		

		

		public function levelUp():void
		{

			//属性提升
			_blood +=  (_level * 10);
			_attack +=  _level;
			_defence +=  _level;

			//等级及升级经验更新
			++_level;
			_lastLevelUpExp = _levelUpExp;
			_levelUpExp = _level * (_level + 1) * 5;
		}

		private function onKeyDown(event:KeyboardEvent):void
		{
			_isArrived = true;
			if (event.keyCode == Keyboard.UP)
			{
				_vy =  -  _speed;
			}
			else if (event.keyCode == Keyboard.DOWN)
			{
				_vy = _speed;
			}
			else if (event.keyCode == Keyboard.LEFT)
			{
				_vx =  -  _speed;
			}
			else if (event.keyCode == Keyboard.RIGHT)
			{
				_vx = _speed;
			}
			else if (event.keyCode == Keyboard.SPACE)
			{
				openBook();
			}
//			//debug
//			else if (event.keyCode == Keyboard.S)
//			{
//				_exp+=100;
//				++_numRedKeys;
//				++_numBlueKeys;
//				++_numYellowKeys;
//				_speed = 10;
//				_numSkillStones += 100;
//				++_numTickets;
//			}
//			else if(event.keyCode == Keyboard.W){
//				//--_attack;
//				//--_defence;
//				_attack = 1;
//				_defence = 1;
//				_blood = 1;
//				_speed = 5;
//				_numYellowKeys = _numRedKeys = 0;
//			}

		}
		
		
		private function openBook():void
		{
			if(MagicTower.gameMode == "play" || MagicTower.gameMode == "reading")
			{
				if (_hasBook && !_isReading)
				{
					MovieClip(parent).addChild(_book);
					MovieClip(parent).setChildIndex(_book, MovieClip(parent).numChildren - 1);
					_isReading = true;
					MagicTower.gameMode = "reading";
				}
				else if (_hasBook && _isReading)
				{
					MovieClip(parent).removeChild(_book);
					_isReading = false;
					MagicTower.gameMode = "play";
				}
			}
		}

		private function onKeyUp(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.UP || event.keyCode == Keyboard.DOWN)
			{
				_vy = 0;
				stop();
			}
			else if (event.keyCode == Keyboard.LEFT || event.keyCode == Keyboard.RIGHT)
			{
				_vx = 0;
				stop();
			}
		}

		//怪物图鉴中增加怪物
		public function addEnemyToBook(enemyType:uint):void
		{
			_book.page["enemy" + enemyType].visible = true;
			_book.page["state" + enemyType].visible = true;
			_book.page["needBlood" + enemyType].visible = true;
			_enemyHasMeetVector[enemyType] = true;
		}


		//刷新图鉴中相应怪物耗血量 以及计算耗血百分比
		private function updateBook()
		{
			for (var i:int = 0; i < _enemyArray.length; ++i)
			{
				//如果怪物实力太强
				if (_attack - _enemyArray[i].defence <= 0)
				{
					_book.page["needBlood" + (i + 1)].text = "正无穷";
					_enemyArray[i].needPercent = 101; //不可战胜
				}
				//如果角色实力太强
			    else if (_enemyArray[i].attack - _defence <= 0)
			    {
				    _book.page["needBlood" + (i + 1)].text = "0";
					_enemyArray[i].needPercent = 0;  //轻而易举
			    }
				else
			    {
				    var nb:int = Math.ceil((_enemyArray[i].blood / (_attack - _enemyArray[i].defence))
				                           * (_enemyArray[i].attack - _defence));
				    if (nb > 999999)
				    {
					    _book.page["needBlood" + (i + 1)].text = "正无穷";
						_enemyArray[i].needPercent = 101; //不可战胜
			    	}
			    	else
			    	{
					    _book.page["needBlood" + (i + 1)].text = nb;
						if(_blood > 0 ){
						    _enemyArray[i].needPercent = Math.ceil((nb*100)/_blood); //百分比
						}
				    }
			    }
			}//End For
	    }

		private function onEnterFrame(event:Event):void
		{
			
			if(MagicTower.gameMode != "play")
			{
				_vx = 0 ;
				_vy = 0;
				_isArrived = true;
			}

			//鼠标控制
			if(!_isArrived && MagicTower.gameMode == "play")
			{
				if(Math.abs(x - _targetX) > _speed * 2)
				{
					if(x < _targetX)
					{
						_vx = _speed;
					}
					else if(x > _targetX)
					{
						_vx = -_speed;
					}
				}
				else
				{
					_vx = 0;
				}
				if(Math.abs(y - _targetY) > _speed * 2)
				{
					if(y < _targetY)
					{
						_vy = _speed;
					}
					else if(y > _targetY)
					{
						_vy = -_speed;
					}
				}
				else 
				{
					_vy = 0;
				}
				if(!_vx && !_vy)
				{
					_isArrived = true;
				}
			}
			
			
			
			//在play状态才可以行动
			if (MagicTower.gameMode == "play")
			{
				x +=  _vx;
				y +=  _vy;
			}

			if (x + _halfWidth > _stageWidth)
			{
				x = _stageWidth - _halfWidth;
			}
			if (x - _halfWidth < PLAYERSTATEWIDTH)
			{
				x = _halfWidth + PLAYERSTATEWIDTH;
			}
			if (y + _halfHeight > _stageHeight)
			{
				y = _stageHeight - _halfHeight;
			}
			if (y - _halfHeight < 0)
			{
				y = _halfHeight;
			}
			if (_exp >= _levelUpExp)
			{
				levelUp();
				_isLevelUp = true;
			}
			if (_isChanging)
			{
				updateBook();
				
				_yiBingSkillAttack = uint(_attack * 1.2);
				_liYongSkillAttack = uint(_attack * 1.5);
				_lingTuSkillAttack = _attack * 2;
				
				_isChanging = false;
			}
			
		}


		//vx
		public function get vx():int
		{
			return _vx;
		}
		public function set vx(l:int):void
		{
			_vx = l;
		}

		//vy
		public function get vy():int
		{
			return _vy;
		}
		public function set vy(l:int):void
		{
			_vy = l;
		}

		//Level
		public function get level():uint
		{
			return _level;
		}
		public function set level(l:uint):void
		{
			_level = l;
		}

		//Blood
		public function get blood():int
		{
			return _blood;
		}
		public function set blood(b:int):void
		{
			_blood = b;
		}

		//Attack
		public function get attack():uint
		{
			return _attack;
		}
		public function set attack(a:uint):void
		{
			_attack = a;
		}

		//Defence
		public function get defence():uint
		{
			return _defence;
		}
		public function set defence(d:uint):void
		{
			_defence = d;
		}

		//Speed
		public function get speed():uint
		{
			return _speed;
		}
		public function set speed(v:uint):void
		{
			_speed = v;
		}

		//Gold
		public function get gold():uint
		{
			return _gold;
		}
		public function set gold(g:uint):void
		{
			_gold = g;
		}

		//EXP
		public function get EXP():uint
		{
			return _exp;
		}
		public function set EXP(e:uint):void
		{
			_exp = e;
		}

		//Number of Yellow Key
		public function get numYellowKeys():uint
		{
			return _numYellowKeys;
		}
		public function set numYellowKeys(e:uint):void
		{
			_numYellowKeys = e;
		}

		//Number of Red Key
		public function get numRedKeys():uint
		{
			return _numRedKeys;
		}
		public function set numRedKeys(e:uint):void
		{
			_numRedKeys = e;
		}

		//Number of Blue Key
		public function get numBlueKeys():uint
		{
			return _numBlueKeys;
		}
		public function set numBlueKeys(e:uint):void
		{
			_numBlueKeys = e;
		}

		//Has Book or Not
		public function get hasBook():Boolean
		{
			return _hasBook;
		}
		public function set hasBook(hasBook:Boolean):void
		{
			_hasBook = hasBook;
		}
		
		public function get hasBottle():Boolean
		{
			return _hasBottle;
		}
		public function set hasBottle(h:Boolean)
		{
			_hasBottle = h;
		}

		//Level Up EXP
		public function get levelUpEXP():uint
		{
			return _levelUpExp;
		}

		//Last Level Up EXP
		public function get lastLevelUpEXP():uint
		{
			return _lastLevelUpExp;
		}

		//Is Level Up
		public function get isLevelUp():Boolean
		{
			return _isLevelUp;
		}
		public function set isLevelUp(lu:Boolean)
		{
			_isLevelUp = lu;
		}

		//Is changed
		public function set isChanged(b:Boolean)
		{
			_isChanging = b;
		}
		
		public function get enemyHasMeetVector():Vector.<Boolean>
		{
			return _enemyHasMeetVector;
		}
		
		public function get isLoad():Boolean
		{
			return _isLoad;
		}
		public function set isLoad(l:Boolean)
		{
			_isLoad = l;
		}
		
		public function get saveX():int
		{
			return _saveX;
		}
		public function get saveY():int
		{
			return _saveY;
		}
        public function set saveX(s:int)
		{
			_saveX = s;
		}
        public function set saveY(s:int)
		{
			_saveY = s;
		}
		public function get hasYiBingSkill():Boolean
		{
			return _hasYiBingSkill;
		}
		public function set hasYiBingSkill(h:Boolean)
		{
			_hasYiBingSkill = h;
		}
		
		public function get hasLiYongSkill():Boolean
		{
			return _hasLiYongSkill;
		}
		public function set hasLiYongSkill(l:Boolean)
		{
			_hasLiYongSkill = l;
		}
		
		public function get hasLingTuSkill():Boolean
		{
			return _hasLingTuSkill;
		}
		public function set hasLingTuSkill(t:Boolean)
		{
			_hasLingTuSkill = t;
		}
		public function get yiBingSkillAttack():uint
		{
			return _yiBingSkillAttack;
		}
		public function get liYongSkillAttack():uint
		{
			return _liYongSkillAttack;
		}
		public function get lingTuSkillAttack():uint
		{
			return _lingTuSkillAttack;
		}
		public function get numSkillStones():uint
		{
			return _numSkillStones;
		}
		public function set numSkillStones(n:uint)
		{
			_numSkillStones = n;
		}
		public function get numTickets():uint
		{
			return _numTickets;
		}
		public function set numTickets(n:uint)
		{
			_numTickets = n;
		}
		
		public function get isReading():Boolean
		{
			return _isReading;
		}
		public function set isReading(b:Boolean)
		{
			_isReading = b;
		}
		
		public function get hasSolvedMusic():Boolean
		{
			return _hasSolvedMusic;
		}
		
		public function set hasSolvedMusic(h:Boolean)
		{
			_hasSolvedMusic = h;
		}
		
		public function get hasSolvedMusicTwo():Boolean
		{
			return _hasSolvedMusicTwo;
		}
		
		public function set hasSolvedMusicTwo(h:Boolean)
		{
			_hasSolvedMusicTwo = h;
		}
		
		public function get hasSwing():Boolean
		{
			return _hasSwing;
		}
		
		public function set hasSwing(h:Boolean)
		{
			_hasSwing = h;
		}
		
		public function get hasMeetCheshireCat():Boolean
		{
			return _hasMeetCheshireCat;
		}
	    public function set hasMeetCheshireCat(h:Boolean)
		{
			_hasMeetCheshireCat = h;
		}

	}

}