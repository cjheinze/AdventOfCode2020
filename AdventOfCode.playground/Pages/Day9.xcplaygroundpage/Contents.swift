//: [Previous](@previous)

import Foundation

let files = FileHandler.getInputs()
let path = files[0]
let inputString = try String(contentsOfFile: path)
let input = inputString.components(separatedBy: .newlines).filter({ !$0.isEmpty }).compactMap({ Int($0) })

let (index,value) = findIndexAndValueWithoutPair(input: input)
if let (min, max) = findRangeOfValuesThatSumToValue(input: input, target: value, targetIndex: index) {
    print(min, max, min+max)
}

func findIndexAndValueWithoutPair(input: [Int]) -> (Int, Int) {
    for index in input.indices[input.startIndex+25..<input.endIndex] {
        let value = input[index]
        
        if !findIfValueIsPartOfSumInSlice(value, input[index-25..<index]) {
            return (index,value)
        }
    }
    
    return (0,0)
}

func findSumOfValuesInSlice(_ slice: ArraySlice<Int>, previousSum: Int = 0) -> Int {
    return slice.reduce(previousSum, +)
}

func findRangeOfValuesThatSumToValue(input: [Int], target: Int, targetIndex: Int) -> (min: Int, max: Int)? {
    for startIndex in input.indices[..<targetIndex] {
        for index in input.indices[startIndex+1..<targetIndex] {
            let sum = findSumOfValuesInSlice(input[startIndex..<index])
            if sum == target {
                let slice = input[startIndex..<index]
                print("Range:", slice)
                return (slice.min()!, slice.max()!)
            }
        }
    }
    return nil
}

func findIfValueIsPartOfSumInSlice(_ value: Int,_ slice: ArraySlice<Int>) -> Bool {
    let subtractedSliceSet = Set(slice.compactMap( { value - $0 == $0 ? nil : value - $0 })).filter({$0 > 0})
    let sliceSet = Set(slice)
    let matches = sliceSet.intersection(subtractedSliceSet)
    return !matches.isEmpty
}

//: [Next](@next)
