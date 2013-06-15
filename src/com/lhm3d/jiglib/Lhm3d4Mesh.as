package com.lhm3d.jiglib {
	import com.lhm3d.materialobjects.Base3DObject;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import jiglib.data.TriangleVertexIndices;
	import jiglib.plugin.ISkin3D;
	
	public class Lhm3d4Mesh implements ISkin3D {
		
		private var _mesh : Base3DObject;
		private var _translationOffset : Vector3D;
		private var _scale : Vector3D;
		private var _transform : Matrix3D = new Matrix3D();
		
		public function Lhm3d4Mesh(do3d : Base3DObject, offset : Vector3D = null) {
			this._mesh = do3d;
			
			if (offset) {
				_translationOffset = offset.clone();
			}
			/*
			if (do3d.scaleX != 1 || do3d.scaleY != 1 || do3d.scaleZ != 1) {
				_scale = new Vector3D(do3d.scaleX, do3d.scaleY, do3d.scaleZ);
			}
			*/
		}
		
		public function get transform() : Matrix3D {
			return _mesh.getPhysicsTransform();
		}
		
		public function set transform(m : Matrix3D) : void {
		//	_transform.identity();
		//	if (_translationOffset) _transform.appendTranslation(_translationOffset.x, _translationOffset.y, _translationOffset.z);
		//	if (_scale) _transform.appendScale(_scale.x, _scale.y, _scale.z);
		//	_transform.append(m);
			_mesh.setPhysicsTransform(m);
		}
		
		public function get mesh() : Base3DObject {
			return _mesh;
		}
		
		public function get vertices() : Vector.<Vector3D> {
			
			
			var result : Vector.<Vector3D>=new Vector.<Vector3D>();
			
			var vts : Vector.<Number>=_mesh.getVertexLayer();
			
			var len : int = vts.length / 13;
			
			for (var i : uint = 0;i < len;i++) {
				result.push(new Vector3D(vts[i * 13], vts[i * 13 + 1], vts[i * 13 + 2]));
			}
			
			
			return result;
		}
		
		public function get indices() : Vector.<TriangleVertexIndices> {
			
			var result : Vector.<TriangleVertexIndices>=new Vector.<TriangleVertexIndices>();
			
			var ids : Vector.<uint>=_mesh.getIndexLayer();
			for (var i : uint = 0;i < ids.length;i += 3) {
				result.push(new TriangleVertexIndices(ids[i], ids[i + 1], ids[i + 2]));
			}
			return result;
			
		}
	}
}
