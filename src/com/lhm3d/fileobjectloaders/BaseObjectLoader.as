package com.lhm3d.fileobjectloaders
{
	import flash.geom.Point;
	import flash.geom.Vector3D;

	public class BaseObjectLoader
	{
		protected var scale:Number;
		
		protected var tangentLayer:Vector.<Number> = new Vector.<Number>();
		protected var biTangentLayer:Vector.<Number> = new Vector.<Number>();
		protected var vertexLayer:Vector.<Number> = new Vector.<Number>();
		protected var uvLayer:Vector.<Number> = new Vector.<Number>();
		protected var normalLayer:Vector.<Number> = new Vector.<Number>();
		protected var indexLayer:Vector.<uint> = new Vector.<uint>();
				
		private var biTangentTangentCalculated:Boolean = false;
		
		//splitting
		private var splitCount:int = 0;
		private var minP:Vector3D;
		private var maxP:Vector3D;
		
		private var splitCubeLength:Number = 0;
		
		protected var splitData:Vector.<SplitDataEntity> = new Vector.<SplitDataEntity>();
		
		
		public function BaseObjectLoader()
		{
		}
		
		/*
		void ComputeTangentBasis(
		const Vec3& P1, const Vec3& P2, const Vec3& P3, 
		const Vec2& UV1, const Vec2& UV2, const Vec2& UV3,
		Vec3 &tangent, Vec3 &bitangent )
		{
		Vec3 Edge1 = P2 - P1;
		Vec3 Edge2 = P3 - P1;
		Vec2 Edge1uv = UV2 - UV1;
		Vec2 Edge2uv = UV3 - UV1;
		
		float cp = Edge1uv.y * Edge2uv.x - Edge1uv.x * Edge2uv.y;
		
		if ( cp != 0.0f ) {
		float mul = 1.0f / cp;
		tangent   = (Edge1 * -Edge2uv.y + Edge2 * Edge1uv.y) * mul;
		bitangent = (Edge1 * -Edge2uv.x + Edge2 * Edge1uv.x) * mul;
		
		tangent.Normalize();
		bitangent.Normalize();
		}
		}
		*/
		
		private function tangentBiTangentForPoly(_p1:Vector3D, _p2:Vector3D, _p3:Vector3D, _uv1:Point, _uv2:Point, _uv3:Point):TangentBiTangentEntity {
			
				var _edge1:Vector3D = _p2.subtract(_p1);
				var _edge2:Vector3D = _p3.subtract(_p1);
				
				var _edge1uv:Point = _uv2.subtract(_uv1);
				var _edge2uv:Point = _uv3.subtract(_uv1);
				
				var _cp:Number = _edge1uv.y * _edge2uv.x - _edge1uv.x * _edge2uv.y;
				
				var _ret:TangentBiTangentEntity = new TangentBiTangentEntity();
				
				if (_cp != 0.0) {
					
					var _mul:Number = 1.0 / _cp;
					
					_ret.tangent = new Vector3D( (_edge1.x * -_edge2uv.y + _edge2.x * _edge1uv.y) * _mul,
											 	 (_edge1.y * -_edge2uv.y + _edge2.y * _edge1uv.y) * _mul,
											 	 (_edge1.z * -_edge2uv.y + _edge2.z * _edge1uv.y) * _mul);
					
					_ret.biTangent = new Vector3D( (_edge1.x * -_edge2uv.x + _edge2.x * _edge1uv.x) * _mul,
											   	   (_edge1.y * -_edge2uv.x + _edge2.y * _edge1uv.x) * _mul,
											   	   (_edge1.z * -_edge2uv.x + _edge2.z * _edge1uv.x) * _mul);
					
					_ret.tangent.normalize();
					_ret.biTangent.normalize();
					
				}
				
				return _ret;

		} 
		
		
		private function calculateTangentBiTangent():void {
			for (var i:int = 0; i < indexLayer.length/3; i++) {
				
				var _ind1:int = indexLayer[i*3];
				var _ind2:int = indexLayer[i*3+1];
				var _ind3:int = indexLayer[i*3+2];
				
				var _p1:Vector3D = new Vector3D(vertexLayer[_ind1*3],vertexLayer[_ind1*3+1],vertexLayer[_ind1*3+2]);
				var _p2:Vector3D = new Vector3D(vertexLayer[_ind2*3],vertexLayer[_ind2*3+1],vertexLayer[_ind2*3+2]);
				var _p3:Vector3D = new Vector3D(vertexLayer[_ind3*3],vertexLayer[_ind3*3+1],vertexLayer[_ind3*3+2]);					
				
				var _uv1:Point = new Point(vertexLayer[_ind1*2],vertexLayer[_ind1*2+1]);
				var _uv2:Point = new Point(vertexLayer[_ind2*2],vertexLayer[_ind2*2+1]);
				var _uv3:Point = new Point(vertexLayer[_ind3*2],vertexLayer[_ind3*2+1]);
				
				var _res:TangentBiTangentEntity= tangentBiTangentForPoly(_p1,_p2,_p3,_uv1,_uv2,_uv3);
				
				tangentLayer.push(_res.tangent.x,_res.tangent.y,_res.tangent.z);
				biTangentLayer.push(_res.biTangent.x,_res.biTangent.y,_res.biTangent.z);
				
			}
			
		}
		
		public function getTangentLayer():Vector.<Number> {
			if (!biTangentTangentCalculated) {
				biTangentTangentCalculated = true;
				calculateTangentBiTangent();
			}
			return tangentLayer;
		}
		
		public function getBiTangentLayer():Vector.<Number> {
			if (!biTangentTangentCalculated) {
				biTangentTangentCalculated = true;
				calculateTangentBiTangent();
			}
			return biTangentLayer;
		}
		
		public function getVertexLayer():Vector.<Number> {return vertexLayer;}
		public function getUVLayer():Vector.<Number> {return uvLayer;}
		public function getNormalLayer():Vector.<Number> {return normalLayer;}
		public function getIndexLayer():Vector.<uint> {return indexLayer;}
		
		public function getSplitVertexLayer(_index:int):Vector.<Number> {return splitData[_index].vertexLayer;}
		public function getSplitUVLayer(_index:int):Vector.<Number> {return splitData[_index].uvLayer;}
		public function getSplitNormalLayer(_index:int):Vector.<Number> {return splitData[_index].normalLayer;}
		public function getSplitIndexLayer(_index:int):Vector.<uint> {return splitData[_index].indexLayer;}
		public function getSplitPartLength():int {return (splitData.length);}
		
		
		public function doSplit(_longestPartCount:int):void {
			
			getMinMax();
			
			if (((maxP.x-minP.x) >= (maxP.y-minP.y))&&((maxP.x-minP.x) >= (maxP.z-minP.z))) {
				splitCubeLength = (maxP.x-minP.x)/_longestPartCount;
			}
			
			if (((maxP.y-minP.y) >= (maxP.x-minP.x))&&((maxP.y-minP.y) >= (maxP.z-minP.z))) {
				splitCubeLength = (maxP.y-minP.y)/_longestPartCount;
			}
			
			if (((maxP.z-minP.z) >= (maxP.x-minP.x))&&((maxP.z-minP.z) >= (maxP.y-minP.y))) {
				splitCubeLength = (maxP.z-minP.z)/_longestPartCount;
			}
			
			var _splitCubes:Vector.<SplitCubeEntity> = new Vector.<SplitCubeEntity>();
			
			for (var _x:int = 0; _x < Math.ceil((maxP.x-minP.x)/splitCubeLength); _x++) {
				for (var _y:int = 0; _y < Math.ceil((maxP.y-minP.y)/splitCubeLength); _y++) {
					for (var _z:int = 0; _z < Math.ceil((maxP.z-minP.z)/splitCubeLength); _z++) {
						
						_splitCubes.push(new SplitCubeEntity(minP.x+_x*splitCubeLength+splitCubeLength/2,minP.y+_y*splitCubeLength+splitCubeLength/2,minP.z+_z*splitCubeLength+splitCubeLength/2,splitCubeLength,vertexLayer,indexLayer));		
						
					}
				}
			 }
			
			
			for (var i:int = 0; i < _splitCubes.length; i++) {
				if (_splitCubes[i].indexLayer.length > 0) {
					
					splitData.push(new SplitDataEntity());
					
					var _ind:int = splitData.length - 1;
					var _tmpIndexes:Vector.<uint> = new Vector.<uint>();
					var _tmpNewIndexes:Vector.<uint> = new Vector.<uint>();
					
					for (var o:int = 0; o < _splitCubes[i].indexLayer.length; o++) {
						
						var _foundIndex:int = -1;
						for (var j:int = 0; j < _tmpIndexes.length; j++) if (_tmpIndexes[j] == _splitCubes[i].indexLayer[o]) _foundIndex = j;
						
						if (_foundIndex == -1) {
							splitData[_ind].vertexLayer.push(vertexLayer[_splitCubes[i].indexLayer[o]*3],vertexLayer[_splitCubes[i].indexLayer[o]*3+1],vertexLayer[_splitCubes[i].indexLayer[o]*3+2]);
							splitData[_ind].normalLayer.push(normalLayer[_splitCubes[i].indexLayer[o]*3],normalLayer[_splitCubes[i].indexLayer[o]*3+1],normalLayer[_splitCubes[i].indexLayer[o]*3+2]);
							splitData[_ind].uvLayer.push(uvLayer[_splitCubes[i].indexLayer[o]*2],uvLayer[_splitCubes[i].indexLayer[o]*2+1]);
							splitData[_ind].indexLayer.push(splitData[_ind].uvLayer.length / 2 -1);
							_tmpIndexes.push(_splitCubes[i].indexLayer[o]);
							_tmpNewIndexes.push(splitData[_ind].uvLayer.length / 2 -1);
						} else {
							splitData[_ind].indexLayer.push(_tmpNewIndexes[_foundIndex]);
						}
						
					
					} 			
				}
			} 
			
		
		}
		
	
		
		private function getMinMax():void {
			
			minP = new Vector3D(Number.MAX_VALUE,Number.MAX_VALUE,Number.MAX_VALUE);
			maxP = new Vector3D(Number.MIN_VALUE,Number.MIN_VALUE,Number.MIN_VALUE);
			
			for (var i:int = 0; i < vertexLayer.length / 3; i++) {
				var _index:int = i*3;
				if (minP.x > vertexLayer[_index+0]) minP.x = vertexLayer[_index+0];
				if (minP.y > vertexLayer[_index+1]) minP.y = vertexLayer[_index+1];
				if (minP.z > vertexLayer[_index+2]) minP.z = vertexLayer[_index+2];
				
				if (maxP.x < vertexLayer[_index+0]) maxP.x = vertexLayer[_index+0];
				if (maxP.y < vertexLayer[_index+1]) maxP.y = vertexLayer[_index+1];
				if (maxP.z < vertexLayer[_index+2]) maxP.z = vertexLayer[_index+2];
				
			}
		
		}
		
		
		
		
	}
}