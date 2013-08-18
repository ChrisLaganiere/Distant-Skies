package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	public class Bullet extends MovieClip
	{
		private var startX:Number;
		private var startY:Number;
		public var _vx:Number;
		public var _vy:Number;
		public var _type:String;
		public var needsBlocklist:Boolean = true;
		var i:int;
		
		public function Bullet(bullet_vx:Number, bullet_vy:Number, bullet_startX:Number, bullet_startY:Number, bullet_type:Class)
		{
			startX = bullet_startX;
			startY = bullet_startY;
			_vx = bullet_vx;
			_vy = bullet_vy;
			_type = getQualifiedClassName(bullet_type);
			expandVX();
			init();
		}
		function init():void
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(event:Event):void
		{
			this.x = startX;
			this.y = startY;
			gotoAndStop(_type);
			
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onRemovedFromStage(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage)
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		function expandVX():void
		{
			//flip if going left
			if (_vx < 0)
			{
				scaleX = -scaleX;
			}
			//speed bullet up depending on type
			if (_type == "Stick" || _type == "Cannon")
			{
				_vx = _vx*30;
			}
		}
		function death():void
		{
			Shared.kill(this);
		}
		function onEnterFrame(event:Event):void
		{
			//add self to list
			Main.currentObject.frameSceneChildren.push(this);
		}
		public function frameActions():void
		{
			//motion
			this.x += _vx;
			this.y += _vy;
			
			if (Shared.checkVisible(this) == false)
			{
				death();
			}
			for (i = 0; i < Main.currentObject.blockList.length; i++) 
			{
				if (this.hitTestObject(Main.currentObject.blockList[i]))
				{
					death();
				}
			}
			for (i =0; i < Main.currentObject.frameSceneChildren.length; i++) 
			{
				var child:MovieClip;
				child = Main.currentObject.frameSceneChildren[i];
				if (child is Class(Roamer) || child is Class(Miner))
				{
					if (this.hitTestObject(child))
					{
						child.shot();
						death();
					}
				}
			}
		}
	}
}