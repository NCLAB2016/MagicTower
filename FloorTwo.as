package 
{

    import aeon.AnimationSequence;
	import aeon.AnimationComposite;
	import aeon.easing.*;
	import aeon.animators.Tweener;
	import aeon.events.AnimationEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import aeon.AnimationLoop;


	public class FloorTwo extends MovieClip
	{
		private var _player:MovieClip;
		private var _playerState:MovieClip;
		
		private var _type:Boolean;
		private var _isUp:Boolean;
		private var _isDown:Boolean;

		private var _playerHalfWidth:uint;
		private var _playerHalfHeight:uint;

		private var _channel:SoundChannel;
		private var _chimes:Chimes;

		private var _tween:Tween;

		//状态栏经验条总长度
		private var _stateExpMeterTotalWidth:uint;

		//stage属性
		private var _stageHalfWidth;
		private var _stageHalfHeight;

		//第一层 For Book
		private var _curtain:Curtain;
		private var _bookShow:Book_Show;

		//是否战斗失败
		private var _isGameOver:Boolean;
		
		private var _messageDialog:Dialog_Message;
		
		private var _fightPage:FightPage;
		
		//储存游戏地图信息
		public static var isGetBook:Boolean;
		//储存已被remove的元素坐标，用来储存游戏数据
		public static var removedPointVector:Vector.<Point>;
		
		private var _book:HandBook;
		

		public function FloorTwo(player:MovieClip, playerState:MovieClip)
		{
			_player = player;
			_playerState = playerState;
			removedPointVector = new Vector.<Point>();
			isGetBook = false;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
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
		
		private function addChildAtPoint(obj:MovieClip,xx:int,yy:int)
		{
			addChild(obj);
			obj.x = xx;
			obj.y = yy;
		}

		private function init()
		{
					
			_channel = new SoundChannel;
			_chimes = new Chimes;
			
			_messageDialog = new Dialog_Message;
		
		 	if(!isGetBook){ _book = new HandBook;  addChildAtPoint(_book,225,25);}
		
		
		    //添加playerState
			addChildAt(_playerState, numChildren - 1);
			_playerState.x = _playerState.y = 0;
			_playerState.floor.text = "第一层";
			
			//添加player并初始化其位置
			addChild(_player);
			stage.focus = this;
			if (_type == Floor.UP_STAIRS)
			{
				_player.x = 475;//与墙错开
				_player.y = 575;
			}
			else if (_type == Floor.DOWN_STAIRS)
			{
				_player.x = 525;
				_player.y = 75;
			}			
			
			if(_player.isLoad)
			{
				_player.x = _player.saveX;
				_player.y = _player.saveY;
				_player.isLoad = false;
			}

			_playerHalfWidth = _player.body.width / 2;
			_playerHalfHeight = _player.body.height / 2;

			//经验条状态
			_stateExpMeterTotalWidth = _playerState.stateEXP.meter.width;

			//初始化显示
			refreshState();

			//初始化未上下楼
			_isUp = false;
			_isDown = false;

			//初始化
			_isGameOver = false;

		}
		private function destory()
		{
			_channel = null;
			_chimes = null;
			_messageDialog = null;
			
		 	if(_book != null){ removeChild(_book);  _book = null;}
			
		}

		private function onEnterFrame(event:Event)
		{

			//墙阻挡角色
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

			//上楼楼梯
			if (_player.body.hitTestObject(upStairs))
			{
				_isUp = true;
			}

			//下楼楼梯
			if (_player.body.hitTestObject(downStairs))
			{
				_isDown = true;
			}

			//检测角色是否升级
			if (_player.isLevelUp)
			{
				refreshProperty();
				refreshEXP();
				_player.isLevelUp = false;
				_messageDialog.change("恭喜你升了一级！");
				addChild(_messageDialog);
			}

			//捡图鉴（仅第一层）
			if (! _player.hasBook && _player.body.hitTestObject(_book))
			{
				if (MagicTower.gameMode == "play")
				{
					_curtain = new Curtain  ;
					_curtain.alpha = 0;
					addChild(_curtain);
					_tween = new Tween(_curtain,"alpha",None.easeNone,0,1,50,false);
					_tween.addEventListener(TweenEvent.MOTION_FINISH, onMotionFinish);
					MagicTower.gameMode = "takeupbook";
				}
			}
			function onMotionFinish(event:Event)
			{

				//更新角色属性
				_player.hasBook = true;
				refreshHasBook();
				
				removeChild(_book);
				_book = null;
				isGetBook = true;

				_bookShow = new Book_Show  ;
				addChild(_bookShow);
				removeChild(_curtain);
				_curtain = null;
				_tween.removeEventListener(TweenEvent.MOTION_FINISH, onMotionFinish);
				_tween = null;
				addEventListener(Event.ENTER_FRAME, onWaitBook);
			}

		}

		function onWaitBook(event:Event)
		{
			if (_bookShow.isOver)
			{
				fadeOut(_bookShow);
				removeEventListener(Event.ENTER_FRAME, onWaitBook);
			}
		}



		//动画实现渐出
		private function fadeOut(obj:MovieClip):void
		{
			var tween:Tween = new Tween(obj,"alpha",None.easeNone,1,0,60,false);
			tween.addEventListener(TweenEvent.MOTION_FINISH, onMotionFinish);
			function onMotionFinish(event:Event):void
			{
				removeChild(obj);
				obj = null;
				MagicTower.gameMode = "play";
				_messageDialog.change("得到 强任的怪物图鉴(空格键或点击状态栏图标查阅)");
				addChild(_messageDialog);
				tween.removeEventListener(TweenEvent.MOTION_FINISH, onMotionFinish);
				tween = null;
			}
		}

	
		//战斗系统----遇敌
		public function checkCollisionWithPlayer_Enemy(enemy:MovieClip)
		{
			
			if (_player != null)
			{
				if (_player.body.hitTestObject(enemy.body))
				{
					
					
					if(MagicTower.gameMode != "fight" && MagicTower.gameMode != "fightover"
					        && !_isGameOver && MagicTower.gameMode != "showdialog" )
					{
						_fightPage = new FightPage(_player,enemy);
						addChild(_fightPage);
						MagicTower.gameMode = "fight";
						
					}
					
					if(MagicTower.gameMode == "fightover"){
						//游戏结束
						removeChild(_fightPage);
						_fightPage = null;
						MagicTower.gameMode = "play";
						
						if (_player.blood <= 0)
						{
							  removeChild(enemy);
							  _isGameOver = true;
						}
					
						//战斗胜利
						else if (enemy.blood <= 0)
						{
							_player.gold +=  enemy.gold;
							_player.EXP +=  enemy.EXP;
							refreshProperty();
							refreshEXP();
							_messageDialog.change("战斗胜利！ 得到金币：" + enemy.gold + " 经验：" + enemy.EXP);
							addChild(_messageDialog);
							//如果第一次遇到则更新图鉴
							if(!enemy.hasMeeted)
							{
						  	  _player.addEnemyToBook(enemy.enemyType);
							}
							
							removedPointVector.push(new Point(enemy.x,enemy.y));
							
						    removeChild(enemy);
							stage.focus = _player;
					    }
					}
				}//hit test
			}//player != null
		}// End check Collision

		//小血瓶
		public function checkCollisionWithPlayer_SmallBlood(smallBlood:MovieClip)
		{
			if (_player != null)
			{
				if (_player.body.hitTestObject(smallBlood.body) && MagicTower.gameMode == "play")
				{
					_player.blood +=  200;
					refreshProperty();
					_messageDialog.change("得到小血瓶，生命+200");
					addChild(_messageDialog);
					_chimes.play();
					removedPointVector.push(new Point(smallBlood.x, smallBlood.y));
				    removeChild(smallBlood);
				}
			}
		}

		//大血瓶
		public function checkCollisionWithPlayer_BigBlood(bigBlood:MovieClip)
		{
			if (_player != null)
			{
				if (_player.body.hitTestObject(bigBlood.body) && MagicTower.gameMode == "play")
				{
					_player.blood +=  500;
					refreshProperty();
					_messageDialog.change("得到大血瓶，生命+500");
					addChild(_messageDialog);
					_chimes.play();
	                removedPointVector.push(new Point(bigBlood.x, bigBlood.y));
				    removeChild(bigBlood);
				}

			}
		}

		//防御药水
		public function checkCollisionWithPlayer_Defend(drugDefend:MovieClip)
		{
			if (_player != null)
			{
				if (_player.body.hitTestObject(drugDefend.body) && MagicTower.gameMode == "play")
				{
					_player.defence +=  2;
					refreshProperty();
					_messageDialog.change("得到防御药水，防御+2");
					addChild(_messageDialog);
					_chimes.play();
				    removedPointVector.push(new Point(drugDefend.x, drugDefend.y));
				    removeChild(drugDefend);
				}
			}
		}

		//攻击药水
		public function checkCollisionWithPlayer_Attack(drugAttack:MovieClip)
		{
			if (_player != null)
			{
				if (_player.body.hitTestObject(drugAttack.body) && MagicTower.gameMode == "play")
				{
					_player.attack +=  2;
					refreshProperty();
					_messageDialog.change("得到攻击药水，攻击+2");
					addChild(_messageDialog);
					_chimes.play();
				    removedPointVector.push(new Point(drugAttack.x, drugAttack.y));
				    removeChild(drugAttack);
				}
			}
		}




		//捡钥匙
		public function checkCollisionWithPlayer_Key(key:MovieClip,type:int):void
		{
			if (_player != null)
			{
				if (_player.body.hitTestObject(key) && MagicTower.gameMode == "play")
				{
					if (type == DoorKey.YELLOWKEY)
					{
						_player.numYellowKeys++;
						_messageDialog.change("得到黄色钥匙  X1");
						addChild(_messageDialog);
					}
					else if (type == DoorKey.REDKEY)
					{
						_player.numRedKeys++;
						_messageDialog.change("得到红色钥匙  X1");
						addChild(_messageDialog);
					}
					else if (type == DoorKey.BLUEKEY)
					{
						_player.numBlueKeys++;
						_messageDialog.change("得到蓝色钥匙  X1");
						addChild(_messageDialog);
					}
					
					removedPointVector.push(new Point(key.x, key.y));
					
					removeChild(key);
					_chimes.play();
					refreshKey();
				}
			}
		}


		//开门
		public function checkCollisionWithPlayer_Door(door:MovieClip,type:int):void
		{
			if (_player.body.hitTestObject(door.body) && MagicTower.gameMode == "play")
			{
				if (type == Door.YELLOWDOOR)
				{
					if (_player.numYellowKeys > 0)
					{
						_player.numYellowKeys--;

						//Tween实现开门动画
						_tween = new Tween(door,"alpha",None.easeNone,this.alpha,0,10,false);
						_tween.addEventListener(TweenEvent.MOTION_FINISH, onMotionFinish);
						MagicTower.gameMode = "opendoor";
						_chimes.play();
					}
					else
					{
						if (MagicTower.gameMode == "play")
						{
							Collision.block(_player,door);
							_messageDialog.change("黄色钥匙不足！");
							if(!contains(_messageDialog))
							{
								addChild(_messageDialog);
							}
						}
					}
				}
				else if (type == Door.REDDOOR)
				{
					if (_player.numRedKeys > 0)
					{
						_player.numRedKeys--;
						_tween = new Tween(door,"alpha",None.easeNone,this.alpha,0,10,false);
						_tween.addEventListener(TweenEvent.MOTION_FINISH, onMotionFinish);
						MagicTower.gameMode = "opendoor";
						_chimes.play();
					}
					else
					{
						if (MagicTower.gameMode == "play")
						{
							Collision.block(_player,door);
							_messageDialog.change("红色钥匙不足！");
							if(!contains(_messageDialog))
							{
								addChild(_messageDialog);
							}
						}
					}
				}
				else if (type == Door.BLUEDOOR)
				{
					if (_player.numBlueKeys > 0)
					{
						_player.numBlueKeys--;
						_tween = new Tween(door,"alpha",None.easeNone,this.alpha,0,10,false);
						_tween.addEventListener(TweenEvent.MOTION_FINISH, onMotionFinish);
						MagicTower.gameMode = "opendoor";
						_chimes.play();
					}
					else
					{
						if (MagicTower.gameMode == "play")
						{
							Collision.block(_player,door);
							_messageDialog.change("蓝色钥匙不足！");
							if(!contains(_messageDialog))
							{
								addChild(_messageDialog);
							}
						}
					}
				}
				refreshKey();
			}
			function onMotionFinish(event:Event)
			{
				removedPointVector.push(new Point(door.x, door.y));
				removeChild(door);
				MagicTower.gameMode = "play";
				_tween.removeEventListener(TweenEvent.MOTION_FINISH, onMotionFinish);
			}

		}

        public function checkExist(child:MovieClip)
		{
			var searchFun:Function = function(item:Point, index:int, vector:Vector.<Point>):Boolean {
                if(Math.abs(child.x-item.x) < 5 && Math.abs(child.y-item.y) < 5)
				{
					return true;
				}
				else
				{
					return false;
				}
             };
			 
            if(removedPointVector.some(searchFun))
			{
				removeChild(child);
			}
		}
		
		//刷新所有状态
		private function refreshState():void
		{
			refreshProperty();
			refreshKey();
			refreshEXP();
			refreshHasBook();
			refreshTickets();
		}
		
				//刷新通行券
		private function refreshTickets():void
		{
			_playerState.numTickets.text = String(_player.numTickets);
		}


		//刷新钥匙显示
		private function refreshKey():void
		{
			with (_playerState)
			{
				numYellow.text = _player.numYellowKeys;
				numRed.text = _player.numRedKeys;
				numBlue.text = _player.numBlueKeys;
			}
		}

		//刷新角色基础属性 不包括经验
		private function refreshProperty():void
		{
			with (_playerState)
			{
				level.text = _player.level;
				blood.text = _player.blood;
				attack.text = _player.attack;
				defence.text = _player.defence;

				//速度100:1比例来显示
				speed.text = _player.speed * 100;
				gold.text = _player.gold;
			}
			_player.isChanged = true;
		}


		//刷新角色经验 包括经验条
		private function refreshEXP():void
		{
			//计算经验进度比例
			var playerEXPPercent:uint = (_player.EXP - _player.lastLevelUpEXP) * 100 
			            / (_player.levelUpEXP - _player.lastLevelUpEXP);
			with (_playerState)
			{
				exp.text = _player.EXP;
				//经验值条
				stateEXP.percent.text = playerEXPPercent + "%";
				stateEXP.meter.width = _stateExpMeterTotalWidth * playerEXPPercent / 100;
			}

			_player.isChanged = true;
		}

		//刷新角色是否有图鉴信息
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