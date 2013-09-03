package com.lhm3d.scene
{
	
	import away3d.events.LoaderEvent;
	
	import com.lhm3d.camera.*;
	import com.lhm3d.fileobjectloaders.*;
	import com.lhm3d.globals.*;
	import com.lhm3d.globals.Globals;
	import com.lhm3d.light.Light;
	import com.lhm3d.materialobjects.*;
	import com.lhm3d.stats.Stats;
	import com.lhm3d.texturemanager.*;
	import com.lhm3d.texturemanager.TextureLoader;
	import com.lhm3d.viewtree.*;
	
	import flash.display.*;
	import flash.display3D.textures.CubeTexture;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class Scene
	{
		
		private var sceneEntities:Vector.<SceneEntity> = new Vector.<SceneEntity>();
		private var differentObjects:Vector.<String> = new Vector.<String>();
		private var objectLoaders:Vector.<BaseObjectLoader> = new Vector.<BaseObjectLoader>();
		
		private var objects:Vector.<Base3DObject> = new Vector.<Base3DObject>();
		
		private var pathFolder:String;
		
		public function Scene(_pathFolder:String) : void
		{
			pathFolder = _pathFolder;
		
			var _loader:URLLoader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, sceneLoadComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, ioSceneErrorHandler);
			
			var fileRequest:URLRequest = new URLRequest(_pathFolder + "/scene.txt");
			_loader.load(fileRequest);
			
		}
		
		private function sceneLoadComplete(e:Event) : void
		{
		
			var _lines:Array = e.target.data.split(/\n/);
			
			for (var i:int = 0; i < _lines.length; i ++) {
				if (_lines[i] != "") {
					
					var _subStr:Array = _lines[i].split(" ");			
					var _name:String = _subStr[0].split(".")[0];
					
					sceneEntities.push(new SceneEntity(_name,Number(_subStr[1]),Number(_subStr[3]),Number(_subStr[2]),-Number(_subStr[4])*(180.0/Math.PI),-Number(_subStr[6])*(180.0/Math.PI),-Number(_subStr[5])*(180.0/Math.PI),Number(_subStr[7])));
					trace("Jaa?");
					var _found:Boolean = false;
					for (var o:int = 0; o < differentObjects.length; o++) {
						if (differentObjects[o] == _name) _found = true;
					}
					if (!_found) differentObjects.push(_name);
				}
			}
		
			for (i = 0; i < differentObjects.length; i++) {
				objectLoaders.push(new WavefrontObjectLoader(pathFolder + "/" + differentObjects[i] + ".obj"));
				
			}
			
			
		}
		
		public function sceneLoaded() : void 
		{
			
			ViewTree.init(new Vector3D(-50,-50,-50), new Vector3D(50,50,50),3);
			
			var _dummyTexture:int = TextureManager.addTextureFromBMD(TextureManager.getDummyTexture());
			
			var _ref:Vector.<int> = new Vector.<int>();
			for (var i:int = 0; i < objectLoaders.length; i++) {

				objects.push(new Tex3DObject(_dummyTexture,objectLoaders[i].getVertexLayer(),objectLoaders[i].getUVLayer(),objectLoaders[i].getIndexLayer()));
				_ref.push(ViewTree.submitObjectToContainer(objects[objects.length-1]));
			
			}
			
			for (i = 0; i < sceneEntities.length; i++) {
				
				var _objectIndex:int = -1;
				for (var o:int = 0; o < differentObjects.length; o++) {
					if (differentObjects[o] == sceneEntities[i].name) _objectIndex = o; 
				}
				
				if (_objectIndex!= -1) {
					ViewTree.addObjectAtPosRotScale(_ref[_objectIndex],sceneEntities[i].x,sceneEntities[i].y,sceneEntities[i].z,sceneEntities[i].rx,sceneEntities[i].ry,sceneEntities[i].rz,sceneEntities[i].scale);
				}
					
				
			}
		
		
		}
		
		public function render() : void 
		{
			//trace("ja, render");
			ViewTree.render();
		}
		
		
		private function ioSceneErrorHandler(e:Event) : void
		{
			trace("IO-Error");
		}
		
		
	}
}