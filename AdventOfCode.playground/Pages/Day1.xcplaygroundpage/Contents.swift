//: [Previous](@previous)

import Foundation

let files = FileHandler.getInputs()
let path = files[0]
let inputString = try String(contentsOfFile: path)
let input = inputString.split(separator: "\n").map { Int($0)! }

let now1 = Date()
outerloop: for (i,x) in input.enumerated() {
    for y in input[i+1 ..< input.count] {
        for z in input[i+2 ..< input.count] {
            if x+y+z == 2020 {
                print(x,y,z, x*y*z)
                print("Time 1:", Date().timeIntervalSince(now1))
                break outerloop
            }
        }
    }
}

let now2 = Date()
outerloop: for (i,x) in input.enumerated() {
    jloop: for (j,y) in input.enumerated() {
        if (j >= i) { break jloop }
        kloop:for (k,z) in input.enumerated() {
            if k >= j { break kloop }
            if x+y+z == 2020 {
                print(x,y,z, x*y*z)
                print("Time 2:", Date().timeIntervalSince(now2))
                break outerloop
            }
        }
    }
}

//: [Next](@next)
