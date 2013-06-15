package com.lhm3d.geometryhelpers
{
	import flash.geom.Vector3D;
	
	public class Plane
	{
		
		private var a:Number;		
		private var b:Number;
		private var c:Number;
		private var d:Number;

		private var n:Vector3D;
		
		public function Plane(_a:Number = 0,_b:Number = 1,_c:Number = 0,_d:Number = 0)
		{
			a = _a;
			b = _b;
			c = _c;
			d = _d;

			var _l:Number = Math.sqrt(a*a+b*b+c*c);
			a = a / _l;
			b = b / _l;
			c = c / _l;
			d = d / _l;

			n = new Vector3D(a,b,c);
		}
		
		public function getNormal():Vector3D {return n;}
		
		public function getDistance():Number {return d;}
		
		public function inSide(_v:Vector3D):Boolean {
			return ((a*_v.x + b*_v.y + c*_v.z - d) > 0);	
		}
		
		
		
	}
}