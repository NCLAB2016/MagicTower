package 
{

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.net.SharedObject;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import flash.events.MouseEvent;
	import flash.display.StageQuality;

	public class MagicTower extends MovieClip
	{
		//游戏状态
		public static var gameMode:String;
		//楼层数组
		private var _floorArray:Array;
		//
		private var _floorOne:FloorOne;
		private var _floorTwo:FloorTwo;
		private var _floorThree:FloorThree;
		private var _floorFour:FloorFour;
		private var _floorFive:FloorFive;
		private var _floorSix:FloorSix;
		private var _floorSeven:FloorSeven;
		private var _floorEight:FloorEight;
		private var _floorNine:FloorNine;
		
		
		
		private var _specialFloor:SpecialFloor;
		//当前楼层
		private var _currentFloor:int;
		//暂停对话框
		private var _pause:Pause;
		//游戏角色
		private var player:Player;
		//角色状态
		private var playerState:State;
		//游戏菜单
		private var _menu:GameMenu;
		//储存游戏数据
		private var _messageDialog:Dialog_Message;
		private var _so:SharedObject;
		
		private var _tween:Tween;
		
		private var _openMenuButton:OpenMenuButton;
		
		//用于控制菜单能否打开
		private var _inSpecialArea:Boolean;
		
		
		//用于星之祝福标记
		private var _hasMarked:Boolean = false;
		private var _markedFloor:int = -1;
		private var _markedX:Number = 0;
		private var _markedY:Number = 0;
		private var _markedFlag:Flag;
		

		public function MagicTower()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			init();
			//stage.quality = StageQuality.MEDIUM;
			addEventListener(Event.DEACTIVATE, onDeactivate);
			addEventListener(Event.ACTIVATE, onActivate);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}

		private function onKeyDown(event:KeyboardEvent)
		{
			if (event.keyCode == Keyboard.Q)
			{
				openMenu();
			}
			else if(event.keyCode == Keyboard.L)
			{
				if(player.hasBottle)
				{
				    useBottle();
				}
			}
		}
		
		private function onBottleClick(event:MouseEvent)
		{
			if(player.hasBottle)
			{
				useBottle();
			}
		}
		
		private function useBottle()
		{
			if(_inSpecialArea)
			{
			     _messageDialog.change("无尽之境非稳定空间，不能使用此功能！");
				 addChild(_messageDialog);
				 return ;
			}
			if(gameMode != "play")
			{
				return ;
			}
			var bottleChoose:BottleChoose;
			if(_hasMarked)
			{
			     bottleChoose = new BottleChoose(_markedFloor); 
			}
			else 
			{
				bottleChoose = new BottleChoose;
			}
			addChild(bottleChoose);
			gameMode = "bottlechoose";
			
			addEventListener(Event.ENTER_FRAME, onWaitBottleChoose);
			function onWaitBottleChoose(event:Event)
			{
				if(bottleChoose.choose == BottleChoose.CANCEL)
				{
					removeChild(bottleChoose);
				    bottleChoose = null;
				    removeEventListener(Event.ENTER_FRAME, onWaitBottleChoose);
					gameMode = "play";
				}
				else if(bottleChoose.choose == BottleChoose.TRANSMIT)
				{
					if(_hasMarked)
					{
						removeChild(_floorArray[_currentFloor]);
						_currentFloor = _markedFloor;
						_floorArray[_currentFloor].stairType = Floor.UP_STAIRS;
						addChild(_floorArray[_currentFloor]);
						player.x = _markedX;
						player.y = _markedY;
						addChild(_openMenuButton);
						removeChild(bottleChoose);
				    	bottleChoose = null;
				    	removeEventListener(Event.ENTER_FRAME, onWaitBottleChoose);
						gameMode = "play";
					}
					else
					{
						_messageDialog.change("没有标记过任何地点，无法传送！");
						addChild(_messageDialog);
						bottleChoose.choose = BottleChoose.NOTCHOOSE;
					}
				}
				else if(bottleChoose.choose == BottleChoose.REMARK)
				{
					_hasMarked = true;
					_markedFloor = _currentFloor;
					_markedX = player.x;
					_markedY = player.y;
					_markedFlag.visible = true;
					_floorArray[_markedFloor].addChild(_markedFlag);
					_markedFlag.x = _markedX;
					_markedFlag.y = _markedY;
					gameMode = "play";
				    _messageDialog.change("标记成功！");
				    addChild(_messageDialog);
					removeChild(bottleChoose);
				    bottleChoose = null;
				    removeEventListener(Event.ENTER_FRAME, onWaitBottleChoose);
				}
			}
			
		}
		
		private function openMenu()
		{ 
			 if (gameMode == "play")
			 {
				_menu = new GameMenu  ;
				addChild(_menu);
				setChildIndex(_menu,numChildren - 1);
				_menu.x = _menu.y = 0;
				gameMode = "openmenu";
				addEventListener(Event.ENTER_FRAME, onWaitMenu);
			 }
			 else if (gameMode == "openmenu")
			 {
				 removeEventListener(Event.ENTER_FRAME, onWaitMenu);
				 removeChild(_menu);
				 _menu = null;
				 gameMode = "play";
			  }
			  function onWaitMenu(event:Event)
			  {
				if (gameMode == "selectload")
				{
					if(_menu)
					{
					    removeChild(_menu);
					}
					_menu = null;
					removeEventListener(Event.ENTER_FRAME, onWaitMenu);
					loadGame();
					gameMode = "play";
				}
				else if (gameMode == "selectsave")
				{
					removeChild(_menu);
					_menu = null;
					removeEventListener(Event.ENTER_FRAME, onWaitMenu);
					
					if(_inSpecialArea)
			        {
						gameMode = "play";
						_messageDialog.change("无尽之境不能存档！");
						addChild(_messageDialog);
						stage.focus = player;
						return;
			 		}
					
					saveData();

                    gameMode = "play";
					stage.focus = player;
					_messageDialog.change("保存成功！");
                    addChild(_messageDialog);
				}
			  }
		}

		private function saveData()
		{
			_so = SharedObject.getLocal("MagicTowerByLiAoSave");

			//储存
			if (! _so.data.playerStateArray)
			{
				_so.data.playerStateArray = new Array();
				_so.data.enemyHasMeetVector = new Vector.<Boolean > (Enemy.NUM_ENEMIES + 1);
				_so.data.floorOneVector = new Vector.<Boolean > (3,true);
			}
			//第一层
			_so.data.floorTwoXVector = null;
			_so.data.floorTwoXVector = new Vector.<Number>();
			_so.data.floorTwoYVector = null;
			_so.data.floorTwoYVector = new Vector.<Number>();
			//第二层
			_so.data.floorThreeXVector = null;
			_so.data.floorThreeXVector = new Vector.<Number>();
			_so.data.floorThreeYVector = null;
			_so.data.floorThreeYVector = new Vector.<Number>();
			//第三层
			_so.data.floorFourXVector = null;
			_so.data.floorFourXVector = new Vector.<Number>();
			_so.data.floorFourYVector = null;
			_so.data.floorFourYVector = new Vector.<Number>();
			//第四层
			_so.data.floorFiveXVector = null;
			_so.data.floorFiveXVector = new Vector.<Number>();
			_so.data.floorFiveYVector = null;
			_so.data.floorFiveYVector = new Vector.<Number>();
			//第五层
			_so.data.floorSixXVector = null;
			_so.data.floorSixXVector = new Vector.<Number>();
			_so.data.floorSixYVector = null;
			_so.data.floorSixYVector = new Vector.<Number>();
			//第六层
			_so.data.floorSevenXVector = null;
			_so.data.floorSevenXVector = new Vector.<Number>();
			_so.data.floorSevenYVector = null;
			_so.data.floorSevenYVector = new Vector.<Number>();
			//第七层
			_so.data.floorEightXVector = null;
			_so.data.floorEightXVector = new Vector.<Number>();
			_so.data.floorEightYVector = null;
			_so.data.floorEightYVector = new Vector.<Number>();
			
			_so.flush();
			_so.close();
			_so = null;
			_so = SharedObject.getLocal("MagicTowerByLiAoSave");

			//储存角色信息
			_so.data.playerStateArray[0] = player.level;
			_so.data.playerStateArray[1] = player.blood;
			_so.data.playerStateArray[2] = player.attack;
			_so.data.playerStateArray[3] = player.defence;
			_so.data.playerStateArray[4] = player.speed;
			_so.data.playerStateArray[5] = player.gold;
			_so.data.playerStateArray[6] = player.EXP;
			_so.data.playerStateArray[7] = player.numYellowKeys;
			_so.data.playerStateArray[8] = player.numRedKeys;
			_so.data.playerStateArray[9] = player.numBlueKeys;
			_so.data.playerStateArray[10] = player.hasBook;
			_so.data.playerStateArray[11] = player.x;
			_so.data.playerStateArray[12] = player.y;
			_so.data.playerStateArray[13] = player.hasYiBingSkill;
			_so.data.playerStateArray[14] = player.hasLiYongSkill;
			_so.data.playerStateArray[15] = player.hasLingTuSkill;
			_so.data.playerStateArray[16] = player.numSkillStones;
			_so.data.playerStateArray[17] = player.numTickets;
			_so.data.playerStateArray[18] = player.hasBottle;
			_so.data.playerStateArray[19] = _hasMarked;
			_so.data.playerStateArray[20] = _markedFloor;
			_so.data.playerStateArray[21] = _markedX;
			_so.data.playerStateArray[22] = _markedY;
			_so.data.playerStateArray[23] = player.hasSolvedMusic;
			_so.data.playerStateArray[24] = player.hasSwing;
			_so.data.playerStateArray[25] = player.hasSolvedMusicTwo;
			_so.data.playerStateArray[26] = player.hasMeetCheshireCat;

			//储存怪物"firstMeet"
			for (var i:int=0; i < player.enemyHasMeetVector.length; ++i)
			{
				_so.data.enemyHasMeetVector[i] = player.enemyHasMeetVector[i];
			}
			//储存第一层数据
			for (i = 0; i < FloorOne.isExist.length; ++i)
			{
				_so.data.floorOneVector[i] = FloorOne.isExist[i];
			}
			
			//储存第二层已经消失的物品坐标
			var eachFun2:Function = function(item:Point, index:int, vector:Vector.<Point>):void 
			{
                 _so.data.floorTwoXVector.push(item.x);
				 _so.data.floorTwoYVector.push(item.y);
             };
			 
            FloorTwo.removedPointVector.forEach(eachFun2);
			
			//Floor Three
			var eachFun3:Function = function(item:Point, index:int, vector:Vector.<Point>):void 
			{
                 _so.data.floorThreeXVector.push(item.x);
				 _so.data.floorThreeYVector.push(item.y);
             };
			 
            FloorThree.removedPointVector.forEach(eachFun3);
			
			//Floor Four
			var eachFun4:Function = function(item:Point, index:int, vector:Vector.<Point>):void 
			{
                 _so.data.floorFourXVector.push(item.x);
				 _so.data.floorFourYVector.push(item.y);
             };
			 
            FloorFour.removedPointVector.forEach(eachFun4);
			
			//Floor Five
			var eachFun5:Function = function(item:Point, index:int, vector:Vector.<Point>):void 
			{
                 _so.data.floorFiveXVector.push(item.x);
				 _so.data.floorFiveYVector.push(item.y);
             };
			 
            FloorFive.removedPointVector.forEach(eachFun5);
			
			//Floor Six
			var eachFun6:Function = function(item:Point, index:int, vector:Vector.<Point>):void 
			{
                 _so.data.floorSixXVector.push(item.x);
				 _so.data.floorSixYVector.push(item.y);
             };
			 
            FloorSix.removedPointVector.forEach(eachFun6);
			
			//Floor Seven
			var eachFun7:Function = function(item:Point, index:int, vector:Vector.<Point>):void 
			{
                 _so.data.floorSevenXVector.push(item.x);
				 _so.data.floorSevenYVector.push(item.y);
             };
			 
			 //Floor Eight
             var eachFun8:Function = function(item:Point, index:int, vector:Vector.<Point>):void 
			{
                 _so.data.floorEightXVector.push(item.x);
				 _so.data.floorEightYVector.push(item.y);
             };
			 
            FloorEight.removedPointVector.forEach(eachFun8);
			
			
			
			_so.data.isGetBook = FloorTwo.isGetBook;

			//储存楼层
			_so.data.currentFloor = _currentFloor;
			_so.flush();
			_so.close();
			_so = null;
		}



		private function onDeactivate(event:Event):void
		{
			addChild( _pause);
			setChildIndex(_pause, numChildren - 1);
			if (gameMode == "play")
			{
				gameMode = "pause";
			}
		}

		private function onActivate(event:Event):void
		{
			if (gameMode == "pause")
			{
				if (contains(_pause))
				{
					removeChild(_pause);
					gameMode = "play";
				}
			}
			else
			{
				if (contains(_pause))
				{
					removeChild(_pause);
				}
			}
		}

		private function gameOver()
		{
			var failure:Failure = new Failure  ;
			var channel = new SoundChannel;
			var failureSound = new FailureSound;
			
			addChild(failure);
			setChildIndex(failure, numChildren - 1);
			channel = failureSound.play();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onWaitQuit);
			stage.addEventListener(MouseEvent.CLICK,onWaitQuit);

			function onWaitQuit(event:Event)
			{
				if(_inSpecialArea)
				{
					_specialFloor.removeChild(player);
					_specialFloor.removeChild(playerState);
					removeChild(_specialFloor);
					_specialFloor = null;
				}
				else
				{
				    _floorArray[_currentFloor].removeChild(player);
				    _floorArray[_currentFloor].removeChild(playerState);
					removeChild(_floorArray[_currentFloor]);
				}
				player = null;
				playerState.bottle.removeEventListener(MouseEvent.CLICK, onBottleClick);
				playerState = null;
				
				for(var i:int = 0; i < _floorArray.length; ++i)
				{
					_floorArray[i] = null;
				}
					
				_floorArray = null;
				removeChild(failure);
				channel.stop();
				channel = null;
				failureSound = null;
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, onWaitQuit);
				stage.removeEventListener(MouseEvent.CLICK, onWaitQuit);
				_inSpecialArea = false;
				gameStart();
			}
		}

		private function init():void
		{
			//缩放模式
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.stageFocusRect = false; 
            _inSpecialArea = false;
			//实例化暂停对话框
			_pause = new Pause  ;
			_markedFlag = new Flag;
			_messageDialog = new Dialog_Message;
            _openMenuButton = new OpenMenuButton;
			_openMenuButton.addEventListener(MouseEvent.CLICK, onOpenMenuButton);
			//游戏模式
			gameMode = "wait";
			gameStart();
			
//			//debug
//			_hasMarked= true;
//		    _markedFloor = 6;
//		    _markedX = 475;
//		    _markedY = 575;
			
			
		}
		
		private function onOpenMenuButton(event:Event)
		{
			openMenu();
			//debug
			//player.gold += 2000;
		}

		//显示游戏开始界面
		private function gameStart()
		{
			var _startPage:StartPage = new StartPage  ;
			addChild(_startPage);
			addEventListener(Event.ENTER_FRAME, onWaitStart);
			function onWaitStart(event:Event)
			{
				if (gameMode == "selectplay")
				{
					newGame();
					removeChild(_startPage);
					_startPage = null;
					removeEventListener(Event.ENTER_FRAME, onWaitStart);
				}
				else if (gameMode == "selectload")
				{
					if (loadGame())
					{
						removeChild(_startPage);
						_startPage = null;
						removeEventListener(Event.ENTER_FRAME, onWaitStart);
					}
					else
					{
						gameMode = "wait";
					}
				}
			}
		}

		private function newGame()
		{
			
			_inSpecialArea = false;
			_markedFlag.visible = false;

			player = new Player();
			playerState = new State();
			playerState.bottle.addEventListener(MouseEvent.CLICK, onBottleClick);

            _floorOne = new FloorOne(player,playerState);
			_floorTwo = new FloorTwo(player,playerState);
			_floorThree = new FloorThree(player, playerState);
			_floorFour = new FloorFour(player, playerState);
			_floorFive = new FloorFive(player, playerState);
			_floorSix = new FloorSix(player, playerState);
			_floorSeven = new FloorSeven(player, playerState);
			_floorEight = new FloorEight(player, playerState);
			_floorNine = new FloorNine(player, playerState);
			
			_floorArray = [_floorOne,_floorTwo, _floorThree, _floorFour,_floorFive, _floorSix, _floorSeven,
						   _floorEight, _floorNine];
			
			_currentFloor = 0;

			_floorArray[_currentFloor].stairType = Floor.UP_STAIRS;
			
			//渐入
			_floorArray[_currentFloor].visible = false;
			addChild(_floorArray[_currentFloor]);
			
			
			var curtain:Curtain = new Curtain;
			addChild(curtain);
			_floorArray[_currentFloor].visible = true;
			
			_tween = new Tween(curtain,"alpha",None.easeNone,1,0,90,false);
			_tween.addEventListener(TweenEvent.MOTION_FINISH, onMotionFinish);
			
			_floorArray[_currentFloor].x = _floorArray[_currentFloor].y = 0;
			
			gameMode = "play";
			function onMotionFinish(event:Event)
			{
				removeChild(curtain);
				addChild(_openMenuButton);
				curtain = null;
				_tween.removeEventListener(TweenEvent.MOTION_FINISH, onMotionFinish);
				_tween = null;
			}
			
		}
		


		private function loadGame():Boolean
		{
			_so = SharedObject.getLocal("MagicTowerByLiAoSave");

			if (! _so.data.playerStateArray)
			{
				gameMode = "wait";
				_messageDialog.change("记录为空！");
				addChild(_messageDialog);
				_so.close();
				_so = null;
				return false;
			}
			else
			{
				if(player != null)
				{
					if(_inSpecialArea)
					{
						_specialFloor.removeChild(player);
						_specialFloor.removeChild(playerState);
						removeChild(_specialFloor);
						_specialFloor = null;
					}
					else
					{
						_floorArray[_currentFloor].removeChild(player);
						_floorArray[_currentFloor].removeChild(playerState);
						removeChild(_floorArray[_currentFloor]);
					}
					removeChild(_openMenuButton);
					player = null;
					playerState.bottle.removeEventListener(MouseEvent.CLICK, onBottleClick);
					playerState = null;
					
					for(i = 0; i < _floorArray.length; ++i)
					{
						_floorArray[i] = null;
					}
					
					_floorArray = null;
				}
			    
				_inSpecialArea = false;
				//加载角色数据
				player = new Player  ;

				player.level = _so.data.playerStateArray[0];
				player.blood = _so.data.playerStateArray[1];
				player.attack = _so.data.playerStateArray[2];
				player.defence = _so.data.playerStateArray[3];
				player.speed = _so.data.playerStateArray[4];
				player.gold = _so.data.playerStateArray[5];
				player.EXP = _so.data.playerStateArray[6];
				player.numYellowKeys = _so.data.playerStateArray[7];
				player.numRedKeys = _so.data.playerStateArray[8];
				player.numBlueKeys = _so.data.playerStateArray[9];
				player.hasBook = _so.data.playerStateArray[10];
				player.saveX = _so.data.playerStateArray[11];
				player.saveY = _so.data.playerStateArray[12];
				player.hasYiBingSkill =_so.data.playerStateArray[13];
			    player.hasLiYongSkill =_so.data.playerStateArray[14];
				player.hasLingTuSkill =_so.data.playerStateArray[15];
				player.numSkillStones =_so.data.playerStateArray[16];
				player.numTickets = _so.data.playerStateArray[17];
				player.hasBottle = _so.data.playerStateArray[18];
			    _hasMarked = _so.data.playerStateArray[19];
			    _markedFloor = _so.data.playerStateArray[20];
			    _markedX = _so.data.playerStateArray[21];
			    _markedY = _so.data.playerStateArray[22];
				player.hasSolvedMusic = _so.data.playerStateArray[23];
				player.hasSwing = _so.data.playerStateArray[24];
				player.hasSolvedMusicTwo = _so.data.playerStateArray[25];
				player.hasMeetCheshireCat = _so.data.playerStateArray[26];

				player.isLoad = true;

				//刷新角色levelUpExp及lastlevelUpExp
				player.refreshLevelUpExp();

				//添加怪物图鉴内容
				for (var i:int=0; i < _so.data.enemyHasMeetVector.length; ++i)
				{
					if (_so.data.enemyHasMeetVector[i])
					{
						player.addEnemyToBook(i);
					}
				}


				playerState = new State();
				playerState.bottle.addEventListener(MouseEvent.CLICK, onBottleClick);

                _floorOne = new FloorOne(player, playerState);
				_floorTwo = new FloorTwo(player, playerState);
				_floorThree = new FloorThree(player, playerState);
				_floorFour = new FloorFour(player, playerState);
				_floorFive = new FloorFive(player, playerState);
				_floorSix = new FloorSix(player, playerState);
				_floorSeven = new FloorSeven(player, playerState);
				_floorEight = new FloorEight(player, playerState);
				_floorNine = new FloorNine(player, playerState);
				
				_floorArray = [_floorOne, _floorTwo, _floorThree, _floorFour, _floorFive, _floorSix, 
							   _floorSeven, _floorEight, _floorNine];
				
				//插星之祝福标志:
				if(_hasMarked)
				{
					_floorArray[_markedFloor].addChild(_markedFlag);
					_markedFlag.x = _markedX;
					_markedFlag.y = _markedY;
				    _markedFlag.visible = true;
				}
				
				//读取floorOne数据
				for (i = 0; i <  _so.data.floorOneVector.length; ++i)
				{
					FloorOne.isExist[i] = _so.data.floorOneVector[i];
				}
				//Floor Two
				for(i = 0; i < _so.data.floorTwoXVector.length; ++i)
				{
					FloorTwo.removedPointVector.push(new Point(_so.data.floorTwoXVector[i],_so.data.floorTwoYVector[i]));
				}
				
				FloorTwo.isGetBook = _so.data.isGetBook;
                //Floor Three
                for(i = 0; i < _so.data.floorThreeXVector.length; ++i)
				{
					FloorThree.removedPointVector.push(new Point(_so.data.floorThreeXVector[i],_so.data.floorThreeYVector[i]));
				}
				//Floor Four
                for(i = 0; i < _so.data.floorFourXVector.length; ++i)
				{
					FloorFour.removedPointVector.push(new Point(_so.data.floorFourXVector[i],_so.data.floorFourYVector[i]));
				}
				//Floor Five
				for(i = 0; i < _so.data.floorFiveXVector.length; ++i)
				{
					FloorFive.removedPointVector.push(new Point(_so.data.floorFiveXVector[i],_so.data.floorFiveYVector[i]));
				}
                //Floor Six
				for(i = 0; i < _so.data.floorSixXVector.length; ++i)
				{
					FloorSix.removedPointVector.push(new Point(_so.data.floorSixXVector[i],_so.data.floorSixYVector[i]));
				}
				
				//Floor Seven
				for(i = 0; i < _so.data.floorSevenXVector.length; ++i)
				{
					FloorSeven.removedPointVector.push(new Point(_so.data.floorSevenXVector[i],_so.data.floorSevenYVector[i]));
				}
				
				//Floor Eight
				for(i = 0; i < _so.data.floorEightXVector.length; ++i)
				{
					FloorEight.removedPointVector.push(new Point(_so.data.floorEightXVector[i],_so.data.floorEightYVector[i]));
				}
				
				_currentFloor = _so.data.currentFloor;

				_floorArray[_currentFloor].stairType = Floor.UP_STAIRS;
				addChild(_floorArray[_currentFloor]);
				_floorArray[_currentFloor].x = _floorArray[_currentFloor].y = 0;
                addChild(_openMenuButton);
				
				gameMode = "play";
				_so.close();
				_so = null;
				return true;
			}
		}
		


		private function onEnterFrame(event:Event):void
		{
			if (gameMode == "play")
			{
				if(_openMenuButton.visible == false)
				{
					_openMenuButton.visible = true;
				}
				if(!_inSpecialArea)
				{
					if (_floorArray[_currentFloor].isUp == true)
					{
						removeChild(_floorArray[_currentFloor]);
						++_currentFloor;
						_floorArray[_currentFloor].stairType = Floor.UP_STAIRS;
						addChild(_floorArray[_currentFloor]);
						addChild(_openMenuButton);
					}
					if (_floorArray[_currentFloor].isDown == true)
					{
						removeChild(_floorArray[_currentFloor]);
						--_currentFloor;
						_floorArray[_currentFloor].stairType = Floor.DOWN_STAIRS;
						addChild(_floorArray[_currentFloor]);
						addChild(_openMenuButton);
					}

					if (_floorArray[_currentFloor].isGameOver)
					{
						if (gameMode == "play")
						{
							gameOver();
							gameMode = "failure";
						}
					}
				}//not in special area
				else
				{
					if(_specialFloor.isGameOver)
					{
						if (gameMode == "play")
						{
							gameOver();
							gameMode = "failure";
						}
					}
				}//in special area
			}//End gameMode=="play"
            else
			{
				if(gameMode != "openmenu" && _openMenuButton.visible)
				{
					_openMenuButton.visible = false;
				}
				if(gameMode == "enterspecialfloor")
				{
					_inSpecialArea = true;
					removeChild(_floorArray[_currentFloor]);
					_specialFloor = new SpecialFloor(player,playerState);
					addChild(_specialFloor);
					addChild(_openMenuButton);
					gameMode = "play";
				}
				if(gameMode == "exitfromspecialfloor")
				{
					_inSpecialArea = false;
					removeChild(_specialFloor);
					_specialFloor = null;
					_floorArray[_currentFloor].stairType = Floor.UP_STAIRS;
					addChild(_floorArray[_currentFloor]);
					addChild(_openMenuButton);
					gameMode = "play";
				}
			}
		}//End EnterFrame

	}
}