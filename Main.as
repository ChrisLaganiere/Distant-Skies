package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.geom.Point;
	Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
	
	public class Main extends MovieClip
	{
		private var currentLevel:int
		public static var currentPlayer:Class;
		public static var currentGun:Class
		public static var nextLevel:int;
		public static var startLevel:Boolean;
		public static var endLevel:Boolean;
		public static var currentObject:Object;
		public static var skipToScene:Boolean;
		public static var nexScene:int;
		public static var speedVar:Number;
		public static var gravityVar:Number;
		public static var halfBlockHeight:int;
		public static var halfStageWidth:uint;
		public static var halfStageHeight:uint;
		public static var lives:int;
		public static var livesLeft:int;
		public static var score:int;
		public static var gameIsOver:Boolean;
		
		//for smooth pass
		public static var smoothPass:Boolean = false;
		public static var passX:Number = 0;
		public static var passY:Number = 0;
		
		var introLevel:IntroLevel;
		var level0:Level0;
		var level1:Level1;
		
		public function Main()
		{
			init();
		}
		function init():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			
			currentLevel = -1;
			currentPlayer = Basil;
			lives = 4;
			livesLeft = 4;
			score = 0;
			currentGun = Cannon;
			nextLevel = -1;
			startLevel = true;
			endLevel = false;
			speedVar = 10;
			gravityVar = 3;
			halfBlockHeight = 64;
			halfStageWidth = 400;
			halfStageHeight = 240;
			gameIsOver = false;
		}
		function onEnterFrame(event:Event):void
		{
			if (endLevel)
			{
				doEndLevel();
				endLevel = false;
			}
			if (startLevel)
			{
				currentLevel = nextLevel;
				doStartLevel();
				startLevel = false;
			}
			if (skipToScene)
			{
				passLevelScene();
			}
			//make screen go to black
			if (!gameIsOver)
			{
				currentObject.frameActions();
			}
			else if (currentObject.sceneClip.alpha >= .03) {
				currentObject.sceneClip.alpha -= .02;
				currentObject.bg.alpha -= .02;
			}
			else {
				livesLeft = lives;
				score = 0;
				
				nextLevel = 0;
				endLevel = true;
				startLevel = true;
				gameIsOver = false;
			}
		}
		
		function doEndLevel():void
		{
			if (currentLevel == -1)
			{
				endIntroLevel();
			}
			else if (currentLevel == 0)
			{
				endLevel0();
			}
			else if (currentLevel == 1)
			{
				endLevel1();
			}
		}
		function doStartLevel():void
		{
			if (currentLevel == -1)
			{
				startIntroLevel();
			}
			else if (currentLevel == 0)
			{
				startLevel0();
			}
			else if (currentLevel == 1)
			{
				startLevel1();
			}
		}
		function passLevelScene():void
		{
			currentObject.scene = nexScene;
			currentObject.passScene = false;
			Shared.doPassScene();
			skipToScene = false;
			nexScene = 1;
			if (smoothPass)
			{
				currentObject.smoothPassX = passX;
				currentObject.smoothPassY = passY;
				currentObject.moveForSmoothScenePass();
				trace("passX , passY:",passX,",",passY);
				passX = 0;
				passY = 0;
			}
		}
		function startIntroLevel():void
		{
			introLevel = new IntroLevel();
			addChild(introLevel);
			currentObject = introLevel;
		}
		function endIntroLevel():void
		{
			removeChild(introLevel);
			introLevel = null;
			currentObject = null;
		}
		function startLevel0():void
		{
			level0 = new Level0();
			addChild(level0);
			currentObject = level0;
		}
		function endLevel0():void
		{
			removeChild(level0);
			level0 = null;
			currentObject = null;
		}
		function startLevel1():void
		{
			level1 = new Level1();
			addChild(level1);
			currentObject = level1;
		}
		function endLevel1():void
		{
			removeChild(level1);
			level1 = null;
			currentObject = null;
		}
	}
}