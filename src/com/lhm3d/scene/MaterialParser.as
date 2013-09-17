package com.lhm3d.scene
{
	import com.lhm3d.geometryhelpers.HelpMath;
	import com.lhm3d.light.Light;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	
	public class MaterialParser
	{
		
		private var callBack:Function;
		
		public var lights:Vector.<Light> = new Vector.<Light>();
		public var cubeMaps:Vector.<CubeMapEntity> = new Vector.<CubeMapEntity>();
		public var objectMaterials:Vector.<ObjectMaterialEntity> = new Vector.<ObjectMaterialEntity>();
		
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
				var _color:uint;
				
				if ( data.lights[i].hasOwnProperty("base") ) {					
					_color = uint(data.lights[i].base);
					_light.setBaseColor(HelpMath.extractR(_color),HelpMath.extractG(_color), HelpMath.extractB(_color));
				}
				
				if ( data.lights[i].hasOwnProperty("additive") && data.lights[i].hasOwnProperty("additiveAmount") )  {					
					_color = uint(data.lights[i].additive);
					_light.setColorAdditive(HelpMath.extractR(_color),HelpMath.extractG(_color), HelpMath.extractB(_color), Number(data.lights[i].hasOwnProperty("additiveAmount")));
				}
				
				if ( data.lights[i].hasOwnProperty("ambient") && data.lights[i].hasOwnProperty("ambientAmount") )  {					
					_color = uint(data.lights[i].ambient);
					_light.setColorAmbient(HelpMath.extractR(_color),HelpMath.extractG(_color), HelpMath.extractB(_color), Number(data.lights[i].hasOwnProperty("ambientAmount")));
				}
				
				lights.push(_light);
			}
			
			
			// cube maps
			if (data.hasOwnProperty("cubeMaps")) {
				for (i = 0; i < data.cubeMaps.length; i++) {
					cubeMaps.push(new CubeMapEntity(data.cubeMaps[i].name));
				}
			}
			
			//Materials
			if (data.hasOwnProperty("materials")) {
				for (i = 0; i < data.materials.length; i++) {
					
					var _assign:String = "none";
					var _material:String = "dummyTex";
					var _cubeMapName:String = "none";
					var _envAmount:Number = 0.5;
					var _lightNr:int = 0;
					var _split:int = 0;
					
					if (data.materials[i].hasOwnProperty("assign")) _assign = data.materials[i].assign;
					if (data.materials[i].hasOwnProperty("material")) _material = data.materials[i].material;
					if (data.materials[i].hasOwnProperty("cubeMap")) _cubeMapName = data.materials[i].cubeMap;
					if (data.materials[i].hasOwnProperty("envAmount")) _envAmount = data.materials[i].envAmount;
					if (data.materials[i].hasOwnProperty("light")) _lightNr = data.materials[i].light;
					if (data.materials[i].hasOwnProperty("split")) _split = data.materials[i].split;
					
					objectMaterials.push( new ObjectMaterialEntity(_assign,_material,_cubeMapName,_envAmount,_lightNr, _split));
				}
			}
			
			
			callBack();
			
		}
		
		
	
		
		
	}
}