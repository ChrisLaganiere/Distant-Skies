package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Roamer extends MovieClip
	{
		public var _vx:Number;
		public var _vy:Number;
		private var hit:Boolean;
		public var gravity:Number;
		public var needsBlocklist:Boolean = true;
		public var health:int = 3;
		var i:int
		
		public function Roamer()
		{
			init();
		}
		function init():void
		{
			gravity = Main.gravityVar;
			_vx = -1;
			_vy = 0;
			hit = false;
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
			this.x += 0.3*Main.speedVar*_vx;
			this.y += _vy;
			_vy += gravity;
			gravity = Main.gravityVar;
			if (_vy > Main.halfBlockHeight)
			{
				_vy = Main.halfBlockHeight;
			}
			if(Main.currentObject.player.collisionArea.hitTestObject(collisionArea) && !hit)
			{
				if (Main.currentObject.player.canBeHurt == true) {
					Main.currentObject.player.bounceHurt(this);
					hit = true;
				}
			}
			if (hit)
			{
				gotoAndPlay("hit");
				hit = false;
			}
			for (i = 0; i < Main.currentObject.blockList.length; i++) 
			{
				if (this.hitTestObject(Main.currentObject.blockList[i]))
				{
					Collision.roamerAndPlatform(this, Main.currentObject.blockList[i]);
				}
			}
		}
		public function shot():void
		{
			if (health > 1)
			{
				hit = true;
				health--;
			}
			else
			{
				death();
			}
		}
		function death():void
		{
			var startX:Number = this.x;
			var startY:Number = this.y;
			var value:int = 1;
			var numberOfCoins:int = 5;
			Main.currentObject.dropCoin(value, startX, startY, numberOfCoins);
			Shared.kill(this);
		}
	}
}