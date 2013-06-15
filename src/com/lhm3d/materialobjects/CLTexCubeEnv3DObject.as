package com.lhm3d.materialobjects
{
	
	import com.adobe.utils.AGALMiniAssembler;
	import com.lhm3d.globals.Globals;
	import com.lhm3d.texturemanager.TextureManager;
	import com.lhm3d.camera.*;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	
	
	public class CLTexCubeEnv3DObject extends Base3DObject
	{
		
		private var textureIndex:int;
		private var cubeEnvTexIndex:int;
		
		private var envAmount:Number;
		
		public function CLTexCubeEnv3DObject(_envAmount:Number, _textureIndex:int, _cubeEnvTexIndex:int, _vertexLayer:Vector.<Number>, 
										 	_normalLayer:Vector.<Number>,_uvLayer:Vector.<Number>,
										 	_indexLayer:Vector.<uint>)
		{
			super(_vertexLayer);
			
			
			envAmount = _envAmount;
			textureIndex = _textureIndex;
			cubeEnvTexIndex =_cubeEnvTexIndex;
			
			var vertices:Vector.<Number> = new Vector.<Number>();
			
			for (var i:int = 0; i < _vertexLayer.length / 3; i++) {
				vertices.push(_vertexLayer[i*3],_vertexLayer[i*3+1],_vertexLayer[i*3+2],_normalLayer[i*3],_normalLayer[i*3+1],_normalLayer[i*3+2],_uvLayer[i*2],_uvLayer[i*2+1]);
			}
			
			
			vertexbuffer = Globals.context3D.createVertexBuffer(_vertexLayer.length / 3, 8);
			vertexbuffer.uploadFromVector(vertices, 0, vertices.length / 8);		
			
			
			indexbuffer = Globals.context3D.createIndexBuffer(_indexLayer.length);			
			indexbuffer.uploadFromVector (_indexLayer, 0, _indexLayer.length);	
			
			/* view
			code += sub(target, camera, position);
			code += nrm(target+".xyz", target);
			*/
			
			var vertexShaderAssembler : AGALMiniAssembler = new AGALMiniAssembler();
			vertexShaderAssembler.assemble( Context3DProgramType.VERTEX,
				
				"m44 op, va0, vc0\n" + // pos -> clipspace
				"mov v2, va2\n" + 	 // uv's in v2
				
				"m33 vt0.xyz, va1.xyz, vc4\n" +  // normalen mit objekt matrix
				"mov v1, vt0.xyz \n" + 			 // wert in v1 = Normalen des Punktes nach Objektdrehng in v1
				
				"m44 vt0, va0, vc4\n" + // position der Punkte nach Objektdrehung in vt0
				"sub vt2, vc8, vt0\n" + // von Kamera-Position abziehen
				"nrm vt2.xyz, vt2\n" + // normalisierte richtung Kamera->Punkt ...
				"mov v0, vt2\n" // ... in v0
				
			);	
			
			
			var fragmentShaderAssembler : AGALMiniAssembler= new AGALMiniAssembler();
			fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,
				"tex ft2, v2, fs0 <2d,clamp,linear> \n"+  //sample texture in ft2
				
				"mul ft2, ft2, fc3 \n"+ 	//basis-colorierung
				
				"dp3 ft3, v0, v1 \n"+ 		//anfang reflect in ft3
				"add ft3, ft3, ft3 \n"+
				"mul ft3, v1, ft3 \n"+
				"sub ft3, v0, ft3 \n"+
				"neg ft3, ft3 \n"+
				"nrm ft3.xyz, ft3 \n"+
				
				"tex ft1, ft3, fs1 <cube,linear,nomip> \n"+  //env map texture in ft1
				"mul ft1, ft1, fc6 \n"+
				"add ft2, ft2, ft1 \n"+ 
				
				"dp3 ft1, fc1, v1 \n"+		//dot transform normal -> light direction
				"sat ft1, ft1 \n"+			//keine negativen werte
				"mul ft3, ft1, fc4 \n" + 	//in ft3 normale * licht rgb
				"add ft2, ft2, ft3 \n" +	//zur farbe addieren
				
				"dp3 ft1, fc2, v1 \n"+      //dot the transform normal with inverse light direction
				"sat ft1, ft1 \n"+		    //keine Negativen werte
				"sub ft3, fc5, ft2 \n" + 	//
				"mul ft3, ft3, ft1 \n" + 	//
				"add ft2, ft3, ft2 \n" +	//zur farbe addieren
				
				"mov oc, ft2"         		//output color
			);
			
			
			program = Globals.context3D.createProgram();
			program.upload( vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
			
			
		}
		
		
		public override function renderWithMatrix(_mat:Matrix3D):void  {
			var _m:Matrix3D = _mat.clone();
			
			_m.append(Camera.viewMatrix);
			_m.append(Camera.projectionTransform);
			
			
			// vertex position to attribute register 0
			Globals.context3D.setVertexBufferAt (0, vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			Globals.context3D.setVertexBufferAt(1, vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_3); //va1 normal
			Globals.context3D.setVertexBufferAt(2, vertexbuffer, 6, Context3DVertexBufferFormat.FLOAT_2); //va2 (u,v)
			
			Globals.context3D.setTextureAt(0, TextureManager.textures[textureIndex].texture);
			
			//Globals.context3D.setTextureAt(1, TextureManager.textures[textureIndex].texture);
			Globals.context3D.setTextureAt(1, TextureManager.cubeTextures[cubeEnvTexIndex].cubeTexture);

			
			
			Globals.context3D.setProgram(program);
			
			Globals.context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _m, true); // view + object + projeziert
			Globals.context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, _mat, true); // object
			
			Globals.context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 8,  Vector.<Number>([-Camera.cameraPosition.x, -Camera.cameraPosition.y, -Camera.cameraPosition.z, 1.0])); // cam pos
			
			
			Globals.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, light.directionC1); //fc1,  licht-seite Richtung
			Globals.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, light.directionC2); //fc2,  schatten-seite Richtung
			
			Globals.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3, light.baseColor); // fc3 basis-farbe
			Globals.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 4, light.color1); //fc4, additives Licht Farbenseite
			Globals.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 5, light.color2); //fc5, additives Licht Schattenseite
			
			Globals.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 6, Vector.<Number>([envAmount, envAmount, envAmount, envAmount])); //fc6, envMap mix
			
			Globals.context3D.drawTriangles(indexbuffer);
			
		}
		
	}
}// ActionScript file