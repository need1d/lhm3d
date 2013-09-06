package com.lhm3d.texturemanager
{
	import com.lhm3d.globals.Globals;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest; 
	
	public class TextureLoader
	{
		
		private var fileName:String;
		
		private var bmd:BitmapData;
		
		private function loaderComplete(e:Event):void {
			
			bmd = new BitmapData(e.target.content.bitmapData.width, e.target.content.bitmapData.height, true);
			bmd = e.target.content.bitmapData;
		
			Globals.textureLoadCallBack();
			
		}
		
		public function getBitmapData():BitmapData {
			return bmd;
		}
		
		public function TextureLoader(_fileName:String)
		{
			trace("Texture Load Stack:",  _fileName);
			
			Globals.texturesToLoad++;
			
			fileName = _fileName;
				
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			var fileRequest:URLRequest = new URLRequest(_fileName);
			loader.load(fileRequest);
			
		}
		
		private function ioErrorHandler(e:Event):void {
		
			throw new Error("kann Datei nicht laden: (" + fileName + ")");
		}
		
		
	}
}