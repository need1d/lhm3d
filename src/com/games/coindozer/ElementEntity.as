package com.games.coindozer
{
	import awayphysics.collision.shapes.AWPBoxShape;
	import awayphysics.collision.shapes.AWPConeShape;
	import awayphysics.collision.shapes.AWPCylinderShape;
	import awayphysics.collision.shapes.AWPSphereShape;
	import awayphysics.collision.shapes.AWPStaticPlaneShape;
	import awayphysics.dynamics.AWPDynamicsWorld;
	import awayphysics.dynamics.AWPRigidBody;
	import awayphysics.debug.AWPDebugDraw;
	
	import com.lhm3d.materialobjects.*;
	
	public class ElementEntity
	{
		
		public var object:Base3DObject;
		public var rigidBody:AWPRigidBody;
		public var type:String = "";
		
		public function ElementEntity() : void
		{
			
			
		}
		
		
	}
}