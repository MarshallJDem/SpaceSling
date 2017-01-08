import UIKit
import SpriteKit
import Foundation


class Ring: SKNode {
    
    //Image/Color Changing
        var colorType: UIColor!
    //The GameScene being used (Can also be selection scene)
        var global: LevelProtocol!
    //Rotation Parent-Node
        var rotationLock = SKNode()
    //Node for the visual ring
        var circle: SKShapeNode!
    //The parent system
        var parentSystem: System!
    //The array of planets
        var planets = Array<Planet>()
    //Whether or not the currentPlanet is within this ring
        var isActive = false
    
    init(color: Int, count: Int, distance: CGFloat, speed: Int, scene: LevelProtocol, system: System) {
        
        //Figure out color type and image
        switch color{
        case 1:
            colorType = UIColor.red
        case 2:
            colorType = UIColor.orange
        case 3:
            colorType = UIColor.blue
        default:
            colorType = UIColor.white
            break
        }
        
        //Main initializer
        super.init()
        
        //Init local variables
        global = scene
        self.addChild(rotationLock)
        parentSystem = system
        
        //Visual Stuff
        drawOrbit(distance: distance)
        
        //Init self
        self.zPosition = 10
        parentSystem.addChild(self)
    
        //Add planets
        var planetPos = CGPoint(x: 0, y: 0)
        let subsection = CGFloat(2 * CGFloat(M_PI) / CGFloat(count))
        for i in 0...(count - 1) {
            planetPos = CGPoint(x: distance * cos(subsection * CGFloat(i)), y: distance * sin(subsection * CGFloat(i)))
            let newPlanet = Planet(color: color, scene: global, pos: planetPos, ring: self, angle: subsection * CGFloat(i))
         //   newPlanet.zRotation = subsection * CGFloat(i)
            planets.append(newPlanet)
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func drawOrbit(distance: CGFloat){
        circle = SKShapeNode(circleOfRadius: distance ) // Size of Circle
        circle.position = CGPoint(x: 0, y: 0)  //Middle of Screen
        circle.strokeColor = UIColor.white
        circle.glowWidth = 1.0
        circle.fillColor = UIColor.clear
        self.addChild(circle)
    }
    
}
