import UIKit
import SpriteKit
import Foundation


class System: SKNode {
    
    //The GameScene being used (Can also be selection scene)
        var global: LevelProtocol!
    //Rotation Parent-Node
        var rotationLock = SKNode()
    //The array of rings
        var rings = Array<Ring>()
    //Used in addRing() to stack distances
        var totalRingDistance: CGFloat = 0
    
    init(color: Int, scene: LevelProtocol, pos: CGPoint, offset: CGPoint) {

        //Main initializer
        super.init()
        
        //Init local variables
        global = scene
        self.addChild(rotationLock)
        
        //Init self
        self.position.x = pos.x + offset.x
        self.position.y = pos.y + offset.y
        self.zPosition = 10
        global.gameWorld.addChild(self)
        global.systems.append(self)
        
        //Init hubPlanet
        addRing(color: color, count: 1, distance: 0, speed: 0)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func addRing(color: Int, count: Int, distance: CGFloat, speed: Int){
        totalRingDistance += distance
        let newRing = Ring(color: color, count: count, distance: totalRingDistance, speed: speed, scene: global, system: self)
        rings.append(newRing)
        
    }
}
