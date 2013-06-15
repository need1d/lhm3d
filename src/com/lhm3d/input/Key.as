package com.lhm3d.input
{

	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;

	
	public class Key {
		
		private static var initialized:Boolean = false;  
		private static var keysDown:Object = new Object();  
		
	
		public static function initialize(stage:Stage):void {
			if (!initialized) {
		
				stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
				stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
				stage.addEventListener(Event.DEACTIVATE, clearKeys);
				
				initialized = true;
			}
		}
		
		
		public static function isDown(keyCode:uint):Boolean {
			if (!initialized) {
				throw new Error("Key class has yet been initialized.");
			}
			return Boolean(keyCode in keysDown);
		}
		

		private static function keyPressed(event:KeyboardEvent):void {
			keysDown[event.keyCode] = true;
			trace(event.keyCode);
		}
		

		private static function keyReleased(event:KeyboardEvent):void {
			if (event.keyCode in keysDown) {
				delete keysDown[event.keyCode];
			}
		}
		

		private static function clearKeys(event:Event):void {
			keysDown = new Object();
		}
	}
	
}