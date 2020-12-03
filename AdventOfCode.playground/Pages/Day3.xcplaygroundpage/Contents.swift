//: [Previous](@previous)

import Foundation

enum MapSquare: Character {
    case tree = "#"
    case ground = "."
}

let files = FileHandler.getInputs()
let path = files[0]
let inputString = try String(contentsOfFile: path)
let inputRows = inputString.split(separator: "\n").map { Array($0) }

let result1 = findTrees(input: inputRows, rowAndColumnDelta: (1,1))
let result2 = findTrees(input: inputRows, rowAndColumnDelta: (1,3))
let result3 = findTrees(input: inputRows, rowAndColumnDelta: (1,5))
let result4 = findTrees(input: inputRows, rowAndColumnDelta: (1,7))
let result5 = findTrees(input: inputRows, rowAndColumnDelta: (2,1))

let final = result1 * result2 * result3 * result4 * result5

func findTrees(input: [[Character]], rowAndColumnDelta: (Int, Int)) -> Int {
    var treeCounter = 0
    var currentColumn = 0
    for rowIndex in stride(from: 0, to: input.count, by: rowAndColumnDelta.0) {
        let row = input[rowIndex]
        currentColumn = (currentColumn + rowAndColumnDelta.1) % row.count
        let square = MapSquare(rawValue: row[currentColumn])
        if let square = square {
            switch square {
            case .tree:
                treeCounter += 1
            case .ground: break
            }
        }
    }
    return treeCounter
}


//: [Next](@next)
