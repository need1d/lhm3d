package com.lhm3d.camera
{
	
	import com.adobe.utils.PerspectiveMatrix3D;
	import com.lhm3d.geometryhelpers.*;
	
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import com.lhm3d.input.Key;
	
	public class Camera
	{
		
		public static var projectionTransform:PerspectiveMatrix3D;
		public static var viewMatrix:Matrix3D;
		public static var cameraDirection:Vector3D;
		public static var cameraPosition:Vector3D = new Vector3D(0,0,0);
		
		public static var clipPlanes:Vector.<Plane> = new Vector.<Plane>();
		
		private static var flyPosition:Vector3D = new Vector3D(0,0,0);
		private static var yRot:Number = 0;
		private static var xRot:Number = 0;
		
		
		public static function updateFlyCamera():void {

			var _ram:Number = 1.0;
			
			var _am:Number = 0.1;
			
			if (Key.isDown(37)) yRot += _ram;
			if (Key.isDown(39)) yRot-= _ram;
			
			if (Key.isDown(69)) xRot += _ram;
			if (Key.isDown(68)) xRot-= _ram;
			
			if (Key.isDown(87)) flyPosition.y -= _am;
			if (Key.isDown(83)) flyPosition.y += _am;
			
			
			if (Key.isDown(38)) {
				flyPosition.x -= Math.cos(yRot * Math.PI/180 + Math.PI/2) * _am;
				flyPosition.z -= Math.sin(yRot * Math.PI/180 + Math.PI/2) * _am;
			} 
			
			if (Key.isDown(40)) {
				flyPosition.x += Math.cos(yRot * Math.PI/180 + Math.PI/2) * _am;
				flyPosition.z += Math.sin(yRot * Math.PI/180 + Math.PI/2) * _am;
			} 
			
		
		}
		
		public static function setFlyCamera():void {
			
			cameraPosition.x = flyPosition.x;
			cameraPosition.y = flyPosition.y;
			cameraPosition.z = flyPosition.z;
			
			viewMatrix = new Matrix3D;
			
			viewMatrix.appendTranslation(flyPosition.x,flyPosition.y,flyPosition.z);
			viewMatrix.appendRotation(yRot,new Vector3D(0,1,0));
			viewMatrix.appendRotation(xRot,new Vector3D(1,0,0));
			
			CalculateFrustum();
		}
		
		
		public static function setCamereXYZRot(_eye:Vector3D, _rotX:Number, _rotY:Number, _rotZ:Number) : void {
		
			cameraPosition.x = _eye.x;
			cameraPosition.y = _eye.y;
			cameraPosition.z = _eye.z;
			
			viewMatrix = new Matrix3D;
			
			viewMatrix.appendTranslation(cameraPosition.x,cameraPosition.y,cameraPosition.z);
			viewMatrix.appendRotation(_rotX,new Vector3D(1,0,0));
			viewMatrix.appendRotation(_rotY,new Vector3D(0,1,0));
			viewMatrix.appendRotation(_rotZ,new Vector3D(0,0,1));
		
			CalculateFrustum();
		} 
		
		
		
		public static function setCamera(_eye:Vector3D, _at:Vector3D, _up:Vector3D):void {
			
			cameraPosition.x = _eye.x;
			cameraPosition.y = _eye.y;
			cameraPosition.z = _eye.z
			
			cameraDirection.x = (_eye.x -_at.x);
			cameraDirection.y = (_eye.y -_at.y);
			cameraDirection.z = (_eye.z -_at.z);
			cameraDirection.normalize();
				
			viewMatrix = new Matrix3D;
			
			var _zaxis:Vector3D = new Vector3D;
			_zaxis = _at.subtract(_eye);
			_zaxis.normalize();
			
			var _xaxis:Vector3D = new Vector3D;
			_xaxis = _up.crossProduct(_zaxis);
			_xaxis.normalize();
			
			var _yaxis:Vector3D  = _zaxis.crossProduct(_xaxis);
			
			var _rD:Vector.<Number> = new Vector.<Number>();
			
			_rD.push (_xaxis.x		   , _yaxis.x			   , _zaxis.x				 , 0,
				_xaxis.y			   , _yaxis.y			   , _zaxis.y				 , 0,
				_xaxis.z			   , _yaxis.z			   , _zaxis.z				 , 0,
				-_xaxis.dotProduct(_eye), -_yaxis.dotProduct(_eye), -_zaxis.dotProduct(_eye)  , 1);
			
			viewMatrix.rawData = _rD;
			
			
			CalculateFrustum();
		}
		
		
		private static function CalculateFrustum():void {
			
			var _mvp:Matrix3D = viewMatrix.clone();
			_mvp.append(projectionTransform);
			
			clipPlanes = new Vector.<Plane>();
			
			clipPlanes.push(new Plane(_mvp.rawData[3]-_mvp.rawData[0], _mvp.rawData[7]-_mvp.rawData[4], (_mvp.rawData[11]-_mvp.rawData[8]), (_mvp.rawData[15]-_mvp.rawData[12])));
			clipPlanes.push(new Plane(_mvp.rawData[3]+_mvp.rawData[0], _mvp.rawData[7]+_mvp.rawData[4], (_mvp.rawData[11]+_mvp.rawData[8]), (_mvp.rawData[15]+_mvp.rawData[12])));
			clipPlanes.push(new Plane(_mvp.rawData[3]+_mvp.rawData[1], _mvp.rawData[7]+_mvp.rawData[5], (_mvp.rawData[11]+_mvp.rawData[9]), (_mvp.rawData[15]+_mvp.rawData[13])));
			clipPlanes.push(new Plane(_mvp.rawData[3]-_mvp.rawData[1], _mvp.rawData[7]-_mvp.rawData[5], (_mvp.rawData[11]-_mvp.rawData[9]), (_mvp.rawData[15]-_mvp.rawData[13])));
			clipPlanes.push(new Plane(_mvp.rawData[3]-_mvp.rawData[2], _mvp.rawData[7]-_mvp.rawData[6], (_mvp.rawData[11]-_mvp.rawData[10]), (_mvp.rawData[15]-_mvp.rawData[14])));
			clipPlanes.push(new Plane(_mvp.rawData[3]+_mvp.rawData[2], _mvp.rawData[7]+_mvp.rawData[6], (_mvp.rawData[11]+_mvp.rawData[10]), (_mvp.rawData[15]+_mvp.rawData[14])));
				
		}
		
		
		
	}
}