package com.lhm3d.materialobjects
{
	
	import com.adobe.utils.AGALMiniAssembler;
	import com.adobe.utils.PerspectiveMatrix3D;
	import com.lhm3d.camera.*;
	import com.lhm3d.geometryhelpers.*;
	import com.lhm3d.globals.Globals;
	import com.lhm3d.light.Light;
	
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
	import flash.utils.getTimer;
	
	public class Base3DObject
	{
		
		
		protected var vertexbuffer:VertexBuffer3D;
		protected var indexbuffer:IndexBuffer3D;
		
		protected var program:Program3D;
		
		protected var light:Light;
				
		private var boundingBox:BoundingBox;
		private var radius:Number;
		
		
		private var vertexLayer:Vector.<Number>; // save reference for physics
		private var indexLayer:Vector.<uint>; // save reference for physics
		
		public function Base3DObject(_vertexLayer:Vector.<Number>, _indexLayer:Vector.<uint>)
		{
			
			vertexLayer = _vertexLayer;
			indexLayer = _indexLayer;
			
			light = Globals.light;
						
			var _minP:Vector3D = new Vector3D(Number.MAX_VALUE,Number.MAX_VALUE,Number.MAX_VALUE);
			var _maxP:Vector3D = new Vector3D(Number.MIN_VALUE,Number.MIN_VALUE,Number.MIN_VALUE);
			radius = 0;

			
			for (var i:int = 0; i < _vertexLayer.length / 3; i++) {
				var _index:int = i*3;
				if (_minP.x > _vertexLayer[_index+0]) _minP.x = _vertexLayer[_index+0];
				if (_minP.y > _vertexLayer[_index+1]) _minP.y = _vertexLayer[_index+1];
				if (_minP.z > _vertexLayer[_index+2]) _minP.z = _vertexLayer[_index+2];
				
				if (_maxP.x < _vertexLayer[_index+0]) _maxP.x = _vertexLayer[_index+0];
				if (_maxP.y < _vertexLayer[_index+1]) _maxP.y = _vertexLayer[_index+1];
				if (_maxP.z < _vertexLayer[_index+2]) _maxP.z = _vertexLayer[_index+2];
			
				var _qr:Number = _vertexLayer[_index+0]*_vertexLayer[_index+0]+_vertexLayer[_index+1]*_vertexLayer[_index+1]+_vertexLayer[_index+2]*_vertexLayer[_index+2]; 
				if (_qr > radius) radius = _qr;
			}
			
			radius = Math.sqrt(radius);
			
			boundingBox = new BoundingBox(_minP, _maxP); 
			

			
		}
		
		public function getVertexLayer() :Vector.<Number> {return vertexLayer;}
		
		public function getIndexLayer() :Vector.<uint> {return indexLayer;}
		
		public function getBoundingBox():BoundingBox {return boundingBox;}
		
		public function setLight(_light:Light) : void {
			light = _light;
		}
		
		
		public function renderAtPosition(_x:Number, _y:Number, _z:Number):void {
			var _m:Matrix3D = new Matrix3D();
			_m.appendTranslation(_x,_y,_z);
			
			var _res:int = Visibility.testSphereAgainstView(_x,_y,_z,radius);
			
			if (_res == Visibility.OUT) return;
			if (_res == Visibility.INTERSECT) { 
				if (Visibility.testAaBBMoveMatrixAgainstView(_m,boundingBox) == false) return;
			}
			
			renderWithMatrix(_m);
			
			Globals.renderedObjectCount ++;
			
		}
		
	
		// Methoden, die überschrieben werden
		
		public function renderWithMatrix(_m:Matrix3D):void  {

		}
		
		
		
		
		
		
		
	}
}