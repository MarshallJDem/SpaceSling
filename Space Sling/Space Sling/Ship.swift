import UIKit
import SpriteKit
import Foundation


class Ship: SKSpriteNode {
    
    //The angle the camera is at in respect to the scene
    var sceneAngle: CGFloat = 0
    //The camera
    let cam = SKCameraNode()
    
    init(pos: CGPoint, angle: CGFloat, velocity: CGVector, global: LevelProtocol, planet: Planet) {
        
        //Init shot
        super.init(texture: SKTexture(imageNamed: "Spaceship"), color: UIColor.clear, size: CGSize(width: 50, height: 100))
        self.size = CGSize(width: 50, height: 100)
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.categoryBitMask = shotCategory
        self.physicsBody?.contactTestBitMask = planetCategory
        self.physicsBody?.angularDamping = 0
        self.physicsBody?.linearDamping = 0
        global.gameWorld.addChild(self)
        global.currentShip = self
        
        //Use calculations
        self.position = pos
        self.zRotation = angle
        self.physicsBody?.velocity = velocity
        
        //Kill after 5 seconds
        self.run(SKAction.sequence([SKAction.wait(forDuration: 50), SKAction.run {
            self.removeFromParent()
            }]))
        
        //Shot Camera
        cam.setScale(2.0)
        cam.name = "Ship"
        cam.zRotation = -planet.rotationLock.zRotation
        if(planet.camFather.position.y < 0){ //If you're aiming downward
            cam.zRotation -= CGFloat(M_PI)
            
        }
        self.addChild(cam)
        sceneAngle = cam.zRotation
        
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
