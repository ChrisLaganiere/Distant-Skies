package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	public class Player extends MovieClip
	{
		public var _vx:Number;
		public var _vy:Number;
		private var upID:int = -1;
		private var leftID:int = -1;
		private var rightID:int = -1;
		private var shootID:int = -1;
		
		//editable variables
		private var shootCounterLength:int = 3;
		private var hurtCounterLength:int = 30;
		
		//prevent multiple key press with KeyDown
		private var downLeft:Boolean = false;
		private var downRight:Boolean = false;
		private var downUp:Boolean = false;
		private var downSpace:Boolean = false;
		
		//dynamic variables
		private var gravity:Number;
		public var canJump:Boolean;
		public var canBeHurt:Boolean;
		private var direction:String;
		private var shootCounter:uint;
		private var hurtCounter:uint;
		var gun:MovieClip;
		
		public function Player()
		{
			init();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		function init():void
		{
			shootCounter = shootCounterLength;
			hurtCounter = 0;
			direction = "right";
			_vx = 0;
			_vy = 0;
			gravity = Main.gravityVar;
			canJump = true;
			canBeHurt = true;
		}
		private function onAddedToStage(event:Event):void
		{
			gun = new Main.currentGun();
			addChild(gun);
			gun.x = exGun.x;
			gun.y = exGun.y;
			gotoAndStop("stand");
			this.myHighKid.alpha = 0;

			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//Button listeners
			MovieClip(parent).controls.upButton.collisionArea.addEventListener(TouchEvent.TOUCH_BEGIN, upBegin);
			MovieClip(parent).controls.leftButton.collisionArea.addEventListener(TouchEvent.TOUCH_BEGIN, leftBegin);
			MovieClip(parent).controls.rightButton.collisionArea.addEventListener(TouchEvent.TOUCH_BEGIN, rightBegin);
			MovieClip(parent).controls.shootButton.collisionArea.addEventListener(TouchEvent.TOUCH_BEGIN, shootBegin);
			stage.addEventListener(TouchEvent.TOUCH_END, allTouchEnd);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		private function onRemovedFromStage(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage)
			MovieClip(parent).controls.upButton.collisionArea.removeEventListener(TouchEvent.TOUCH_BEGIN, upBegin);
			MovieClip(parent).controls.leftButton.collisionArea.removeEventListener(TouchEvent.TOUCH_BEGIN, leftBegin);
			MovieClip(parent).controls.rightButton.collisionArea.removeEventListener(TouchEvent.TOUCH_BEGIN, rightBegin);
			MovieClip(parent).controls.shootButton.collisionArea.removeEventListener(TouchEvent.TOUCH_BEGIN, shootBegin);
			stage.removeEventListener(TouchEvent.TOUCH_END, allTouchEnd);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}

		function frameActions():void
		{
			if (shootCounter > 0)
			{
				shootCounter--;
			}
			//movement
			x += Main.speedVar*_vx;
			y += _vy;
			_vy += gravity;
			if (_vy > Main.halfBlockHeight)
			{
				_vy = Main.halfBlockHeight;
			}

			//reset changed variables
			canBeHurt = true;
			stabilizeMyAlpha();

			//collisions
			blockAll();

			//gun position
			gun.x = exGun.x;
			gun.y = exGun.y;
		}
		function leftBegin(event:TouchEvent):void
		{
			if(leftID == -1)
			{   
				Main.currentObject.controls.leftButton.alpha = 1;
				_vx = -1;
				leftID = event.touchPointID;
				//flip horizontal
				if (direction == "right")
				{
					scaleX = -scaleX;
					direction = "left";
				}
				this.gotoAndPlay("run");
			}
		}
		function rightBegin(event:TouchEvent):void
		{
			if(rightID == -1)
			{   
				Main.currentObject.controls.rightButton.alpha = 1;
				_vx = 1;
				rightID = event.touchPointID;
				if (direction == "left")
				{
					scaleX = -scaleX;
					direction = "right";
				}
				this.gotoAndPlay("run");
			}
		}
		function upBegin(event:TouchEvent):void
		{
			if(upID == -1)
			{   
				Main.currentObject.controls.upButton.alpha = 1;
				if (canJump)
				{
					_vy = -30;
					gravity--;
					canJump = false;
					upID = event.touchPointID;
				}
			}
		}
		function shootBegin(event:TouchEvent):void
		{
			if(shootID == -1)
			{
				Main.currentObject.controls.shootButton.alpha = 1;
				if (shootCounter == 0)
				{
					fireBullet();
					shootID = event.touchPointID;
					shootCounter = shootCounterLength;
				}
			}
		}
		function onKeyDown(event:KeyboardEvent):void
		{
			//keyboard control 1 - finger down
			if (event.keyCode == Keyboard.LEFT)
			{
				if (!downLeft)
				{
					Main.currentObject.controls.leftButton.alpha = 1;
					_vx = -1;
					//flip horizontal
					if (direction == "right")
					{
						scaleX = -scaleX;
						direction = "left";
					}
					this.gotoAndPlay("run");
				}
				downLeft = true;
			}
			else if (event.keyCode == Keyboard.RIGHT)
			{
				if (!downRight)
				{
					Main.currentObject.controls.rightButton.alpha = 1;
					_vx = 1;
					if (direction == "left")
					{
						scaleX = -scaleX;
						direction = "right";
					}
					this.gotoAndPlay("run");
				}
				downRight = true;
			}
			else if (event.keyCode == Keyboard.UP || event.keyCode == Keyboard.A)
			{
				if (!downUp)
				{
					Main.currentObject.controls.upButton.alpha = 1;
					if (canJump)
					{
						_vy = -30;
						gravity -= .5;
						canJump = false;
					}
				}
				downUp = true;
			}
			else if (event.keyCode == Keyboard.SPACE || event.keyCode == Keyboard.B)
			{
				if (!downSpace)
				{
					Main.currentObject.controls.shootButton.alpha = 1;
					if (shootCounter == 0)
					{
						fireBullet();
						shootCounter = shootCounterLength;
					}
				}
				downSpace = true;
			}
			else if (event.keyCode == Keyboard.K)
			{
				Main.nextLevel = 0;
				Shared.resetLevel();
			}
		}
		function onKeyUp(event:KeyboardEvent):void
		{	
			//keyboard control 2 - finger up
			if (event.keyCode == Keyboard.LEFT)
			{
				if (_vx < 0)
				{
					_vx = 0;
					gotoAndStop("stand");
					this.myHighKid.gotoAndStop("1");
				}
				downLeft = false;
				Main.currentObject.controls.leftButton.alpha = .5;
			}
			else if (event.keyCode == Keyboard.RIGHT)
			{
				if (_vx > 0)
				{
					_vx = 0;
					gotoAndStop("stand");
					this.myHighKid.gotoAndStop("1");
				}
				downRight = false;
				Main.currentObject.controls.rightButton.alpha = .5;
			}
			else if (event.keyCode == Keyboard.UP || event.keyCode == Keyboard.A)
			{
				downUp = false;
				gravity = Main.gravityVar;
				Main.currentObject.controls.upButton.alpha = .5;
			}
			else if (event.keyCode == Keyboard.SPACE || event.keyCode == Keyboard.B)
			{
				downSpace = false;
				Main.currentObject.controls.shootButton.alpha = .5;
			}
		}
		function allTouchEnd(event:TouchEvent):void
		{
			//lifting finger
			if(event.touchPointID == leftID)
			{
				if (_vx < 0)
				{
					_vx = 0;
					gotoAndStop("stand");
					this.myHighKid.gotoAndStop("1");
				}
				leftID = -1;
				Main.currentObject.controls.leftButton.alpha = .5;
			}
			else if(event.touchPointID == rightID)
			{
				if (_vx > 0)
				{
					_vx = 0;
					gotoAndStop("stand");
					this.myHighKid.gotoAndStop("1");
				}
				rightID = -1;
				Main.currentObject.controls.rightButton.alpha = .5;
			}
			else if(event.touchPointID == upID)
			{
				upID = -1;
				gravity = Main.gravityVar;
				Main.currentObject.controls.upButton.alpha = .5;
			}
			else if(event.touchPointID == shootID)
			{
				shootID = -1;
				Main.currentObject.controls.shootButton.alpha = .5;
			}
		}
		private function stabilizeMyAlpha():void
		{
			if (this.alpha < 1) {
				this.alpha += .02;
			}
			if (this.myHighKid) {
				//if (this.myHighKid.alpha > .04 ) {
					this.myHighKid.alpha -= .04;
				//}
				//else {
				//	myHighKid.alpha = 0;
				//}
			}
		}
		public function fireBullet():void
		{
			var bullet_vx:Number;
			var bullet_vy:Number;
			var bullet_startX:Number = x - MovieClip(parent).sceneClip.x + gun.x + gun.exBullet.x;
			var bullet_startY:Number = y - MovieClip(parent).sceneClip.y + gun.y + gun.exBullet.y;
			
			if (direction == "right")
			{
				bullet_vx = 1;
				bullet_vy = 0;
			}
			else if (direction == "left")
			{
				bullet_vx = -1;
				bullet_vy = 0;
			}
			var bullet1:Bullet = new Bullet(bullet_vx, bullet_vy, bullet_startX, bullet_startY, Main.currentGun);
			MovieClip(parent).sceneClip.addChild(bullet1);
		}
		public function hurt():void
		{
			if(hurtCounter == 0 && canBeHurt)
			{
				gotoAndPlay("hurt");
				hurtCounter = hurtCounterLength;
				MovieClip(parent).reports.loseLife();
			}
		}
		public function bounceHurt(enemy:MovieClip):void
		{
			if(hurtCounter == 0)
			{
				gotoAndPlay("hurt");
				hurtCounter = hurtCounterLength;
				MovieClip(parent).hurtCollision(enemy);
				blockAll();
				MovieClip(parent).reports.loseLife();
			}
		}
		function blockAll():void
		{
			for (var i:int = 0; i < Main.currentObject.blockList.length; i++) 
			{
				if (this.hitTestObject(Main.currentObject.blockList[i]))
				{
					//trace("player collision with", Main.currentObject.blockList[i].name);
					Collision.playerAndPlatform(this, Main.currentObject.blockList[i])

					//special collisions
					if (getQualifiedClassName(Main.currentObject.blockList[i]) == "Outcrop") {
						this.alpha = 0.5;
						this.canBeHurt = false;

					}
				}
			}
		}
	}
}