package com.lhm3d.scene
{
	import com.lhm3d.texturemanager.*;
	
	public class CubeMapEntity
	{
		
		public var cubeTextureData:Vector.<TextureLoader> = new Vector.<TextureLoader>();
		public var name:String;
		public var index:int;
		
		public function CubeMapEntity(_name:String) : void 
		{
			
			name = _name;
			
		}
		
	}
}