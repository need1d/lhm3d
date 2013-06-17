package com.games.coindozer
{
	import awayphysics.collision.shapes.AWPBoxShape;
	import awayphysics.collision.shapes.AWPConeShape;
	import awayphysics.collision.shapes.AWPCylinderShape;
	import awayphysics.collision.shapes.AWPSphereShape;
	import awayphysics.collision.shapes.AWPStaticPlaneShape;
	import awayphysics.debug.AWPDebugDraw;
	import awayphysics.dynamics.AWPDynamicsWorld;
	import awayphysics.dynamics.AWPRigidBody;
	
	import com.lhm3d.materialobjects.*;
	
	import flash.geom.Vector3D;
	
	
	public class ElementList
	{
		
		public static const COIN:String = "coin";
		
		
		private var list:Vector.<ElementEntity>;
		
		private var physics:AWPDynamicsWorld;
		
		private var coinShape : AWPCylinderShape = new AWPCylinderShape(100,40);
		
		public function ElementList(_physics:AWPDynamicsWorld) : void
		{
			list = new Vector.<ElementEntity>();
			physics = _physics;
			
		}
		
		public function addElement(_typ:String, _pos:Vector3D, _rotX:Number, _rotY:Number, _rotZ:Number, _object3d:Base3DObject) : void {
		
			var _typeFound:Boolean = false;
			
			if (_typ == COIN) {
				_typeFound = true;
				
				list.push(new ElementEntity());
				list[list.length-1].object = _object3d;
				list[list.length-1].rigidBody = new AWPRigidBody(coinShape,null,1000.9);	
				list[list.length-1].rigidBody.friction = 2;
				list[list.length-1].rigidBody.ccdSweptSphereRadius = 0.5;
				list[list.length-1].rigidBody.ccdMotionThreshold = 1;
				list[list.length-1].rigidBody.gravity = new Vector3D(0,10,0);
				
			}
			
			if (_typeFound) {

			
				physics.addRigidBody(list[list.length-1].rigidBody);
				
				list[list.length-1].rigidBody.position = new Vector3D(_pos.x, _pos.y, _pos.z);
				
				list[list.length-1].rigidBody.rotationX = _rotX;
				list[list.length-1].rigidBody.rotationY = _rotY;
				list[list.length-1].rigidBody.rotationZ = _rotZ;
			}
		}
		
		public function render() : void {
		
			for (var i:int = 0; i < list.length; i++) {
				list[i].object.renderWithMatrix(list[i].rigidBody.transform);
			}
			
			
		}
		
		
		
	}
}