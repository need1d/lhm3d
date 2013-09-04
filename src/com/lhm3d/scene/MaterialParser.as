package com.lhm3d.scene
{
	import com.lhm3d.light.Light;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	
	public class MaterialParser
	{
		
		private var callBack:Function;
		
		public var lights:Vector.<Light> = new Vector.<Light>();
		public var cubeMaps:Vector.<CubeMapEntity> = new Vector.<CubeMapEntity>();
		
		public function MaterialParser(_url:String, _callBack:Function) : void
		{
			
			callBack = _callBack;
			
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest();
			request.url = _url;
			loader.addEventListener(Event.COMPLETE, onLoaderComplete);
			loader.load(request);
			
		}
		
		
		private function onLoaderComplete(e:Event) : void {
			var loader:URLLoader = URLLoader(e.target);
			
			var data:Object = JSON.parse(loader.data);

			// lights			
			for (var i:int = 0; i < data.lights.length; i++) {
				var _light:Light = new Light();
				
				// clone light 0, to use it's setting as base-setting
				if (i > 0) _light = lights[0].clone();
				
				if ( data.lights[i].hasOwnProperty("directionX") && data.lights[i].hasOwnProperty("directionY") && data.lights[i].hasOwnProperty("directionZ") ) {
					_light.setDirection(Number(data.lights[i].directionX),Number(data.lights[i].directionY), Number(data.lights[i].directionZ));
				}
				
				trace("light", i);
				
				lights.push(_light);
			}
			
			
			// cube maps
			for (i = 0; i < data.cubeMaps.length; i++) {
				cubeMaps.push(new CubeMapEntity(data.cubeMaps[i].name));
			}
			
			
			
			callBack();
			
		}
		
	
		
		
	}
}