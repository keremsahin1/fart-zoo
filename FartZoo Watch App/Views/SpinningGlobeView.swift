import SwiftUI
import SceneKit

struct SpinningGlobeView: View {
    var body: some View {
        SceneView(scene: makeScene(), options: [])
            .frame(width: 80, height: 80)
            .clipShape(Circle())
    }

    private func makeScene() -> SCNScene {
        let scene = SCNScene()
        scene.background.contents = UIColor.black

        let sphere = SCNSphere(radius: 1.0)
        let material = SCNMaterial()
        if let url = Bundle.main.url(forResource: "earth_texture", withExtension: "jpg") {
            material.diffuse.contents = UIImage(contentsOfFile: url.path)
        }
        material.lightingModel = .constant
        sphere.materials = [material]

        let node = SCNNode(geometry: sphere)
        let rotation = SCNAction.rotateBy(x: 0, y: .pi * 2, z: 0, duration: 3)
        node.runAction(SCNAction.repeatForever(rotation))
        scene.rootNode.addChildNode(node)

        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        camera.fieldOfView = 45
        cameraNode.position = SCNVector3(0, 0, 2.5)
        scene.rootNode.addChildNode(cameraNode)

        return scene
    }
}
