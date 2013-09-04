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
	
	import flash.display3D.textures.CubeTexture;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	
	
	[SWF(width="1024", height="768", frameRate="60", backgroundColor="#FFFFFF")]
	
	
	
	public class SceneTest extends LHM3D
	{
		
		private var scene:Scene;
	
		public function SceneTest() 
		{
			super();
		}
		
		
		public override function load():void {
			scene = new Scene("./data/scenetest/testscene/");	
		}
		
		public override function loaded():void {
			scene.sceneLoaded();
			addChild(new Stats());
		}
		
		public override function update():void {
			Camera.updateFlyCamera();
		}
		
		public override function render():void {
			Camera.setFlyCamera();
		
			scene.render();
			
		}
		
		
	}
}