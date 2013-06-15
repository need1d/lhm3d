package com.lhm3d.viewtree
{
	import com.lhm3d.geometryhelpers.BoundingBox;
	
	import flash.geom.Matrix3D;

	public class TreeEntity
	{
		
		internal var m:Matrix3D;
		internal var ref:int;
		
		internal var rendered:Boolean = false;
		
		public function TreeEntity(_ref:int,_m:Matrix3D):void {
			m= _m.clone();
			ref = _ref;
		}
		
		
	}
}