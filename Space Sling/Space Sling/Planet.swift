import UIKit
import SpriteKit
import Foundation


class Planet: SKSpriteNode {
    
    //Image/Color Changing
    var colorType: Int!
    var planetImage = SKTexture(imageNamed: "Spaceship")
    //The GameScene being used (Can also be selection scene)
    var global: LevelProtocol!
    //The camera
    var camFather = SKNode()
    var cam = SKCameraNode()
    var maxCamOffset: CGFloat = 200 //Offset from center when zooming out(the L of sigmoid)
    //Movement
    var rotationSpeed: CGFloat = 0.0
    //Rotation Parent-Node
    var rotationLock = SKNode()
    //The aiming Line
    var lineNode = SKSpriteNode()
    var maxLineLength: CGFloat!
    //The parent ring
    var parentRing: Ring!
    //The angle that the planet is at within its ring
    var angleInRing: CGFloat!
    //IF forward, its zero. If shooting backward, M_PI so that shooting is in the correct direction
    var angleBuffer: CGFloat = 0
    //Has been touched
    var isAwake = false
    
    init(color: Int, scene: LevelProtocol, pos: CGPoint, ring: Ring!, angle: CGFloat) {
        
        //Figure out color type and image
        switch color{
        case 1:
            planetImage = SKTexture(imageNamed: "redP")
        case 2:
            planetImage = SKTexture(imageNamed: "orangeP")
        case 3:
            planetImage = SKTexture(imageNamed: "blueP")
        default:
            planetImage = SKTexture(imageNamed: "Spaceship")
            break
        }
        
        //Main initializer **NOTE DOES NOT ACTUALLY DISPLAY THE IMAGE**
        super.init(texture: planetImage, color: UIColor.clear, size: CGSize(width: 100, height: 100))
        
        //Init local variables
        global = scene
        colorType = color
        cam.position = CGPoint(x: 0, y: 0)
        cam.setScale(2.0)
        cam.name = "Planet"
        self.addChild(rotationLock)
        self.addChild(camFather)
        camFather.addChild(cam)
        lineNode = SKSpriteNode(color: UIColor.white, size: CGSize(width: 1, height: 0))
        rotationLock.addChild(lineNode)
        maxLineLength = (global as! SKScene).size.height/2
        parentRing = ring
        angleInRing = angle
        
        //Visual Stuff
        let mainImage = SKSpriteNode(texture: planetImage, size: self.size)
        self.addChild(mainImage)
        
        
        //Init self
        self.position = pos
        self.zPosition = 10
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.collisionBitMask = 0
        self.colorBlendFactor = 1.0
        parentRing.rotationLock.addChild(self)
        self.zRotation = angleInRing - CGFloat(M_PI/2)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.categoryBitMask = planetCategory
        self.physicsBody?.angularDamping = 0
        self.physicsBody?.linearDamping = 0
        
        
        
    }
    func panCamera(pos: CGPoint){ //Updates line length and cam position
        
        //Cam position & Line Length
        var length: CGFloat = 0
        var height = sqrt(pos.x*pos.x + pos.y*pos.y)
        height *= 2
        lineNode.size.height = height
        lineNode.position.y = (height/2) * -pos.y/abs(pos.y)
        
        if(pos.y == 0){cam.position.y = 0} //Catches a null pointer
        else{
            
            length = pos.y/maxLineLength //Get length out of a factor of 1
            
            let signHolder = length/abs(length) //Is it positive or negative
            length = abs(length) //Forces it into a positive number for the functions
            
            var newPosition: CGFloat!
            if(length > 0.5){//Parametric Equation
                camFather.position.y = -signHolder * maxCamOffset * (4 * length)/(3 * length + 1)
                
            }
            else{//Math!
                camFather.position.y = -signHolder * maxCamOffset * (8/5) * length
            }
        }
        
    }
    func setRotation(pos: CGPoint){ //Updates the rotation speed used in updatePlanet()
        
        //pos.x out of 0-2/3
        let input = (2 * pos.x)/(3*((global as! SKScene).size.width/2))
        if(abs(input) < 1/3) // if its too close to 0
        {rotationSpeed = 0}
        else if(input > 0){rotationSpeed = ((3*input - 1) / (-3*input + 3))/10}
        else{rotationSpeed = -((-3*input - 1) / (3*input + 3))/10}
        
        //Rotate the aiming line and do slingshot animation
        var angle: CGFloat = atan(pos.x/pos.y)
        if(pos.y == 0){angle = 0}
        rotationLock.zRotation = -angle
        if (pos.y > 0) // This is used in the shoot() function
            {angleBuffer = CGFloat(M_PI)}
        else{angleBuffer = 0}
        
    }
    func updatePlanet(){//updates the planet (called in the update function of GameScene)
        parentRing.rotationLock.zRotation += rotationSpeed
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func wakeUp(){//gets called on the first touch
        
        //cam.run(SKAction.sequence([SKAction.scale(to: 1.25, duration: 0.1),SKAction.scale(to: 1.50, duration: 0.15),SKAction.scale(to: 1.75, duration: 0.15),SKAction.scale(to: 2.0, duration: 0.2)]), withKey: "Zooming2")
        isAwake = true
        
    }
    func activate(){
        //If the last camera hasnt finished getting to the ship
        global.currentPlanet?.camFather.removeAction(forKey: "trajectory")
        
        
        //Main Init
        //ASDF(global as! SKScene).camera = cam
        global.currentPlanet = self
        parentRing.isActive = true
        isAwake = false
        
        if(global.currentShip != nil){
            //Camera stuff
            //Positional
            let localPos = (global as! SKScene).convert(global.currentShip.position, to: self)
            var action = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.7)
            action.timingMode = .easeInEaseOut
            camFather.position = localPos
            camFather.run(action)
            //Angular
            var globalAngle = parentRing.rotationLock.zRotation + angleInRing
            var camAngle = global.currentShip.cam.zRotation + global.currentShip.zRotation + CGFloat(M_PI/2)
            camFather.zRotation = camAngle - globalAngle
            action = SKAction.rotate(toAngle: 0, duration: 0.7, shortestUnitArc: true)
            action.timingMode = .easeInEaseOut
            camFather.run(action)
        }
    }
    func deactivate(){
        parentRing.isActive = false
        rotationSpeed = 0
        panCamera(pos: CGPoint(x: 0, y: 0))
        setRotation(pos: CGPoint(x: 0, y: 0))
    }
    func shoot(){
        //Make projectile calculations
        let pos = (global as! SKScene).convert(self.position, from: self.parent!)
        let angle = parentRing.rotationLock.zRotation + angleInRing + rotationLock.zRotation - CGFloat(M_PI/2) + angleBuffer
        let velocity = CGVector(dx: 2000*cos(angle + CGFloat(M_PI/2)), dy: 2000*sin(angle + CGFloat(M_PI/2)))
        _ = Ship(pos: pos, angle: angle, velocity: velocity, global: global, planet: self)
        
        //Camera stuff. The planet camera follows a predicted path, then global.camera = ship.cam
        
        /*(AASDFcamFather.run(SKAction.sequence([SKAction.move(to: (global as! SKScene).convert(CGPoint(x: pos.x + velocity.dx * 0.1, y: pos.y + velocity.dy * 0.1), to: self), duration: 0.1), SKAction.run {
            (self.global as! SKScene).camera = self.global.currentShip.cam
            }]), withKey: "trajectory")*/
        
        //Other important things
        rotationSpeed = 0.0
        lineNode.run(SKAction.resize(toHeight: 0, duration: 0.1))
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
}
