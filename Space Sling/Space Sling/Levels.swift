import UIKit
import SpriteKit
import Foundation


func loadLevel(level: Int, offset: CGPoint, scene: LevelProtocol){
    switch level {
    case 0:
        var system = System(color: 2, scene: scene, pos: CGPoint(x: 0, y: 0), offset: offset)
        system.addRing(color: 1, count: 4, distance: 300, speed: 2)
        system.addRing(color: 3, count: 4, distance: 300, speed: 2)
        system.rings[1].planets[1].activate()
        
        system = System(color: 3, scene: scene, pos: CGPoint(x: 300, y: -700), offset: offset)
        system.addRing(color: 2, count: 3, distance: 300, speed: 2)
        system.addRing(color: 1, count: 6, distance: 300, speed: 1)
        
        system = System(color: 1, scene: scene, pos: CGPoint(x: -300, y: 1100), offset: offset)
        system.addRing(color: 1, count: 6, distance: 300, speed: 4)
        system.addRing(color: 3, count: 4, distance: 100, speed: 2)
        
        break;
    case 1:
        break;
    default:
        print("Level Doesn't Exist")
        break;
    }
}
