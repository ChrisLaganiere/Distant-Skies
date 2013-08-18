package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Coin extends MovieClip
	{
		private var hit:Boolean;
		public var needsBlocklist:Boolean = true;;
		public var gravity:Number;
		public var _vy:Number;
		public var _vx:Number;
		private var value:int;
		
		public function Coin(startValue:int, startVx:Number)
		{
			_vx = startVx;
			_vy = -Math.abs(startVx);
			if (startValue == 1)
			{
				value = 1;
				init();
			}
			else if (startValue == 5)
			{
				value = 5;
				init();
			}
		}
		function init():void
		{
			hit = false;
			gravity = Main.gravityVar;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			gotoAndStop(value + "up");
		}
		private function onAddedToStage(event:Event):void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		private function onRemovedFromStage(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		function onEnterFrame(event:Event):void
		{
			if (Shared.checkVisible(this) == true)
			{
				//add self to list
				Main.currentObject.frameSceneChildren.push(MovieClip(this));
			}
		}
		function frameActions():void
		{
			if(Main.currentObject.player.collisionArea.hitTestObject(this) && !hit)
			{
				gotoAndPlay(value + "down");
				_vy = 0;
				hit = true;
			}
			//gravity
			this.y += _vy;
			this.x += _vx;
			_vy += gravity;
			if (_vy > Main.halfBlockHeight)
			{
				_vy = Main.halfBlockHeight;
			}
			//block
			for (var i:int = 0; i < Main.currentObject.blockList.length; i++) 
			{
				if (this.hitTestObject(Main.currentObject.blockList[i]))
				{
					Collision.block(this, Main.currentObject.blockList[i])
				}
			}
			//stabilize horizontal
			if (_vy == 0 && _vx !=  0)
			{
				if (_vx > gravity)
				{
					_vx -= gravity;
				}
				else if (_vx < -gravity)
				{
					_vx += gravity;
				}
				else
				{
					_vx = 0;
				}
			}
		}
		function killMe():void
		{
			Main.score += value;
			Shared.kill(this);
		}
	}
}