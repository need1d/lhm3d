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
	
	
	
	public class CLTexEnvBump3DObject extends Base3DObject
	{
		
		private var textureIndex:int;
		private var textureIndex2:int;
		private var textureIndexBump:int;
		
		private var envAmount:Number;
		
		
		public function CLTexEnvBump3DObject(_envAmount:Number,_textureIndex:int, _textureIndex2:int,_textureIndexBump:int, _vertexLayer:Vector.<Number>, 
														  _normalLayer:Vector.<Number>,_uvLayer:Vector.<Number>,
														  _indexLayer:Vector.<uint>)
		{
			super(_vertexLayer);
			
			envAmount = _envAmount;
			
			textureIndex = _textureIndex;
			textureIndex2 =_textureIndex2;
			textureIndexBump = _textureIndexBump;
			
			var vertices:Vector.<Number> = new Vector.<Number>();
			
			for (var i:int = 0; i < _vertexLayer.length / 3; i++) {
				vertices.push(_vertexLayer[i*3],_vertexLayer[i*3+1],_vertexLayer[i*3+2],_normalLayer[i*3],_normalLayer[i*3+1],_normalLayer[i*3+2],_uvLayer[i*2],_uvLayer[i*2+1]);
			}
			
			
			vertexbuffer = Globals.context3D.createVertexBuffer(_vertexLayer.length / 3, 8);
			vertexbuffer.uploadFromVector(vertices, 0, vertices.length / 8);		
			
			
			indexbuffer = Globals.context3D.createIndexBuffer(_indexLayer.length);			
			indexbuffer.uploadFromVector (_indexLayer, 0, _indexLayer.length);	
			
			var vertexShaderAssembler : AGALMiniAssembler = new AGALMiniAssembler();
			vertexShaderAssembler.assemble( Context3DProgramType.VERTEX,
				"m44 op, va0, vc0\n" + // pos to clipspace
				
				"m33 vt0.xyz, va1.xyz, vc4\n" +  
				"mov v1, vt0.xyz \n" + 
				
				"mov v2, va2\n" + 		// uv's in v2
				
				"m33 vt0.xyz, va1.xyz, vc8\n" + 
				"mul vt0.xyz, vt0.xyz, vc12\n"+
				"add v0, vt0.xyz, vc12"
			);	
			
			
			var fragmentShaderAssembler : AGALMiniAssembler= new AGALMiniAssembler();
			fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,
				"tex ft2, v2, fs0 <2d,clamp,linear> \n"+  //sample texture in ft2
				
				"mul ft2, ft2, fc3 \n"+ 	//basis-colorierung
				
				"tex ft1, v2, fs2 \n"+ 		//bump map coords
				"mul ft3, v0, ft1 \n"+		// in ft3 ist nun mormal reflektion
				"mul ft4, v1, ft1 \n"+		// in ft4 ist nun mormal mit kamera mitgehend
				
				"tex ft1, ft3, fs1 <2d,clamp,linear> \n"+  //env map texture in ft1
				"mul ft1, ft1, fc6 \n"+
				"add ft2, ft2, ft1 \n"+ 
				
				"dp3 ft1, fc1, ft4 \n"+		//dot the transformed normal with  light direction
				"sat ft1, ft1 \n"+			// keine negativen werte
				"mul ft3, ft1, fc4 \n" + 	//in ft3 normale * licht rgb
				"add ft2, ft2, ft3 \n" +	//zur farbe addieren
				
				"dp3 ft1, fc2, ft4 \n"+     //dot the transformed normal with inverse light direction
				"sat ft1, ft1 \n"+		    //keine Negativen werte
				"sub ft3, fc5, ft2 \n" + 	//
				"mul ft3, ft3, ft1 \n" + 	//
				"add ft2, ft3, ft2 \n" +	//zur farbe addieren
				
				"mov oc, ft2"         		//output the color
			);
			
			
			program = Globals.context3D.createProgram();
			program.upload( vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
			
			
		}
		
		
		public override function renderWithMatrix(_mat:Matrix3D):void  {			
			var _m:Matrix3D = _mat.clone();
			
			_m.append(Camera.viewMatrix);
			
			var _mvv:Matrix3D = _m.clone();
			
			_m.append(Camera.projectionTransform);
			
			
			
			// vertex position to attribute register 0
			Globals.context3D.setVertexBufferAt (0, vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			Globals.context3D.setVertexBufferAt(1, vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_3); //va1 normal
			Globals.context3D.setVertexBufferAt(2, vertexbuffer, 6, Context3DVertexBufferFormat.FLOAT_2); //va2 (u,v)
			
			Globals.context3D.setTextureAt(0, TextureManager.textures[textureIndex].texture);
			Globals.context3D.setTextureAt(1, TextureManager.textures[textureIndex2].texture);
			Globals.context3D.setTextureAt(2, TextureManager.textures[textureIndexBump].texture);
			
			Globals.context3D.setProgram(program);
			
			Globals.context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _m, true); // view + object + projeziert
			Globals.context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, _mat, true); // object
			Globals.context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, _mvv, true); // view + object
			Globals.context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 12,  Vector.<Number>([0.5, 0.5, 0.5, 0.5]));
			
			
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