package 
{

	import flash.display.MovieClip;
	import flash.media.SoundChannel;
	import flash.events.Event;
	import flash.media.Sound;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.events.MouseEvent;


	public class FloorEight extends MovieClip
	{

		private var _player:Player;
		private var _playerState:State;
		public static var removedPointVector:Vector.<Point > ;
		private var _channel:SoundChannel;
		private var _chimes:Chimes;
		private var _messageDialog:Dialog_Message;
		private var _type:Boolean;
		private var _isUp:Boolean;
		private var _isDown:Boolean;
		private var _playerHalfWidth:uint;
		private var _playerHalfHeight:uint;
		private var _tween:Tween;
		private var _stateExpMeterTotalWidth:uint;
		private var _stageHalfWidth;
		private var _stageHalfHeight;
		private var _isGameOver:Boolean;
		private var _fightPage:FightPage;
		private var _musicProblemTwo:MusicProblem_Two;
		private var _gmDialog:GMDialog;
		private var _mpTwoMusic:MPTwo_Music;

		public function FloorEight(player:Player,playerState:State)
		{
			_player = player;
			_playerState = playerState;
			removedPointVector = new Vector.<Point>();
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

		private function init()
		{

			_channel = new SoundChannel  ;
			_chimes = new Chimes  ;
			_messageDialog = new Dialog_Message  ;
			_musicProblemTwo = new MusicProblem_Two;
            _mpTwoMusic = new MPTwo_Music;
			addChildAt(_playerState, numChildren - 1);
			_playerState.x = _playerState.y = 0;
			_playerState.floor.text = "第七层";
			
			addChild(_player);
			stage.focus = this;
			
			if (_type == Floor.UP_STAIRS)
			{
				_player.x = 275;
				_player.y = 25;
			}
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
			
			if(_player.hasSolvedMusicTwo)
			{
				if(ironDoor)
				{
				    removeChild(ironDoor);
					removeChild(musicKey);
					ironDoor = null;
					musicKey = null;
				}
			}
			
			if(_player.hasLiYongSkill)
			{
				if(skillPage)
				{
					removeChild(skillPage);
					skillPage = null;
				}
			}
			
			if(_player.hasSwing)
			{
				if(swing)
				{
					removeChild(swing);
					swing = null;
				}
			}

			_isGameOver = false;
			
		}

		private function destory()
		{
			_channel = null;
			_chimes = null;
			_messageDialog = null;
			_musicProblemTwo = null;
			_mpTwoMusic = null;
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
			
			if(ironDoor)
			{
				if (ironDoor.hitTestPoint(_player.x - _playerHalfWidth,_player.y - _playerHalfHeight,true))
				{
					_player.x -=  _player.vx;
					_player.y -=  _player.vy;
				}
				if (ironDoor.hitTestPoint(_player.x - _playerHalfWidth,_player.y + _playerHalfHeight,true))
				{
					_player.x -=  _player.vx;
					_player.y -=  _player.vy;
				}
				if (ironDoor.hitTestPoint(_player.x + _playerHalfWidth,_player.y - _playerHalfHeight,true))
				{
					_player.x -=  _player.vx;
					_player.y -=  _player.vy;
				}
				if (ironDoor.hitTestPoint(_player.x + _playerHalfWidth,_player.y + _playerHalfHeight,true))
				{
					_player.x -=  _player.vx;
					_player.y -=  _player.vy;
				}
			}

			if (_player.body.hitTestObject(upStairs))
			{
				_isUp = true;
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
			
			if(musicKey && _player.body.hitTestObject(musicKey.body))
			{
				if(MagicTower.gameMode == "play")
				{
					MagicTower.gameMode = "waitmusic";
					_gmDialog = new GMDialog;
					_gmDialog.change("你碰到墙上的机关，突然不知从何处传来一阵优雅动听的音乐。");
					_channel = _mpTwoMusic.play();
					addChild(_gmDialog);
				}
				if(MagicTower.gameMode == "waitmusic")
				{
					if(_gmDialog.isShowOver)
					{
						removeChild(_gmDialog);
						_gmDialog = null;
						addChild(_musicProblemTwo);
					    MagicTower.gameMode = "musicproblem";
					}
				}
				if(MagicTower.gameMode == "musicproblem")
				{
					if(_musicProblemTwo.musicState == MusicProblem_Two.SUCCESS)
					{
						removeChild(_musicProblemTwo);
						_player.hasSolvedMusicTwo = true;
						removeChild(ironDoor);
						removeChild(musicKey);
						ironDoor = null;
						musicKey = null;
						MagicTower.gameMode = "play";
						_messageDialog.change("随着一声巨响，似乎有门被打开了。");
						addChild(_messageDialog);
					}
					else if(_musicProblemTwo.musicState == MusicProblem_Two.FAILURE)
					{
						removeChild(_musicProblemTwo);
						MagicTower.gameMode = "play";
						_messageDialog.change("你被一股不可抗拒的力量挡了回来！");
						addChild(_messageDialog);
						_player.x = 475;
						_player.y = 25;
					}
				}
			}
			
			if(skillPage && _player.body.hitTestObject(skillPage))
			{
				_player.hasLiYongSkill = true;
				removeChild(skillPage);
				skillPage = null;
				_messageDialog.change("获得技能页，学会新技能！");
				addChild(_messageDialog);
			}
			
			if(swing && _player.body.hitTestObject(swing))
			{
				_player.hasSwing = true;
				removeChild(swing);
				swing = null;
				_messageDialog.change("获得飞羽，移动速度+200");
				addChild(_messageDialog);
				_player.speed += 2;
				refreshProperty();
			}
			
		}

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
		
		public function checkCollisionWithPlayer_SkillStone(skillStone:MovieClip,type:uint):void
		{
			if (_player != null)
			{
				if (_player.body.hitTestObject(skillStone) && MagicTower.gameMode == "play")
				{
					if (type == SkillStones.REDSKILLSTONE)
					{
						_player.numSkillStones += 2;
						_messageDialog.change("得到技能晶  X2");
						addChild(_messageDialog);
					}
					else if (type == SkillStones.BLUESKILLSTONE)
					{
						_player.numSkillStones += 5;
						_messageDialog.change("得到技能晶  X5");
						addChild(_messageDialog);
					}
					else if (type == SkillStones.GREENSKILLSTONE)
					{
						_player.numSkillStones += 10;
						_messageDialog.change("得到技能晶  X10");
						addChild(_messageDialog);
					}
					removedPointVector.push(new Point(skillStone.x, skillStone.y));
					removeChild(skillStone);
					_chimes.play();
				}
			}
		}
		
		public function checkCollisionWithPlayer_Ticket(ticket:MovieClip)
		{
			if (_player != null)
			{
				if (_player.body.hitTestObject(ticket) && MagicTower.gameMode == "play")
				{
					_player.numTickets++;
					refreshTickets();
					_messageDialog.change("得到无尽之境通行券！");
					addChild(_messageDialog);
					_chimes.play();
					removedPointVector.push(new Point(ticket.x, ticket.y));
					removeChild(ticket);
				}
			}
		}
		

		public function checkCollisionWithPlayer_Enemy(enemy:MovieClip)
		{
			
			if (_player != null)
			{
				if (_player.body.hitTestObject(enemy.body))
				{
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
							removedPointVector.push(new Point(enemy.x,enemy.y));
						    removeChild(enemy);
							stage.focus = _player;
					    }
					}//fightover
				}//hit test
			}//player != null
		}// End check Collision
		
		public function checkCollisionWithPlayer_Door(door:MovieClip,type:int):void
		{
			if (_player.body.hitTestObject(door.body) && MagicTower.gameMode == "play")
			{
				if (type == Door.YELLOWDOOR)
				{
					if (_player.numYellowKeys > 0)
					{
						_player.numYellowKeys--;
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
							if (! contains(_messageDialog))
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
							if (! contains(_messageDialog))
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
							if (! contains(_messageDialog))
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
		}//door

		public function checkExist(child:MovieClip)
		{
			var searchFun:Function = function(item:Point, index:int, vector:Vector.<Point>):Boolean 
			{
			    if(Math.abs(child.x-item.x) < 5 && Math.abs(child.y-item.y) < 5)
				{
					return true;
				}
				else
				{
					return false;
				}
			};

			if (removedPointVector.some(searchFun))
			{
				removeChild(child);
			}
		}


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