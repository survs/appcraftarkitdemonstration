//
//  ARBall.swift
//  AR
//
//  Created by Кирилл Баюков on 04.01.2020.
//  Copyright © 2020 AppCraft. All rights reserved.
//

import ARKit

class ARBall: SCNNode {
    override init() {
        super.init()
        
        let sphere = SCNSphere(radius: 0.1)
        self.geometry = sphere
        let shape = SCNPhysicsShape(geometry: sphere, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        self.physicsBody?.allowsResting = true
        self.physicsBody?.categoryBitMask = 1
        self.physicsBody?.contactTestBitMask = 2
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "peka2.png")
        self.geometry?.materials = [material]
//        self.physicsBody?.collisionBitMask = SCNPhysicsCollisionCategory.all.rawValue
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class ARBox: SCNNode {
    override init() {
        super.init()
        
        let box = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0)
        self.geometry = box
        let shape = SCNPhysicsShape(geometry: box, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        self.physicsBody?.isAffectedByGravity = true
        self.physicsBody?.allowsResting = true
        self.physicsBody?.categoryBitMask = 1
        self.physicsBody?.contactTestBitMask = 2
        self.physicsBody?.mass = 0.1
        self.physicsBody?.rollingFriction = 1
        self.physicsBody?.angularDamping = 0.85
        self.physicsBody?.continuousCollisionDetectionThreshold = 0.0001
//        self.physicsBody?.angularRestingThreshold = 1
        let material1 = SCNMaterial()
        material1.diffuse.contents = UIImage(named: "1")
        let material2 = SCNMaterial()
        material2.diffuse.contents = UIImage(named: "2")
        let material3 = SCNMaterial()
        material3.diffuse.contents = UIImage(named: "3")
        let material4 = SCNMaterial()
        material4.diffuse.contents = UIImage(named: "4")
        let material5 = SCNMaterial()
        material5.diffuse.contents = UIImage(named: "5")
        let material6 = SCNMaterial()
        material6.diffuse.contents = UIImage(named: "6")
        self.geometry?.materials = [material1, material2, material3, material4, material5, material6]
//        self.physicsBody?.collisionBitMask = SCNPhysicsCollisionCategory.all.rawValue
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
