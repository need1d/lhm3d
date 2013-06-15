package com.lhm3d.fileobjectloaders
{
	import flash.geom.Vector3D;

	public class SplitCubeEntity
	{
		
		internal var indexLayer:Vector.<uint> = new Vector.<uint>();
		
		public function SplitCubeEntity(_x:Number, _y:Number, _z:Number, _sideLength:Number, _vertexLayer:Vector.<Number>, _indexLayer:Vector.<uint>):void
		{
			
			var _minX:Number = 	_x - _sideLength / 2;
			var _minY:Number = 	_y - _sideLength / 2;
			var _minZ:Number = 	_z - _sideLength / 2;
			
			var _maxX:Number = 	_x + _sideLength / 2;
			var _maxY:Number = 	_y + _sideLength / 2;
			var _maxZ:Number = 	_z + _sideLength / 2;
			
			for (var i:int = 0; i < _indexLayer.length / 3; i++) {
				
				var _i1:uint = _indexLayer[i*3];
				var _i2:uint = _indexLayer[i*3+1];
				var _i3:uint = _indexLayer[i*3+2];
				
				var _mp:Vector3D = new Vector3D((_vertexLayer[_i1*3] + _vertexLayer[_i2*3] + _vertexLayer[_i3*3]) / 3,
												(_vertexLayer[_i1*3+1] + _vertexLayer[_i2*3+1] + _vertexLayer[_i3*3+1]) / 3,
												(_vertexLayer[_i1*3+2] + _vertexLayer[_i2*3+2] + _vertexLayer[_i3*3+2]) / 3);
				
				if ((_mp.x >= _minX) && (_mp.x < _maxX) && (_mp.y >= _minY) && (_mp.y < _maxY) && (_mp.z >= _minZ) && (_mp.z < _maxZ)) {
					indexLayer.push(_i1,_i2,_i3); // diekte punkte die im bereich liegen und EIN poly beschrieben
				}
			
			}
			
			
		}
		
		
		
		
		
		
	}
}