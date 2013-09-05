package com.lhm3d.scene
{
	import com.lhm3d.texturemanager.*;
	
	public class ObjectMaterialEntity
	{
		
		public var assign:String;
		public var material:String;
		public var cubeMapName:String;
		public var envAmount:Number;
		public var lightIndex:int;
		
		public var texIndex1:int;
		public var texIndex2:int;
		
		public var textureData:Vector.<TextureLoader> = new Vector.<TextureLoader>();
		
		
		public function ObjectMaterialEntity(_assign:String, _material:String, _cubeMapName:String, _envAmount:Number, _light:int) : void
		{
			assign = _assign;
			material = _material;
			cubeMapName = _cubeMapName;
			envAmount = _envAmount;
			lightIndex = _light;
		}
		
		
	}
}