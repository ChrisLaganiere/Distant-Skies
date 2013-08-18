package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Wall extends MovieClip
	{
		public function Wall()
		{
			init();
		}
		function init():void
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(event:Event):void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onRemovedFromStage(event:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage)
		}
		function onEnterFrame(event:Event):void
		{
			if (Shared.checkWallVisible(this) == true)
			{
				Main.currentObject.blockList.push(MovieClip(this));
			}
			//if (this.hitTestObject(Main.currentObject.player))
			//{
				//Collision.playerAndPlatform(Main.currentObject.player, this);
			//}
		}
	}
}