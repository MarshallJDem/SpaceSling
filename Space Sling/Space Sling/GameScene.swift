import SpriteKit
import Darwin
import Foundation

var allCategory: UInt32 = 0xFFFFFFFF
var shotCategory: UInt32 = 1 << 1
var planetCategory: UInt32 = 1 << 2
var markCategory: UInt32 = 1 << 3

class GameScene: SKScene, SKPhysicsContactDelegate, LevelProtocol{
    
    var viewController: GameViewController!
    
    let gameWorld = SKSpriteNode()
    var currentPlanet: Planet!
    var currentShip: Ship!
    var systems = Array<System>()
    var start = NSDate()
    var end = NSDate()
    
    //Used in the update function
    var lastTime: CFTimeInterval!
    
    var line = SKSpriteNode(color: UIColor.white, size: CGSize(width: 10,height: 0))
    
    override func didMove(to view: SKView) {
        self.removeAllChildren()
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.speed = 1.0
        backgroundColor = SKColor.black
        physicsWorld.contactDelegate = self
        self.anchorPoint = CGPoint(x: 0.5,y: 0.5);
        self.addChild(gameWorld);
        self.addChild(line)
        
        //Aesthetic
        var background = SKSpriteNode(texture: SKTexture(imageNamed: "space"), size: CGSize(width: 1920, height: 1080))
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = -1
        self.addChild(background)
        background = SKSpriteNode(texture: SKTexture(imageNamed: "space"), size: CGSize(width: 1920, height: 1080))
        background.position = CGPoint(x: 0, y: 540)
        background.zPosition = -1
        self.addChild(background)
        background = SKSpriteNode(texture: SKTexture(imageNamed: "space"), size: CGSize(width: 1920, height: 1080))
        background.position = CGPoint(x: 0, y: -540)
        background.zPosition = -1
        self.addChild(background)
        
        //Just incase for null! pointer exceptions
        let cam = SKCameraNode()
        self.camera = cam
        self.addChild(cam)
        cam.position = CGPoint(x: 0, y: 0)
        
        loadLevel(level: 0, offset: CGPoint(x: 0, y: 0), scene: self)
        
        
        
    }
    override func update(_ currentTime: CFTimeInterval) {
        currentPlanet.updatePlanet()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches{
            let positionInScene = touch.location(in: self.view)
        }
        currentPlanet.wakeUp()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            // let touchLocation = touch.location(in: self)
            // let touchedNode = self.atPoint(touchLocation)
            currentPlanet.shoot()
            
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        end = NSDate()
        print(end.timeIntervalSince(start as Date))
        for touch in touches{
            var positionInScene = touch.location(in: self.view)
            positionInScene.x -= self.size.width/2
            positionInScene.y -= self.size.height/2; positionInScene.y *= -1
            
            currentPlanet.panCamera(pos: positionInScene)
            currentPlanet.setRotation(pos: positionInScene)
            
        
            
        }
        start = NSDate()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return;}
        let positionInScene = touch.location(in: self)
        // let touchedNode = self.atPoint(positionInScene)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch(contactMask) {
        case planetCategory | shotCategory:
            var planet: Planet!
            var shot: SKSpriteNode!
            if(contact.bodyA.categoryBitMask == planetCategory){
                planet = contact.bodyA.node as! Planet
                shot = contact.bodyB.node as! SKSpriteNode
            }
            else{
                planet = contact.bodyB.node as! Planet
                shot = contact.bodyA.node as! SKSpriteNode
            }
            if(planet != currentPlanet){
                currentPlanet.deactivate()
                planet.activate()
                shot.removeFromParent()}
            
            return
        case markCategory | shotCategory:
            return
        default:
            return
        }
    }
    func didEnd(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch(contactMask) {
        case 0 | 0:
            return
        default:
            return
        }
    }
}
