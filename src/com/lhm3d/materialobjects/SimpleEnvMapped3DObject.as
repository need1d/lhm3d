package com.lhm3d.materialobjects
{
	import com.adobe.utils.AGAL;
	import com.adobe.utils.AGALMiniAssembler;
	
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
	import com.lhm3d.globals.Globals;
	import com.lhm3d.texturemanager.TextureManager;
	import com.lhm3d.camera.*;
	
	
	
	public class SimpleEnvMapped3DObject extends Base3DObject
	{
		
		private var textureIndex:int;
		
		public function SimpleEnvMapped3DObject(_textureIndex:int, _vertexLayer:Vector.<Number>, 
												  _normalLayer:Vector.<Number>,
												  _indexLayer:Vector.<uint>)
		{
			super(_vertexLayer);
			
			textureIndex = _textureIndex;
			var vertices:Vector.<Number> = new Vector.<Number>();
			
			for (var i:int = 0; i < _vertexLayer.length / 3; i++) {
				vertices.push(_vertexLayer[i*3],_vertexLayer[i*3+1],_vertexLayer[i*3+2],_normalLayer[i*3],_normalLayer[i*3+1],_normalLayer[i*3+2]);
			}
			
			
			vertexbuffer = Globals.context3D.createVertexBuffer(_vertexLayer.length / 3, 6);
			vertexbuffer.uploadFromVector(vertices, 0, _vertexLayer.length / 3);		
			
			
			indexbuffer = Globals.context3D.createIndexBuffer(_indexLayer.length);			
			indexbuffer.uploadFromVector (_indexLayer, 0, _indexLayer.length);	
			
			var vertexShaderAssembler : AGALMiniAssembler = new AGALMiniAssembler();
			
			AGAL.init();
			AGAL.m44("op","va0","vc0");
			AGAL.m44("vt0","va1","vc4");
			AGAL.mul("vt0","vt0","vc8");
			AGAL.add("vt0","vt0","vc8");
			AGAL.mov("v0","vt0");
			
			vertexShaderAssembler.assemble( Context3DProgramType.VERTEX,AGAL.code);
			
			var fragmentShaderAssembler : AGALMiniAssembler= new AGALMiniAssembler();
			fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,
				"tex ft1, v0, fs0 <2d,linear,nomip>\n" +
				"mov oc, ft1"
			);
			
			program = Globals.context3D.createProgram();
			program.upload( vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
			
			
		}
		
		
		public override function renderWithMatrix(_mat:Matrix3D):void  {
			var _m:Matrix3D = _mat.clone();
			
			_m.append(Camera.viewMatrix);			
			_m.append(Camera.projectionTransform);
			
			Globals.context3D.setVertexBufferAt (0, vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			Globals.context3D.setVertexBufferAt(1, vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_3);
			Globals.context3D.setTextureAt(0, TextureManager.textures[textureIndex].texture);				
			Globals.context3D.setProgram(program);
			
			Globals.context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _m, true);
			Globals.context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, _mat, true);
			Globals.context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 8,  Vector.<Number>([0.5, 0.5, 0.5, 0.5]));

			
			Globals.context3D.drawTriangles(indexbuffer);
			
		}
		
	}
}// ActionScript file