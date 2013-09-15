package com.lhm3d.geometryhelpers
{
	import flash.geom.*;
	
	public class HelpMath
	{
		public function HelpMath()
		{
		}
		
		public static function extractR(col:uint):Number {
			return (((col >> 16 ) & 0xFF) / 255.0);
		}
		
		public static function extractG(col:uint):Number {
			return (((col >> 8) & 0xFF ) / 255.0);
		}
		
		public static function extractB(col:uint):Number {
			return ((col & 0xFF ) / 255.0);
		}
		
		public static function pointSideTriangle(_p:Vector3D, _t1:Vector3D, _t2:Vector3D, _t3:Vector3D) : Boolean {
		
			var _n:Vector3D = _t3.subtract(_t1).crossProduct(_t3.subtract(_t2)); 
			return _n.dotProduct(_p.subtract(_t1)) < 0;					
		
		}
		
		
	}
}