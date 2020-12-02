//: [Previous](@previous)

import Foundation

struct Password {
    let range: ClosedRange<Int>
    let character: Character
    let password: String
}

let files = FileHandler.getInputs()
let path = files[0]
let inputString = try String(contentsOfFile: path)
let inputRows = inputString.split(separator: "\n")
let input = inputRows.map {
    $0.split(separator: " ")
}

let passwords = input.map { (inputRow) -> Password in
    let rangeString = inputRow[0]
    let characterString = inputRow[1]
    let passwordString = inputRow[2]
    
    let rangeBound = rangeString.split(separator: "-").map { Int($0)! }
    let range = rangeBound[0]...rangeBound[1]
    
    return Password(range: range, character: characterString.first!, password: String(passwordString))
}

let validPasswords1 = passwords.filter(passwordValidityPart1)
let validPasswords2 = passwords.filter(passwordValidityPart2)
print(validPasswords1.count)
print(validPasswords2.count)

func passwordValidityPart1(password: Password) -> Bool {
    let character = password.character
    let range = password.range
    let passwordString = password.password
    
    let characterCount = passwordString.filter { $0 == character }.count
    return range.contains(characterCount)
}

func passwordValidityPart2(password: Password) -> Bool {
    let character = password.character
    let lowerBound = password.range.lowerBound - 1
    let upperBound = password.range.upperBound - 1
    let passwordString = password.password
    return (passwordString[lowerBound] == character) != (passwordString[upperBound] == character)
}

//: [Next](@next)
