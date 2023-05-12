//: [Previous](@previous)

import Foundation

let files = FileHandler.getInputs()
let path = files[0]
let inputString = try String(contentsOfFile: path)
let input = inputString
    .split(separator: "\n\n")
    .map({ $0.split(separator: "\n")
            .map({ Int($0)! })
            .reduce(0, +)
    })
print(input.max()!)
input.sorted(by: >)[0...2].reduce(0, +)

//: [Next](@next)
