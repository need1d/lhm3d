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

	public class Level
	{
		
		private var physics:AWPDynamicsWorld;
		
		private var boxShape : AWPBoxShape = new AWPBoxShape(1000,1000,1000);
		private var boxRigidBody:AWPRigidBody;
		
		private var sliderObject: Base3DObject;
		
		private var upd:int;
		
		public function Level(_physics:AWPDynamicsWorld, _sliderObject:Base3DObject)
		{
			physics = _physics;
			
			sliderObject = _sliderObject;
			
			boxRigidBody = new AWPRigidBody(boxShape,null,0);	
			boxRigidBody.friction = 0.0;
			boxRigidBody.ccdSweptSphereRadius = 0.5;
			boxRigidBody.ccdMotionThreshold = 0;
			boxRigidBody.position = new Vector3D(0,500,500);
			
			physics.addRigidBody(boxRigidBody);
		}
		
		
		public function update() : void {
			upd++;
			//boxRigidBody.position = new Vector3D(0,500,500 + Math.sin(upd / 30) * 500);
			boxRigidBody.x = 0;
			boxRigidBody.y = 400;
			boxRigidBody.z = Math.sin(upd / 30) * 500;
			
		}
		
		public function render() : void {
			sliderObject.renderWithMatrix(boxRigidBody.transform);
		}
		
		
	}
}