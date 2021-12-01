//: [Previous](@previous)

import Foundation

let files = FileHandler.getInputs()
let path = files[0]
let inputString = try String(contentsOfFile: path)
var input = inputString.components(separatedBy: .newlines).filter({ !$0.isEmpty })
let timestamp = Int(input.first!)!
let buslines = input.last!.split(separator: ",").filter({ $0 != "x" }).compactMap({ Int($0) })

let departures = buslines.reduce(into: [Int: Array<Int>]()) { result, line in
    result[line] = Array(stride(from: 0, through: timestamp * 2, by: line))
}

var busline = 0
var closestTimestamp = Int.max
//
//departures.forEach { (line, departures) in
//    let closest = departures.enumerated().filter({ $0.1 >= timestamp }).min { abs($0.1 - timestamp) < abs($1.1 - timestamp) }
//    if let closest = closest, closest.element < closestTimestamp {
//        busline = line
//        closestTimestamp = closest.element
//    }
//}

print(busline, closestTimestamp, closestTimestamp-timestamp, (closestTimestamp-timestamp) * busline)

// Knuth's modular inverse
func modInv(value: Int, modulus: Int) -> Int? {
    var inv = 1, gcd = value, v1 = 0, v3 = modulus
    var even = true
    while v3 != 0 {
        (inv, v1, gcd, v3) = (v1, inv + gcd / v3 * v1, v3, gcd % v3)
        even.toggle()
    }
    if gcd != 1 { return nil }
    return even ? inv : modulus - inv
}

func chineseRemainder(_ mas: [(Int, Int)]) -> Int {
    let m = mas.lazy.map(\.0).reduce(1, *)
    let was = mas.map { (mi, ai) -> (Int, Int) in
        let zi = m / mi
        guard let yi = modInv(value: zi, modulus: mi) else { fatalError("\(zi)^-1 mod \(mi) does not exist!") }
        return ((yi * zi) % m, ai)
    }
    return was.reduce(0, { ($0 + ($1.0 * $1.1)) % m })
}

let indexedBuslines: [(Int, Int)] = input.last!.split(separator: ",").enumerated().compactMap {
    guard let line = Int($1) else { return nil }
    return (line, $0)
}.map { (m, v: Int) in
    (m, (-v).mod(m))
}

let time = chineseRemainder(indexedBuslines)
print(time)


//: [Next](@next)
