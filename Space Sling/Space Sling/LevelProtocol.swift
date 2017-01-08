import UIKit
import SpriteKit
import Foundation

protocol LevelProtocol: class {
    
    var gameWorld: SKSpriteNode { get }
    var currentPlanet: Planet! { get set }
    var currentShip: Ship! { get set }
    var systems: Array<System> { get set }
    
}
