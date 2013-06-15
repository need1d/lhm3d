package
{
	//import com.lhm3d.camera.*;
	import com.lhm3d.fileobjectloaders.*;
	import com.lhm3d.globals.*;
	import com.lhm3d.materialobjects.*;
	import com.lhm3d.texturemanager.*;
	import com.lhm3d.texturemanager.TextureLoader;
	import com.lhm3d.viewtree.*;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	
	import com.lhm3d.camera.*;
	
	
	[SWF(width="1024", height="768", frameRate="60", backgroundColor="#FFFFFF")]
	
	public class OctreeTest extends LHM3D
	{

		private var torusObjectData:WavefrontObjectLoader;		
		private var torusObject:Base3DObject;
		
		private var landObjectData:WavefrontObjectLoader;		
		private var landSplittedObjects:Vector.<Base3DObject> = new Vector.<Base3DObject>();
		
		private var landTextureData:TextureLoader;
		private var landTexture:int;
	
		private var torusTextureData:TextureLoader;
		private var torusTexture:int;
		
		private var debugTF:TextField;
		
		
		public function OctreeTest()
		{
			super();
		}
		
		
		public override function load():void {	
			torusObjectData = new WavefrontObjectLoader("./data/torus.obj",1);	
			landObjectData = new WavefrontObjectLoader("./data/land.obj",30);	
			
			landTextureData = new TextureLoader("./data/purple.png");
			torusTextureData = new TextureLoader("./data/green.png");
		}
		
		public override function loaded():void {
		
			trace("hallo");
		
			ViewTree.init(new Vector3D(-30,-30,-30),new Vector3D(30,30,30), 3); // init the view tree
			
			landTexture = TextureManager.addTextureFromBMD(landTextureData.getBitmapData()); // add the loaded texture to the TexManager and ret a reference
			torusTexture = TextureManager.addTextureFromBMD(torusTextureData.getBitmapData()); // add the loaded texture to the TexManager and ret a reference
			
			landObjectData.doSplit(10); // Split the land obj to smaller pieces (longest edge is splittet into 10 parts)
			for (var j:int = 0; j < landObjectData.getSplitPartLength(); j++) {
				landSplittedObjects.push(new CLTex3DObject(landTexture,landObjectData.getSplitVertexLayer(j),landObjectData.getSplitNormalLayer(j),landObjectData.getSplitUVLayer(j),landObjectData.getSplitIndexLayer(j))); //generate a simple textured object for each land part
				var _ref:int = ViewTree.submitObjectToContainer(landSplittedObjects[j]); // submit each part-object to the view-container and get the reference
			
				ViewTree.addObjectAtPosRotScale(_ref,0,-5,0,0,0,0,1); // position a little bit below camera (y = -5)
			}
			
			/*
			torusObject = new CLTex3DObject(torusTexture,torusObjectData.getVertexLayer(),torusObjectData.getNormalLayer(),torusObjectData.getUVLayer(),torusObjectData.getIndexLayer()); // generate simple textured torus object
			var _torusRef:int = ViewTree.submitObjectToContainer(torusObject); // submit to container, get reference
			
			
			
			for (var i:int = 0; i < 150; i++) ViewTree.addObjectAtPosRotScale(_torusRef,Math.random()*40-20,Math.random()*30-4,Math.random()*40-20,Math.random()*360,Math.random()*360,Math.random()*360,1); // add 150 torus at random position / roatioan
			*/
			
			debugTF = new TextField();
			addChild(debugTF);
			
		}
		
		// end init part
		
		public override function update():void {
			Camera.updateFlyCamera(); // update fly-cam (arrow-keys, w,s, e,d);
		}
		
		
		public override function render():void {
			
			Camera.setFlyCamera();
			
			ViewTree.render(); // render everything in the view-tree
			
			debugTF.text = String(Globals.renderedObjectCount); // give info how much objects are rendered
			
			
		}
		
		
	}
}