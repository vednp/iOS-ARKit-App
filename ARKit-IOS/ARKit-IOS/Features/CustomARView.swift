//
//  CustomARView.swift
//  ARKit-IOS
//
//  Created by Ved Pahune on 18/02/24.
//

import SwiftUI
import ARKit
import RealityKit
import Combine

class CustomARView: ARView{
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
    }
    
    dynamic required init?(coder decoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
        subscribeToActionStream()
        
    }
    
    private var cancellables: Set<AnyCancellable> = []
    func subscribeToActionStream() {
        ARManager.shared.actionStream
            .sink { [weak self] action in
                switch action {
                case .placeSphere(let color):
                    self?.placeSphere(ofcolor: color)
                    
                case .removeAllAnchors:
                    self?.scene.anchors.removeAll()
                }
            }
            .store(in: &cancellables)
        
    }
    
    func configuration(){
        let config = ARWorldTrackingConfiguration()
        session.run(config)
    }
    
    func anchorFunction(){
        let coordinateAnchor = AnchorEntity(world: .zero)
        scene.addAnchor(coordinateAnchor)
    }
    
    func entityFunction(){
        let sphere = MeshResource.generateSphere(radius: 1)
        let entity = ModelEntity(mesh: sphere)
        
        let anchor = AnchorEntity()
        anchor.addChild(entity)
    }
    
    func placeSphere(ofcolor color:Color) {
        // Generate a sphere mesh with a radius of 0.2
        let block = MeshResource.generateSphere(radius: 0.2)
        let material = SimpleMaterial(color: UIColor(color), isMetallic: false)
        let entity = ModelEntity(mesh: block, materials:[material])

        // Get the current frame from the AR session
        guard let frame = self.session.currentFrame else {
            print("AR session is not available")
            return
        }

        // Calculate a position 2 meters in front of the camera
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -2.0  // 2 meters in front of the camera
        let transform = simd_mul(frame.camera.transform, translation)

        // Create an anchor with the transform and add the entity to it
        let anchor = AnchorEntity(world: transform)
        anchor.addChild(entity)

        // Add the anchor to the scene
        scene.addAnchor(anchor)

        // Create a point light and position it near the sphere
        let light = PointLight()
        light.light.intensity = 10_000_000 // Adjust as needed
        light.light.color = .white
        light.position = [0, 0, 0.2] // Positioned slightly above the sphere

        // Add the light to the anchor
        anchor.addChild(light)
    }


    

}

