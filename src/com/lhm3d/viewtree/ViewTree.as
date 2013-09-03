package com.lhm3d.viewtree
{
	import com.lhm3d.camera.*;
	import com.lhm3d.globals.Globals;
	import com.lhm3d.geometryhelpers.BoundingBox;
	import com.lhm3d.materialobjects.Base3DObject;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	public class ViewTree
	{
		
		public static var objectContainer:Vector.<Base3DObject>;
		public static var objects:Vector.<TreeEntity>;
		
		private static var tree:OctreeSibling;
		
		public function ViewTree()
		{
		}
		
		public static function init(_minP:Vector3D, _maxP:Vector3D, _iterationDepth:int):void {
			objectContainer = new Vector.<Base3DObject>();
			objects = new Vector.<TreeEntity>();
			
			OctreeSibling.itDepth = _iterationDepth;
			tree = new OctreeSibling(_minP, _maxP);
		}
		
		public static function submitObjectToContainer(_obj:Base3DObject):int {
			objectContainer.push(_obj);
			return (objectContainer.length-1);
		}
		
		public static function addObjectAtPosRotScale(_ref:int,_x:Number,_y:Number,_z:Number,
												 		 _rx:Number,_ry:Number,_rz:Number,_s:Number):void {
		
			var _m:Matrix3D = new Matrix3D();
			_m.appendScale(_s,_s,_s);			
			_m.appendRotation(_rx,new Vector3D(1,0,0));
			_m.appendRotation(_ry,new Vector3D(0,1,0));
			_m.appendRotation(_rz,new Vector3D(0,0,1));
			_m.appendTranslation(_x,_y,_z);
			
			trace("rotation values:", _rx, _ry, _rz);
			
			var _treeBB:BoundingBox = new BoundingBox(new Vector3D(0,0,0), new Vector3D(0,0,0));

			
			_treeBB.cloneValuesFromOtherBB(objectContainer[_ref].getBoundingBox());
			_treeBB.appendMatrix(_m);
			
			objects.push(new TreeEntity(_ref,_m));
			var _objectsRef:int = objects.length-1;
			
			
			tree.addObject(_objectsRef,_treeBB,0);
			
		}
		
		
		public static function addObject(_ref:int):void {
			addObjectAtPosRotScale(_ref,0,0,0,0,0,0,1);
		}
		
		
		public static function render():void {
			for (var i:int = 0; i < objects.length; i++) objects[i].rendered = false;			
			tree.render();
			trace("objects rendered:", Globals.renderedObjectCount);
		}
		
		
		
	}
}