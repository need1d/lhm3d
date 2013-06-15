package
{
	import com.lhm3d.camera.*;
	import com.lhm3d.fileobjectloaders.*;
	import com.lhm3d.globals.*;
	import com.lhm3d.materialobjects.*;
	import com.lhm3d.texturemanager.*;
	import com.lhm3d.texturemanager.TextureLoader;
	import com.lhm3d.viewtree.*;
	import com.lhm3d.jiglib.*;
	
	import flash.display3D.textures.CubeTexture;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	
	import jiglib.geometry.*;
	import jiglib.debug.Stats;
	import jiglib.events.JCollisionEvent;
	import jiglib.physics.*;
	import jiglib.plugin.AbstractPhysics;
	
	
	[SWF(width="1024", height="768", frameRate="60", backgroundColor="#FFFFFF")]
	
	
	
	public class CoinDozer extends LHM3D
	{
		
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
		
		private var ball:RigidBody;
		private var physics:AbstractPhysics;
		
		
		public function CoinDozer() 
		{
			super();
		}
		
		
		public override function load():void {	
			torusObjectData = new WavefrontObjectLoader("./data/torus.obj",0.5);	
			
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

			
			//torusObject = new SimpleEnvMapped3DObject(torusTexture,torusObjectData.getVertexLayer(),torusObjectData.getNormalLayer(),torusObjectData.getIndexLayer()); // generate env / bump mapped lighting material	
		
			// physics
			
			trace("holla");
			
			physics = new AbstractPhysics(1);
			
			var jGround:JPlane = new JPlane(new Lhm3d4Mesh(torusObject2),new Vector3D(0, 1, 0));
			jGround.y = -1.3;
			jGround.movable = false;
			physics.addBody(jGround);
			
			ball = new JSphere(new Lhm3d4Mesh(torusObject), 2);
			physics.addBody(ball);
			
		
			
			
		}
		
		public override function update():void {
			rotate++;
			Camera.updateFlyCamera();
			
			physics.step(1.0 / 60.0);
		}
		
		
		public override function render():void {
			
			Camera.setFlyCamera();
			
			
			ball.addWorldForce(new Vector3D(-10,0,0),ball.currentState.position);
			
			torusObject.renderWithPhysicsTransform();
		
			
			
			torusObject2.renderWithPhysicsTransform();
			
		}
		
		
	}
}