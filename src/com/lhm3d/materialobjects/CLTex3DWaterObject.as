package com.lhm3d.materialobjects
{
	
	import com.adobe.utils.AGALMiniAssembler;
	import com.lhm3d.camera.*;
	import com.lhm3d.globals.Globals;
	import com.lhm3d.texturemanager.TextureManager;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	
	
	public class CLTex3DWaterObject extends Base3DObject
	{
		
		private static var program:Program3D = null;
		
		private var textureWave1Index:int;
		private var textureWave2Index:int;
		private var cubeEnvTexIndex:int;

		private var alphaAmount:Number;
		private var envAmount:Number;
		private var r:Number;
		private var g:Number;
		private var b:Number;
		
		
		private var texCycleAmount:Number = 0;
		
		
		public function CLTex3DWaterObject(_envAmount:Number, _alphaAmount:Number, _r:Number, _g:Number, _b:Number, _textureWave1Index:int, _textureWave2Index:int, _cubeEnvTexIndex:int,  _vertexLayer:Vector.<Number>, 
														_normalLayer:Vector.<Number>,_uvLayer:Vector.<Number>, _indexLayer:Vector.<uint>)
		{
			super(_vertexLayer,_indexLayer);
			alphaAmount = _alphaAmount;
			envAmount = _envAmount;
			textureWave1Index = _textureWave1Index;
			textureWave2Index = _textureWave2Index;
			
			cubeEnvTexIndex =_cubeEnvTexIndex;
			r = _r;
			g = _g;
			b = _b;
			
			
			var vertices:Vector.<Number> = new Vector.<Number>();
			
			for (var i:int = 0; i < _vertexLayer.length / 3; i++) {
				vertices.push(_vertexLayer[i*3],_vertexLayer[i*3+1],_vertexLayer[i*3+2],_normalLayer[i*3],_normalLayer[i*3+1],_normalLayer[i*3+2],_uvLayer[i*2],_uvLayer[i*2+1]);
			}
			
			vertexbuffer = Globals.context3D.createVertexBuffer(_vertexLayer.length / 3,8);
			vertexbuffer.uploadFromVector(vertices,0, vertices.length / 8);		
			
			indexbuffer = Globals.context3D.createIndexBuffer(_indexLayer.length);			
			indexbuffer.uploadFromVector(_indexLayer, 0, _indexLayer.length);	
			
			if (program == null) {
				var vertexShaderAssembler : AGALMiniAssembler = new AGALMiniAssembler();
				vertexShaderAssembler.assemble( Context3DProgramType.VERTEX,
					
					"m44 op, va0, vc0\n" + // pos -> clipspace
						
					"add v2, va2, vc9\n" + // tex corrds for wave tex 1
					"add vt0, va2, vc10\n" + // tex corrds for wave tex 2
					"mul v3, vt0, vc11\n" + 
					
					"m33 vt0.xyz, va1.xyz, vc4\n" +  // normalen mit objekt matrix
					"mov v1, vt0.xyz \n" + 			 // wert in v1 = Normalen des Punktes nach Objektdrehng (world matrix) in v1
					
					"m44 vt0, va0, vc4\n" + // position der Punkte nach Objektdrehung in vt0
					"sub vt2, vc8, vt0\n" + // von Kamera-Position abziehen
					"nrm vt2.xyz, vt2\n" +  // normalisierte richtung Kamera->Punkt ...
					
					"mov v0, vt2\n" // ... in v0
					
				);	
				
				
				var fragmentShaderAssembler : AGALMiniAssembler= new AGALMiniAssembler();
				fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,
					
					"mov ft2, fc1 \n"+ 	//basis-colorierung
					
					"tex ft3, v3, fs0 <2d,repeat,linear> \n"+  //first texture in ft2
					"tex ft4, v2, fs1 <2d,repeat,linear> \n"+  //dubug 
					
					"add ft4, ft4, ft3 \n"+
					"sub ft4, ft4, fc0.z \n"+
					
					"dp3 ft3, v0, v1 \n"+ 		//anfang reflect in ft3
					"dp3 ft3, ft3, ft4 \n"+ 
					
					"add ft3, ft3, ft3 \n"+
					"mul ft3, v1, ft3 \n"+
					"sub ft3, v0, ft3 \n"+
					"neg ft3, ft3 \n"+
					"nrm ft3.xyz, ft3 \n"+
					
					"tex ft1, ft3, fs2 <cube,clamp,nomip> \n"+  //env map texture in ft1
					"mul ft1, ft1, fc2 \n"+
					
					"add ft2, ft2, ft1 \n"+ 
					
					"mov oc, ft2"         		//output color
				);
				
				
				program = Globals.context3D.createProgram();
				program.upload( vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
			}
			
		}
		
		public function setWaveAnimation(_ani:int) : void {
			texCycleAmount = _ani * 0.008;
		}
		
		public override function renderWithMatrix(_mat:Matrix3D, _cull:String = Context3DTriangleFace.FRONT, _blend1:String = Context3DBlendFactor.ONE, _blend2:String = Context3DBlendFactor.ZERO):void  {
			var _m:Matrix3D = _mat.clone();
			
			_m.append(Camera.viewMatrix);
			_m.append(Camera.projectionTransform);
			
			
			Globals.context3D.setVertexBufferAt(0, vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			Globals.context3D.setVertexBufferAt(1, vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_3); //va1 normal
			Globals.context3D.setVertexBufferAt(2, vertexbuffer, 6, Context3DVertexBufferFormat.FLOAT_2); //va2 (u,v)
			
			Globals.context3D.setTextureAt(0, TextureManager.textures[textureWave1Index].texture);
			Globals.context3D.setTextureAt(1, TextureManager.textures[textureWave2Index].texture);
			Globals.context3D.setTextureAt(2, TextureManager.cubeTextures[cubeEnvTexIndex].cubeTexture);
			
			
			Globals.context3D.setProgram(program);
			
			Globals.context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _m, true); // view + object + projeziert
			Globals.context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, _mat, true); // object
			
			Globals.context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 8,  Vector.<Number>([-Camera.cameraPosition.x, -Camera.cameraPosition.y, -Camera.cameraPosition.z, 1.0])); // cam pos
			
			Globals.context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 9,	  Vector.<Number>([texCycleAmount, texCycleAmount, texCycleAmount, 1.0])); // vc9
			Globals.context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 10,  Vector.<Number>([-texCycleAmount*0.5, -texCycleAmount*0.345, -texCycleAmount*1.235, 1.0])); // vc10
			Globals.context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 11,  Vector.<Number>([1.4, 1.3, 1.3, 1.0]));
			
			
			Globals.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([1, 1, 1, 1])); //fc0,  nur einsen
			Globals.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([r, g, b, 0.5])); // fc1 basis-farbe
		
			Globals.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, Vector.<Number>([envAmount, envAmount, envAmount, alphaAmount])); //fc2, envMap mix
			
		
			Globals.context3D.setBlendFactors(_blend1, _blend2);
			Globals.context3D.setCulling(_cull);
			Globals.context3D.drawTriangles(indexbuffer);
			
			// cleanup
			Globals.context3D.setVertexBufferAt(0, null);
			Globals.context3D.setVertexBufferAt(1, null);
			Globals.context3D.setVertexBufferAt(2, null);
			Globals.context3D.setTextureAt(0, null);
			Globals.context3D.setTextureAt(1, null);
			Globals.context3D.setTextureAt(2, null);
			
			
		}
		
	}
}// ActionScipf file