package com.lhm3d.geometryhelpers
{
	import com.lhm3d.materialobjects.*;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	public class BoundingBox
	{
		
		private var bounds:Vector.<Vector3D> = new Vector.<Vector3D>();
		
		// extending to alternative describing method
		public var center:Vector3D;
		public var u:Vector.<Vector3D>;
		public var e:Vector.<Number>;
		
		// saving vars
		private var eSave:Vector.<Number>;
		private var boundsSave:Vector.<Vector3D> = new Vector.<Vector3D>();
		
		public function BoundingBox(_minP:Vector3D,_maxP:Vector3D)
		{
			center = new Vector3D( (_minP.x+_maxP.x) * 0.5, (_minP.y+_maxP.y) * 0.5, (_minP.z+_maxP.z) * 0.5 );
			
			u = new Vector.<Vector3D>();
			u.push(new Vector3D(1,0,0));
			u.push(new Vector3D(0,1,0));
			u.push(new Vector3D(0,0,1));
			
			e = new Vector.<Number>();
			e.push( (_maxP.x-_minP.x) * 0.5, (_maxP.y-_minP.y) * 0.5, (_maxP.z-_minP.z) * 0.5 );
			eSave = new Vector.<Number>();
			eSave.push(e[0], e[1], e[2]); 
			
			bounds.push(new Vector3D(_minP.x,_minP.y,_minP.z));	
			bounds.push(new Vector3D(_maxP.x,_minP.y,_minP.z));	
			bounds.push(new Vector3D(_maxP.x,_maxP.y,_minP.z));	
			bounds.push(new Vector3D(_minP.x,_maxP.y,_minP.z));	
			
			bounds.push(new Vector3D(_minP.x,_minP.y,_maxP.z));	
			bounds.push(new Vector3D(_maxP.x,_minP.y,_maxP.z));	
			bounds.push(new Vector3D(_maxP.x,_maxP.y,_maxP.z));	
			bounds.push(new Vector3D(_minP.x,_maxP.y,_maxP.z));	
			
			boundsSave.push(new Vector3D(_minP.x,_minP.y,_minP.z));	
			boundsSave.push(new Vector3D(_maxP.x,_minP.y,_minP.z));	
			boundsSave.push(new Vector3D(_maxP.x,_maxP.y,_minP.z));	
			boundsSave.push(new Vector3D(_minP.x,_maxP.y,_minP.z));	
			
			boundsSave.push(new Vector3D(_minP.x,_minP.y,_maxP.z));	
			boundsSave.push(new Vector3D(_maxP.x,_minP.y,_maxP.z));	
			boundsSave.push(new Vector3D(_maxP.x,_maxP.y,_maxP.z));	
			boundsSave.push(new Vector3D(_minP.x,_maxP.y,_maxP.z));	
				
		}
		
		public function traceOut(): void {
			for (var i:int = 0; i < bounds.length; i++) trace("index:",i ,"X:",bounds[i].x,"Y:",bounds[i].y, "Z:",bounds[i].z);
		}
		
		public function getBounds():Vector.<Vector3D> {return bounds;}
		public function getAaMin():Vector3D {return bounds[0];}
		public function getAaMax():Vector3D {return bounds[6];}
		
		
		public function invert():void {
			for (var i:int = 0; i < 8; i++) {
				bounds[i].x = bounds[i].x * -1;
				bounds[i].y = bounds[i].y * -1;
				bounds[i].z = bounds[i].z * -1;				
			}
			for (i = 0; i < 3; i++) {
				u[i].x = u[i].x * -1;
				u[i].y = u[i].y * -1;
				u[i].z = u[i].z * -1;
			}
			
		}
		
		public function setToMatrix(_m:Matrix3D):void{
			// achtung: nicht mer Axis-aligned!!
			
			for (var i:int = 0; i < 8; i++) {
				bounds[i] = _m.transformVector(boundsSave[i]);
			}
			
			var _scale:Number = _m.deltaTransformVector(Vector3D.Z_AXIS).length;
			
			var raw:Vector.<Number> = _m.rawData;
			var right:Vector3D = new Vector3D(raw[0], raw[1], raw[2]);
			var up:Vector3D = new Vector3D(raw[4], raw[5], raw[6]);
			var out:Vector3D = new Vector3D(raw[8], raw[9], raw[10]);
			
			right.normalize();
			up.normalize();
			out.normalize();
			
			u[0] = right;
			u[1] = up;
			u[2] = out;
					
			center.x = (bounds[0].x + bounds[6].x) / 2;
			center.y = (bounds[0].y + bounds[6].y) / 2;
			center.z = (bounds[0].z + bounds[6].z) / 2;
			
			e[0] = eSave[0] * _scale;
			e[1] = eSave[1] * _scale;
			e[2] = eSave[2] * _scale;
			
		} 
		
		
		public function cloneValuesFromOtherBB(_obb:BoundingBox):void {
			
			bounds = new Vector.<Vector3D>();
			boundsSave = new Vector.<Vector3D>();
			
			for (var i:int = 0; i < 8; i++) {
				bounds.push(_obb.bounds[i]);
				boundsSave.push(_obb.boundsSave[i]);
			}
			
			center = new Vector3D(_obb.center.x, _obb.center.y, _obb.center.z);

			u = new Vector.<Vector3D>();
			u.push(new Vector3D(_obb.u[0].x,_obb.u[0].y,_obb.u[0].z));
			u.push(new Vector3D(_obb.u[1].x,_obb.u[1].y,_obb.u[1].z));
			u.push(new Vector3D(_obb.u[2].x,_obb.u[2].y,_obb.u[2].z)); 
			
			e[0] = _obb.e[0];
			e[1] = _obb.e[1];
			e[2] = _obb.e[2];
			
			eSave[0] = _obb.eSave[0];
			eSave[1] = _obb.eSave[1];
			eSave[2] = _obb.eSave[2];
			
		}
		
		
		public function pointInSelfAaBB(_p:Vector3D):Boolean {
		
			if ((_p.x >= bounds[0].x) && (_p.x <= bounds[6].x) && (_p.y >= bounds[0].y) && (_p.y <= bounds[6].y) && (_p.z >= bounds[0].z) && (_p.z <= bounds[6].z)) return true; else return false;
				
		}
		
		public function pointInSelfNonAaBB(_p:Vector3D):Boolean { 
			var _r1:Boolean = HelpMath.pointSideTriangle(_p, bounds[0], bounds[1], bounds[2]);
			var _r2:Boolean = HelpMath.pointSideTriangle(_p, bounds[1], bounds[5], bounds[6]);
			var _r3:Boolean = HelpMath.pointSideTriangle(_p, bounds[5], bounds[4], bounds[7]);
			var _r4:Boolean = HelpMath.pointSideTriangle(_p, bounds[4], bounds[0], bounds[3]);
			var _r5:Boolean = HelpMath.pointSideTriangle(_p, bounds[3], bounds[2], bounds[6]);
			var _r6:Boolean = HelpMath.pointSideTriangle(_p, bounds[4], bounds[5], bounds[1]);
			
			return ((_r1==_r2)&&(_r1==_r3)&&(_r1==_r4)&&(_r1==_r5)&&(_r1==_r6));	
		}
	
		
		public function TestIntersectionWithOtherOBB(_obb:BoundingBox) : Boolean
		{
			const  EPSILON:Number = 1.175494e-37;
			
			var R:Vector.<Vector.<Number>> = new <Vector.<Number>>[
				new <Number>[0,0,0],
				new <Number>[0,0,0],
				new <Number>[0,0,0]
			];
			
			var AbsR:Vector.<Vector.<Number>> = new <Vector.<Number>>[
				new <Number>[0,0,0],
				new <Number>[0,0,0],
				new <Number>[0,0,0]
			];
			
			for(var i:int = 0; i < 3; i++)
			{
				for(var j:int = 0; j < 3; j++)
				{
					R[i][j] = u[i].dotProduct(_obb.u[j]);
					AbsR[i][j] = Math.abs(R[i][j]) + EPSILON;
				}
			}
			
			var tt:Vector3D = _obb.center.subtract(center); 
		
			var t:Vector.<Number> = new Vector.<Number>();
			t.push(tt.dotProduct(u[0]), tt.dotProduct(u[1]), tt.dotProduct(u[2]));
			
			var ra:Number;
			var rb:Number;
				
			for(i = 0; i < 3; i++)
			{
				ra = e[i];
				rb = _obb.e[0] * AbsR[i][0] + _obb.e[1] * AbsR[i][1] +_obb.e[2] * AbsR[i][2];
				if (Math.abs(t[i])  >  ra + rb ) return false;

			}
			for(i = 0; i < 3; i++)
			{
				ra = e[0] * AbsR[0][i] + e[1] * AbsR[1][i] + e[2] * AbsR[2][i];
				rb = _obb.e[i];
				if(Math.abs(t[0] * R[0][i] + t[1] * R[1][i] + t[2] * R[2][i]) > ra + rb) return false;
			}
			
			ra = e[1] * AbsR[2][0] + e[2] * AbsR[1][0];
			rb = _obb.e[1] * AbsR[0][2] + _obb.e[2] * AbsR[0][1];
			if(Math.abs(t[2] * R[1][0] - t[1] * R[2][0]) > ra + rb) return false;
			
			ra = e[1] * AbsR[2][1] + e[2] * AbsR[1][1];
			rb = _obb.e[0] * AbsR[0][2] + _obb.e[2] * AbsR[0][0];
			if(Math.abs(t[2] * R[1][1] - t[1] * R[2][1]) > ra + rb) return false;
			
			ra = e[1] * AbsR[2][2] + e[2] * AbsR[1][2];
			rb = _obb.e[0] * AbsR[0][1] + _obb.e[1] * AbsR[0][0];
			if(Math.abs(t[2] * R[1][2] - t[1] * R[2][2]) > ra + rb) return false;
			
			ra = e[0] * AbsR[2][0] + e[2] * AbsR[0][0];
			rb = _obb.e[1] * AbsR[1][2] + _obb.e[2] * AbsR[1][1];
			if(Math.abs(t[0] * R[2][0] - t[2] * R[0][0]) > ra + rb) return false;
			
			ra = e[0] * AbsR[2][1] + e[2] * AbsR[0][1];
			rb = _obb.e[0] * AbsR[1][2] + _obb.e[2] * AbsR[1][0];
			if(Math.abs(t[0] * R[2][1] - t[2] * R[0][1]) > ra + rb) return false;
			
			ra = e[0] * AbsR[2][2] + e[2] * AbsR[0][2];
			rb = _obb.e[0] * AbsR[1][1] + _obb.e[1] * AbsR[1][0];
			if(Math.abs(t[0] * R[2][2] - t[2] * R[0][2]) > ra + rb) return false;
			
			ra = e[0] * AbsR[1][0] + e[1] * AbsR[0][0];
			rb = _obb.e[1] * AbsR[2][2] + _obb.e[2] * AbsR[2][1];
			if(Math.abs(t[1] * R[0][0] - t[0] * R[1][0]) > ra + rb) return false;
			
			ra = e[0] * AbsR[1][1] + e[1] * AbsR[0][1];
			rb = _obb.e[0] * AbsR[2][2] + _obb.e[2] * AbsR[2][0];
			if(Math.abs(t[1] * R[0][1] - t[0] * R[1][1]) > ra + rb) return false;
			
			ra = e[0] * AbsR[1][2] + e[1] * AbsR[0][2];
			rb = _obb.e[0] * AbsR[2][1] + _obb.e[1] * AbsR[2][0];
			if(Math.abs(t[1] * R[0][2] - t[0] * R[1][2]) > ra + rb) return false;
				
			return true;
		}
		
		
		public function intersectsOtherNonAaBB(_obb:BoundingBox):Boolean {
			return TestIntersectionWithOtherOBB(_obb);		
		}
		
		
		// display helping function
		public function buildTex3DObject(_textureIndex:int):Tex3DObject {
			
			var _vLayer:Vector.<Number> = new Vector.<Number>();
			
			for (var i:int = 0; i < bounds.length; i++) _vLayer.push(bounds[i].x,bounds[i].y,bounds[i].z);
			
			
			var _uvLayer:Vector.<Number> = new Vector.<Number>();
			_uvLayer.push(0,0);
			_uvLayer.push(1,0);
			_uvLayer.push(1,1);
			_uvLayer.push(0,1);
			
			_uvLayer.push(0,0);
			_uvLayer.push(1,0);
			_uvLayer.push(1,1);
			_uvLayer.push(0,1);

			
			var _iLayer:Vector.<uint> = new Vector.<uint>();
			_iLayer.push(0,1,2, 2,3,0);
			_iLayer.push(1,5,6, 6,2,1);
			
			_iLayer.push(5,4,7, 7,6,5);
			_iLayer.push(3,2,6, 6,7,3);
			
			_iLayer.push(1,0,4, 4,5,1);
			_iLayer.push(4,0,3, 3,7,4);

			
			return new Tex3DObject(_textureIndex,_vLayer,_uvLayer,_iLayer);

			
		}
		
		
		
		
		
	}
}