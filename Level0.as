package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.events.MouseEvent;
	Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
	
	public class Level0 extends MovieClip
	{
		public var scene:int;
		private var oldScene:int;
		public var passScene:Boolean;
		
		public function Level0()
		{
			init();
		}
		function init():void
		{
			this.x = 0;
			this.y = 0;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		function initLevel():void
		{
			scene = 1;
			passScene = true;
			playButton.addEventListener(TouchEvent.TOUCH_BEGIN, playTouch);
			playButton.addEventListener(MouseEvent.CLICK, playClick);
		}
		function endLevel():void
		{
			
		}
		private function onAddedToStage(event:Event):void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			initLevel();
		}
		private function onRemovedFromStage(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			endLevel();
		}
		function frameActions():void
		{
			if (passScene)
			{
				doPassScene();
				passScene = false;
			}
		}
		function playTouch(event:TouchEvent):void
		{
			Main.nextLevel = 1;
			killLevel();
		}
		function playClick(event:MouseEvent):void
		{
			Main.nextLevel = 1;
			killLevel();
		}
		function doPassScene():void
		{
			
			if (scene <= 1)
			{
				this.gotoAndStop(String(scene));
			}
		}
		public function killGrandChildren(object:MovieClip):void
		{
			//empty function to avoid error when an object (say, a Roamer) asks to be killed by Shared after it's parent (Level1) is already removed by Main
		}
		function killLevel():void
		{
			Main.nextLevel = 1;
			Shared.resetLevel();
		}
	}
}