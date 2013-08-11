package com.games.coindozer
{	
	import away3d.arcane;
	import away3d.core.base.*;
	
	import awayphysics.collision.shapes.AWPBoxShape;
	import awayphysics.collision.shapes.AWPCompoundShape;
	import awayphysics.collision.shapes.AWPConeShape;
	import awayphysics.collision.shapes.AWPConvexHullShape;
	import awayphysics.collision.shapes.AWPCylinderShape;
	import awayphysics.collision.shapes.AWPSphereShape;
	import awayphysics.collision.shapes.AWPStaticPlaneShape;
	import awayphysics.debug.AWPDebugDraw;
	import awayphysics.dynamics.AWPDynamicsWorld;
	import awayphysics.dynamics.AWPRigidBody;
	
	import com.lhm3d.materialobjects.*;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	public class Level
	{
		
		private var physics:AWPDynamicsWorld;
		
		private var boxShape : AWPBoxShape = new AWPBoxShape(1000,1000,1000);
		private var boxRigidBody:AWPRigidBody;
		
		
		private var dummyObject: Base3DObject;
		
		private var sliderObject: Base3DObject;
		
		private var castleObject: Base3DObject;
		private var castleMatrix: Matrix3D;
		
		
		// castle collision
		private var cubeMatrixes:Vector.<Matrix3D> = new Vector.<Matrix3D>();
		private var cubeRGB:Vector.<AWPRigidBody> = new Vector.<AWPRigidBody>();
		
		
		private var upd:int;
		
		public function Level(_physics:AWPDynamicsWorld, _sliderObject:Base3DObject, _castleObject:Base3DObject, _dummyCube:Base3DObject)
		{
			physics = _physics;
			
			// slider object
			
			sliderObject = _sliderObject;			
			boxRigidBody = new AWPRigidBody(boxShape,null,0);	
			boxRigidBody.friction = 0.0;
			boxRigidBody.ccdSweptSphereRadius = 0.5;
			boxRigidBody.ccdMotionThreshold = 0;
			boxRigidBody.position = new Vector3D(0,100,500);
			
			physics.addRigidBody(boxRigidBody);
			
			// castle object
			
			castleObject = _castleObject;
			
			castleMatrix = new Matrix3D();
			castleMatrix.appendRotation(180, new Vector3D(0,1,0));
			castleMatrix.position = new Vector3D(0,0,-1300);
			
			// collision boxes
			
			dummyObject = _dummyCube;
			
			// untergrund
			cubeMatrixes.push(new Matrix3D());
			cubeMatrixes[cubeMatrixes.length - 1].appendScale(1.2,1,2.2);
			cubeMatrixes[cubeMatrixes.length - 1].appendRotation(0, new Vector3D(1,0,0));
			cubeMatrixes[cubeMatrixes.length - 1].appendTranslation(0,-423,-394);
				
			// hinten schräg
			cubeMatrixes.push(new Matrix3D());
			cubeMatrixes[cubeMatrixes.length - 1].appendScale(1.6,1.186,0.5);
			cubeMatrixes[cubeMatrixes.length - 1].appendRotation(54, new Vector3D(1,0,0));
			cubeMatrixes[cubeMatrixes.length - 1].appendTranslation(0,414,492);
			
		
			// hinten gerade
			cubeMatrixes.push(new Matrix3D());
			cubeMatrixes[cubeMatrixes.length - 1].appendScale(1.6,1.186,0.5);
			cubeMatrixes[cubeMatrixes.length - 1].appendRotation(0, new Vector3D(1,0,0));
			cubeMatrixes[cubeMatrixes.length - 1].appendTranslation(0,-330,117);
			
			
			// left side
			cubeMatrixes.push(new Matrix3D());
			cubeMatrixes[cubeMatrixes.length - 1].appendScale(0.5,1,1);
			cubeMatrixes[cubeMatrixes.length - 1].appendRotation(0, new Vector3D(1,0,0));
			cubeMatrixes[cubeMatrixes.length - 1].appendTranslation(-601,-240,-25);
			
			cubeMatrixes.push(new Matrix3D());
			cubeMatrixes[cubeMatrixes.length - 1].appendScale(0.5,1,1);
			cubeMatrixes[cubeMatrixes.length - 1].appendRotation(-32, new Vector3D(0,0,1));
			cubeMatrixes[cubeMatrixes.length - 1].appendTranslation(-828,-26,-25);
			
			cubeMatrixes.push(new Matrix3D());
			cubeMatrixes[cubeMatrixes.length - 1].appendScale(0.5,0.5,0.38);
			cubeMatrixes[cubeMatrixes.length - 1].appendRotation(40.1, new Vector3D(0,1,0));
			cubeMatrixes[cubeMatrixes.length - 1].appendTranslation(-668,17,-511);
			
			// right side
			cubeMatrixes.push(new Matrix3D());
			cubeMatrixes[cubeMatrixes.length - 1].appendScale(0.5,1,1);
			cubeMatrixes[cubeMatrixes.length - 1].appendRotation(0, new Vector3D(1,0,0));
			cubeMatrixes[cubeMatrixes.length - 1].appendTranslation(601,-240,-25);
			
			cubeMatrixes.push(new Matrix3D());
			cubeMatrixes[cubeMatrixes.length - 1].appendScale(0.5,1,1);
			cubeMatrixes[cubeMatrixes.length - 1].appendRotation(32, new Vector3D(0,0,1));
			cubeMatrixes[cubeMatrixes.length - 1].appendTranslation(828,-26,-25);
			
			cubeMatrixes.push(new Matrix3D());
			cubeMatrixes[cubeMatrixes.length - 1].appendScale(0.5,0.5,0.38);
			cubeMatrixes[cubeMatrixes.length - 1].appendRotation(-40.1, new Vector3D(0,1,0));
			cubeMatrixes[cubeMatrixes.length - 1].appendTranslation(668,17,-511);
		
			
			
			for (var i:int = 0; i < cubeMatrixes.length; i++) {
				var _bShape : AWPBoxShape = new AWPBoxShape(1000,1000,1000);
				var _cubeRGB: AWPRigidBody = new AWPRigidBody(_bShape, null, 0);
				
				_cubeRGB.ccdSweptSphereRadius = 0.001;
				//list[list.length-1].rigidBody.angularFactor = 0.2;
				_cubeRGB.angularDamping =0.8;
				_cubeRGB.ccdMotionThreshold = 0.001;
				_cubeRGB.restitution = 0.001;
				
				if (i == 0) {
					_cubeRGB.friction = 0.3;
			
				} else {
					_cubeRGB.friction = 0.3;
				}
			
			
				_cubeRGB.transform = cubeMatrixes[i];
				physics.addRigidBody(_cubeRGB);
			}
		
			
		}
		
		
		public function update() : void {
			upd++;
			//boxRigidBody.position = new Vector3D(0,500,500 + Math.sin(upd / 30) * 500);
			boxRigidBody.x = 0;
			boxRigidBody.y = -330;
			boxRigidBody.z = Math.sin(upd / 50) * 250 + 170;
			
		}
		
		public function render() : void {
			
			// slider object
			sliderObject.renderWithMatrix(boxRigidBody.transform);
			
			// castle collision
			castleObject.renderWithMatrix(castleMatrix);
			
			// collision cubes
			
			for (var i:int = 0; i < cubeMatrixes.length; i++) {
				dummyObject.renderWithMatrix(cubeMatrixes[i]);
			}
		
		
		}
		
		
	}
}