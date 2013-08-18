package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class Level1 extends MovieClip
	{
		public var scene:int = 2;
		public var numScenes:int = 2;
		public var passScene:Boolean = true;
		public var smoothPassX:int = 0;
		public var smoothPassY:int = 0;
		var controls:Controls;
		var reports:Reports;
		var player:Player;
		var blockList = [];
		var sceneList = []; //:Vector.<MovieClip> = new Vector.<MovieClip>();
		var sceneClip:Object;
		private var smoothScenePass:Boolean = false;
		public var frameSceneChildren:Array;
		var i:uint
		
		public function Level1()
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
			frameSceneChildren = [];
			sceneClip = null;
			
			controls = new Controls();
			addChild(controls);
			controls.x = 400;
			controls.y = 480;
			
			reports = new Reports();
			addChild(reports);
			reports.x = 400;
			reports.y = 0;
		}
		function endLevel():void
		{
			
		}
		function moveForSmoothScenePass():void
		{
			sceneClip.x = smoothPassX;
			sceneClip.y = smoothPassY;
			player.x += smoothPassX;
			player.y += smoothPassY;
		}
		private function onAddedToStage(event:Event):void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			initLevel();
		}
		private function onRemovedFromStage(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			endLevel();
		}
		function frameActions():void
		{
			if (passScene)
			{
				Shared.doPassScene();
				passScene = false;
			}
			if (Shared.checkVisible(player))
			{
				player.frameActions();
			}
			Collision.fluidBoundaries(player, MovieClip(sceneClip));
			for (i = 0; i < frameSceneChildren.length; i++)
			{
				if (frameSceneChildren[i] != null)
				{
					//if object needs block list
					MovieClip(frameSceneChildren[i]).frameActions();
				}
			}
			frameSceneChildren = [];
			blockList = [];
		}
		function onKeyDown(event:KeyboardEvent):void
		{
			//cool level reset
			if (event.keyCode == Keyboard.BACK)
			{
				event.preventDefault();
				Shared.doSmoothScenePass();
			}
		}
		function killLevel():void
		{
			Shared.resetLevel();
		}
		public function dropCoin(value:int, startX:Number, startY:Number, number:uint):void
		{
			var coin1:Coin;
			var startVx:int;
			for (var i:int = 0; i < number; i++)
			{
				startVx = -10 + Math.floor(Math.random() * 21);
				if (startVx > 0)
				{
					startVx += 5;
				}
				else
				{
					startVx -= 5;
				}
				if (value == 1)
				{
					coin1 = new Coin(1, startVx);
				}
				else if (value == 5)
				{
					coin1 = new Coin(5, startVx);
				}
				else
				{
					return;
				}
				sceneClip.addChild(coin1);
				coin1.x = startX;
				coin1.y = startY;
			}
		}
		public function hurtCollision(enemy:MovieClip):void
		{
			Collision.bouncePlayer(player, enemy, 30);
		}
		public function killGrandChildren(object:MovieClip):void
		{
			for (i = 0; i < frameSceneChildren.length; i++)
			{
				if (frameSceneChildren[i] == object)
				{
					var tempArray:Array = [];
					frameSceneChildren[i] = null;
					for (i = 0; i < frameSceneChildren.length; i++)
					{
						if (frameSceneChildren[i] != null)
						{
							tempArray.push(frameSceneChildren[i]);
						}
					}
					frameSceneChildren = [];
					frameSceneChildren = tempArray;
					tempArray = null;
				}
			}
			try
			{
				// remove child from list of all sceneClip children (because instance name not registered as any variable to name)
				for (i = 0; i < sceneClip.numChildren; i++)
				{
					if (sceneClip.getChildAt(i) == object)
					{
						sceneClip.removeChild(object);
						break;
					}
				}
			}
			catch (err:Error)
			{
				trace("error caught by killGrandChildren in Level1: can't remove Child", object.name, "--->", err);
			}
		}
	}
}