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
	
	
	
	public class Tex3DObject extends Base3DObject
	{

		private static var program:Program3D = null;
		
		private var textureIndex:int;
		
		public function Tex3DObject(_textureIndex:int, _vertexLayer:Vector.<Number>, _uvLayer:Vector.<Number>, _indexLayer:Vector.<uint>)
		{
			super(_vertexLayer,_indexLayer);
			
			textureIndex = _textureIndex;
			var vertices:Vector.<Number> = new Vector.<Number>();
			
			for (var i:int = 0; i < _vertexLayer.length / 3; i++) {
				vertices.push(_vertexLayer[i*3],_vertexLayer[i*3+1],_vertexLayer[i*3+2],_uvLayer[i*2],_uvLayer[i*2+1]);
			}
			
			
			vertexbuffer = Globals.context3D.createVertexBuffer(_vertexLayer.length / 3, 5);
			vertexbuffer.uploadFromVector(vertices, 0, vertices.length / 5);		
			
			
			indexbuffer = Globals.context3D.createIndexBuffer(_indexLayer.length);			
			indexbuffer.uploadFromVector (_indexLayer, 0, _indexLayer.length);	
			
			if (program == null) {
			
				var vertexShaderAssembler : AGALMiniAssembler = new AGALMiniAssembler();
				vertexShaderAssembler.assemble( Context3DProgramType.VERTEX,
					"m44 op, va0, vc0\n" + // pos to clipspace
					"mov v0, va1" // copy UV
				);			
				
				var fragmentShaderAssembler : AGALMiniAssembler= new AGALMiniAssembler();
				fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,
					"tex ft1, v0, fs0 <2d,linear,nomip>\n" +
					"mov oc, ft1"
				);
				
				program = Globals.context3D.createProgram();
				program.upload( vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
			
			}
			
		}
		
		
		public override function renderWithMatrix(_mat:Matrix3D, _cull:String = Context3DTriangleFace.FRONT, _blend1:String = Context3DBlendFactor.ONE, _blend2:String = Context3DBlendFactor.ZERO):void  {
			
			var _m:Matrix3D = _mat.clone();
			
			_m.append(Camera.viewMatrix);
			_m.append(Camera.projectionTransform);
			
			Globals.context3D.setProgram(program);
			

			Globals.context3D.setVertexBufferAt (0, vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);

			Globals.context3D.setVertexBufferAt(1, vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_2);

			Globals.context3D.setTextureAt(0, TextureManager.textures[textureIndex].texture);

			
			
			Globals.context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _m, true);
			
			Globals.context3D.setBlendFactors(_blend1, _blend2);
			Globals.context3D.setCulling(_cull);
			Globals.context3D.drawTriangles(indexbuffer);
			
			
			// cleanup
			Globals.context3D.setVertexBufferAt(0, null);
			Globals.context3D.setVertexBufferAt(1, null);
			Globals.context3D.setTextureAt(0, null);
			
		}
		
	}
}