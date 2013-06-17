package
{
	import awayphysics.collision.shapes.AWPBoxShape;
	import awayphysics.collision.shapes.AWPConeShape;
	import awayphysics.collision.shapes.AWPCylinderShape;
	import awayphysics.collision.shapes.AWPSphereShape;
	import awayphysics.collision.shapes.AWPStaticPlaneShape;
	import awayphysics.debug.AWPDebugDraw;
	import awayphysics.dynamics.AWPDynamicsWorld;
	import awayphysics.dynamics.AWPRigidBody;
	
	import com.games.coindozer.ElementList;
	import com.games.coindozer.Level;
	import com.lhm3d.camera.*;
	import com.lhm3d.fileobjectloaders.*;
	import com.lhm3d.globals.*;
	import com.lhm3d.jiglib.*;
	import com.lhm3d.materialobjects.*;
	import com.lhm3d.texturemanager.*;
	import com.lhm3d.texturemanager.TextureLoader;
	import com.lhm3d.viewtree.*;
	
	import flash.display3D.textures.CubeTexture;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	
	
	[SWF(width="1024", height="768", frameRate="60", backgroundColor="#FFFFFF")]
	
	
	
	public class CoinDozer extends LHM3D
	{

		private var boxObjectData:WavefrontObjectLoader;		
		private var boxObject:Base3DObject;		
		
		private var torusObjectData:WavefrontObjectLoader;		
		private var torusObject:Base3DObject;
		private var torusObject2:Base3DObject;
		
		private var torusTextureData:TextureLoader;
		private var torusTexture:int;
		
		private var envmapTextureData:TextureLoader;
		private var envmapTexture:int;
		
		private var bumpTextureData:TextureLoader;
		private var bumpTexture:int;
		
		private var cubeTextureData:Vector.<TextureLoader> = new Vector.<TextureLoader>();
		private var cubeTexture:int;
		
		private var rotate:int = 0;
		
		// collision
		
		private var physics:AWPDynamicsWorld;
		
		private var elementList:ElementList;
		private var level:Level;
		
		// some logic
		
		private var upd:int = 0;
		
		
		public function CoinDozer() 
		{
			super();
		}
		
		
		public override function load():void {	
			torusObjectData = new WavefrontObjectLoader("./data/coindozer/coin.obj",100);
			boxObjectData = new WavefrontObjectLoader("./data/coindozer/testcube.obj",500);
			
			torusTextureData = new TextureLoader("./data/base.png");
			envmapTextureData = new TextureLoader("./data/envmap.png");
			bumpTextureData = new TextureLoader("./data/bump.png");
			
			cubeTextureData.push(new TextureLoader("./data/xleft.png"));
			cubeTextureData.push(new TextureLoader("./data/xright.png"));
			cubeTextureData.push(new TextureLoader("./data/yup.png"));
			cubeTextureData.push(new TextureLoader("./data/ydown.png"));
			cubeTextureData.push(new TextureLoader("./data/zback.png"));
			cubeTextureData.push(new TextureLoader("./data/zfront.png"));
			
		}
		
		public override function loaded():void {
			
		
			// 3d

			cubeTexture = TextureManager.addCubeTextureFromBMD(cubeTextureData[0].getBitmapData(),cubeTextureData[1].getBitmapData(),cubeTextureData[2].getBitmapData(),cubeTextureData[3].getBitmapData(),cubeTextureData[4].getBitmapData(),cubeTextureData[5].getBitmapData());
			
			torusTexture = TextureManager.addTextureFromBMD(torusTextureData.getBitmapData()); // add texture to manager and get refereence
			envmapTexture = TextureManager.addTextureFromBMD(envmapTextureData.getBitmapData()); // add texture to manager and get refereence
			bumpTexture = TextureManager.addTextureFromBMD(bumpTextureData.getBitmapData()); // add texture to manager and get refereence	
			
			torusObject = new CLTexCubeEnvBumpFresnel3DObject(0.8,torusTexture,cubeTexture,bumpTexture,torusObjectData.getVertexLayer(),torusObjectData.getNormalLayer(),torusObjectData.getUVLayer(),torusObjectData.getIndexLayer()); // generate env / bump mapped lighting material	
			torusObject2 = new CLTexCubeEnvBumpFresnel3DObject(0.8,torusTexture,cubeTexture,bumpTexture,torusObjectData.getVertexLayer(),torusObjectData.getNormalLayer(),torusObjectData.getUVLayer(),torusObjectData.getIndexLayer()); // generate env / bump mapped lighting material	

			boxObject = new CLTexCubeEnvBumpFresnel3DObject(0.8,torusTexture,cubeTexture,bumpTexture,boxObjectData.getVertexLayer(),boxObjectData.getNormalLayer(),boxObjectData.getUVLayer(),boxObjectData.getIndexLayer()); 
			
			//torusObject = new SimpleEnvMapped3DObject(torusTexture,torusObjectData.getVertexLayer(),torusObjectData.getNormalLayer(),torusObjectData.getIndexLayer()); // generate env / bump mapped lighting material	
			// physics
			

				
			physics = AWPDynamicsWorld.getInstance();
			physics.initWithDbvtBroadphase();
			
			physics.gravity = new Vector3D(0,-50,0);
			
			
			var groundShape : AWPStaticPlaneShape = new AWPStaticPlaneShape(new Vector3D(0, 1, 0));
			
			var groundRigidbody : AWPRigidBody = new AWPRigidBody(groundShape);
			groundRigidbody.position =  new Vector3D(0,0,0);
			groundRigidbody.friction = 0.2;
			
			physics.addRigidBody(groundRigidbody);
			
			elementList = new ElementList(physics);
			level = new Level(physics,boxObject);
			
			
			
			
			elementList.addElement("coin", new Vector3D(0,2000,0), 45,0,45, torusObject);
		}
		
		public override function update():void {
			rotate++;
			Camera.updateFlyCamera();
			
			
			upd++;
			
			if (upd % 60 == 0) {
			
				elementList.addElement("coin", new Vector3D(Math.random()*100-50,2000,Math.random()*100-50), Math.random()*180,Math.random()*180,Math.random()*180, torusObject);
			}
			
			level.update();
			
		}
		
		
		public override function render():void {
			
			physics.step(1.0 / 60.0, 1, 1.0 / 60.0);
			
			//Camera.setFlyCamera();
			Camera.setCamereXYZRot(new Vector3D(0,-5 * 200,20 * 200),-20,0,0);
			
			
			//ball.addWorldForce(new Vector3D(-5,0,-5),ball.currentState.position);
			
			level.render();
			elementList.render();
			
			
			
		}
		
		
	}
}