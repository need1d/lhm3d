package com.lhm3d.materialobjects
{
	
	import com.lhm3d.fileobjectloaders.*;
	
	public class MaterialFactory
	{
		public function MaterialFactory() : void
		{
		}
		
		public static function buildTexObject(_textureIndex:int, _objectLoader:BaseObjectLoader) : Tex3DObject {
			return new Tex3DObject(_textureIndex,_objectLoader.getVertexLayer(),_objectLoader.getUVLayer(),_objectLoader.getIndexLayer());
		}
		
		
		public static function buildCLTexCubeEnvObject(_envAmount:int,_textureIndex:int,_cubeTextureIndex:int,_objectLoader:BaseObjectLoader) : CLTexCube3DObject {
			return new CLTexCube3DObject(_envAmount,_textureIndex,_cubeTextureIndex,_objectLoader.getVertexLayer(),_objectLoader.getNormalLayer(),_objectLoader.getUVLayer(),_objectLoader.getIndexLayer());
		}
		
		
		public static function buildCLTexCubeEnvBumpFresnelObject(_envAmount:Number,_textureIndex:int,_cubeTextureIndex:int,_bumpTextureIndex:int,_objectLoader:BaseObjectLoader) : CLTexCubeBumpFresnel3DObject {
			return new 	CLTexCubeBumpFresnel3DObject(_envAmount,_textureIndex, _cubeTextureIndex, _bumpTextureIndex,_objectLoader.getVertexLayer(),_objectLoader.getNormalLayer(),_objectLoader.getUVLayer(),_objectLoader.getIndexLayer());
		}
		
		
		public static function buildCLTex3DWater(_envAmount:Number, _alphaAmount:Number, _r:Number, _g:Number, _b:Number, _wave1TextureIndex:int, _wave2TextureIndex:int, _cubeTextureIndex:int,_objectLoader:BaseObjectLoader): CLTex3DWaterObject {
			return new CLTex3DWaterObject(_envAmount,_alphaAmount,_r,_g,_b,_wave1TextureIndex,_wave2TextureIndex,_cubeTextureIndex,_objectLoader.getVertexLayer(),_objectLoader.getNormalLayer(),_objectLoader.getUVLayer(),_objectLoader.getIndexLayer());
		}
		
		public static function hasBumpTexture(_materialName:String) : Boolean {
		
			if (_materialName == "CLTex3DWater") return true;
			if (_materialName == "CLTexCubeBump") return true;
			if (_materialName == "CLTexCubeBumpFresnel") return true;

			if (_materialName == "CLTexEnvBump") return true;
			if (_materialName == "CLTexEnvBumpFresnel") return true;

			return false;
		}

		public static function hasEnvTexture(_materialName:String) : Boolean {
		
			if (_materialName == "CLTexEnv") return true;
			if (_materialName == "CLTexEnvBump") return true;
			if (_materialName == "CLTexEnvBumpFresnel") return true;
			
			return false;
		}
		
		
		
		
	}
}