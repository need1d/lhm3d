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
		
		private var sceneComplete:Boolean = false;
		private var materialComplete:Boolean = false;
		
		private var lines:Array;
		
		private var sceneEntities:Vector.<SceneEntity> = new Vector.<SceneEntity>();
		private var differentObjects:Vector.<String> = new Vector.<String>();
		private var objectLoaders:Vector.<BaseObjectLoader> = new Vector.<BaseObjectLoader>();
		
		public var objects:Vector.<Base3DObject> = new Vector.<Base3DObject>();
		
		private var pathFolder:String;
		
		private var materialParser:MaterialParser;
		
		public function Scene(_pathFolder:String) : void
		{
			pathFolder = _pathFolder;
		
			// load placament-file manually
			var _loader:URLLoader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, sceneLoadComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, ioSceneErrorHandler);
			
			var fileRequest:URLRequest = new URLRequest(_pathFolder + "scene.txt");
			_loader.load(fileRequest);
			
			//load matarial parser-file var parse-class
			materialParser = new MaterialParser(_pathFolder + "material.json", 	materialParseComplete);
		}
		
		private function materialParseComplete() : void {
			materialComplete = true;
	
			if (materialComplete && sceneComplete) beginBuildingScene();
		}
		
		
		private function sceneLoadComplete(e:Event) : void
		{
			lines = e.target.data.split(/\n/);
			sceneComplete = true;
			
			if (materialComplete && sceneComplete) beginBuildingScene();
		}
		
		
		
		private function beginBuildingScene() : void {
			
			// objects to load
			for (var i:int = 0; i < lines.length; i ++) {
				if (lines[i] != "") {
					
					var _subStr:Array = lines[i].split(" ");			
					var _name:String = _subStr[0].split(".")[0];
					
					sceneEntities.push(new SceneEntity(_name,Number(_subStr[1]),Number(_subStr[2]),Number(_subStr[3]), 
															 Number(_subStr[4])*(180.0/Math.PI),Number(_subStr[5])*(180.0/Math.PI),Number(_subStr[6])*(180.0/Math.PI),
															 Number(_subStr[7])));
					var _found:Boolean = false;
					for (var o:int = 0; o < differentObjects.length; o++) {
						if (differentObjects[o] == _name) _found = true;
					}
					if (!_found) differentObjects.push(_name);
				}
			}
			
			for (i = 0; i < differentObjects.length; i++) {
				objectLoaders.push(new WavefrontObjectLoader(pathFolder + differentObjects[i] + ".obj"));
			}
			
			// object Materials to load
			for (i = 0; i < materialParser.cubeMaps.length; i++) {
				materialParser.cubeMaps[i].cubeTextureData.push(new TextureLoader(pathFolder + materialParser.cubeMaps[i].name + "_xleft.png"));
				materialParser.cubeMaps[i].cubeTextureData.push(new TextureLoader(pathFolder + materialParser.cubeMaps[i].name + "_xright.png"));
				materialParser.cubeMaps[i].cubeTextureData.push(new TextureLoader(pathFolder + materialParser.cubeMaps[i].name + "_yup.png"));
				materialParser.cubeMaps[i].cubeTextureData.push(new TextureLoader(pathFolder + materialParser.cubeMaps[i].name + "_ydown.png"));
				materialParser.cubeMaps[i].cubeTextureData.push(new TextureLoader(pathFolder + materialParser.cubeMaps[i].name + "_zback.png"));
				materialParser.cubeMaps[i].cubeTextureData.push(new TextureLoader(pathFolder + materialParser.cubeMaps[i].name + "_zfront.png"));
			}
			
			for (i = 0; i < materialParser.objectMaterials.length; i++) {
				materialParser.objectMaterials[i].textureData.push(new TextureLoader(pathFolder + materialParser.objectMaterials[i].assign + ".png"));
				if (MaterialFactory.hasBumpTexture(materialParser.objectMaterials[i].material)) {
					materialParser.objectMaterials[i].textureData.push(new TextureLoader(pathFolder + materialParser.objectMaterials[i].assign + "_bump.png"));
				}
				if (MaterialFactory.hasEnvTexture(materialParser.objectMaterials[i].material)) {
					materialParser.objectMaterials[i].textureData.push(new TextureLoader(pathFolder + materialParser.objectMaterials[i].assign + "_env.png"));
				}
				
			}
			
			
		}
		
		private function getCubeMapIndex(_name:String) : int {
			for (var i:int = 0; i < materialParser.cubeMaps.length; i++) {
				if (_name == materialParser.cubeMaps[i].name) return materialParser.cubeMaps[i].index;
			}
			return -1;
		}
		
		
		public function sceneLoaded() : void 
		{
			
			var _dummyTexture:int = TextureManager.addTextureFromBMD(TextureManager.getDummyTexture());
			
			// building up the cube maps
			for (var i:int = 0; i < materialParser.cubeMaps.length; i++) {
				trace("hier cube maps");	
				materialParser.cubeMaps[i].index = TextureManager.addCubeTextureFromBMD(materialParser.cubeMaps[i].cubeTextureData[0].getBitmapData(),materialParser.cubeMaps[i].cubeTextureData[1].getBitmapData(),materialParser.cubeMaps[i].cubeTextureData[2].getBitmapData(),materialParser.cubeMaps[i].cubeTextureData[3].getBitmapData(),materialParser.cubeMaps[i].cubeTextureData[4].getBitmapData(),materialParser.cubeMaps[i].cubeTextureData[5].getBitmapData());
			}
			
			// building up normal Texture Maps
			for (i = 0; i < materialParser.objectMaterials.length; i++) {
				if (materialParser.objectMaterials[i].textureData.length > 0) materialParser.objectMaterials[i].texIndex1 = TextureManager.addTextureFromBMD(materialParser.objectMaterials[i].textureData[0].getBitmapData());
				if (materialParser.objectMaterials[i].textureData.length > 1) materialParser.objectMaterials[i].texIndex2 = TextureManager.addTextureFromBMD(materialParser.objectMaterials[i].textureData[1].getBitmapData());
				trace("hier texture maps maps", materialParser.objectMaterials[i].textureData.length);	
			}
			
			
			// get bounding box for scene by using radius of placed objects
			var minX:Number = Number.MAX_VALUE;
			var minY:Number = Number.MAX_VALUE;
			var minZ:Number = Number.MAX_VALUE;
			
			var maxX:Number = Number.MIN_VALUE;
			var maxY:Number = Number.MIN_VALUE;
			var maxZ:Number = Number.MIN_VALUE;
			
			// add objects to scene first
			for (i = 0; i < differentObjects.length; i++) {
		
				var _matIndex:int = -1;
				for (var o:int = 0; o < materialParser.objectMaterials.length; o++) {
					if (materialParser.objectMaterials[o].assign == differentObjects[i]) {
						_matIndex = o;
					}
				}
				
				if (_matIndex > -1) {
					
					if (materialParser.objectMaterials[_matIndex].material == "CLTexCubeBumpFresnel") {
						objects.push(MaterialFactory.buildCLTexCubeEnvBumpFresnelObject(materialParser.objectMaterials[_matIndex].envAmount,
																						materialParser.objectMaterials[_matIndex].texIndex1,
																						getCubeMapIndex(materialParser.objectMaterials[_matIndex].cubeMapName),
																						materialParser.objectMaterials[_matIndex].texIndex2,objectLoaders[i]));
																						
						trace("hier materials");	
					}
					
					
				} else {
					objects.push(new Tex3DObject(_dummyTexture,objectLoaders[i].getVertexLayer(),objectLoaders[i].getUVLayer(),objectLoaders[i].getIndexLayer()));
				}
			}
			
			for (i = 0; i < sceneEntities.length; i++) {
				var _objectIndex:int = -1;
				for (o = 0; o < differentObjects.length; o++) {
					if (differentObjects[o] == sceneEntities[i].name) _objectIndex = o; 
				}
				
				if (_objectIndex!= -1) {
					
					var _minX:Number = sceneEntities[i].x - objects[_objectIndex].getRadius() * sceneEntities[i].scale;
					var _maxX:Number = sceneEntities[i].x + objects[_objectIndex].getRadius() * sceneEntities[i].scale;
					
					var _minY:Number = sceneEntities[i].y - objects[_objectIndex].getRadius() * sceneEntities[i].scale;
					var _maxY:Number = sceneEntities[i].y + objects[_objectIndex].getRadius() * sceneEntities[i].scale;
					
					var _minZ:Number = sceneEntities[i].z - objects[_objectIndex].getRadius() * sceneEntities[i].scale;
					var _maxZ:Number = sceneEntities[i].z + objects[_objectIndex].getRadius() * sceneEntities[i].scale;
					
					if (_minX < minX) minX = _minX;
					if (_maxX > maxX) maxX = _maxX;
					
					if (_minY < minY) minY = _minY;
					if (_maxY > maxY) maxY = _maxY;
					
					if (_minZ < minZ) minZ = _minZ;
					if (_maxZ > maxZ) maxZ = _maxZ;					
					
				}
				
			}
			
			trace("mins:", minX, minY, minZ);
			trace("max:", maxX, maxY, maxZ);
			

			ViewTree.init(new Vector3D(minX,minY,minZ), new Vector3D(maxX,maxY,maxZ),5);
			
			var _ref:Vector.<int> = new Vector.<int>();
			
			for (o = 0; o < objects.length; o++) {
				_ref.push(ViewTree.submitObjectToContainer(objects[o]));
			}
			
			for (i = 0; i < sceneEntities.length; i++) {
				
				_objectIndex = -1;
				for (o = 0; o < differentObjects.length; o++) {
					if (differentObjects[o] == sceneEntities[i].name) _objectIndex = o; 
				}
				
				if (_objectIndex!= -1) {
					/*if (i == 6)*/ ViewTree.addObjectAtPosRotScale(_ref[_objectIndex],sceneEntities[i].x,sceneEntities[i].y,sceneEntities[i].z,sceneEntities[i].rx,sceneEntities[i].ry,sceneEntities[i].rz,sceneEntities[i].scale);
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