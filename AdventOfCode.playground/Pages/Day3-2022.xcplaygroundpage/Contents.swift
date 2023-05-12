//: [Previous](@previous)

import Foundation

let files = FileHandler.getInputs()
let path = files[0]
let inputString = try String(contentsOfFile: path)
    .split(separator: "\n")
let splitInputString = inputString.map { contents in
    let halflength = contents.count / 2
    let (first, second) = (contents.dropLast(halflength), contents.dropFirst(halflength))
    print(contents, contents.count, first, first.count, second, second.count)
    return (first, second)
}

let splitInputString2 = inputString.chunked(into: 3)

var letterToValueMap: [Character: Int] = [:]

(65...90).forEach({ value in
    let char = Character(UnicodeScalar(value)!)
    letterToValueMap[char] = value - 38
})

(97...122).forEach({ value in
    let char = Character(UnicodeScalar(value)!)
    letterToValueMap[char] = value - 96
})

let commonItems = splitInputString.compactMap { (first, second) in
    let common = Set(String(first)).intersection(String(second))
    print(common)
    return common.first
}

let result = commonItems.reduce(0) { partialResult, char in
    partialResult + letterToValueMap[char]!
}

let commonItems2 = splitInputString2.compactMap { items in
    var commonSet = Set(String(items.first!))
    items.forEach { subStr in
        commonSet = commonSet.intersection(String(subStr))
    }
    return commonSet.first!
}

let result2 = commonItems2.reduce(0) { partialResult, char in
    partialResult + letterToValueMap[char]!
}

//: [Next](@next)
