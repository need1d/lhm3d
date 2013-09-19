package
{
	import com.lhm3d.camera.*;
	import com.lhm3d.fileobjectloaders.*;
	import com.lhm3d.globals.*;
	import com.lhm3d.light.Light;
	import com.lhm3d.materialobjects.*;
	import com.lhm3d.scene.Scene;
	import com.lhm3d.stats.Stats;
	import com.lhm3d.texturemanager.*;
	import com.lhm3d.texturemanager.TextureLoader;
	import com.lhm3d.viewtree.*;
	
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.textures.CubeTexture;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	
	
	[SWF(width="1024", height="768", frameRate="60", backgroundColor="#FFFFFF")]
	
	
	
	public class SceneTest extends LHM3D
	{
		
		private var scene:Scene;
	
		
		private var bbObject:Vector.<Tex3DObject> = new Vector.<Tex3DObject>();
		
		private var upd:int = 0;
		
		public function SceneTest() 
		{
			super();
		}
		
		
		public override function load():void {
			scene = new Scene("./data/scenetest/testscene2/");	
		}
		
		public override function loaded():void {
			scene.sceneLoaded();
			addChild(new Stats());
			
			var _dummyTex:int = TextureManager.addTextureFromBMD(TextureManager.getDummyTexture());
			
					
			if (ViewTree.tree.sib1!= null) bbObject.push(ViewTree.tree.sib1.bb.buildTex3DObject(_dummyTex));
			if (ViewTree.tree.sib2!= null) bbObject.push(ViewTree.tree.sib2.bb.buildTex3DObject(_dummyTex));
			if (ViewTree.tree.sib3!= null) bbObject.push(ViewTree.tree.sib3.bb.buildTex3DObject(_dummyTex));
			if (ViewTree.tree.sib4!= null) bbObject.push(ViewTree.tree.sib4.bb.buildTex3DObject(_dummyTex));
			if (ViewTree.tree.sib5!= null) bbObject.push(ViewTree.tree.sib5.bb.buildTex3DObject(_dummyTex));
			if (ViewTree.tree.sib6!= null) bbObject.push(ViewTree.tree.sib6.bb.buildTex3DObject(_dummyTex));
			if (ViewTree.tree.sib7!= null) bbObject.push(ViewTree.tree.sib7.bb.buildTex3DObject(_dummyTex));
			if (ViewTree.tree.sib8!= null) bbObject.push(ViewTree.tree.sib8.bb.buildTex3DObject(_dummyTex));
			
			
		}
		
		public override function update():void {
			Camera.updateFlyCamera();
			upd++;
		}
		
		public override function render():void {
			Camera.setFlyCamera();
		
			scene.render(upd / 20);
			
			var _m:Matrix3D = new Matrix3D();
			
			
		}
		
		
	}
}