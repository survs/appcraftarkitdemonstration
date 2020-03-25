//
//  ViewController.swift
//  AR
//
//  Created by Кирилл Баюков on 04.01.2020.
//  Copyright © 2020 AppCraft. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    var items = 0
    var amount = 1
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.scene.physicsWorld.contactDelegate = self
        self.sceneView.showsStatistics = true
        self.sceneView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func stepped(_ sender: Any) {
        self.amountLabel.text = "\(Int(self.stepper.value))"
        self.amount = Int(self.stepper.value)
    }
    
    @IBAction func resetAllButtonPressed(_ sender: Any) {
        for node in self.sceneView.scene.rootNode.childNodes {
            node.removeFromParentNode()
        }
        self.items = 0
    }
    
    @IBAction func resetDiceButtonPressed(_ sender: Any) {
        for node in self.sceneView.scene.rootNode.childNodes {
            if node.isKind(of: ARBox.self) {
                node.removeFromParentNode()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
//        configuration.planeDetection = .horizontal
        self.sceneView.session.run(configuration, options: [])
        self.sceneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
        self.sceneView.isUserInteractionEnabled = true
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    @objc
    func tapped() {
        self.addBall()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sceneView.session.pause()
    }
    
    func startGame() {
        self.addBall()
    }
    
    func addBall() {
        guard let currentFrame = sceneView.session.currentFrame else { return }
        if self.items == 0 {
            
            let plane = SCNPlane(width: 5, height: 5)
            let planeNode = SCNNode(geometry: plane)
            plane.materials.first?.diffuse.contents = UIColor.green.withAlphaComponent(0.5)
            planeNode.eulerAngles.x = -.pi / 2
            let shape = SCNPhysicsShape(geometry: plane, options: nil)
            planeNode.physicsBody?.isAffectedByGravity = false
            planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: shape)
            planeNode.physicsBody?.categoryBitMask = 2
            planeNode.physicsBody?.contactTestBitMask = 1
            planeNode.position.y = -1
            sceneView.scene.rootNode.addChildNode(planeNode)
            self.items += 1
            return
        }
        //        if self.items % 2 == 0 {
//                    let ball = ARBall()
//                    sceneView.scene.rootNode.addChildNode(ball)
//        //
//                    var translation = matrix_identity_float4x4
//                    translation.columns.3.z = -1
//                    ball.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
        //        } else {
        for _ in 0...self.amount - 1 {
            let ball = ARBox()
            self.sceneView.scene.rootNode.addChildNode(ball)
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -0.5
            ball.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
            ball.rotation.y = Float(Double.random(in: 0...(2 * .pi)))
            ball.rotation.x = Float(Double.random(in: 0...(2 * .pi)))
            ball.rotation.z = Float(Double.random(in: 0...(2 * .pi)))
            ball.physicsBody?.applyTorque(SCNVector4(Float(Double.random(in: 0...0.003)), Float(Double.random(in: 0...0.003)), Float(Double.random(in: 0...0.003)), Float(Double.random(in: 0...0.003))), asImpulse: true)
        }
        
    }
}


extension ViewController: SCNPhysicsContactDelegate {
    
    func physicsWorld(_ world: SCNPhysicsWorld, didUpdate contact: SCNPhysicsContact) {
        if contact.nodeA.isKind(of: ARBox.self) {
            if contact.nodeA.physicsBody!.velocity.x == 0.0001 && contact.nodeA.physicsBody!.velocity.y < 0.0001 && contact.nodeA.physicsBody!.velocity.z < 0.0001 && contact.nodeA.physicsBody!.angularVelocity.x < 0.0001 && contact.nodeA.physicsBody!.angularVelocity.y < 0.0001 && contact.nodeA.physicsBody!.angularVelocity.z < 0.0001 {
                contact.nodeB.physicsBody?.setResting(true)
            }
        }
        if contact.nodeB.isKind(of: ARBox.self) {
            if contact.nodeB.physicsBody!.velocity.x < 0.0001 && contact.nodeB.physicsBody!.velocity.y < 0.0001 && contact.nodeB.physicsBody!.velocity.z < 0.0001 && contact.nodeB.physicsBody!.angularVelocity.x < 0.0001 && contact.nodeB.physicsBody!.angularVelocity.y < 0.0001 && contact.nodeB.physicsBody!.angularVelocity.z < 0.0001 {
                contact.nodeB.physicsBody?.setResting(true)
//                contact.nodeB.physicsBody?.type = .static
            }
        }
    }
    
    
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // 2
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        let plane = SCNPlane(width: width, height: height)
        
        // 3
        plane.materials.first?.diffuse.contents = UIColor.green.withAlphaComponent(0.8)
        
        // 4
        let planeNode = SCNNode(geometry: plane)
        
        // 5
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x,y,z)
        planeNode.eulerAngles.x = -.pi / 2
        let shape = SCNPhysicsShape(geometry: plane, options: nil)
        planeNode.physicsBody?.isAffectedByGravity = false
        planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: shape)
        planeNode.physicsBody?.categoryBitMask = 2
        planeNode.physicsBody?.contactTestBitMask = 1
        
        // 6
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as?  ARPlaneAnchor,
            let planeNode = node.childNodes.first,
            let plane = planeNode.geometry as? SCNPlane
            else { return }
        
        // 2
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        plane.width = width
        plane.height = height
        
        // 3
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x, y, z)
    }
}
