package 
{

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	import aeon.AnimationComposite;
	import aeon.animators.Tweener;
	import fl.transitions.easing.*;


	public class ShopShow extends MovieClip
	{

		private var _shopArray:Array;
		private var _priceVector:Vector.<uint > ;
		private var _currentShow:uint;
		private var _player:Player;
		private var _dialog:Dialog_Message;
		private var _isBuyOver:Boolean;


		public function ShopShow(player:Player)
		{
			_player = player;
			_currentShow = 15;
			right.visible = false;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(event:Event)
		{
			init();
			buyButton.addEventListener(MouseEvent.CLICK, onBuyButton);
			buyOverButton.addEventListener(MouseEvent.CLICK, onBuyOverButton);
			left.addEventListener(MouseEvent.CLICK, onLeft);
			right.addEventListener(MouseEvent.CLICK, onRight);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		private function onRemovedFromStage(event:Event)
		{
			destory();
			stage.focus = _player;
			buyButton.removeEventListener(MouseEvent.CLICK, onBuyButton);
			buyOverButton.removeEventListener(MouseEvent.CLICK, onBuyOverButton);
			left.removeEventListener(MouseEvent.CLICK, onLeft);
			right.removeEventListener(MouseEvent.CLICK, onRight);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			//removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		private function onBuyButton(event:Event)
		{
			if (_player.gold < _priceVector[_currentShow])
			{
				_dialog.change("金币不足！");
				addChild(_dialog);
			}
			else
			{
				_player.gold -=  _priceVector[_currentShow];
				if(_currentShow == 0)
				{
					_dialog.change("得到冰魄，与自身融合，攻击+300");
				    addChild(_dialog);
					_player.attack += 300;
				}
				else if(_currentShow == 1)
				{
					_dialog.change("得到圣光盾，与自身融合，防御+250");
				    addChild(_dialog);
					_player.defence += 250;
				}
				else if(_currentShow == 2)
				{
					_dialog.change("得到无影鞋，与自身融合，速度+200");
				    addChild(_dialog);
					_player.speed += 2;
				}
				else if(_currentShow == 3)
				{
					_dialog.change("得到LI'AO的祝福，生命+5000");
				    addChild(_dialog);
					_player.blood += 5000;
				}
				else if(_currentShow == 4)
				{
					_dialog.change("得到无尽之境通行券!");
					addChild(_dialog);
					_player.numTickets ++;
					MovieClip(parent).refreshTickets();
				}
				else if(_currentShow == 5)
				{
					_dialog.change("得到任强的灭世誓言，与自身融合，攻击+100");
				    addChild(_dialog);
					_player.attack += 100;
				}
				else if(_currentShow == 6)
				{
					_dialog.change("得到谷一兵的祈祷，与自身融合，攻击+50");
				    addChild(_dialog);
					_player.attack += 50;
				}
				else if(_currentShow == 7)
				{
					_dialog.change("得到谷一兵的破败之盾，与自身融合，防御+40，速度-100");
				    addChild(_dialog);
					_player.defence += 40;
					if(_player.speed > 1 )
					{
						--_player.speed;
					}
					else
					{
						_player.speed = 0;
					}
				}
				else if(_currentShow == 8)
				{
					_dialog.change("得到风雷魅影，与自身融合，攻击+20");
				    addChild(_dialog);
					_player.attack += 20;
				}
				else if(_currentShow == 9)
				{
					_dialog.change("得到黄金盾，与自身融合，防御+16");
				    addChild(_dialog);
					_player.defence += 16;
				}
				else if(_currentShow == 10)
				{
					_dialog.change("得到青锋剑，与自身融合，攻击+10");
				    addChild(_dialog);
					_player.attack += 10;
				}
				else if(_currentShow == 11)
				{
					_dialog.change("得到青钢盾，与自身融合，防御+8");
				    addChild(_dialog);
					_player.defence += 8;
				}
				else if(_currentShow == 12)
				{
					_dialog.change("得到利刃，与自身融合，攻击+5");
				    addChild(_dialog);
					_player.attack += 5;
				}
				else if(_currentShow == 13)
				{
					_dialog.change("得到铁盾，与自身融合，防御+4");
				    addChild(_dialog);
					_player.defence += 4;
				}
				else if(_currentShow == 14)
				{
					_dialog.change("得到木剑，与自身融合，攻击+3");
				    addChild(_dialog);
					_player.attack += 3;
				}
				else if(_currentShow == 15)
				{
					_dialog.change("得到龟壳盾，与自身融合，防御+2");
				    addChild(_dialog);
					_player.defence += 2;
				}
				MovieClip(parent).refreshProperty();
			}
		}

		private function onBuyOverButton(event:Event)
		{
			_isBuyOver = true;
		}

		private function onLeft(event:Event)
		{
			if (_currentShow == 1)
			{
				left.visible = false;
			}
			if (_currentShow == _shopArray.length - 1)
			{
				right.visible = true;
			}
			if(_currentShow > 0)
			{
                new AnimationComposite([new Tweener(_shopArray[_currentShow],{x:0,alpha:1},{x:800,alpha:0},250),new Tweener(_shopArray[_currentShow - 1],{x:-900,alpha:0},{x:0,alpha:1},250)]).start();
			    --_currentShow;
			}
		}

		private function onRight(event:Event)
		{
			if (_currentShow ==_shopArray.length - 2 )
			{
				right.visible = false;
			}
			if (_currentShow == 0)
			{
				left.visible = true;
			}
			
			if(_currentShow <  _shopArray.length - 1)
			{
			    new AnimationComposite([new Tweener(_shopArray[_currentShow],{x:0,alpha:1},{x:-900,alpha:0},250),new Tweener(_shopArray[_currentShow + 1],{x:800,alpha:0},{x:0,alpha:1},250)]).start();
			    ++_currentShow;
			}
		}
		
		private function onKeyDown(event:KeyboardEvent)
		{
			if(event.keyCode == Keyboard.LEFT)
			{
				onLeft(event);
			}
			else if(event.keyCode == Keyboard.RIGHT)
			{
				onRight(event);
			}
			else if(event.keyCode == Keyboard.ESCAPE)
			{
				onBuyOverButton(event);
			}
			else if(event.keyCode == Keyboard.ENTER)
			{
				onBuyButton(event);
			}
		}

		private function init()
		{
			x = y = 0;
			_isBuyOver = false;
			_shopArray = [bingPoShow,shengGuangShow,wuYingShow,liaoShow,ticketShow,mieShiShow,yiBingShow,yiBingShield,
						  shuangJian,huangJinShow,qingFengShow,qingGangShow,liRenShow,tieDunShow,
						  muJianShow,guiKeDun];
						  
			_priceVector = new <uint>[1000,1000,1000,100,10,380,200,200,90,90,50,50,30,30,20,20];
			//_currentShow = 1;
			_dialog = new Dialog_Message  ;
		}

		private function destory()
		{
			_shopArray = null;
			_dialog = null;
		}

		public function get isBuyOver():Boolean
		{
			return _isBuyOver;
		}

	}

}