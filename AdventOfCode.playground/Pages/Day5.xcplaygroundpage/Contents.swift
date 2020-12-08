//: [Previous](@previous)

import Foundation

enum RowPart: Character {
    case F = "F"
    case B = "B"
}

enum Column: Character {
    case L = "L"
    case R = "R"
}

struct Airplane {

}

let files = FileHandler.getInputs()
let path = files[0]
let inputString = try String(contentsOfFile: path)
let input: [String] = inputString.components(separatedBy: .whitespacesAndNewlines).dropLast()
let inputCount = input.count

findMissingSeats(bPasses: input)

func highestSeatId(boardingPasses: [String]) -> Int? {
    return boardingPasses.map({ findSeatFromBoardingPass(bPass: $0) }).max()
}

func findMissingSeats(bPasses: [String]) {
    let seatIds = bPasses.map({ findSeatFromBoardingPass(bPass: $0) }).sorted()
    let sum = seatIds.reduce(0, +)
    let correctSum = (seatIds.min()!...seatIds.max()!).reduce(0, +)
    print("Seat is \(correctSum - sum)")
//    var min = 0
//    var max = seatIds.count - 1
//    var middle = (max + min) / 2
//    while (max - min) > 1 {
//        middle = (max + min) / 2
//        if sectionHasMissingSeat(section: seatIds, min: min, max: middle) {
//            max = middle
//        } else if sectionHasMissingSeat(section: seatIds, min: middle, max: max) {
//            min = middle
//        }
//    }
//    print("Seat is between \(seatIds[min]) and \(seatIds[max])")
//    print("Seat is \(seatIds[min] + 1)")
}

func sectionHasMissingSeat(section: [Int], min: Int, max: Int) -> Bool {
    print(section[min...max])
    let count = section[min...max].count
    let diff = section[max] - section[min]
    print(count, diff, (count - diff) != 1)
    return (count - diff) != 1
}

func findSeatFromBoardingPass(bPass: String) -> Int {
    let rowPart = bPass.dropLast(3).compactMap({ RowPart(rawValue: $0) })
    let columnPart = bPass.dropFirst(4).compactMap({ Column(rawValue: $0) })
    var firstPossibleRow = 0
    var lastPossibleRow = 127
    var rowRange = 0...127

    for char in rowPart {
        let middleRow = Int(floor(Double(firstPossibleRow + lastPossibleRow) / 2.0))
        switch char {
        case .F:
            lastPossibleRow = middleRow
            rowRange = firstPossibleRow...middleRow
        case .B:
            firstPossibleRow = middleRow + 1
            rowRange = middleRow+1...lastPossibleRow
        }
    }
    
    guard rowRange.count == 1, let finalRow = rowRange.first else {
        print(firstPossibleRow, lastPossibleRow, rowRange, bPass)
        return -1
    }
    
    var firstPossibleColumn = 0
    var lastPossibleColumn = 7
    var columnRange = 0...7
    for char in columnPart {
        let middleColumn = Int(floor(Double(firstPossibleColumn + lastPossibleColumn) / 2.0))
        switch char {
        case .L:
            lastPossibleColumn = middleColumn
            columnRange = firstPossibleColumn...lastPossibleColumn
        case .R:
            firstPossibleColumn = middleColumn + 1
            columnRange = middleColumn + 1...lastPossibleColumn
        }
    }
    
    guard columnRange.count == 1, let finalColumn = columnRange.first else { return -1 }
    
    return finalRow * 8 + finalColumn
}


//: [Next](@next)
