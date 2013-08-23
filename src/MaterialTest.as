package
{
	import com.lhm3d.camera.*;
	import com.lhm3d.fileobjectloaders.*;
	import com.lhm3d.globals.*;
	import com.lhm3d.light.Light;
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
		
		// cylinder
		private var cylinderObjectData:WavefrontObjectLoader;		
		private var cylinderObject:Base3DObject;
		
		private var cylinderTextureData:TextureLoader;
		private var cylinderTexture:int;
		
		// plane
		private var planeObjectData:WavefrontObjectLoader;		
		private var planeObject:CLTex3DWater;
		
		private var waterBumpTextureData:TextureLoader;
		private var waterBumpTexture:int;
		
		// kamicat logo
		private var torusObjectData:WavefrontObjectLoader;		
		private var torusObject:Base3DObject;
		
		private var torusTextureData:TextureLoader;
		private var torusTexture:int;
		
		private var bumpTextureData:TextureLoader;
		private var bumpTexture:int;
		
		
		// eisberg
		private var eisbergObjectData:WavefrontObjectLoader;		
		private var eisbergObject:Base3DObject;
		
		private var eisbergTextureData:TextureLoader;
		private var eisbergTexture:int;
		
		private var eisbergBumpTextureData:TextureLoader;
		private var eisbergBumpTexture:int;
		
		// cubical env map
		private var cubeTextureData:Vector.<TextureLoader> = new Vector.<TextureLoader>();
		private var cubeTexture:int;
		
		// cubical2 env map
		private var cube2TextureData:Vector.<TextureLoader> = new Vector.<TextureLoader>();
		private var cube2Texture:int;
		
		private var rotate:int = 0;
		
		
		public function MaterialTest() 
		{
			super();
		}
		
		
		public override function load():void {
			
			planeObjectData = new WavefrontObjectLoader("./data/demo/lake.obj",9, 2.8);
			cylinderObjectData = new WavefrontObjectLoader("./data/demo/cylinder.obj");
		
			cylinderTextureData = new TextureLoader("./data/demo/sky.png");
			
			waterBumpTextureData = new TextureLoader("./data/demo/waterbump2.png");
			
			eisbergObjectData = new WavefrontObjectLoader("./data/demo/eisberg.obj",0.7);	
			eisbergTextureData = new TextureLoader("./data/demo/eisberg.png");
			eisbergBumpTextureData = new TextureLoader("./data/demo/eisbergbump.png");

			torusObjectData = new WavefrontObjectLoader("./data/demo/logo.obj",1.1);	
			torusTextureData = new TextureLoader("./data/demo/logo.jpg");
			bumpTextureData = new TextureLoader("./data/demo/bump.png");
			
			cubeTextureData.push(new TextureLoader("./data/demo/xleft.png"));
			cubeTextureData.push(new TextureLoader("./data/demo/xright.png"));
			cubeTextureData.push(new TextureLoader("./data/demo/yup.png"));
			cubeTextureData.push(new TextureLoader("./data/demo/ydown.png"));
			cubeTextureData.push(new TextureLoader("./data/demo/zback.png"));
			cubeTextureData.push(new TextureLoader("./data/demo/zfront.png"));
			
			cube2TextureData.push(new TextureLoader("./data/demo/xleft2.png"));
			cube2TextureData.push(new TextureLoader("./data/demo/xright2.png"));
			cube2TextureData.push(new TextureLoader("./data/demo/yup2.png"));
			cube2TextureData.push(new TextureLoader("./data/demo/ydown2.png"));
			cube2TextureData.push(new TextureLoader("./data/demo/zback2.png"));
			cube2TextureData.push(new TextureLoader("./data/demo/zfront2.png"));
			
			
		}
		
		public override function loaded():void {

			cube2Texture = TextureManager.addCubeTextureFromBMD(cube2TextureData[0].getBitmapData(),cube2TextureData[1].getBitmapData(),cube2TextureData[2].getBitmapData(),cube2TextureData[3].getBitmapData(),cube2TextureData[4].getBitmapData(),cube2TextureData[5].getBitmapData());

			
			cubeTexture = TextureManager.addCubeTextureFromBMD(cubeTextureData[0].getBitmapData(),cubeTextureData[1].getBitmapData(),cubeTextureData[2].getBitmapData(),cubeTextureData[3].getBitmapData(),cubeTextureData[4].getBitmapData(),cubeTextureData[5].getBitmapData());
			waterBumpTexture = TextureManager.addTextureFromBMD(waterBumpTextureData.getBitmapData());
			
			cylinderTexture = TextureManager.addTextureFromBMD(cylinderTextureData.getBitmapData());
			
			
			torusTexture = TextureManager.addTextureFromBMD(torusTextureData.getBitmapData()); // add texture to manager and get refereence
			bumpTexture = TextureManager.addTextureFromBMD(bumpTextureData.getBitmapData()); // add texture to manager and get refereence	
			torusObject = new CLTexCubeEnvBumpFresnel3DObject(0.5,torusTexture,cubeTexture,bumpTexture,torusObjectData.getVertexLayer(),torusObjectData.getNormalLayer(),torusObjectData.getUVLayer(),torusObjectData.getIndexLayer()); // generate env / bump mapped lighting material	

			
			
			eisbergTexture = TextureManager.addTextureFromBMD(eisbergTextureData.getBitmapData()); // add texture to manager and get refereence
			eisbergBumpTexture = TextureManager.addTextureFromBMD(eisbergBumpTextureData.getBitmapData()); // add texture to manager and get refereence
			eisbergObject = new CLTexCubeEnvBumpFresnel3DObject(0.5,eisbergTexture,cubeTexture,eisbergBumpTexture,eisbergObjectData.getVertexLayer(),eisbergObjectData.getNormalLayer(),eisbergObjectData.getUVLayer(),eisbergObjectData.getIndexLayer()); // generate env / bump mapped lighting material
			var lightEisberg:Light = new Light();
			lightEisberg.setBaseColor(0.8,0.8,0.8);
			eisbergObject.setLight(lightEisberg);
			
			
			cylinderObject = new SimpleTextured3DObject(eisbergTexture,cylinderObjectData.getVertexLayer(),cylinderObjectData.getUVLayer(),cylinderObjectData.getIndexLayer());

			
			planeObject = new CLTex3DWater(1.1, 0.1,  0.3, 0.3, 0.4, waterBumpTexture,waterBumpTexture, cube2Texture, planeObjectData.getVertexLayer(), planeObjectData.getNormalLayer(), planeObjectData.getUVLayer(),planeObjectData.getIndexLayer());
			
		}
		
		public override function update():void {
			rotate++;
			var _rMul:Number = rotate * 0.5;
						
			Camera.setCamereXYZRot(new Vector3D(Math.sin(_rMul * Math.PI/180.0) * 4.0, -1.5 + Math.sin(rotate * 0.007) * 0.5,Math.cos(_rMul * Math.PI/180.0) * 4.0), Math.sin(rotate * 0.007) * 10 - 10,-_rMul,0);
			planeObject.setWaveAnimation(rotate);
		}
		
		
		public override function render():void {
			
			//Camera.setFlyCamera();
			
			// render the logo
			var _mat:Matrix3D = new Matrix3D();
			_mat.appendTranslation(0,1,0);
			_mat.appendRotation(-rotate* 0.2, new Vector3D(0,1,0));
			torusObject.renderWithMatrix(_mat);
			
			_mat.identity();
			_mat.appendTranslation(0,1,0);
			_mat.appendRotation(rotate* 0.2, new Vector3D(0,1,0));
			
			_mat.appendRotation(180,new Vector3D(1,0,0));		
			torusObject.renderWithMatrix(_mat);
			
			// eisberge
			for (var i:int = 0; i < 5; i++) {
				var _matEisberg:Matrix3D = new Matrix3D();
				
				_matEisberg.appendRotation(i * 35, new Vector3D(0,1,0))
				_matEisberg.appendTranslation(Math.sin(i*3.5) * 5, -0.1, Math.cos(i*1.7) * 5);
				eisbergObject.renderWithMatrix(_matEisberg);
				
			}
			
			//lake
			_mat.identity();
			_mat.appendRotation(rotate* 0.2, new Vector3D(0,1,0));
			
			cylinderObject.renderWithMatrix(_mat);
			planeObject.renderWithMatrix(_mat);
			
		}
		
		
	}
}