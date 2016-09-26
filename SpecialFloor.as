package 
{

	import flash.display.MovieClip;
	import flash.media.SoundChannel;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	import aeon.animators.Tweener;
	import fl.transitions.easing.Bounce;


	public class SpecialFloor extends MovieClip
	{

		private var _player:Player;
		private var _playerState:State;
		private var _channel:SoundChannel;
		private var _chimes:Chimes;
		private var _messageDialog:Dialog_Message;
		private var _playerHalfWidth:uint;
		private var _playerHalfHeight:uint;
		private var _stateExpMeterTotalWidth:uint;
		private var _stageHalfWidth;
		private var _stageHalfHeight;
		private var _isGameOver:Boolean;
		private var _fightPage:FightPage;
		
		private var _chooseDialog:ChooseDialog;
		
		private var _hasBoss:Boolean;


		public function SpecialFloor(player:Player,playerState:State)
		{
			_player = player;
			_playerState = playerState;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(event:Event):void
		{
			init();
			_stageHalfWidth = stage.stageWidth / 2;
			_stageHalfHeight = stage.stageHeight / 2;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		
//		     //debug
//			 addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}

		private function onRemovedFromStage(event:Event):void
		{
			destory();
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
//      Debug
//		private function onKeyDown(event:KeyboardEvent)
//		{
//			if(event.keyCode == Keyboard.L)
//			{
//				removeChild(moveCat);
//				moveCat = null;
//				removeChild(sitCat);
//				sitCat = null;
//				removeChild(smileCat1);
//				smileCat1 = null;
//				removeChild(smileCat2);
//				smileCat2 = null;
//				removeChild(smileCat3);
//				smileCat3 = null;
//				removeChild(smileCat4);
//				smileCat4 = null;
//				_player.attack += 1000;
//			}
//		}

		private function init()
		{
			x = y = 0;

			_channel = new SoundChannel  ;
			_chimes = new Chimes  ;
			_messageDialog = new Dialog_Message  ;

			addChildAt(_playerState, numChildren - 1);
			_playerState.x = _playerState.y = 0;
			_playerState.floor.text = "无尽之境";

			addChild(_player);
			stage.focus = this;

			_player.x = 230;
			_player.y = 500;

			_playerHalfWidth = _player.body.width / 2;
			_playerHalfHeight = _player.body.height / 2;

			_stateExpMeterTotalWidth = _playerState.stateEXP.meter.width;

			refreshState();

			_isGameOver = false;
			_hasBoss = false;
		}

		private function destory()
		{
			_channel = null;
			_chimes = null;
			_messageDialog = null;
		}

		private function onEnterFrame(event:Event)
		{

			if (_player.isLevelUp)
			{
				refreshProperty();
				refreshEXP();
				_player.isLevelUp = false;
				_messageDialog.change("恭喜你升了一级！");
				addChild(_messageDialog);
			}

			if (_player.hitTestObject(exit))
			{
				if (MagicTower.gameMode == "play")
				{
					MagicTower.gameMode = "waitchoose";
					_chooseDialog = new ChooseDialog("确认要离开？");
					addChild(_chooseDialog);
				}
				if(MagicTower.gameMode == "waitchoose")
				{
					if(_chooseDialog.choose == 1)
					{
						removeChild(_chooseDialog);
						_chooseDialog = null;
						MagicTower.gameMode = "exitfromspecialfloor";
					}
					else if(_chooseDialog.choose == 0)
					{
						removeChild(_chooseDialog);
						_chooseDialog =null;
						_player.x = 230;
		            	_player.y = 500;
						MagicTower.gameMode = "play";
					}
				}
			}

			if (sitCat && _player.hitTestObject(sitCat.body))
			{
				fightWithSitCat();
			}

			if (moveCat && _player.hitTestObject(moveCat))
			{
				fightWithMoveCat();
			}

			if (smileCat1)
			{
				if(!contains(smileCat1))
				{
					smileCat1 = null;
				}
				else if (_player.hitTestObject(smileCat1))
				{
					fightWithSmileCat(smileCat1);
				}
				else if (Math.abs(smileCat1.x - _player.x) <= 100 && Math.abs(smileCat1.y - _player.y) <= 60)
				{
					smileCat1.gotoAndStop(2);
				}
				else
				{
					smileCat1.gotoAndStop(1);
				}
			}
			if (smileCat2)
			{
				if(!contains(smileCat2))
				{
					smileCat2 = null;
				}
				else if (_player.hitTestObject(smileCat2))
				{
					fightWithSmileCat(smileCat2);
				}
				else if (Math.abs(smileCat2.x - _player.x) <= 100 && Math.abs(smileCat2.y - _player.y) <= 60)
				{
					smileCat2.gotoAndStop(2);
				}
				else
				{
					smileCat2.gotoAndStop(1);
				}
			}
			if (smileCat3)
			{
				if(!contains(smileCat3))
				{
					smileCat3 = null;
				}
				else if (_player.hitTestObject(smileCat3))
				{
					fightWithSmileCat(smileCat3);
				}
				else if (Math.abs(smileCat3.x - _player.x) <= 100 && Math.abs(smileCat3.y - _player.y) <= 60)
				{
					smileCat3.gotoAndStop(2);
				}
				else
				{
					smileCat3.gotoAndStop(1);
				}
			}
			if (smileCat4)
			{
				if(!contains(smileCat4))
				{
					smileCat4 = null;
				}
				else if (_player.hitTestObject(smileCat4))
				{
					fightWithSmileCat(smileCat4);
				}
				else if (Math.abs(smileCat4.x - _player.x) <= 100 && Math.abs(smileCat4.y - _player.y) <= 60)
				{
					smileCat4.gotoAndStop(2);
				}
				else
				{
					smileCat4.gotoAndStop(1);
				}
			}
			
			if(!sitCat && !moveCat && !smileCat1 && !smileCat2 && !smileCat3 && !smileCat4)
			{
				if(!_hasBoss)
				{
					_hasBoss = true;
					if(getTimer() & 1)
					{
						catBoss.attack = _player.defence + 10;
						catBoss.defence = _player.attack - 10;
						catBoss.gold = _player.level;
						catBoss.EXP = _player.level;
						new Tweener(catBoss,{x:1000},{x:610},1000,Bounce.easeInOut).start();
						catBoss.play();
					}
				}
			}
			
			if(catBoss && _player.hitTestObject(catBoss.body))
			{
				fightWithCatBoss();
			}

		}

		private function fightWithSitCat()
		{
			if (MagicTower.gameMode != "fight" && MagicTower.gameMode != "fightover"
			       && MagicTower.gameMode != "showdialog" && !_isGameOver)
			{
				sitCat.stop();
				_fightPage = new FightPage(_player,sitCat);
				addChild(_fightPage);
				MagicTower.gameMode = "fight";
			}
			if (MagicTower.gameMode == "fightover")
			{
				removeChild(_fightPage);
				_fightPage = null;
				MagicTower.gameMode = "play";
				if (_player.blood <= 0)
				{
					removeChild(sitCat);
					_isGameOver = true;
				}
				else if (sitCat.blood <= 0)
				{
					_player.gold +=  sitCat.gold;
					_player.EXP +=  sitCat.EXP;
					refreshProperty();
					refreshEXP();
					_messageDialog.change("战斗胜利！ 得到金币：" + sitCat.gold + " 经验：" + sitCat.EXP);
					addChild(_messageDialog);

					var rand:uint = getTimer() & 3;
					
					//几率掉宝
					if (rand == 0)
					{
						var da:Drug_Attack = new Drug_Attack  ;
						da.notCheckExist();
						addChild(da);
						da.x = sitCat.x;
						da.y = sitCat.y;
					}
					else if (rand == 1)
					{
						var dd:Drug_Defend = new Drug_Defend  ;
						dd.notCheckExist();
						addChild(dd);
						dd.x = sitCat.x;
						dd.y = sitCat.y;
					}
					else
					{
						var sb:SmallBlood = new SmallBlood  ;
						sb.notCheckExist();
						addChild(sb);
						sb.x = sitCat.x;
						sb.y = sitCat.y;
					}


					if (! sitCat.hasMeeted)
					{
						_player.addEnemyToBook(sitCat.enemyType);
					}
					removeChild(sitCat);
					sitCat = null;
					stage.focus = _player;
				}
			}//fightover
		}

		private function fightWithMoveCat()
		{
			if (MagicTower.gameMode != "fight" && MagicTower.gameMode != "fightover"
			       && MagicTower.gameMode != "showdialog" && !_isGameOver)
			{
				moveCat.stopMove();
				_fightPage = new FightPage(_player,moveCat);
				addChild(_fightPage);
				MagicTower.gameMode = "fight";
			}
			if (MagicTower.gameMode == "fightover")
			{
				removeChild(_fightPage);
				_fightPage = null;
				MagicTower.gameMode = "play";
				if (_player.blood <= 0)
				{
					removeChild(moveCat);
					_isGameOver = true;
				}
				else if (moveCat.blood <= 0)
				{
					_player.gold +=  moveCat.gold;
					_player.EXP +=  moveCat.EXP;
					refreshProperty();
					refreshEXP();
					_messageDialog.change("战斗胜利！ 得到金币：" + moveCat.gold + " 经验：" + moveCat.EXP);
					addChild(_messageDialog);


					var rand:uint = getTimer() & 3;
					//几率掉宝
					
					if (rand == 0)
					{
						var bb:BigBlood = new BigBlood  ;
						bb.notCheckExist();
						addChild(bb);
						bb.x = moveCat.x;
						bb.y = moveCat.y;
					}
					else if (rand == 1)
					{
						var bb1:BigBlood = new BigBlood  ;
						var bb2:BigBlood = new BigBlood  ;
						bb1.notCheckExist();
						bb2.notCheckExist();
						addChild(bb1);
						addChild(bb2);
						bb1.x = moveCat.x;
						bb2.x = moveCat.x;
						bb1.y = moveCat.y - (moveCat.height / 4);
						bb2.y = moveCat.y + (moveCat.height / 4);
					}
					else
					{
						var rs:RedSkillStone = new RedSkillStone  ;
						rs.notCheckExist();
						addChild(rs);
						rs.x = moveCat.x;
						rs.y = moveCat.y;
					}


					if (! moveCat.hasMeeted)
					{
						_player.addEnemyToBook(moveCat.enemyType);
					}
					removeChild(moveCat);
					moveCat = null;
					stage.focus = _player;
				}
			}//fightover
		}

		private function fightWithSmileCat(smileCat:SmileCat)
		{
			if (MagicTower.gameMode != "fight" && MagicTower.gameMode != "fightover"
			       && MagicTower.gameMode != "showdialog" && !_isGameOver)
			{
				_fightPage = new FightPage(_player,smileCat);
				addChild(_fightPage);
				MagicTower.gameMode = "fight";
			}
			if (MagicTower.gameMode == "fightover")
			{
				removeChild(_fightPage);
				_fightPage = null;
				MagicTower.gameMode = "play";
				if (_player.blood <= 0)
				{
					removeChild(smileCat);
					_isGameOver = true;
				}
				else if (smileCat.blood <= 0)
				{
					_player.gold +=  smileCat.gold;
					_player.EXP +=  smileCat.EXP;
					refreshProperty();
					refreshEXP();
					_messageDialog.change("战斗胜利！ 得到金币：" + smileCat.gold + " 经验：" + smileCat.EXP);
					addChild(_messageDialog);


					var rand:uint = getTimer() & 7;
					//几率掉宝
					if (rand == 0)
					{
						var bs:BlueSkillStone = new BlueSkillStone  ;
						bs.notCheckExist();
						addChild(bs);
						bs.x = smileCat.x;
						bs.y = smileCat.y;
					}
					else if ((rand == 1) || (rand == 2))
					{
						var yk1:YellowKey = new YellowKey  ;
						var yk2:YellowKey = new YellowKey  ;
						yk1.notCheckExist();
						yk2.notCheckExist();
						addChild(yk1);
						addChild(yk2);
						yk1.x = smileCat.x;
						yk2.x = smileCat.x;
						yk1.y = smileCat.y - (smileCat.height / 4);
						yk2.y = smileCat.y + (smileCat.height / 4);
					}
					else if ((rand==3) || (rand == 4))
					{
						var yk:YellowKey = new YellowKey  ;
						yk.notCheckExist();
						addChild(yk);
						yk.x = smileCat.x;
						yk.y = smileCat.y;
					}
					else if (rand == 5)
					{
						var rk:RedKey = new RedKey  ;
						rk.notCheckExist();
						addChild(rk);
						rk.x = smileCat.x;
						rk.y = smileCat.y;
					}
					else
					{
						var rs:RedSkillStone = new RedSkillStone  ;
						rs.notCheckExist();
						addChild(rs);
						rs.x = smileCat.x;
						rs.y = smileCat.y;
					}


					if (! smileCat.hasMeeted)
					{
						_player.addEnemyToBook(smileCat.enemyType);
					}
					removeChild(smileCat);
					smileCat = null;
					stage.focus = _player;
				}
			}//fightover
		}


        private function fightWithCatBoss()
		{
			if (MagicTower.gameMode != "fight" && MagicTower.gameMode != "fightover"
			       && MagicTower.gameMode != "showdialog" && !_isGameOver)
			{
				catBoss.stop();
				_fightPage = new FightPage(_player,catBoss);
				addChild(_fightPage);
				MagicTower.gameMode = "fight";
			}
			if (MagicTower.gameMode == "fightover")
			{
				removeChild(_fightPage);
				_fightPage = null;
				MagicTower.gameMode = "play";
				if (_player.blood <= 0)
				{
					removeChild(catBoss);
					_isGameOver = true;
				}
				else if (catBoss.blood <= 0)
				{
					_player.gold +=  catBoss.gold;
					_player.EXP +=  catBoss.EXP;
					refreshProperty();
					refreshEXP();
					_messageDialog.change("战斗胜利！ 得到金币：" + catBoss.gold + " 经验：" + catBoss.EXP);
					addChild(_messageDialog);


					var rand:uint = getTimer() & 7;
					//几率掉宝
					if (rand == 0)
					{
						var gs:GreenSkillStone =  new GreenSkillStone;
						gs.notCheckExist();
						addChild(gs);
						gs.x = catBoss.x;
						gs.y = catBoss.y;
					}
					else if (rand == 1)
					{
						var bb1:BigBlood = new BigBlood;
						var bb2:BigBlood = new BigBlood;
						var bb3:BigBlood = new BigBlood;
						var bb4:BigBlood = new BigBlood;
						bb1.notCheckExist();
						bb2.notCheckExist();
						bb3.notCheckExist();
						bb4.notCheckExist();
						addChild(bb1);
						addChild(bb2);
						addChild(bb3);
						addChild(bb4);
						bb1.x = catBoss.x;
						bb2.x = catBoss.x;
						bb3.x = catBoss.x;
						bb4.x = catBoss.x;
						bb1.y = catBoss.y - (3 * catBoss.height / 8);
					    bb2.y = catBoss.y - (catBoss.height / 8);
						bb3.y = catBoss.y + (catBoss.height / 8);
						bb4.y = catBoss.y + (3 * catBoss.height / 8);
					}
					else if (rand == 2)
					{
						var bk:BlueKey = new BlueKey;
						bk.notCheckExist();
						addChild(bk);
						bk.x = catBoss.x;
						bk.y = catBoss.y;
					}
					else if (rand == 3)
					{
						var rs1:RedSkillStone = new RedSkillStone;
						var rs2:RedSkillStone = new RedSkillStone;
						rs1.notCheckExist();
						rs2.notCheckExist();
						addChild(rs1);
						addChild(rs2);
						rs1.x = catBoss.x;
						rs2.x = catBoss.x;
						rs1.y = catBoss.y - (catBoss.height / 4);
						rs2.y = catBoss.y + (catBoss.height / 4);
					}
					else if(rand == 4)
					{
						var yk1:YellowKey = new YellowKey;
						var yk2:YellowKey = new YellowKey;
						var yk3:YellowKey = new YellowKey;
						var yk4:YellowKey = new YellowKey;
						yk1.notCheckExist();
						yk2.notCheckExist();
						yk3.notCheckExist();
						yk4.notCheckExist();
						addChild(yk1);
						addChild(yk2);
						addChild(yk3);
						addChild(yk4);
						yk1.x = catBoss.x;
						yk2.x = catBoss.x;
						yk3.x = catBoss.x;
						yk4.x = catBoss.x;
						yk1.y = catBoss.y - (3 * catBoss.height / 8);
						yk2.y = catBoss.y - (catBoss.height / 8);
						yk3.y = catBoss.y + (catBoss.height / 8);
						yk4.y = catBoss.y + (3 * catBoss.height / 8);
					}
					else if(rand == 5)
					{
						var da1:Drug_Attack = new Drug_Attack;
						var da2:Drug_Attack = new Drug_Attack;
						da1.notCheckExist();
						da2.notCheckExist();
						addChild(da1);
						addChild(da2);
						da1.x = catBoss.x;
						da2.x = catBoss.x;
						da1.y = catBoss.y - (catBoss.height / 4);
						da2.y = catBoss.y + (catBoss.height / 4);
					}
					else if(rand == 6)
					{
						var dd1:Drug_Defend = new Drug_Defend;
						var dd2:Drug_Defend = new Drug_Defend;
						dd1.notCheckExist();
						dd2.notCheckExist();
						addChild(dd1);
						addChild(dd2);
						dd1.x = catBoss.x;
						dd2.x = catBoss.x;
						dd1.y = catBoss.y - (catBoss.height / 4);
						dd2.y = catBoss.y + (catBoss.height / 4);
					}
					else
					{
						var rk:RedKey = new RedKey;
						var bs:BlueSkillStone = new BlueSkillStone;
						rk.notCheckExist();
						bs.notCheckExist();
						addChild(rk);
						addChild(bs);
						rk.x = catBoss.x;
						bs.x = catBoss.x;
						rk.y = catBoss.y - (catBoss.height / 4);
						bs.y = catBoss.y + (catBoss.height / 4);
					}


					if (! catBoss.hasMeeted)
					{
						_player.addEnemyToBook(catBoss.enemyType);
					}
					removeChild(catBoss);
					catBoss = null;
					stage.focus = _player;
				}
			}//fightover
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
						_player.numSkillStones +=  2;
						_messageDialog.change("得到技能晶  X2");
						addChild(_messageDialog);
					}
					else if (type == SkillStones.BLUESKILLSTONE)
					{
						_player.numSkillStones +=  5;
						_messageDialog.change("得到技能晶  X5");
						addChild(_messageDialog);
					}
					else if (type == SkillStones.GREENSKILLSTONE)
					{
						_player.numSkillStones +=  10;
						_messageDialog.change("得到技能晶  X10");
						addChild(_messageDialog);
					}
					removeChild(skillStone);
					_chimes.play();
				}
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

			//special floor
			if (sitCat)
			{
				sitCat.attack = _player.defence + 9;
				sitCat.defence = _player.attack - 9;
			}
			if (moveCat)
			{
				moveCat.attack = _player.defence + 9;
				moveCat.defence = _player.attack - 9;
			}

			for (var i:int = 1; i<=4; ++i)
			{
				if (this["smileCat" + i])
				{
					this["smileCat" + i].attack = _player.defence + 9;
					this["smileCat" + i].defence = _player.attack - 9;
				}
			}

			if ((_player.level & 1) && (getTimer() & 1))
			{
				if (sitCat)
				{
					sitCat.gold = _player.level;
					sitCat.EXP = _player.level;
				}
				if(moveCat)
				{
					moveCat.gold = _player.level;
					moveCat.EXP = _player.level;
				}
				for (i = 1; i<=4; ++i)
				{
					if (this["smileCat" + i])
					{
						this["smileCat" + i].gold = _player.level;
						this["smileCat" + i].EXP = _player.level;
					}
				}
			}
			else
			{
				if (sitCat)
				{
					sitCat.gold = 0;
					sitCat.EXP = 0;
				}
				if(moveCat)
				{
					moveCat.gold = 0;
					moveCat.EXP = 0;
				}
				for (i = 1; i<=4; ++i)
				{
					if (this["smileCat" + i])
					{
						this["smileCat" + i].gold = 0;
						this["smileCat" + i].EXP = 0;
					}
				}
			}
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
			}
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