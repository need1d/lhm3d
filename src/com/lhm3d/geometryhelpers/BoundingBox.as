package com.lhm3d.geometryhelpers
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	public class BoundingBox
	{
		
		private var bounds:Vector.<Vector3D> = new Vector.<Vector3D>();
		
		public function BoundingBox(_minP:Vector3D,_maxP:Vector3D)
		{
			
			bounds.push(new Vector3D(_minP.x,_minP.y,_minP.z));	
			bounds.push(new Vector3D(_maxP.x,_minP.y,_minP.z));	
			bounds.push(new Vector3D(_maxP.x,_maxP.y,_minP.z));	
			bounds.push(new Vector3D(_minP.x,_maxP.y,_minP.z));	
			
			bounds.push(new Vector3D(_minP.x,_minP.y,_maxP.z));	
			bounds.push(new Vector3D(_maxP.x,_minP.y,_maxP.z));	
			bounds.push(new Vector3D(_maxP.x,_maxP.y,_maxP.z));	
			bounds.push(new Vector3D(_minP.x,_maxP.y,_maxP.z));	
				
		}
		
		public function traceOut(): void {
			for (var i:int = 0; i < bounds.length; i++) trace("X:",bounds[i].x,"Y:",bounds[i].y, "Z:",bounds[i].z);
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
		}
		
		public function appendMatrix(_m:Matrix3D):void{
			// achtung: evtl. nicht mer Axis-aligned!!
			for (var i:int = 0; i < 8; i++) bounds[i] = _m.transformVector(bounds[i]);
			
		} 
		
		
		public function cloneValuesFromOtherBB(_obb:BoundingBox):void {
			bounds = new Vector.<Vector3D>();
			for (var i:int = 0; i < 8; i++) bounds.push(_obb.bounds[i]);
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
			var _r6:Boolean = HelpMath.pointSideTriangle(_p, bounds[5], bounds[0], bounds[4]);
			
			return ((_r1==_r2)&&(_r1==_r3)&&(_r1==_r4)&&(_r1==_r5)&&(_r1==_r6));
		}
		
		
		public function icludesOtherNonAaBB(_obb:BoundingBox):Boolean {
			for (var i:int = 0; i < 8; i++) {
				if (pointInSelfAaBB(_obb.bounds[i])) return true;
				if (_obb.pointInSelfNonAaBB(bounds[i])) return true;
			}
			return false;		
		}
		
		
		
	}
}