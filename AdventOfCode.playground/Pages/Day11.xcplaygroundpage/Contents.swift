//: [Previous](@previous)

import UIKit
import PlaygroundSupport

struct Map {
    
    var seats: [[Seat]]
    var width: Int
    var height: Int
    
    var finalState = false
    
    init(input: [String]) {
        seats = input.enumerated().map { (x, row) in
            return row.enumerated().compactMap { (y, seat) -> Map.Seat? in
                guard let seatState = SeatState(rawValue: seat) else { return nil }
                return Seat(x: x, y: y, state: seatState)
            }
        }
        height = seats.count
        width = seats.first?.count ?? 0
    }
    
    mutating func start() -> Int {
        var updates = -1
        
        while updates != 0 {
            var updatedSeats = seats
            updates = 0
            var lock = os_unfair_lock_s()
            
            DispatchQueue.concurrentPerform(iterations: seats.count) { (x) in
                let row = seats[x]
                DispatchQueue.concurrentPerform(iterations: row.count) { (y) in
                    let seat = row[y]
                    let count = getOccupiedNeighborsInDirectionCount(seat)
                    switch (seat.state, count) {
                    case (.empty, 0), (.occupied, 5...):
                        os_unfair_lock_lock(&lock)
                        updatedSeats[x][y] = seat.flipped()
                        updates += 1
                        os_unfair_lock_unlock(&lock)
                    default:
                        break
                    }
                }
            }
            
            print("Updates: ", updates)
            seats = updatedSeats
        }
        
        return seats.reduce(0) { (count: Int, row) in
            return count + row.filter({$0.state == .occupied}).count
        }
    }
    
//    static func memoize<Input: Hashable, Output>(_ function: @escaping (Input) -> Output) -> (Input) -> Output {
//        // our item cache
//        var storage = [Input: Output]()
//
//        // send back a new closure that does our calculation
//        return { input in
//            if let cached = storage[input] {
//                return cached
//            }
//
//            let result = function(input)
//            storage[input] = result
//            return result
//        }
//    }
//
//    func getOccupiedNeighborsToSeat(_ seat: Seat) -> [Seat] {
//        var occupiedNeighbors = [Seat]()
//        memoizedNeighbors!(seat).forEach { (seat) in
//            let updatedSeat = seats[seat.x][seat.y]
//            if (updatedSeat.state == .occupied) {
//                occupiedNeighbors.append(updatedSeat)
//            }
//        }
//        return occupiedNeighbors
//    }
//
//    func getNeighborsToSeat(_ seat: Seat) -> [Seat] {
//        var neighbors = [Seat]()
//        let x = seat.x
//        let y = seat.y
//        let xRange = (x-1...x+1).clamped(to: 0...height-1)
//        let yRange = (y-1...y+1).clamped(to: 0...width-1)
//        for xR in xRange {
//            for yR in yRange {
//                if (x == xR && y == yR) {
//                    continue
//                }
//                neighbors.append(seats[xR][yR])
//            }
//        }
//        return neighbors
//    }
    
    func getOccupiedNeighborsCount(_ seat: Seat) -> Int {
        var count = 0
        let x = seat.x
        let y = seat.y
        let xRange = (x-1...x+1).clamped(to: 0...height-1)
        let yRange = (y-1...y+1).clamped(to: 0...width-1)
        for xR in xRange {
            for yR in yRange {
                if (x == xR && y == yR) {
                    continue
                }
                if seats[xR][yR].state == .occupied {
                    count += 1
                }
            }
            
        }
        return count
    }
    
    func getOccupiedNeighborsInDirectionCount(_ seat: Seat) -> Int {
        var count = 0
        let x = seat.x
        let y = seat.y
        for i in -1...1 {
            for j in -1...1 {
                if (i == 0 && j == 0) {
                    continue
                }
                
                let firstNeighbor = getFirstSeatNeighborInDirection(x: x, y: y, xDiff: i, yDiff: j)
                count += (firstNeighbor?.state == .occupied) == true ? 1 : 0
                
            }
            
        }
        return count
    }
    
    func getFirstSeatNeighborInDirection(x: Int, y: Int, xDiff: Int, yDiff: Int) -> Seat? {
        if (0...height-1).contains(x+xDiff) && (0...width-1).contains(y+yDiff) {
            let seat = seats[x+xDiff][y+yDiff]
            switch seat.state {
            case .occupied, .empty:
                return seat
            case .floor:
                return getFirstSeatNeighborInDirection(x: x+xDiff, y: y+yDiff, xDiff: xDiff, yDiff: yDiff)
            }
        } else {
            return nil
        }
    }
    
    struct Seat: Hashable {
        let x: Int
        let y: Int
        var state: SeatState
        
        func isNeighborToSeat(_ seat: Seat) -> Bool {
            let xDelta = abs(self.x - seat.x)
            let yDelta = abs(self.y - seat.y)
            
            switch (xDelta, yDelta) {
            case (0, 1), (1, 0), (1, 1):
                return true
            default:
                return false
            }
        }
        
        func flipped() -> Seat {
            switch self.state {
            case .empty:
                return Seat(x: x, y: y, state: .occupied)
            case .occupied:
                return Seat(x: x, y: y, state: .empty)
            default:
                return self
            }
        }
        
        func getColor() -> UIColor {
            switch state {
            case .empty:
                return .systemGreen
            case .occupied:
                return .systemRed
            case .floor:
                return .black
            }
        }
    }
    
    enum SeatState: Character {
        case empty = "L"
        case occupied = "#"
        case floor = "."
    }
    
    class MapView: UIView {
        var map: Map
        static let seatWidth = 4
        static let seatHeight = 8
        
        override init(frame: CGRect) {
            self.map = Map(input: [])
            super.init(frame: frame)
        }
        
        convenience init(map: Map) {
            let frame = CGRect(x: 0, y: 0, width: map.width * Self.seatWidth, height: map.height * Self.seatHeight)
            self.init(frame: frame)
            self.map = map
        }
        
        required init?(coder: NSCoder) {
            map = Map(input: [])
            super.init(coder: coder)
        }
        
        func run() {
            let result = map.start()
            print(result)
            setNeedsLayout()
        }
        
        override func draw(_ rect: CGRect) {
            let context = UIGraphicsGetCurrentContext()
            context?.saveGState()
            for row in map.seats {
                for seat in row {
                    let newRect = CGRect(x: seat.x * Map.MapView.seatWidth, y: seat.y * Map.MapView.seatHeight, width: Map.MapView.seatWidth, height: Map.MapView.seatHeight)
                    let color = seat.getColor()
                    context?.addRect(newRect)
                    context?.setFillColor(color.cgColor)
                    context?.fill(newRect)
                }
            }
            context?.restoreGState()
        }
    }
}

let files = FileHandler.getInputs()
let path = files[0]
let inputString = try String(contentsOfFile: path)
var input = inputString.components(separatedBy: .newlines).filter({ !$0.isEmpty })
let map = Map(input: input)
print(map.seats.count)
let mapView = Map.MapView(map: map)
PlaygroundPage.current.liveView = mapView
mapView.setNeedsDisplay()
mapView.run()

//: [Next](@next)
