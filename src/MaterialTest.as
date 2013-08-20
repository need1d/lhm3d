package
{
	import com.lhm3d.camera.*;
	import com.lhm3d.fileobjectloaders.*;
	import com.lhm3d.globals.*;
	import com.lhm3d.materialobjects.*;
	import com.lhm3d.texturemanager.*;
	import com.lhm3d.texturemanager.TextureLoader;
	import com.lhm3d.viewtree.*;
	
	import flash.display3D.textures.CubeTexture;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	
	
	[SWF(width="1024", height="768", frameRate="60", backgroundColor="#FFFFFF")]
	

	
	public class MaterialTest extends LHM3D
	{
		
		private var torusObjectData:WavefrontObjectLoader;		
		private var torusObject:Base3DObject;
		
		private var torusTextureData:TextureLoader;
		private var torusTexture:int;
		
		//private var envmapTextureData:TextureLoader;
		//private var envmapTexture:int;
		
		private var bumpTextureData:TextureLoader;
		private var bumpTexture:int;
		
		private var cubeTextureData:Vector.<TextureLoader> = new Vector.<TextureLoader>();
		private var cubeTexture:int;
		
		private var rotate:int = 0;
		
		
		public function MaterialTest() 
		{
			super();
		}
		
		
		public override function load():void {	
			torusObjectData = new WavefrontObjectLoader("./data/demo/logo.obj",1);	
			
			torusTextureData = new TextureLoader("./data/demo/logo.jpg");
			//envmapTextureData = new TextureLoader("./data/envmap.png");
			bumpTextureData = new TextureLoader("./data/bump.png");
			
			cubeTextureData.push(new TextureLoader("./data/demo/xleft.png"));
			cubeTextureData.push(new TextureLoader("./data/demo/xright.png"));
			cubeTextureData.push(new TextureLoader("./data/demo/yup.png"));
			cubeTextureData.push(new TextureLoader("./data/demo/ydown.png"));
			cubeTextureData.push(new TextureLoader("./data/demo/zback.png"));
			cubeTextureData.push(new TextureLoader("./data/demo/zfront.png"));
			
		}
		
		public override function loaded():void {
			
			
			
			cubeTexture = TextureManager.addCubeTextureFromBMD(cubeTextureData[0].getBitmapData(),cubeTextureData[1].getBitmapData(),cubeTextureData[2].getBitmapData(),cubeTextureData[3].getBitmapData(),cubeTextureData[4].getBitmapData(),cubeTextureData[5].getBitmapData());
			
			torusTexture = TextureManager.addTextureFromBMD(torusTextureData.getBitmapData()); // add texture to manager and get refereence
			//envmapTexture = TextureManager.addTextureFromBMD(envmapTextureData.getBitmapData()); // add texture to manager and get refereence
			bumpTexture = TextureManager.addTextureFromBMD(bumpTextureData.getBitmapData()); // add texture to manager and get refereence	
			
			torusObject = new CLTexCubeEnvBumpFresnel3DObject(0.1,torusTexture,cubeTexture,bumpTexture,torusObjectData.getVertexLayer(),torusObjectData.getNormalLayer(),torusObjectData.getUVLayer(),torusObjectData.getIndexLayer()); // generate env / bump mapped lighting material	
			//torusObject = new SimpleEnvMapped3DObject(torusTexture,torusObjectData.getVertexLayer(),torusObjectData.getNormalLayer(),torusObjectData.getIndexLayer()); // generate env / bump mapped lighting material	
	
		}
		
		public override function update():void {
			rotate++;
			Camera.updateFlyCamera();
		}
		
		
		public override function render():void {
			
			Camera.setFlyCamera();
			
			var _mat:Matrix3D = new Matrix3D();
			
			_mat.appendRotation(rotate/1.5, new Vector3D(0,1,0));
			
		
			
			_mat.appendTranslation(0,0,5);		
			
			torusObject.renderWithMatrix(_mat);
			
		}
		
		
	}
}