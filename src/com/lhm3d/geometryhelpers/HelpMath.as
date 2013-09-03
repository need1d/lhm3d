package com.lhm3d.geometryhelpers
{
	import flash.geom.*;
	
	public class HelpMath
	{
		public function HelpMath()
		{
		}
		
		public static function pointSideTriangle(_p:Vector3D, _t1:Vector3D, _t2:Vector3D, _t3:Vector3D) : Boolean {
		
			var _n:Vector3D = _t2.subtract(_t1).crossProduct(_t3.subtract(_t1)); 
			return _n.dotProduct(_p.subtract(_t1)) > 0;					
		
		}
		
		
	}
}