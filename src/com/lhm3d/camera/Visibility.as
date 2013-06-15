package com.lhm3d.camera
{
	
	import com.lhm3d.globals.Globals;
	import com.lhm3d.geometryhelpers.BoundingBox;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	public class Visibility
	{
		public static var IN:int = 2;
		public static var OUT:int = 0;
		public static var INTERSECT:int = 1;
		
	
		public static function testSphereAgainstView(_x:Number, _y:Number, _z:Number, _r:Number):int {
			
			var _fDistance:Number;
			
			for(var i:int = 0; i < 6; i++) {
				
				// distanz zur plane
				_fDistance = Camera.clipPlanes[i].getNormal().dotProduct(new Vector3D(_x,_y,_z))+Camera.clipPlanes[i].getDistance();
				
				if(_fDistance < -_r) return(OUT);
				
				if(Math.abs(_fDistance) < _r) return(INTERSECT); //intersect
			}
			
			return(IN);
		}
		
		
		public static function testAaBBAgainstView(_bb:BoundingBox):Boolean {
			
			var _iTotalIn:int = 0;
			for(var p:int = 0; p < 6; p++) {
				
				var _iInCount:int = 8;
				var _iPtIn:int = 1;
				
				for(var i:int = 0; i < 8; i++) {
					
					if(Camera.clipPlanes[p].inSide(_bb.getBounds()[i]) == true) {
						_iPtIn = 0;
						_iInCount--;
					}
				}
				
				if(_iInCount == 0) return(false);
				_iTotalIn += _iPtIn;
			}
			
			//if( _iTotalIn == 6) return(true); // komplett im view
			
			return(true); // mindestens intersect also true

		}
		
		
		public static function testAaBBMoveMatrixAgainstView(_m:Matrix3D, _bb:BoundingBox):Boolean {

			var _iTotalIn:int = 0;
			var _bounds:Vector.<Vector3D> = new Vector.<Vector3D>();

			var _mm:Matrix3D = _m.clone();
			_mm.invert();
			
			for (var o:int; o < _bb.getBounds().length; o++) _bounds.push( _mm.transformVector(_bb.getBounds()[o]));			
			
			for(var p:int = 0; p < 6; p++) {
				
				var _iInCount:int = 8;
				var _iPtIn:int = 1;
				
				for(var i:int = 0; i < 8; i++) {
					
					if(Camera.clipPlanes[p].inSide(_bounds[i]) == true) {
						_iPtIn = 0;
						_iInCount--;
					}
				}
				
				if(_iInCount == 0) return(false);
				
				_iTotalIn += _iPtIn;
			}
			
			//if( _iTotalIn == 6) return(true);  // komplett im view
			
			return(true); // mindestens intersect also true

		}
		
		
		
		
	}
}