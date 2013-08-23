package com.lhm3d.fileobjectloaders
{
	import com.lhm3d.globals.Globals;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	
	public class WavefrontObjectLoader extends BaseObjectLoader
	{
		
		private var loader:URLLoader;
		private var file:String;
	
	
		private static const VERTEX:RegExp = /^v\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)/;
		private static const T_VERTEX:RegExp = /^vt\s+([^\s]+)\s+([^\s]+)/;
		private static const NORMAL_VERTEX:RegExp = /^vn\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)/;
		private static const NOUVFACE:RegExp = /^f\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)/;
	
		
		public function WavefrontObjectLoader(_filename:String, _scale:Number = 1, _scaleUV:Number = 1):void
		{
			super();
			
			Globals.objectsToLoad++;
			scaleUV = _scaleUV;	
			scale = _scale;
			file = _filename;
			loadWavefront(_filename);
		}
		
		
		private function loadWavefront(filename:String):void
		{
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, parseWavefront);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			try
			{
				loader.load(new URLRequest(filename));
			}
			catch(e:Error)
			{
				trace("error in loading wavefront file (" + filename + ")");
			}
		}
		
	
		private function parseWavefront(event:Event):void
		{
			var _lines:Array = loader.data.split("\n");
			var _params:Array; 
			var _line:String;
			
			var _tmpVertexLayer:Vector.<Number> = new Vector.<Number>();
			var _tmpUVLayer:Vector.<Number> = new Vector.<Number>();
			var _tmpNormalLayer:Vector.<Number> = new Vector.<Number>();
			
			var _touples:Vector.<String> = new Vector.<String>();
			
			for each(_line in _lines) {
				if ((_params = _line.match(VERTEX)) != null) {

					_tmpVertexLayer.push(Number(_params[1]) * scale, Number(_params[2]) * scale, Number(_params[3]) * scale);
					
				}
			    
				if ((_params = _line.match(T_VERTEX)) != null) {
					_tmpUVLayer.push(Number(_params[1]) * scaleUV, 1 - Number(_params[2]) * scaleUV);
				}
				
				if ((_params = _line.match(NORMAL_VERTEX)) != null) {
					_tmpNormalLayer.push(Number(_params[1]), Number(_params[2]), Number(_params[3]));
				}
				
				
				if ((_params = _line.match(NOUVFACE)) != null) {
					
					var _p1:Array = new Array();
					_p1 = String(_params[1]).split("/");
					var _p2:Array = new Array();
					_p2 = String(_params[2]).split("/");
					var _p3:Array = new Array();
					_p3 = String(_params[3]).split("/");
					
					
					var _toupleIndex:int = -1;
					for (var i:int = 0; i < _touples.length; i++) if (_touples[i] == _params[1]) _toupleIndex = i;
	
					if (_toupleIndex == -1) {
						_touples.push(_params[1]);
						vertexLayer.push(_tmpVertexLayer[(int(_p1[0])-1)*3],_tmpVertexLayer[(int(_p1[0])-1)*3+1],_tmpVertexLayer[(int(_p1[0])-1)*3+2]);
						uvLayer.push(_tmpUVLayer[(int(_p1[1])-1)*2],_tmpUVLayer[(int(_p1[1])-1)*2+1]);
						normalLayer.push(_tmpNormalLayer[(int(_p1[2])-1)*3],_tmpNormalLayer[(int(_p1[2])-1)*3+1],_tmpNormalLayer[(int(_p1[2])-1)*3+2]);
						//normalLayer.push(0,0,0);
						
						indexLayer.push(uvLayer.length/2 -1);
					} else {
						indexLayer.push(_toupleIndex);
					}
					
					
					_toupleIndex = -1;
					for (i = 0; i < _touples.length; i++) if (_touples[i] == _params[2]) _toupleIndex = i;
					
					if (_toupleIndex == -1) {
						_touples.push(_params[2]);	
						vertexLayer.push(_tmpVertexLayer[(int(_p2[0])-1)*3],_tmpVertexLayer[(int(_p2[0])-1)*3+1],_tmpVertexLayer[(int(_p2[0])-1)*3+2]);
						uvLayer.push(_tmpUVLayer[(int(_p2[1])-1)*2],_tmpUVLayer[(int(_p2[1])-1)*2+1]);
						normalLayer.push(_tmpNormalLayer[(int(_p2[2])-1)*3],_tmpNormalLayer[(int(_p2[2])-1)*3+1],_tmpNormalLayer[(int(_p2[2])-1)*3+2]);
						//normalLayer.push(0,0,0);
						
						indexLayer.push(uvLayer.length/2 -1);
					} else {
						indexLayer.push(_toupleIndex);
					}
					
					
					_toupleIndex = -1;
					for (i = 0; i < _touples.length; i++) if (_touples[i] == _params[3]) _toupleIndex = i;
					
					if (_toupleIndex == -1) {
						_touples.push(_params[3]);
						vertexLayer.push(_tmpVertexLayer[(int(_p3[0])-1)*3],_tmpVertexLayer[(int(_p3[0])-1)*3+1],_tmpVertexLayer[(int(_p3[0])-1)*3+2]);
						uvLayer.push(_tmpUVLayer[(int(_p3[1])-1)*2],_tmpUVLayer[(int(_p3[1])-1)*2+1]);
						normalLayer.push(_tmpNormalLayer[(int(_p3[2])-1)*3],_tmpNormalLayer[(int(_p3[2])-1)*3+1],_tmpNormalLayer[(int(_p3[2])-1)*3+2]);
						//normalLayer.push(0,0,0);
						
						indexLayer.push(uvLayer.length/2 -1);
					} else {
						indexLayer.push(_toupleIndex);
					}

					
					
				} // if ((_params = _line.match(NOUVFACE)) != null)
				
				
			} //for each(_line in _lines) 
			
			loader.close();
			Globals.objectLoadCallBack();
		
		}
		
	
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			throw new Error("could not load wavefront file (" + file + ")");
		}
		
	}
}