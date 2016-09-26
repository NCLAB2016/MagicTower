package 
{

	import flash.display.MovieClip;
	import flash.events.Event;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.text.TextField;

	public class FloorOne extends MovieClip
	{
		private var _player:MovieClip;
		private var _playerState:MovieClip;
		private var _type:Boolean;
		private var _isUp:Boolean;

		private var _playerHalfWidth:uint;
		private var _playerHalfHeight:uint;

		private var _channel:SoundChannel;
		private var _chimes:Chimes;

		private var _tween:Tween;

		//状态栏经验条总长度
		private var _stateExpMeterTotalWidth:uint;

		private var _stageHalfWidth:uint;
		private var _stageHalfHeight:uint;

		private var _isGameOver:Boolean;

		private var _background:Sky;
		//储存游戏地图信息
		public static var isExist:Vector.<Boolean > ;

		//地图
		private var _wall:FloorOneWall;
		private var _upStairs:UpStairs;

		//需要储存是否存在信息的物品，以下顺序及其在isExist中顺序
		private var _sprite:Celestial;
		private var _yellowKey:YellowKeyT;
		private var _yellowDoor:YellowDoorT;

		private var _hitDoorWithoutKey:Boolean = false;
		
		 //仙子
		private var spriteDialog:SpriteDialog;
		//角色
		private var playerDialog:PlayerDialog;
		//对话计数
		private var dialogCount:uint;
		
		private var _messageDialog:Dialog_Message;

        private var _isTouch:Boolean;

		public function FloorOne(player:MovieClip, playerState:MovieClip)
		{
			_player = player;
			_playerState = playerState;
			isExist = new <Boolean>[true,true,true];
			isExist.fixed = true;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(event:Event):void
		{
			init();
			x = y = 0;
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
			_background = new Sky  ;
			_chimes = new Chimes  ;
			_channel = new SoundChannel  ;

			_wall = new FloorOneWall  ;
			addChildAtPoint(_wall,200,0);
			_upStairs = new UpStairs  ;
			addChildAtPoint(_upStairs,475,26);
			
			spriteDialog = new SpriteDialog;
			playerDialog = new PlayerDialog;
			dialogCount = 0;
			
			_messageDialog = new Dialog_Message;

			if (isExist[0])
			{
				_sprite = new Celestial  ;
				addChildAtPoint(_sprite,425,475);
			}
			if (isExist[1])
			{
				_yellowKey = new YellowKeyT  ;
				addChildAtPoint(_yellowKey,475,225);
			}
			if (isExist[2])
			{
				_yellowDoor = new YellowDoorT  ;
				addChildAtPoint(_yellowDoor,525,425);
			}

			addChildAt(_background,0);
			
			//添加playerState 需在player之前
			addChildAt(_playerState, numChildren - 1);
			_playerState.x = _playerState.y = 0;
			_playerState.floor.text = "第零层";

			//添加player并初始化其位置
			addChild(_player);
			
			if (_type == Floor.UP_STAIRS)
			{
				_player.x = 525;
				_player.y = 525;
			}
			else if (_type == Floor.DOWN_STAIRS)
			{
				_player.x = 525;
				_player.y = 25;
			}

			if (_player.isLoad)
			{
				_player.x = _player.saveX;
				_player.y = _player.saveY;
				_player.isLoad = false;
			}


			stage.focus = this;

			_playerHalfWidth = _player.body.width / 2;
			_playerHalfHeight = _player.body.height / 2;

			//经验条状态
			_stateExpMeterTotalWidth = _playerState.stateEXP.meter.width;

			//初始化显示
			refreshState();

			//初始化未上楼
			_isUp = false;
			_isGameOver = false;
			_isTouch = false;
		}

		private function destory()
		{
			removeChild(_background);
			_background = null;
			_channel.stop();
			_channel = null;
			_chimes = null;

            spriteDialog = null;
			playerDialog = null;
			
			_messageDialog = null;
			
			removeChild(_wall);
			_wall = null;
			removeChild(_upStairs);
			_upStairs = null;
			if (_sprite != null)
			{
				removeChild(_sprite);
				_sprite = null;
			}
			if (_yellowKey != null)
			{
				removeChild(_yellowKey);
				_yellowKey = null;
			}
			if (_yellowDoor != null)
			{
				removeChild(_yellowDoor);
				_yellowDoor = null;
			}
		}

		private function onEnterFrame(event:Event)
		{

			//墙阻挡角色
			if (_wall.hitTestPoint(_player.x - _playerHalfWidth,_player.y - _playerHalfHeight,true))
			{
				_player.x -=  _player.vx;
				_player.y -=  _player.vy;
				
			}
			if (_wall.hitTestPoint(_player.x - _playerHalfWidth,_player.y + _playerHalfHeight,true))
			{
				_player.x -=  _player.vx;
				_player.y -=  _player.vy;
			}
			if (_wall.hitTestPoint(_player.x + _playerHalfWidth,_player.y - _playerHalfHeight,true))
			{
				_player.x -=  _player.vx;
				_player.y -=  _player.vy;
			}
			if (_wall.hitTestPoint(_player.x + _playerHalfWidth,_player.y + _playerHalfHeight,true))
			{
				_player.x -=  _player.vx;
				_player.y -=  _player.vy;
			}

			if (_yellowKey != null && _player.body.hitTestObject(_yellowKey))
			{
				_player.numYellowKeys++;
				_messageDialog.change("得到黄色钥匙  X1");
			    addChild(_messageDialog);
				
				removeChild(_yellowKey);
				_yellowKey = null;
				isExist[1] = false;
				_chimes.play();
				refreshKey();
			}


			if (_yellowDoor != null && _player.body.hitTestObject(_yellowDoor))
			{
				if (MagicTower.gameMode == "play")
				{
					if (_player.numYellowKeys > 0)
					{
						_player.numYellowKeys--;
						//Tween实现开门动画
						_tween = new Tween(_yellowDoor,"alpha",None.easeNone,1,0,10,false);
						_tween.addEventListener(TweenEvent.MOTION_FINISH, onMotionFinish);
						MagicTower.gameMode = "opendoor";
						_chimes.play();
					}
					else
					{
						if (! _hitDoorWithoutKey)
						{
							_hitDoorWithoutKey = true;
							_messageDialog.change("黄色钥匙不足！");
							addChild(_messageDialog);
						}
						Collision.block(_player, _yellowDoor);
					}
					refreshKey();
				}
			}
			function onMotionFinish(event:Event)
			{
				removeChild(_yellowDoor);
				_yellowDoor = null;
				isExist[2] = false;
				MagicTower.gameMode = "play";
				_tween.removeEventListener(TweenEvent.MOTION_FINISH, onMotionFinish);
				_tween = null;
			}
			
			//debug
			if(_player.hitTestObject(spe) && !_isTouch)
			{
				_isTouch = true;
				_player.EXP += 10000;
				_player.gold += 10000;
			}

			//上楼楼梯
			if (_player.body.hitTestObject(_upStairs))
			{
				_isUp = true;
			}
			
			if(_sprite != null && _player.hitTestObject(_sprite.body))
			{
				if(MagicTower.gameMode == "play")
				{
				    MagicTower.gameMode = "dialog";
					 addChild(spriteDialog);
					spriteDialog.change("你醒了！");
				}
				if(dialogCount == 0)
				{
					if(spriteDialog.isShowOver)
					{
						spriteDialog.visible = false;
						addChild(playerDialog);
						playerDialog.change("......\n你是谁？我在哪里？");
						++dialogCount;
					}
				}
				else if(dialogCount == 1)
				{
					spriteSaid("我是这座塔的守护者——冰一仙子，刚才你被这里\n的小怪打晕了。");
				}
				else if(dialogCount == 2)
				{
					playerSaid("......\n那...那我要怎样才能出去？");
				}
				else if(dialogCount == 3)
				{
					spriteSaid("这里的结构没有你想象的那么简单，你的实力太弱\n，这样是出不去的。");
				}
				else if(dialogCount == 4)
				{
					playerSaid("......\n那...那我该怎么办？");
				}
				else if(dialogCount == 5)
				{
					spriteSaid("放心吧，我可以将我的力量借给你，不过在此之前\n，你需要先帮我拿到一样东西。");
				}
				else if(dialogCount == 6)
				{
					playerSaid("什么东西？在哪里？");
				}
				else if(dialogCount == 7)
				{
					spriteSaid("是一个通体绿色的法杖，它的位置并不固定，但是\n它只会在五层之上出现。\n");
				}
				else if(dialogCount == 8)
				{
					playerSaid("那...我要怎样才能上去？");
				}
				else if(dialogCount == 9)
				{
                     spriteSaid("这座塔里面有很多钥匙，一种颜色钥匙只能开同种\n颜色的门，我这儿有三把钥匙，你先拿去，塔里还有一些钥匙，你要珍惜使用。");

				}
				else if(dialogCount == 10)
				{
					 spriteSaidAgain("还有，楼层里面的怪物受到这座塔神力束缚，你可\n以通过它们名称颜色看到它们的实力。怪物名称颜\n色分为绿色，紫色，红色，黑色四种，分别代表安\n全，一般，危险，深不可测。");
				}
				else if(dialogCount == 11)
				{
					 spriteSaidAgain("另外，还有很多宝物拿到后可以提升你的实力。好\n了，在你拿到法杖之后再来找我。勇敢的去吧！");
				}
				else if(dialogCount == 12)
				{
					if(spriteDialog.isShowOver)
					{
						removeChild(spriteDialog);
						removeChild(playerDialog);
						removeChild(_sprite);
					    isExist[0] = false;
					    _sprite = null;
					    ++dialogCount;
						
					    _player.numRedKeys++;
					    _player.numYellowKeys++;
					    _player.numBlueKeys++;
						refreshKey();
					    MagicTower.gameMode = "play";
						stage.focus = _player;
					}
				}
				

			}
		}

        private function playerSaid(msg:String)
		{
			if(spriteDialog.isShowOver)
			{
				spriteDialog.visible = false;
				playerDialog.visible = true;
				playerDialog.change(msg);
				++dialogCount;
			}
		}
		private function spriteSaid(msg:String)
		{
			if(playerDialog.isShowOver)
			{
				playerDialog.visible = false;
				spriteDialog.visible = true;
				spriteDialog.change(msg);
				++dialogCount;
			}
		}
		
		private function spriteSaidAgain(msg:String)
		{
			if(spriteDialog.isShowOver)
			{
			    spriteDialog.change(msg);
				++dialogCount;
			}
		}
		
		
	
		//一个一个字的显示文本
		private function showTextOneByOne(container:TextField,msg:String)
		{
			var timer:Timer = new Timer(250);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			timer.start();
			
			var i:int = 0;
			function onTimer(event:TimerEvent)
			{
				container.appendText(msg.charAt(i));
				++i;
				if(i == msg.length)
				{
					timer.stop();
					timer.removeEventListener(TimerEvent.TIMER, onTimer);
					timer = null;
				}
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
		
		//刷新通行券
		private function refreshTickets():void
		{
			_playerState.numTickets.text = String(_player.numTickets);
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

		//为了使MagicTower类中判断切换楼层正常工作
		public function get isDown():Boolean
		{
			return false;
		}

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