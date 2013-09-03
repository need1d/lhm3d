package com.lhm3d.scene
{
	public class SceneEntity
	{
		
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		public var rx:Number;
		public var ry:Number;
		public var rz:Number;
		
		public var scale:Number;
		

		public var name:String;

		
		public function SceneEntity(_objectName:String, _x:Number, _y:Number, _z:Number, _rx:Number, _ry:Number, _rz:Number, _scale:Number) : void 
		{
			
			name = _objectName;
			x = _x;
			y = _y;
			z = _z;
			
			rx = _rx;
			ry = _ry;
			rz = _rz;
			
			
			scale = _scale;
		
		}
	}
}