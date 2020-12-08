//: [Previous](@previous)

import Foundation

struct Device {
    var accumulator: Int = 0
    var pointer: Int = 0
    
    var operations: [Int: Op]
    var performedOperations = [Int: Op]()
    
    init(opList: [String]) {
        let indexes = Array(0...opList.count-1)
        let operations: [Op] = input.compactMap { opString in
            let opAndArg = opString.split(separator: " ").map({ String($0) })
            guard let op = opAndArg.first, let arg = opAndArg.last else {
                return nil
            }
            return Device.Op(op: op, arg: arg)
        }
        
        self.operations = Dictionary(uniqueKeysWithValues: zip(indexes, operations))
    }
    
    mutating func run(terminationStrategy: (_ pointer: Int, _ operations: [Int: Op], _ perfomedOperations: [Int: Op]) -> Bool) {
        pointer = 0
        accumulator = 0
        performedOperations = [:]
        while terminationStrategy(pointer, operations, performedOperations) {
            guard let op = operations[pointer] else { return }
            performedOperations[pointer] = op
            switch op {
            case let .acc(arg):
                self.accumulator += arg
                self.pointer += 1
            case let .jmp(arg):
                self.pointer += arg
            case .nop:
                self.pointer += 1
            }
        }
    }
    
    func errorCheck() -> (key: Int, value: Op)? {
        var (searchPointer, _) = findLastNegJump()!
        var safeDestinations = Array(searchPointer...operations.count-1)
        let start = searchPointer
        
        while searchPointer > 0 {
            searchPointer -= 1
            guard let op = operations[searchPointer] else { return nil }
            let opEntry = (searchPointer, op)
            if safeDestinations.contains(searchPointer) {
                continue
            } else if let nopToFix = checkOpForHitNop(opEntry: opEntry, ranges: safeDestinations) {
                return nopToFix
            } else if let jmp = checkOpForMissedJmp(opEntry: opEntry, ranges: safeDestinations) {
                if let previousJump = findFirstPreviousJmpMissed(ranges: safeDestinations, missed: jmp) {
                    if performedOperations.keys.contains(previousJump.key) {
                        return previousJump
                    } else {
                        safeDestinations.append(contentsOf: Array((previousJump.key+1...searchPointer)))
                        searchPointer = start
                    }
                }
            }
        }
        return nil
    }
    
    func findLastNegJump() -> (key: Int, value: Op)? {
        for opEntry in operations.sorted(by: {$0.key < $1.key}).reversed() {
            if case .jmp(let arg) = opEntry.value {
                if arg < 0 {
                    return opEntry
                }
            }
        }
        return nil
    }
    
    func checkOpForHitNop(opEntry: (key: Int, value: Op), ranges: [Int]) -> (key: Int, value: Op)? {
        let (index, op) = opEntry
        if !performedOperations.keys.contains(index) {
            return nil
        }
        if case .nop(let arg) = op {
            return ranges.contains(arg + index) ? opEntry : nil
        }
        return nil
    }
    
    func checkOpForMissedJmp(opEntry: (key: Int, value: Op), ranges: [Int]) -> (key: Int, value: Op)? {
        let (index, op) = opEntry
        if performedOperations.keys.contains(index) && !ranges.contains(index) {
            return nil
        }
        if case .jmp(let arg) = op {
            return ranges.contains(arg + index) ? opEntry : nil
        }
        return nil
        
    }
    
    func findFirstPreviousJmpMissed(ranges: [Int], missed: (key: Int, value: Op)) -> (key: Int, value: Op)? {
        let rangeToSearch: [Int] = Array(0...missed.key - 1).reversed()
        
        for index in rangeToSearch {
            let op = operations[index]
            if case .jmp = op, let op = op {
                return (key: index, value: op)
            }
        }
        return nil
    }

    enum Op: CustomStringConvertible {
        
        var description: String {
            switch self {
            case let .acc(arg):
                return "acc \(arg)"
            case let .jmp(arg):
                return "jmp \(arg)"
            case let .nop(arg):
                return "nop \(arg)"
            }
        }
        
        case acc(Int)
        case jmp(Int)
        case nop(Int)
        
        init?(op: String, arg: String) {
            guard let opKey = OpKey(rawValue: op), let argValue = Int(arg) else { return nil }
            switch opKey {
            case .acc:
                self = .acc(argValue)
            case .jmp:
                self = .jmp(argValue)
            case .nop:
                self = .nop(argValue)
            }
        }
        
        var argument: Int {
            switch self {
            case let .acc(arg):
                return arg
            case let .jmp(arg):
                return arg
            case let .nop(arg):
                return arg
            }
        }
        
        func swapped() -> Op {
            switch self {
            case .acc:
                return self
            case let .jmp(arg):
                return .nop(arg)
            case let .nop(arg):
                return .jmp(arg)
            }
        }
        
        enum OpKey: String {
            case acc
            case jmp
            case nop
        }
    }
}

let files = FileHandler.getInputs()
let path = files[0]
let inputString = try String(contentsOfFile: path)
let input = inputString.components(separatedBy: .newlines)

var device = Device(opList: input)
device.run { (pointer, _, performedOperations) -> Bool in
    !performedOperations.keys.contains(pointer)
}
print(device.accumulator)
if let error = device.errorCheck() {
    device.operations[error.key] = error.value.swapped()
    device.run { (pointer, operations, _) -> Bool in
        pointer <= operations.count
    }
    print(device.accumulator)
}

//: [Next](@next)
