package 
{

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import fl.transitions.easing.*;
    import flash.events.MouseEvent;
	import flash.ui.MouseCursor;
	import flash.ui.Mouse;
	
	import aeon.AnimationSequence;
	import aeon.AnimationComposite;
	import aeon.animators.Tweener;
	import aeon.events.AnimationEvent;


	public class FightPage extends MovieClip
	{


		private var _enemy:MovieClip;
		private var _enShow:MovieClip;
		private var _player:MovieClip;
		private var _isAuto:Boolean;
		private var timer:Timer;
		private var _message:Dialog_Message;

		public function FightPage(pl:MovieClip,en:MovieClip)
		{
			_player = pl;
			_enemy = en;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(event:Event)
		{
			init();
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		private function onRemovedFromStage(event:Event)
		{
			if (_enShow != null)
			{
				removeChild(_enShow);
			}
			_enShow = null;
			_player = null;
			_enemy = null;
			_message = null;
			if(timer != null)
			{
				timer.removeEventListener(TimerEvent.TIMER, onTimer);
				timer = null;
			}
			if(Mouse.cursor != MouseCursor.AUTO)
			{
			    Mouse.cursor =MouseCursor.AUTO;
			}
			attack.removeEventListener(MouseEvent.CLICK, onAttack);
			skill.removeEventListener(MouseEvent.CLICK,onSkill);
			autoFight.removeEventListener(MouseEvent.CLICK, onAutoFight);
			autoFight.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			autoFight.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			yiBingSkillIcon.removeEventListener(MouseEvent.CLICK, onYiBingSkill);
			liYongSkillIcon.removeEventListener(MouseEvent.CLICK, onLiYongSkill);
			lingTuSkillIcon.removeEventListener(MouseEvent.CLICK, onLingTuSkill);
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		private function init()
		{
			yiBingSkillIcon.visible = false;
			liYongSkillIcon.visible = false;
			lingTuSkillIcon.visible = false;
			
			_message = new Dialog_Message;
			
			skillLabel.text = "技能晶：" + _player.numSkillStones;
							
			timer = new Timer(50);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			
			_isAuto = false;
			
			if (_enemy.enemyType == Enemy.SMALL_GHOST)
			{
				_enShow = new SmallGhostShow  ;
			}
			else if (_enemy.enemyType == Enemy.BIG_GHOST)
			{
				_enShow = new BigGhostShow  ;
			}
			else if (_enemy.enemyType == Enemy.SMALL_ENCHANTER)
			{
				_enShow = new SmallEnchanterShow  ;
			}
			else if(_enemy.enemyType == Enemy.RABBIT)
			{
				_enShow = new RabbitShow;
			}
			else if(_enemy.enemyType == Enemy.SCORPION)
			{
				_enShow = new ScorpionShow;
			}
			else if(_enemy.enemyType == Enemy.BAIZE)
			{
				_enShow = new BaiZeShow;
			}
			else if(_enemy.enemyType == Enemy.SNAKE)
			{
				_enShow = new SnakeShow;
			}
			else if(_enemy.enemyType == Enemy.FIREFLY)
			{
				_enShow = new FireflyShow;
			}
			else if(_enemy.enemyType == Enemy.FLYPIG)
			{
				_enShow = new FlyPigShow;
			}
			else if(_enemy.enemyType == Enemy.CAT)
			{
				_enShow = new CatShow;
			}
			else if(_enemy.enemyType == Enemy.DOG)
			{
				_enShow = new DogShow;
			}
			else if(_enemy.enemyType == Enemy.CheshireCat)
			{
				_enShow = new CheshireCatShow;
			}

			addChild(_enShow);
			//swapChildren(_enShow,enemyBlood);
            setChildIndex(_enShow, 1);
			
			_enShow.x = -200;
			_enShow.y = 312;

			alpha = 0;

            var animation:AnimationSequence = 
			new AnimationSequence(
				[  
				    new Tweener(this,{alpha:0},{alpha:1},1000),
				    new AnimationComposite(
						[   
						    new Tweener(player,{x:972},{x:628},1000,Strong.easeInOut),
						    new Tweener(_enShow,{x:-200},{x:160},1000,Strong.easeInOut)
						]
					),
					new AnimationComposite(
						[
						    new Tweener(attack,{y:-110,alpha:0},{y:280,alpha:1},500,Bounce.easeInOut),
							new Tweener(skill,{y:710,alpha:0},{y:320,alpha:1},500,Bounce.easeInOut)
						]				   
					),
					new Tweener(autoFight,{alpha:0},{alpha:1},1000,None.easeNone)
				]
			);
			
			
			attack.enabled = false;
			skill.enabled = false;
			autoFight.enabled = false;
			
			animation.addEventListener(AnimationEvent.END,onShowButtonEnd);
			
			animation.start();
			
			function onShowButtonEnd(event:AnimationEvent)
			{
				enemyBlood.text = _enemy.blood;
			    playerBlood.text = _player.blood;
				
			    attack.enabled = true;
			    skill.enabled = true;
				attack.addEventListener(MouseEvent.CLICK, onAttack);
				skill.addEventListener(MouseEvent.CLICK,onSkill);
				autoFight.addEventListener(MouseEvent.CLICK, onAutoFight);
				autoFight.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				autoFight.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				
				animation.removeEventListener(AnimationEvent.END,onShowButtonEnd);
				animation = null;
			}
		}
		private function onMouseOver(event:MouseEvent)
		{
			if(Mouse.cursor != MouseCursor.BUTTON)
			{
			    Mouse.cursor =MouseCursor.BUTTON;
			}
		}
		private function onMouseOut(event:MouseEvent)
		{
			if(Mouse.cursor != MouseCursor.AUTO)
			{
			    Mouse.cursor =MouseCursor.AUTO;
			}
		}
		private function onAttack(event:MouseEvent)
		{
			attack.visible = false;
			skill.visible = false;
			autoFight.visible = false;
			
			yiBingSkillIcon.visible = false;
			liYongSkillIcon.visible = false;
			lingTuSkillIcon.visible = false;
			
			enemyLose.alpha = 0;
			playerLose.alpha = 0;
			
			if(_player.attack > _enemy.defence)
			{
			    enemyLose.text = String(_player.attack - _enemy.defence);
			}
			else
			{
				enemyLose.text = "0";
			}
			
			if(_enemy.attack > _player.defence)
			{
				playerLose.text = String(_enemy.attack - _player.defence);
			}
			else
			{
				playerLose.text = "0";
			}
			
			var animationSequence:AnimationSequence = 
			new AnimationSequence(
				[
				      new Tweener(player,{x:player.x,alpha:1},{x:_enShow.x + _enShow.width/2,alpha:0.5},200),
					  new Tweener(player,{x:player.x,alpha:0.5},{x:628,alpha:1},100),
					  new Tweener(enemyLose,{y:144,alpha:1},{y:0,alpha:0},500)
				]  
			);
			
			animationSequence.addEventListener(AnimationEvent.END, onAnimationEnd);
			
			animationSequence.start();
			function onAnimationEnd(event:AnimationEvent)
			{
				animationSequence.removeEventListener(AnimationEvent.END, onAnimationEnd);
				animationSequence = null;
				
			    if (_player.attack > _enemy.defence)
				{
					_enemy.blood -= (_player.attack - _enemy.defence);
				}
				if(_enemy.blood <= 0)
				{
					enemyBlood.text = "0";
					MagicTower.gameMode = "fightover";
				}
				else
				{
				    enemyBlood.text = _enemy.blood;
					animationSequence = new AnimationSequence(
					[
						 new Tweener(_enShow,{x:_enShow.x,alpha:1},{x:player.x - player.width/2,alpha:0.5},200),
					 	 new Tweener(_enShow,{x:_enShow.x,alpha:0.5},{x:160,alpha:1},100),
					  	 new Tweener(playerLose,{y:144,alpha:1},{y:0,alpha:0},500)  
			     	]
					);
					animationSequence.addEventListener(AnimationEvent.END, onEnemyAttack);
					animationSequence.start();
				
					function onEnemyAttack(event:Event)
					{
				   	 	if (_enemy.attack > _player.defence)
				    	{
					    	_player.blood -= (_enemy.attack - _player.defence);
						}
						if(_player.blood <=0)
						{
							playerBlood.text = "0";
							MagicTower.gameMode = "fightover";
						}
						else
						{
							playerBlood.text = _player.blood;
							attack.visible = true;
			                skill.visible = true;
				            autoFight.visible = true;
						}
						animationSequence.removeEventListener(AnimationEvent.END, onEnemyAttack);
				    	animationSequence = null;
					}
				}//
			}
		}

		
		private function onSkill(event:MouseEvent)
		{
			if(!_player.hasYiBingSkill && !_player.hasLiYongSkill && !_player.hasLingTuSkill)
			{
				_message.change("没有任何技能！");
				addChild(_message);
				return ;
			}
			
			skill.visible = false;
			
		    if(_player.hasYiBingSkill)
			{
				yiBingSkillIcon.visible = true;
				yiBingSkillIcon.addEventListener(MouseEvent.CLICK, onYiBingSkill);
			}
			if(_player.hasLiYongSkill)
			{
				liYongSkillIcon.visible = true;
			    liYongSkillIcon.addEventListener(MouseEvent.CLICK, onLiYongSkill);
			}
			
			if(_player.hasLingTuSkill)
			{
				lingTuSkillIcon.visible = true;
				lingTuSkillIcon.addEventListener(MouseEvent.CLICK, onLingTuSkill);
			}
		}
		
		private function onYiBingSkill(event:Event)
		{
			yiBingSkillIcon.visible = false;
			liYongSkillIcon.visible = false;
			lingTuSkillIcon.visible = false;
			
			
			if(_player.numSkillStones < 2)
			{
				_message.change("技能晶少于2个，不能释放！");
				addChild(_message);
				return;
			}
			
			
			_player.numSkillStones -= 2;
			
			yiBingSkillShow.alpha = 1;
			skillLabel.text = "谷一兵之怒";
			
			attack.visible = false;
			skill.visible = false;
			autoFight.visible = false;
			
			enemyLose.alpha = 0;
			playerLose.alpha = 0;
			
			if(_player.yiBingSkillAttack > _enemy.defence)
			{
			    enemyLose.text = String(_player.yiBingSkillAttack - _enemy.defence);
			}
			else
			{
				enemyLose.text = "0";
			}
			
			if(_enemy.attack > _player.defence)
			{
				playerLose.text = String(_enemy.attack - _player.defence);
			}
			else
			{
				playerLose.text = "0";
			}
			
			
			var animationSeq:AnimationSequence = 
			    new AnimationSequence(
				[
					new Tweener(yiBingSkillShow,{y:-215},{y:312},200),
					new Tweener(yiBingSkillShow,{alpha:1},{alpha:0},100),
				    new Tweener(enemyLose,{y:144,alpha:1},{y:0,alpha:0},500)
		        ]
			);
			animationSeq.start();
			animationSeq.addEventListener(AnimationEvent.END,onYiBingEnd);
			
			function onYiBingEnd(event:Event)
			{
				skillLabel.text = "技能晶：" + _player.numSkillStones;
				
				animationSeq.removeEventListener(AnimationEvent.END,onYiBingEnd);
				yiBingSkillIcon.removeEventListener(MouseEvent.CLICK, onYiBingSkill);
				animationSeq = null;
				
				
				if (_player.yiBingSkillAttack > _enemy.defence)
				{
					_enemy.blood -= (_player.yiBingSkillAttack - _enemy.defence);
				}
				if(_enemy.blood <= 0)
				{
					enemyBlood.text = "0";
					attack.visible = false;
					skill.visible = false;
					autoFight.visible = false;
					MagicTower.gameMode = "fightover";
				}
				else
				{
					enemyBlood.text = _enemy.blood;
					animationSeq = new AnimationSequence(
					[
						 new Tweener(_enShow,{x:_enShow.x,alpha:1},{x:player.x - player.width/2,alpha:0.5},200),
					 	 new Tweener(_enShow,{x:_enShow.x,alpha:0.5},{x:160,alpha:1},100),
					  	 new Tweener(playerLose,{y:144,alpha:1},{y:0,alpha:0},500)  
			     	]
					);
					animationSeq.addEventListener(AnimationEvent.END, onEnemyAttack);
					animationSeq.start();
				
					function onEnemyAttack(event:Event)
					{
				   	 	if (_enemy != null && _player!= null && _enemy.attack > _player.defence)
				    	{
					    	_player.blood -= (_enemy.attack - _player.defence);
						}
						if(_player.blood <=0)
						{
							playerBlood.text = "0";
							attack.visible = false;
					        skill.visible = false;
					        autoFight.visible = false;
							MagicTower.gameMode = "fightover";
						}
						else
						{
							playerBlood.text = _player.blood;
							attack.visible = true;
			                skill.visible = true;
				            autoFight.visible = true;
						}
						animationSeq.removeEventListener(AnimationEvent.END, onEnemyAttack);
				    	animationSeq = null;
					}
				}
			}
		}
		
		private function onLiYongSkill(event:MouseEvent)
		{
			yiBingSkillIcon.visible = false;
			liYongSkillIcon.visible = false;
			lingTuSkillIcon.visible = false;
			
			if(_player.numSkillStones < 3)
			{
				_message.change("技能晶少于3个，不能释放！");
				addChild(_message);
				return;
			}
			
			_player.numSkillStones -= 3;
			
			
			skillLabel.text = "李勇的颂歌";
			
			attack.visible = false;
			skill.visible = false;
			autoFight.visible = false;
			
			enemyLose.alpha = 0;
			playerLose.alpha = 0;
			
			if(_player.liYongSkillAttack > _enemy.defence)
			{
			    enemyLose.text = String(_player.liYongSkillAttack - _enemy.defence);
			}
			else
			{
				enemyLose.text = "0";
			}
			
			if(_enemy.attack > _player.defence)
			{
				playerLose.text = String(_enemy.attack - _player.defence);
			}
			else
			{
				playerLose.text = "0";
			}
			
			
			var animationSeq:AnimationSequence = 
			    new AnimationSequence(
				[
					new Tweener(liYongSkillShow,{x:1200},{x:-600},300),
				    new Tweener(enemyLose,{y:144,alpha:1},{y:0,alpha:0},500)
		        ]
			);
			animationSeq.start();
			animationSeq.addEventListener(AnimationEvent.END,onLiYongEnd);
			
			function onLiYongEnd(event:Event)
			{
				skillLabel.text = "技能晶：" + _player.numSkillStones;
				
				animationSeq.removeEventListener(AnimationEvent.END,onLiYongEnd);
				liYongSkillIcon.removeEventListener(MouseEvent.CLICK, onLiYongSkill);
				animationSeq = null;
				
				
				if (_player.liYongSkillAttack > _enemy.defence)
				{
					_enemy.blood -= (_player.liYongSkillAttack - _enemy.defence);
				}
				if(_enemy.blood <= 0)
				{
					enemyBlood.text = "0";
					attack.visible = false;
					skill.visible = false;
					autoFight.visible = false;
					MagicTower.gameMode = "fightover";
				}
				else
				{
					enemyBlood.text = _enemy.blood;
					animationSeq = new AnimationSequence(
					[
						 new Tweener(_enShow,{x:_enShow.x,alpha:1},{x:player.x - player.width/2,alpha:0.5},200),
					 	 new Tweener(_enShow,{x:_enShow.x,alpha:0.5},{x:160,alpha:1},100),
					  	 new Tweener(playerLose,{y:144,alpha:1},{y:0,alpha:0},500)  
			     	]
					);
					animationSeq.addEventListener(AnimationEvent.END, onEnemyAttack);
					animationSeq.start();
				
					function onEnemyAttack(event:Event)
					{
				   	 	if (_enemy.attack > _player.defence)
				    	{
					    	_player.blood -= (_enemy.attack - _player.defence);
						}
						if(_player.blood <=0)
						{
							playerBlood.text = "0";
							attack.visible = false;
					        skill.visible = false;
					        autoFight.visible = false;
							MagicTower.gameMode = "fightover";
						}
						else
						{
							playerBlood.text = _player.blood;
							attack.visible = true;
			    			skill.visible = true;
							autoFight.visible = true;
						}
						animationSeq.removeEventListener(AnimationEvent.END, onEnemyAttack);
				    	animationSeq = null;
					}
				}
			}
		}
		
		private function onLingTuSkill(event:MouseEvent)
		{
			yiBingSkillIcon.visible = false;
			liYongSkillIcon.visible = false;
			lingTuSkillIcon.visible = false;
			
			if(_player.numSkillStones < 5)
			{
				_message.change("技能晶少于5个，不能释放！");
				addChild(_message);
				return;
			}
			
			_player.numSkillStones -= 5;
			
			skillLabel.text = "灵图剑阵";
			
			attack.visible = false;
			skill.visible = false;
			autoFight.visible = false;
			
			enemyLose.alpha = 0;
			playerLose.alpha = 0;
			
			if(_player.lingTuSkillAttack > _enemy.defence)
			{
			    enemyLose.text = String(_player.lingTuSkillAttack - _enemy.defence);
			}
			else
			{
				enemyLose.text = "0";
			}
			
			if(_enemy.attack > _player.defence)
			{
				playerLose.text = String(_enemy.attack - _player.defence);
			}
			else
			{
				playerLose.text = "0";
			}
			
			var lingTuSkillShow:LingTuSkillShow = new LingTuSkillShow;
			lingTuSkillShow.alpha = 0;
			lingTuSkillShow.x = 0;
			lingTuSkillShow.y = 100;
			addChild(lingTuSkillShow);
			
			var animationSeq:AnimationSequence = 
			    new AnimationSequence(
				[
				    new AnimationComposite([
					new Tweener(lingTuSkillShow,{alpha:1},{alpha:0},500),
					new Tweener(lingTuSkill_Sword,{y:-354},{y:954},500)]),
				    new Tweener(enemyLose,{y:144,alpha:1},{y:0,alpha:0},500)
		        ]
			);
			animationSeq.start();
			animationSeq.addEventListener(AnimationEvent.END,onLingTuEnd);
			
			function onLingTuEnd(event:Event)
			{
				
				removeChild(lingTuSkillShow);
				lingTuSkillShow = null;
				
				skillLabel.text = "技能晶：" + _player.numSkillStones;
				
				animationSeq.removeEventListener(AnimationEvent.END,onLingTuEnd);
				lingTuSkillIcon.removeEventListener(MouseEvent.CLICK, onLingTuSkill);
				animationSeq = null;
				
				
				if (_player.lingTuSkillAttack > _enemy.defence)
				{
					_enemy.blood -= (_player.lingTuSkillAttack - _enemy.defence);
				}
				if(_enemy.blood <= 0)
				{
					enemyBlood.text = "0";
				    attack.visible = false;
					skill.visible = false;
					autoFight.visible = false;
					MagicTower.gameMode = "fightover";
				}
				else
				{
					enemyBlood.text = _enemy.blood;
					animationSeq = new AnimationSequence(
					[
						 new Tweener(_enShow,{x:_enShow.x,alpha:1},{x:player.x - player.width/2,alpha:0.5},200),
					 	 new Tweener(_enShow,{x:_enShow.x,alpha:0.5},{x:160,alpha:1},100),
					  	 new Tweener(playerLose,{y:144,alpha:1},{y:0,alpha:0},500)  
			     	]
					);
					animationSeq.addEventListener(AnimationEvent.END, onEnemyAttack);
					animationSeq.start();
				
					function onEnemyAttack(event:Event)
					{
				   	 	if (_enemy.attack > _player.defence)
				    	{
					    	_player.blood -= (_enemy.attack - _player.defence);
						}
						if(_player.blood <=0)
						{
							playerBlood.text = "0";
							attack.visible = false;
					        skill.visible = false;
					        autoFight.visible = false;
							MagicTower.gameMode = "fightover";
						}
						else
						{
							playerBlood.text = _player.blood;
							attack.visible = true;
			    			skill.visible = true;
							autoFight.visible = true;
						}
						animationSeq.removeEventListener(AnimationEvent.END, onEnemyAttack);
				    	animationSeq = null;
					}
				}
			}			
		}
		
		private function onAutoFight(event:MouseEvent)
		{
			yiBingSkillIcon.visible = false;
			liYongSkillIcon.visible = false;
			lingTuSkillIcon.visible = false;
			
			if(!_isAuto)
			{
				attack.visible = false;
			    skill.visible = false;
				_isAuto = true;
				autoFight.title1.text = "停止";
				if(timer)
				{
			        timer.start();
				}
			}
			else
			{
				if(timer)
				{
				    timer.stop();
				}
				autoFight.title1.text = "自动战斗";
				attack.visible = true;
			    skill.visible = true;
				_isAuto = false;
				
			}
		}
		
		function onTimer(event:TimerEvent)
	    {
		    if (_player.blood > 0 && _enemy.blood > 0)
			{
			    if (_enemy.attack > _player.defence)
			    {
					  _player.blood -= (_enemy.attack - _player.defence);
				}
			    if (_player.attack > _enemy.defence)
				{
				      _enemy.blood -= (_player.attack - _enemy.defence);
				}
				else
				{
				     _player.blood = 0;
				}
				
				if(_enemy.blood < 0)
				{
					enemyBlood.text = "0";
				}
				else
				{
				    enemyBlood.text = _enemy.blood;
				}
				
				if(_player.blood < 0)
				{
					playerBlood.text = "0";
				}
				else
				{
				    playerBlood.text = _player.blood;
				}
				if (_player.blood <= 0 || _enemy.blood <= 0)
				{
					timer.stop();
				    timer.removeEventListener(TimerEvent.TIMER, onTimer);
					timer = null;
					attack.visible = false;
					skill.visible = false;
					autoFight.visible = false;
					MagicTower.gameMode = "fightover";
				}
			}
			else
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, onTimer);
				timer = null;
				MagicTower.gameMode = "fightover";
			}
		}
	}

}

