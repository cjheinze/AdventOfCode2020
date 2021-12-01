//: [Previous](@previous)

import Foundation

enum Instruction {
    case north(Int)
    case south(Int)
    case east(Int)
    case west(Int)
    case left(Int)
    case right(Int)
    case forward(Int)
    
    init?(char: Character, value: Int) {
        guard let key = Key(rawValue: char) else {
            return nil
        }
        switch key {
        case .north:
            self = .north(value)
        case .south:
            self = .south(value)
        case .east:
            self = .east(value)
        case .west:
            self = .west(value)
        case .left:
            self = .left(value)
        case .right:
            self = .right(value)
        case .forward:
            self = .forward(value)
        }
        
    }
    
    enum Key: Character {
        case north = "N"
        case south = "S"
        case east = "E"
        case west = "W"
        case left = "L"
        case right = "R"
        case forward = "F"
    }
}

enum Direction: Int {
    case north = 0, west = 270, south = 180, east = 90
    
    func rotateLeftBy(degrees: Int) -> Direction {
        print(self, degrees)
        var target = (self.rawValue - degrees) % 360
        print("Pre Target ------- \(target)")
        if target < 0 {
            target = 360 + target
        }
        print("Target ------- \(target)")
        return Direction.init(rawValue: target)!
    }
    
    func rotateRightBy(degrees: Int) -> Direction {
        let target = (self.rawValue + degrees) % 360
        return Direction.init(rawValue: target)!
    }
}

struct Ship {
    var direction: Direction = .east
    var northSouthDistance: Int = 0
    var eastWestDistance: Int = 0
    var waypoint = Waypoint()
    
    struct Waypoint {
        var northSouthUnits: Int = 1
        var eastWestUnits: Int = 10
        
        mutating func rotate(degrees: Int, clockwise: Bool) {
            let oldNS = northSouthUnits
            let oldEW = eastWestUnits

            switch (degrees, clockwise) {
            case (90, true), (270, false):
                northSouthUnits = -oldEW
                eastWestUnits = oldNS
            case (180, _):
                northSouthUnits = -oldNS
                eastWestUnits = -oldEW
            case (270, true), (90, false):
                northSouthUnits = oldEW
                eastWestUnits = -oldNS
            default:
                break
            }
        }
        
        mutating func update(_ instruction: Instruction) {
            switch instruction {
            case let .north(distance):
                northSouthUnits += distance
            case let .south(distance):
                northSouthUnits -= distance
            case let .east(distance):
                eastWestUnits += distance
            case let .west(distance):
                eastWestUnits -= distance
            case let .left(degrees):
                rotate(degrees: degrees, clockwise: false)
            case let .right(degrees):
                rotate(degrees: degrees, clockwise: true)
            case .forward(_):
                break
            }
        }
        
    }
    
    mutating func execute(_ instruction: Instruction) {
        switch instruction {
        case let .north(distance):
            northSouthDistance += distance
        case let .south(distance):
            northSouthDistance -= distance
        case let .east(distance):
            eastWestDistance += distance
        case let .west(distance):
            eastWestDistance -= distance
        case let .left(degrees):
            self.direction = direction.rotateLeftBy(degrees: degrees)
        case let .right(degrees):
            self.direction = direction.rotateRightBy(degrees: degrees)
        case let .forward(distance):
            switch direction {
            case .north:
                northSouthDistance += distance
            case .west:
                eastWestDistance -= distance
            case .south:
                northSouthDistance -= distance
            case .east:
                eastWestDistance += distance
            }
        }
    }
    
    mutating func executeUsingWaypoint(_ instruction: Instruction) {
        switch instruction {
        case let .forward(times):
            self.northSouthDistance += (waypoint.northSouthUnits * times)
            self.eastWestDistance += (waypoint.eastWestUnits * times)
        default:
            waypoint.update(instruction)
        }
    }
}

let files = FileHandler.getInputs()
let path = files[0]
let inputString = try String(contentsOfFile: path)
var input = inputString.components(separatedBy: .newlines).filter({ !$0.isEmpty })

let instructions = input.compactMap { string -> Instruction? in
    let direction = string[0]
    let distance = Int(string.dropFirst())!
    
    return Instruction(char: direction, value: distance)
}

var ship1 = Ship()
instructions.forEach {
    ship1.execute($0)
}
print(ship1.northSouthDistance, ship1.eastWestDistance)
print(abs(ship1.northSouthDistance) + abs(ship1.eastWestDistance))

var ship2 = Ship()
instructions.forEach {
    ship2.executeUsingWaypoint($0)
}
print(ship2.northSouthDistance, ship2.eastWestDistance)
print(abs(ship2.northSouthDistance) + abs(ship2.eastWestDistance))


//: [Next](@next)
