//: [Previous](@previous)

import Foundation

let files = FileHandler.getInputs()
let path = files[0]
let inputString = try String(contentsOfFile: path)
var input = inputString.components(separatedBy: .newlines).filter({ !$0.isEmpty }).compactMap({ Int($0) }).sorted()
var input1 = input
input1.insert(0, at: 0)
input1.append(input.last! + 3)

func getResultPart1(_ input: [Int]) -> Int {
    let values = (input + [0, input.last! + 3]).sorted()
    let differences = zip(values.dropFirst(), values).map(-)
    return differences.filter({$0 == 3}).count * differences.filter({$0 == 1}).count
}

func getResultPart2(_ input: [Int]) -> Int {
    let result = input.reduce(into: [0: 1]) { (res, joltage) in
        let minus1 = res[joltage - 1] ?? 0
        let minus2 = res[joltage - 2] ?? 0
        let minus3 = res[joltage - 3] ?? 0
        res[joltage] = minus1 + minus2 + minus3
    }
    return result[input.last!]!
}

print(getResultPart1(input))
print(getResultPart2(input))

//: [Next](@next)

