//: [Previous](@previous)

import Foundation

let files = FileHandler.getInputs()
let path = files[0]
let inputString = try String(contentsOfFile: path)
let input = inputString.components(separatedBy: .whitespacesAndNewlines).split(separator: "").map({ Array($0) })

let sumPart1 = input.reduce(0, { result, group in
    return group.reduce(Set<Character>()) { (set, value) in
        set.union(value)
    }.count + result
})
print(sumPart1)

let sumPart2 = input.reduce(0, { result, group in
    return group.reduce(Set<Character>(group.first!)) { (set, value) in
        set.intersection(value)
    }.count + result
})
print(sumPart2)
//: [Next](@next)
