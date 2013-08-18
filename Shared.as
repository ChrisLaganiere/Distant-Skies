package 
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class Shared
	//1.0 (October 24, 2012)
	{
		public function Shared()
		{
		}
		
		//Block objects
		static public function kill(object:MovieClip):void
		{
			if (object) {
				Main.currentObject.killGrandChildren(object);
			}
		}
		static public function doPassScene():void
		{
			//level switching scene, don't call
			var level:Object = Main.currentObject;
			
			if (level.scene <= level.numScenes)
			{
				level.gotoAndStop(String(level.scene));
			}
			else
			{
				level.scene = level.numScenes;
				level.gotoAndStop(String(level.scene));
			}
			var player:Object = new Main.currentPlayer();
			level.addChild(player);
			level.player = player;
			player.x = MovieClip(level.sceneClip).exPlayer.localToGlobal(new Point()).x;
			player.y = MovieClip(level.sceneClip).exPlayer.localToGlobal(new Point()).y;
			MovieClip(level.sceneClip).exPlayer.alpha = 0;
			//arrange player behind controls
			level.setChildIndex(level.reports, level.numChildren-1);
			level.setChildIndex(level.controls, level.numChildren-1);
		}
		static public function resetLevel():void
		{
			var level:Object = Main.currentObject;
			
			Main.endLevel = true;
			Main.startLevel = true;
		}
		static public function doSmoothScenePass():void
		{
			var level:Object = Main.currentObject;
			
			Main.passX = level.sceneClip.x;
			Main.passY = level.sceneClip.y;
			Main.smoothPass = true;
			passSceneReset();
		}
		static public function passSceneReset():void
		{
			//clears out old level and goes to new scene
			var level:Object = Main.currentObject;
			
			
			Main.nexScene = level.scene;
			Main.skipToScene = true;
			resetLevel();
		}
		static public function checkVisible(object:MovieClip):Boolean
		{
			var halfWidth:Number = object.width / 2;
			var halfHeight:Number = object.height / 2;
			
			if (object.localToGlobal(new Point()).x + halfWidth < -2*Main.halfBlockHeight)
			{
				//too far left
				return false;
			}
			else if (object.localToGlobal(new Point()).x - halfWidth > 800 + 2*Main.halfBlockHeight)
			{
				//too far right
				return false;
			}
			else if (object.localToGlobal(new Point()).y + halfHeight < -2*Main.halfBlockHeight)
			{
				//too high
				return false;
			}
			else if (object.localToGlobal(new Point()).y - halfHeight > 480 + 2*Main.halfBlockHeight)
			{
				//too low
				return false;
			}
			else
			{
				return true;
			}
		}
		static public function checkWallVisible(object:MovieClip):Boolean
		{
			var halfWidth:Number = object.width / 2;
			var halfHeight:Number = object.height / 2;
			
			if (object.localToGlobal(new Point()).x + halfWidth < -5*Main.halfBlockHeight)
			{
				//too far left
				return false;
			}
			else if (object.localToGlobal(new Point()).x - halfWidth > 800 + 5*Main.halfBlockHeight)
			{
				//too far right
				return false;
			}
			else if (object.localToGlobal(new Point()).y + halfHeight < -5*Main.halfBlockHeight)
			{
				//too high
				return false;
			}
			else if (object.localToGlobal(new Point()).y - halfHeight > 480 + 5*Main.halfBlockHeight)
			{
				//too low
				return false;
			}
			else
			{
				return true;
			}
		}
	}
}