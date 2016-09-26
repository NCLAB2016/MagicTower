package 
{


	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import flash.system.fscommand;
	import flash.text.TextField;
	
	import aeon.AnimationComposite;
	import aeon.AnimationSequence;
	import aeon.events.AnimationEvent;
	import aeon.animators.Tweener;


	public class StartPage extends MovieClip
	{

		public function StartPage()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(event:Event)
		{
			fadeIn();
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

			words.playButton.enabled = false;
			words.loadButton.enabled = false;
			words.quitButton.enabled = false;
		}
		
		function fadeIn()
		{
			var animationSeq:AnimationSequence = new AnimationSequence(
			   [
				    new Tweener(tower,{y:-500},{y:100},2000,Bounce.easeInOut),
					new Tweener(player,{alpha:0},{alpha:1},2000,Regular.easeInOut),
					new Tweener(words,{alpha:0},{alpha:1},2000)
			    ]   
			);
			animationSeq.addEventListener(AnimationEvent.END, onEnd);
			animationSeq.start();
			function onEnd(event:Event)
			{
				words.playButton.enabled = true;
				words.loadButton.enabled = true;
				words.quitButton.enabled = true;

				words.playButton.addEventListener(MouseEvent.CLICK, onPlayClick);
				words.loadButton.addEventListener(MouseEvent.CLICK, onLoadClick);
				words.quitButton.addEventListener(MouseEvent.CLICK, onQuitClick);
				
				animationSeq.removeEventListener(AnimationEvent.END, onEnd);
				animationSeq = null;
			}
		}


		private function onRemovedFromStage(event:Event)
		{
			words.playButton.removeEventListener(MouseEvent.CLICK, onPlayClick);
			words.loadButton.removeEventListener(MouseEvent.CLICK, onLoadClick);
			words.quitButton.removeEventListener(MouseEvent.CLICK, onQuitClick);
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		private function onQuitClick(event:MouseEvent)
		{
			fscommand("quit");
		}


		private function onPlayClick(event:MouseEvent)
		{
			words.playButton.removeEventListener(MouseEvent.CLICK, onPlayClick);
			words.loadButton.removeEventListener(MouseEvent.CLICK, onLoadClick);
			words.quitButton.removeEventListener(MouseEvent.CLICK, onQuitClick);
			words.playButton.enabled = false;
			words.loadButton.enabled = false;
			words.quitButton.enabled = false;


			//Tower go back;
			var tween:Tween = new Tween(tower,"y",Elastic.easeIn,100,-500,60,false);
			tween.addEventListener(TweenEvent.MOTION_FINISH, onMotionFinish);
			function onMotionFinish(event:Event):void
			{
				tween.removeEventListener(TweenEvent.MOTION_FINISH, onMotionFinish);
				tween = null;
				tween = new Tween(player,"x",Regular.easeInOut,632,173,60,false);;
				tween.addEventListener(TweenEvent.MOTION_FINISH, onPlayerFinish);
			}
			function onPlayerFinish(event:Event):void
			{
				player.scaleX = -1;
				tween.removeEventListener(TweenEvent.MOTION_FINISH, onPlayerFinish);
				tween = null;
				tween = new Tween(words,"alpha",None.easeNone,1,0,60,false);
				tween.addEventListener(TweenEvent.MOTION_FINISH, onWordsDisappear);
			}
			function onWordsDisappear(event:Event)
			{
				removeChild(words);
				tween.removeEventListener(TweenEvent.MOTION_FINISH, onPlayerFinish);
				tween = null;
				var msg:String = "这是一个很古老的故事......\n"+
				                                 "        上古时期，神魔交战不断。灵\n"+
				                                 "图部族因协助天皇伏羲镇压魔族有\n"+
				                                 "功，其子民得以永世居住神界。灵\n"+
				                                 "图部族首领茂森王借助神界无尽灵\n"+
				                                 "力，耗时九百年铸就神器灵图塔，\n"+
				                                 "此塔拥有浩大无俦之力，能降服一\n"+
				                                 "切妖魔鬼怪，神魔之战至此彻底息\n"+
				                                 "止。而灵图塔坠落人间，下落不明\n"+
				                                 "。                         \n"+
				                                 "        而你......额...很抱歉，这一切\n"+
				 "与你无关，你只是一个普通的探险\n"+
				 "家，只不过有一天你突然误闯入一\n"+
				 "座塔就再也出不来罢了......";
				showTextOneByOne(introduction.intro,msg);
			}
		}

		//一个一个字的显示文本
		private function showTextOneByOne(container:TextField,msg:String)
		{
			var timer:Timer = new Timer(100);
			var tween:Tween;
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			timer.start();

			var i:int = 0;
			function onTimer(event:TimerEvent)
			{
				if(i < msg.length)
				{
				    container.appendText(msg.charAt(i));
				}
				++i;
				if (i == msg.length + 30)
				{
					timer.stop();
					timer.removeEventListener(TimerEvent.TIMER, onTimer);
					timer = null;
					tween = new Tween(introduction.intro,"alpha",None.easeNone,1,0,80,false);
					tween.addEventListener(TweenEvent.MOTION_FINISH, onBeginGame);
				}
			}
			function onBeginGame(event:Event)
			{
				tween.removeEventListener(TweenEvent.MOTION_FINISH, onBeginGame);
				tween = null;
				tween = new Tween(player,"x",Elastic.easeIn,173,968,90,false);
				tween.addEventListener(TweenEvent.MOTION_FINISH, onMoveFinished);

			}
			function onMoveFinished(event:Event)
			{
				tween.removeEventListener(TweenEvent.MOTION_FINISH, onBeginGame);
				tween = null;
				MagicTower.gameMode = "selectplay";
			}
		}

		private function onLoadClick(event:MouseEvent)
		{
			MagicTower.gameMode = "selectload";
		}


	}

}