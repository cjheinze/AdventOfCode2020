//: [Previous](@previous)

import Foundation

let files = FileHandler.getInputs()
let path = files[0]
let inputString = try String(contentsOfFile: path)
var input = inputString.components(separatedBy: .newlines).filter({ !$0.isEmpty })

enum Program: CustomStringConvertible {
    var description: String {
        switch self {
        case let .mask(value):
            return "Mask \(value)"
        case let .store(address, value):
            return "\(address) = \(value)"
        }
    }
    
    case mask(String)
    case store(Int, Int)
    
}

let commands = try input.map { line -> Program in
    let lineComponents = line.components(separatedBy: " = ")
    let command = lineComponents[0]
    let value = lineComponents[1]
    switch command {
    case "mask":
        return Program.mask(value)
    default:
        let pattern = #"^mem\[(\d+)\]"#
        let regexp = try NSRegularExpression(pattern: pattern, options: [])
        let match = regexp.firstMatch(in: command, options: [], range: NSRange(location: 0, length: command.count))!
        if let matchRange = Range(match.range(at: 1), in: command), let value = Int(value), let address = Int(command[matchRange]) {
            return Program.store(address, value)
        } else {
            throw fatalError()
        }
    }
}

print(commands)



//: [Next](@next)
