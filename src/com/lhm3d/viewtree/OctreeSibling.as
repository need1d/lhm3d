package com.lhm3d.viewtree
{
	import com.lhm3d.camera.*;
	import com.lhm3d.globals.Globals;
	import com.lhm3d.geometryhelpers.BoundingBox;
	
	import flash.geom.Vector3D;
	
	

	public class OctreeSibling
	{
		
		protected var sib1:OctreeSibling;
		protected var sib2:OctreeSibling;
		protected var sib3:OctreeSibling;
		protected var sib4:OctreeSibling;		
		protected var sib5:OctreeSibling;
		protected var sib6:OctreeSibling;
		protected var sib7:OctreeSibling;
		protected var sib8:OctreeSibling;

		protected var sib1Used:Boolean = false;
		protected var sib2Used:Boolean = false;
		protected var sib3Used:Boolean = false;
		protected var sib4Used:Boolean = false;
		protected var sib5Used:Boolean = false;
		protected var sib6Used:Boolean = false;
		protected var sib7Used:Boolean = false;
		protected var sib8Used:Boolean = false;
		
		
		private var bb:BoundingBox;
		private var invBB:BoundingBox;
		
		private var midP:Vector3D;
		private var radius:Number;
		
		private var minP:Vector3D;
		private var maxP:Vector3D;
		
		public static var itDepth:int = 3;
		
		public var objectRefs:Vector.<int> = new Vector.<int>();
		
		public var iteration:int = 0;
		
		public function OctreeSibling(_minP:Vector3D, _maxP:Vector3D):void
		{
		
			bb = new BoundingBox(_minP,_maxP);
			
			invBB = new BoundingBox(_minP,_maxP);
			invBB.invert();
				
			minP = new Vector3D(_minP.x, _minP.y, _minP.z);
			maxP = new Vector3D(_maxP.x, _maxP.y, _maxP.z);
			
			midP = new Vector3D((_minP.x+_maxP.x)/2,(_minP.y+_maxP.y)/2,(_minP.z+_maxP.z)/2);
			radius = new Vector3D(_minP.x-_maxP.x,_minP.y-_maxP.y,_minP.z-_maxP.z).length/2;
			
		}
		
		
		public function render():void {
			
			if (iteration == itDepth) {
				for (var i:int = 0; i < objectRefs.length; i++) {
					var _index:int = objectRefs[i];
					
					if(ViewTree.objects[_index].rendered == false) {
						ViewTree.objects[_index].rendered = true;
						ViewTree.objectContainer[ViewTree.objects[_index].ref].renderWithMatrix(ViewTree.objects[_index].m);
						Globals.renderedObjectCount ++;
					}
				
				}
				
				return;
			}
		
			// schnelle Abfrage aller siblings
			if (sib1Used) {if (visTest(sib1)) { sib1.render(); }}
			if (sib2Used) {if (visTest(sib2)) { sib2.render(); }}
			if (sib3Used) {if (visTest(sib3)) { sib3.render(); }}
			if (sib4Used) {if (visTest(sib4)) { sib4.render(); }}
			if (sib5Used) {if (visTest(sib5)) { sib5.render(); }}
			if (sib6Used) {if (visTest(sib6)) { sib6.render(); }}
			if (sib7Used) {if (visTest(sib7)) { sib7.render(); }}
			if (sib8Used) {if (visTest(sib8)) { sib8.render(); }}
		
		}
		
		
		private function visTest(_sib:OctreeSibling):Boolean {
		
			var _res:int = Visibility.testSphereAgainstView(_sib.midP.x,_sib.midP.y,_sib.midP.z,_sib.radius);
			
			if (_res == Visibility.OUT) return false;
			
			if (_res == Visibility.INTERSECT) { 
				if (Visibility.testAaBBAgainstView(_sib.invBB) == false) return false;
			}
			
			return true;
		
		}
		
		
		
		public function addObject(_oref:int, _objectBB:BoundingBox, _iteration:int):void {
			
			iteration = _iteration;
			

			if (iteration == itDepth) {
				objectRefs.push(_oref);
				return;
			}
			
			var _bb1:BoundingBox = new BoundingBox(minP, new Vector3D((minP.x+maxP.x)/2,(minP.y+maxP.y)/2,(minP.z+maxP.z)/2));
			var _bb2:BoundingBox = new BoundingBox(new Vector3D((minP.x+maxP.x)/2,minP.y,minP.z), new Vector3D(maxP.x,(minP.y+maxP.y)/2,(minP.z+maxP.z)/2));	
			var _bb3:BoundingBox = new BoundingBox(new Vector3D(minP.x,(minP.y+maxP.y)/2,minP.z),new Vector3D((minP.x+maxP.x)/2,maxP.y,(minP.z+maxP.z)/2));
			var _bb4:BoundingBox = new BoundingBox(new Vector3D((minP.x+maxP.x)/2,(minP.y+maxP.y)/2,minP.z),new Vector3D(maxP.x,maxP.y,(minP.z+maxP.z)/2));
			var _bb5:BoundingBox = new BoundingBox(new Vector3D(minP.x,minP.y,(minP.z+maxP.z)/2), new Vector3D((minP.x+maxP.x)/2,(minP.y+maxP.y)/2,maxP.z));
			var _bb6:BoundingBox = new BoundingBox(new Vector3D((minP.x+maxP.x)/2,minP.y,(minP.z+maxP.z)/2), new Vector3D(maxP.x,(minP.y+maxP.y)/2,maxP.z));
			var _bb7:BoundingBox = new BoundingBox(new Vector3D(minP.x,(minP.y+maxP.y)/2,(minP.z+maxP.z)/2),new Vector3D((minP.x+maxP.x)/2,maxP.y,maxP.z));
			var _bb8:BoundingBox = new BoundingBox(new Vector3D((minP.x+maxP.x)/2,(minP.y+maxP.y)/2,(minP.z+maxP.z)/2),new Vector3D(maxP.x,maxP.y,maxP.z));

			
			var _f:Boolean = false;
			
			if (_bb1.icludesOtherNonAaBB(_objectBB)) {
				_f = true;
				if (sib1Used == false) {
					sib1 = new OctreeSibling(_bb1.getAaMin(),_bb1.getAaMax());
				}

				sib1Used = true;
				sib1.addObject(_oref,_objectBB,iteration+1);
			}			
			
			if (_bb2.icludesOtherNonAaBB(_objectBB)) {
				_f = true;
				if (sib2Used == false) {
					sib2  = new OctreeSibling(_bb2.getAaMin(),_bb2.getAaMax());
				}
				
				sib2Used = true;
				sib2.addObject(_oref,_objectBB,iteration+1);
			}			
			
			if (_bb3.icludesOtherNonAaBB(_objectBB)) {
				_f = true;
				if (sib3Used == false) {
					sib3 = new OctreeSibling(_bb3.getAaMin(),_bb3.getAaMax());
				}
				
				sib3Used = true;
				sib3.addObject(_oref,_objectBB,iteration+1);
			}			

			if (_bb4.icludesOtherNonAaBB(_objectBB)) {
				_f = true;
				if (sib4Used == false) {
					sib4 = new OctreeSibling(_bb4.getAaMin(),_bb4.getAaMax());
				}
				
				sib4Used = true;
				sib4.addObject(_oref,_objectBB,iteration+1);
			}		
			
			if (_bb5.icludesOtherNonAaBB(_objectBB)) {
				_f = true;
				if (sib5Used == false) {
					sib5 = new OctreeSibling(_bb5.getAaMin(),_bb5.getAaMax());
				}
				
				sib5Used = true;
				sib5.addObject(_oref,_objectBB,iteration+1);
			}	
			
			if (_bb6.icludesOtherNonAaBB(_objectBB)) {
				_f = true;
				if (sib6Used == false) {
					sib6 = new OctreeSibling(_bb6.getAaMin(),_bb6.getAaMax());
				}
				
				sib6Used = true;
				sib6.addObject(_oref,_objectBB,iteration+1);
			}	
			
			if (_bb7.icludesOtherNonAaBB(_objectBB)) {
				_f = true;
				if (sib7Used == false) {
					sib7 = new OctreeSibling(_bb7.getAaMin(),_bb7.getAaMax());
				}
				
				sib7Used = true;
				sib7.addObject(_oref,_objectBB,iteration+1);
			}
			
			if (_bb8.icludesOtherNonAaBB(_objectBB)) {
				_f = true;
				if (sib8Used == false) {
					sib8 = new OctreeSibling(_bb8.getAaMin(),_bb8.getAaMax());
				}
				
				sib8Used = true;
				sib8.addObject(_oref,_objectBB,iteration+1);
			}
			
			
			if (_f == false) {
				
				trace("keine passende Bounding-Box gefunden (object außerhalb) !");
			
			}
			
		
		}
		
		
		
		
		
	}
}