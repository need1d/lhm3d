package com.lhm3d.globals
{
	
	import com.adobe.utils.AGALMiniAssembler;
	import com.adobe.utils.PerspectiveMatrix3D;
	import com.lhm3d.light.Light;
	import com.lhm3d.camera.*;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	
	
	public class Globals
	{
		// object laod handling
		public static var objectsToLoad:int = 0;
		public static var objectLoadCallBack:Object;
		
		//texture load handling
		public static var texturesToLoad:int = 0;
		public static var textureLoadCallBack:Object;
		
		public static var context3D:Context3D;
		public static var light:Light;
		public static var renderedObjectCount:int = 0; 
		
		
		
		public static function init():void {
			Camera.projectionTransform = new PerspectiveMatrix3D();
			
			var _aspect:Number = 4/3;
			var _zNear:Number = 1;
			var _zFar:Number = 10000;
			var _fov:Number = 45*Math.PI/180;
			Camera.projectionTransform.perspectiveFieldOfViewLH(_fov, _aspect, _zNear, _zFar);
			
			Camera.viewMatrix = new Matrix3D;

			Camera.cameraDirection = new Vector3D(0,0,1);
			light = new Light();
			
			Camera.setCamera(new Vector3D(0,0,0), new Vector3D(0,0,1),new Vector3D(0,1,0));
			
		}

	
	
		
	}
}