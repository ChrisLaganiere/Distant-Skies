package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Miner extends MovieClip
	{
		public var _vx:Number;
		public var _vy:Number;
		private var hit:Boolean;
		private var gotHim:Boolean;
		public var gravity:Number;
		public var needsBlocklist:Boolean = true;
		var i:int
		
		public function Miner()
		{
			init();
		}
		function init():void
		{
			gravity = Main.gravityVar;
			_vx = 1;
			_vy = 1;
			hit = false;
			gotHim = false;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
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
		public function frameActions():void
		{
			//movement
			this.x += 0.4*Main.speedVar*_vx;
			this.y += _vy;
			_vy += gravity;
			if (_vy > Main.halfBlockHeight)
			{
				_vy = Main.halfBlockHeight;
			}
			if (Main.currentObject.player.canBeHurt) {
				if(touchArea != null && Main.currentObject.player.collisionArea.hitTestObject(touchArea) && !hit)
				{
					gotoAndPlay("expand");
					_vx = 0;
					hit = true;
				}
				if(Main.currentObject.player.collisionArea.hitTestObject(collisionArea) && !gotHim)
				{
					Main.livesLeft = 0;
					Main.currentObject.player.bounceHurt(this);
					gotHim = true;
				}
			}
			for (i = 0; i < Main.currentObject.blockList.length; i++) 
			{
				if (collisionArea.hitTestObject(Main.currentObject.blockList[i]))
				{
					Collision.roamerAndPlatform(this, Main.currentObject.blockList[i])
				}
			}
		}
		public function shot():void
		{
			gotoAndPlay("expand");
			hit = true;
			var startX:Number = this.x;
			var startY:Number = this.y;
			var value:int = 5;
			var numberOfCoins:int = 3;
			Main.currentObject.dropCoin(value, startX, startY, numberOfCoins);
		}
		function death():void
		{
			Shared.kill(this);
		}
	}
}