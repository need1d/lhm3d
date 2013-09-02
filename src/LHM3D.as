package
{
	import com.adobe.utils.AGALMiniAssembler;
	import com.adobe.utils.PerspectiveMatrix3D;
	import com.lhm3d.*;
	import com.lhm3d.globals.Globals;
	import com.lhm3d.materialobjects.*;
	import com.lhm3d.texturemanager.*;
	import com.lhm3d.fileobjectloaders.WavefrontObjectLoader;
	import com.lhm3d.input.Key;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	
	[SWF(width="800", height="600", frameRate="2", backgroundColor="#FFFFFF")]
	
	
	
	public class LHM3D extends Sprite
	{
		
		private var overallUpdates:uint;
		private var startTime:uint;
		
		public function LHM3D()
		{			
		
			stage.stage3Ds[0].addEventListener( Event.CONTEXT3D_CREATE, initMolehill );
			stage.stage3Ds[0].requestContext3D();
			
		}
		
		protected function initMolehill(e:Event):void
		{
			Key.initialize(stage);
			
			Globals.init();
			Globals.objectLoadCallBack = objLoaded;
			Globals.textureLoadCallBack = texLoaded;
			
			Globals.context3D = stage.stage3Ds[0].context3D;			
			Globals.context3D.configureBackBuffer(800, 600, 1, true);
		
			Globals.context3D.setCulling(Context3DTriangleFace.BACK);
			Globals.context3D.setDepthTest(true, Context3DCompareMode.LESS);
				
			load();
			
		}	
		
		public function load():void { // to override
			
		}
		
		private function objLoaded():void {
			
			Globals.objectsToLoad--;
			
			if ((Globals.objectsToLoad == 0)&&(Globals.texturesToLoad==0)) {
				loaded();
				startUpdateRender();
			}
		}
		
		
		private function texLoaded():void {
			Globals.texturesToLoad--;
			
			if ((Globals.objectsToLoad == 0)&&(Globals.texturesToLoad==0)) {
				loaded();
				startUpdateRender();
			}
		}
			
		public function loaded():void { // zum überschreiben
			
			
		}
		
		private function startUpdateRender():void {
			startTime = getTimer();
			overallUpdates = 0;
			
			addEventListener(Event.ENTER_FRAME, onLoop);
		}
		
		
		private function onLoop(e:Event):void
		{
			
			var _shUp:uint = Math.round ((getTimer()-startTime) / (1000.0 / 60.0) );
			var _k:uint = _shUp - overallUpdates;
			for (var i:uint = 0; i < _k; i++) {
				update();
				overallUpdates++;
			}

			if ( !Globals.context3D ) 
			return;
			
			Globals.context3D.clear(1.0,1.0,1.0);
			Globals.renderedObjectCount = 0;
			
			
			render();
		
			Globals.context3D.present();			
		}
		
		public function render():void {  // to override
			
		}
		
		public function update():void {  // to override
		
		}
		
		
		
	}
}