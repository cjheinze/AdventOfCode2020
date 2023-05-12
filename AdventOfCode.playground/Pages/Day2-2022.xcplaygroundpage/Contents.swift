//: [Previous](@previous)

import Foundation

enum Result: String {
    case lose = "X"
    case draw = "Y"
    case win = "Z"
    
    func getScore() -> Int {
        switch self {
        case .lose:
            return 0
        case .draw:
            return 3
        case .win:
            return 6
        }
    }
}

enum Move {
    case rock
    case paper
    case scissors

    static func initFromCode(code: String) -> Move? {
        switch code {
        case "A", "X":
            return .rock
        case "B", "Y":
            return .paper
        case "C", "Z":
            return .scissors
        default:
            return nil
        }
    }
    
    func getValue() -> Int {
        switch self {
        case .rock:
            return 1
        case .paper:
            return 2
        case .scissors:
            return 3
        }
    }
    
    func getMoveFromResult(result: Result) -> Move? {
        switch result {
        case .lose:
            return self.getBeatingMove()
        case .draw:
            return self
        case .win:
            return self.getWinningMove()
        default:
            return nil
        }
    }
    
    func getWinningMove() -> Move {
        switch self {
        case .rock:
            return .paper
        case .paper:
            return .scissors
        case .scissors:
            return .rock
        }
    }
    
    func getBeatingMove() -> Move {
        switch self {
        case .rock:
            return .scissors
        case .paper:
            return .rock
        case .scissors:
            return .paper
        }
    }

    
    func beats(move: Move) -> Bool {
        switch (self, move) {
        case (.rock, .scissors): return true
        case (.paper, .rock): return true
        case (.scissors, .paper): return true
        default: return false
        }
    }
    
    func scoreAgainst(move: Move) -> Int {
        if self.beats(move: move) {
            return 6
        } else if self == move {
            return 3
        } else {
            return 0
        }
    }
}

let files = FileHandler.getInputs()
let path = files[0]
let inputString = try String(contentsOfFile: path)
    .split(separator: "\n")
let inputData1 = inputString
    .map({ $0.split(separator: " ").map({ Move.initFromCode(code: String($0))! }) })
    .compactMap({ gameArray in
        (gameArray[0], gameArray[1])
    })
var result1 = inputData1.reduce(0) { partialResult, game in
    let (opponentMove, myMove) = game
    return partialResult + myMove.scoreAgainst(move: opponentMove) + myMove.getValue()
}

let inputData2 = inputString
    .map({ $0.split(separator: " ") })
    .map({ (Move.initFromCode(code: String($0[0]))!, Result(rawValue: String($0[1]))!) })

let result2 = inputData2.reduce(0) { partialResult, game in
    let (opponentMove, result) = game
    let myMove = opponentMove.getMoveFromResult(result: result)!
    print(game, myMove, myMove.getValue(), result.getScore())
    return partialResult + myMove.getValue() + result.getScore()
}
    
//: [Next](@next)
