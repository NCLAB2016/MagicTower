package 
{

	import flash.display.MovieClip;
	import flash.media.SoundChannel;
	import flash.events.Event;
	import flash.media.Sound;
	import fl.transitions.easing.*;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	import aeon.animators.Tweener;
	import aeon.AnimationComposite;
	import aeon.AnimationSequence;
	import aeon.events.AnimationEvent;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;


	public class FloorNine extends MovieClip
	{

		private var _player:Player;
		private var _playerState:State;
		private var _channel:SoundChannel;
		private var _chimes:Chimes;
		private var _messageDialog:Dialog_Message;
		private var _type:Boolean;
		private var _isUp:Boolean;
		private var _isDown:Boolean;
		private var _playerHalfWidth:uint;
		private var _playerHalfHeight:uint;
		private var _stateExpMeterTotalWidth:uint;
		private var _stageHalfWidth;
		private var _stageHalfHeight;
		private var _isGameOver:Boolean;
		private var _fightPage:FightPage;
		private var _catPoints:Vector.<Point>;
		private var _point:Point;
		private var _index:int;
		private var _hasCollision:Boolean;
        private var _isFading:Boolean;
		private var _isWin:Boolean;
		
		public function FloorNine(player:Player,playerState:State)
		{
			cheshireCatShow.visible = false;
			_player = player;
			_playerState = playerState;
			_catPoints = new Vector.<Point>(8,true);
			_catPoints[0] = new Point(270,80);
			_catPoints[1] = new Point(500,80);
			_catPoints[2] = new Point(705,80);
			_catPoints[3] = new Point(270,300);
			_catPoints[4] = new Point(705,300);
			_catPoints[5] = new Point(270,520);
			_catPoints[6] = new Point(500,520);
			_catPoints[7] = new Point(705,520);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function selectPoint():Point
		{
			++_index;
			if(_index >= 8)
			{
				_index = 0;
			}
			for(var i = _index; i< 8;++i)
			{
		        if(Point.distance(new Point(_player.x,_player.y),_catPoints[i]) >= 300) 
			    {
					++_index;
					return _catPoints[i];
			    }
			}
			for(i = 0; i < _index;++i)
			{
		        if(Point.distance(new Point(_player.x,_player.y),_catPoints[i]) >= 300) 
			    {
					++_index;
					return _catPoints[i];
			    }
			}
			
			return null;
		}
		

		private function onAddedToStage(event:Event):void
		{
			x = y = 0;
			init();
			_stageHalfWidth = stage.stageWidth / 2;
			_stageHalfHeight = stage.stageHeight / 2;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onRemovedFromStage(event:Event):void
		{
			destory();
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		private function init()
		{
			_index  = 0;
			_channel = new SoundChannel  ;
			_chimes = new Chimes  ;
			_messageDialog = new Dialog_Message  ;
			addChildAt(_playerState, numChildren - 1);
			_playerState.x = _playerState.y = 0;
			_playerState.floor.text = "第八层";
			
			addChild(_player);
			stage.focus = this;
			
			if (_type == Floor.UP_STAIRS)
			{
				_player.x = 500;
				_player.y = 250;
			}
			
			//impossible
			else if (_type == Floor.DOWN_STAIRS)
			{
				_player.x = 725;
				_player.y = 25;
			}

			if (_player.isLoad)
			{
				_player.x = _player.saveX;
				_player.y = _player.saveY;
				_player.isLoad = false;
			}

			_playerHalfWidth = _player.body.width / 2;
			_playerHalfHeight = _player.body.height / 2;

			_stateExpMeterTotalWidth = _playerState.stateEXP.meter.width;

			refreshState();

			_isUp = false;
			_isDown = false;
			
            if(_player.hasMeetCheshireCat)
			{
				
				if(cheshireCat)
				{
					if(contains(cheshireCat))
					{
					    removeChild(cheshireCat);
					}
					cheshireCat = null;
				}
				if(cheshireCatShow)
				{
					if(contains(cheshireCatShow))
					{
					    removeChild(cheshireCatShow);
					}
					cheshireCatShow = null;
				}
			}
			else
			{
				cheshireCatShow.visible = true;
				setChildIndex(cheshireCatShow, numChildren - 1);
				new Tweener(cheshireCatShow,{alpha:1},{alpha:0},4000).start();
			}
			_hasCollision = false;
			_isFading = false;
			_isGameOver = false;
			_isWin = false;
		}

		private function destory()
		{
			_channel = null;
			_chimes = null;
			_messageDialog = null;
		}

		private function onEnterFrame(event:Event)
		{
			
			if (wall.hitTestPoint(_player.x - _playerHalfWidth,_player.y - _playerHalfHeight,true))
			{
				_player.x -=  _player.vx;
				_player.y -=  _player.vy;
			}
			if (wall.hitTestPoint(_player.x - _playerHalfWidth,_player.y + _playerHalfHeight,true))
			{
				_player.x -=  _player.vx;
				_player.y -=  _player.vy;
			}
			if (wall.hitTestPoint(_player.x + _playerHalfWidth,_player.y - _playerHalfHeight,true))
			{
				_player.x -=  _player.vx;
				_player.y -=  _player.vy;
			}
			if (wall.hitTestPoint(_player.x + _playerHalfWidth,_player.y + _playerHalfHeight,true))
			{
				_player.x -=  _player.vx;
				_player.y -=  _player.vy;
			}
			

			if (_player.body.hitTestObject(downStairs))
			{
				_isDown = true;
			}

			if (_player.isLevelUp)
			{
				refreshProperty();
				refreshEXP();
				_player.isLevelUp = false;
				_messageDialog.change("恭喜你升了一级！");
				addChild(_messageDialog);
			}
			
			if(cheshireCat)
			{
				if(_player.hitTestObject(cheshireCat) && !_hasCollision && !_isFading)
				{
					_point = selectPoint();
					if(_point)
					{
						 var tween:Tween = new Tween(cheshireCat,"alpha",None.easeNone,1,0,10);
						 tween.addEventListener(TweenEvent.MOTION_FINISH, onMotionFinish);
						 tween.start();
						 _isFading = true;
						 function onMotionFinish(event:Event)
						 {
							 tween.removeEventListener(TweenEvent.MOTION_FINISH, onMotionFinish);
							 tween = null;
							 if(!_hasCollision)
							 {
						         cheshireCat.x = _point.x;
						         cheshireCat.y = _point.y;
						         cheshireCat.visible = true;
						         cheshireCat.alpha = 0;
						         new Tweener(cheshireCat,{alpha:0},{alpha:1},500).start();
							 }
							  _isFading = false;
						 }
					}
				}
			}
			
			if(_isWin && MagicTower.gameMode == "play")
			{
				MagicTower.gameMode = "end";
		        var end:End = new End;
				addChild(end);
				end.x = 400;
				end.y = 830;
				var tweener:Tweener = new Tweener(end,{y:830},{y:-487},20000);
				tweener.addEventListener(AnimationEvent.END, onEnd);
				tweener.start();
				
			    function onEnd(event:Event)
				{
					tweener.removeEventListener(AnimationEvent.END, onEnd);
					tweener = null;
					end.addEventListener(MouseEvent.CLICK, onMouseClick);
				}
				function onMouseClick(event:Event)
				{
					removeChild(end);
					end = null;
					_isWin = false;
					MagicTower.gameMode = "play";
					_messageDialog.change("恭喜你学到新的技能！你仍可以继续游戏。");
					_player.hasLingTuSkill = true;
					addChild(_messageDialog);
				}
			}

		}

		public function checkCollisionWithPlayer_Enemy(enemy:MovieClip)
		{
			
			if (_player != null)
			{
				if (_player.body.hitTestObject(enemy.head))
				{
					_hasCollision = true;
					if(MagicTower.gameMode != "fight" && MagicTower.gameMode != "fightover"
					        && MagicTower.gameMode != "showdialog" && !_isGameOver)
					{
						_fightPage = new FightPage(_player,enemy);
						addChild(_fightPage);
						MagicTower.gameMode = "fight";
					}
					if(MagicTower.gameMode == "fightover")
					{
						removeChild(_fightPage);
						_fightPage = null;
						MagicTower.gameMode = "play";
						if (_player.blood <= 0)
						{
							  removeChild(enemy);
							  _isGameOver = true;
						}
						else if (enemy.blood <= 0)
						{
							_player.gold +=  enemy.gold;
							_player.EXP +=  enemy.EXP;
							refreshProperty();
							refreshEXP();
							_messageDialog.change("战斗胜利！ 得到金币：" + enemy.gold + " 经验：" + enemy.EXP);
							addChild(_messageDialog);
							if(!enemy.hasMeeted)
							{
						  	  _player.addEnemyToBook(enemy.enemyType);
							}
							_player.hasMeetCheshireCat = true;
						    removeChild(enemy);
							enemy = null;
							_isWin = true;
							stage.focus = _player;
					    }
					}//fightover
				}//hit test
			}//player != null
		}// End check Collision


		private function refreshState():void
		{
			refreshProperty();
			refreshKey();
			refreshEXP();
			refreshHasBook();
			refreshTickets();
		}
		        		//刷新通行券
		public function refreshTickets():void
		{
			_playerState.numTickets.text = String(_player.numTickets);
		}
		

		private function refreshKey():void
		{
			with (_playerState)
			{
				numYellow.text = _player.numYellowKeys;
				numRed.text = _player.numRedKeys;
				numBlue.text = _player.numBlueKeys;
			}
		}

		public function refreshProperty():void
		{
			with (_playerState)
			{
				level.text = _player.level;
				blood.text = _player.blood;
				attack.text = _player.attack;
				defence.text = _player.defence;
				speed.text = _player.speed * 100;
				gold.text = _player.gold;
			}
			_player.isChanged = true;
		}

		private function refreshEXP():void
		{
			var playerEXPPercent:uint = (_player.EXP - _player.lastLevelUpEXP) * 100 
			            / (_player.levelUpEXP - _player.lastLevelUpEXP);
			with (_playerState)
			{
				exp.text = _player.EXP;
				stateEXP.percent.text = playerEXPPercent + "%";
				stateEXP.meter.width = _stateExpMeterTotalWidth * playerEXPPercent / 100;
			}
			_player.isChanged = true;
		}

		public function refreshHasBook():void
		{
			with (_playerState)
			{
				if (_player.hasBook)
				{
					book.visible = true;
				}
				else
				{
					book.visible = false;
				}
				if(_player.hasBottle)
				{
					bottle.visible = true;
				}
				else
				{
					bottle.visible = false;
				}
			}
		}

		public function set stairType(t:Boolean):void
		{
			_type = t;
		}

		public function get isUp():Boolean
		{
			return _isUp;
		}
		public function get isDown():Boolean
		{
			return _isDown;
		}

		//标记游戏失败变量访问器
		public function get isGameOver():Boolean
		{
			return _isGameOver;
		}
		
		public function get playerState():MovieClip
		{
			return _playerState as State;
		}
	}

}