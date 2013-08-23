package com.lhm3d.light
{
	
	import com.lhm3d.globals.Globals;
	
	import flash.geom.Vector3D;
	
	public class Light
	{
		
		public var halfWayDirectionLight:Vector.<Number>;
		
		public var directionC1:Vector.<Number>;
		public var directionC2:Vector.<Number>;
		
		private var saveDir:Vector3D;
		
		public var baseColor:Vector.<Number>;
		public var haloColor:Vector.<Number>;
		public var color1:Vector.<Number>;
		public var color2:Vector.<Number>;

		public var color1Amount:Number = 1.0;
		public var color2Amount:Number = 1.0;

		
		public function Light()
		{
			setDirection(1,0.5,-1);
			
			setBaseColor(0.8, 0.8, 0.8);
			setHaloColor(0.1, 0.5, 0.0);
			setColorAdditive(1.0, 1.0, 1.0, 0.7);
			setColorAmbient(0.0, 0.0, 0.0, 0.4);
		}
		
		
	
		public function setDirection(_x:Number,_y:Number,_z:Number):void {
			saveDir = new Vector3D(_x,_y,_z,0);
			saveDir.normalize();
	
			halfWayDirectionLight = new Vector.<Number>();
			halfWayDirectionLight.push(_x,_y,_z, 0); //wird gleich berechnet neu berechnet
			directionC1  = new Vector.<Number>();
			directionC1.push(_x,_y,_z, 0);
			directionC2  = new Vector.<Number>();
			directionC2.push(-_x,-_y,-_z, 0); //wird gleich berechnet neu berechnet
			recalcDirs();
		}
		
		private function recalcDirs():void {
			var _v:Vector3D = new Vector3D(saveDir.x,saveDir.y,saveDir.z);
			
			directionC1[0] = _v.x * color1Amount;
			directionC1[1] = _v.y * color1Amount;
			directionC1[2] = _v.z * color1Amount;

			directionC2[0] = -_v.x * color2Amount;
			directionC2[1] = -_v.y * color2Amount;
			directionC2[2] = -_v.z * color2Amount;
			
		}
		
		
		public function setHaloColor(_r:Number, _g:Number, _b:Number):void {
			haloColor = new Vector.<Number>();
			haloColor.push(_r,_g,_b,1.0);
		}
		
		
		public function setBaseColor(_r:Number, _g:Number, _b:Number):void {
			baseColor = new Vector.<Number>();
			baseColor.push(_r,_g,_b,1.0);
			
		}
		
		public function setColorAdditive(_r:Number, _g:Number, _b:Number, _amount:Number):void {
			color1 = new Vector.<Number>();
			color1.push(_r,_g,_b,1.0);	
			
			color1Amount = _amount;
			recalcDirs();
		}
		
		public function setColorAmbient(_r:Number, _g:Number, _b:Number, _amount:Number):void {
			color2 = new Vector.<Number>();
			color2.push(_r,_g,_b,1.0);	
			
			color2Amount = _amount;
			recalcDirs();
		}
		
		
		

		
		
	}
}