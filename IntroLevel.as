package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
	
	public class IntroLevel extends MovieClip
	{
		private var counter:int;
		
		public function IntroLevel()
		{
			init();
		}
		function init():void
		{
			counter = 0;
			this.x = 0;
			this.y = 0;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		function initLevel():void
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
		}
		function frameActions():void
		{
			if (counter < 30)
			{
				counter++;
			}
			else if (alpha > 0)
			{
				alpha -= .05;
			}
			else
			{
				endLevel();
			}
		}
		function endLevel():void
		{
			Main.nextLevel = 0;
			Shared.resetLevel();
		}
	}
}