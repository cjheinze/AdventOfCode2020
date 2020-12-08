//: [Previous](@previous)

import Foundation

struct Bag: Hashable {
    static func == (lhs: Bag, rhs: Bag) -> Bool {
        return lhs.description == rhs.description
    }
    
    let description: String
    var contents: [String: Int]
}

enum BagEnum {
    case bag(String, Int)
}

let files = FileHandler.getInputs()
let path = files[0]
let inputString = try String(contentsOfFile: path)
let input = inputString.components(separatedBy: .newlines)
    .filter({ !$0.contains("no other bags") })
    .map({ $0.components(separatedBy: " bags contain ")}).dropLast(1)

let bags: [Bag] = input.map({ rule in
    let superBag = rule.first!
    let containingBags = rule[1].components(separatedBy: ", ").map({
        $0.split(separator: " ")
    })
    let contents = containingBags.reduce(into: [String: Int](), { (result, bag) in
        let bagCount = Int(String(bag[0]))!
        let description = bag[1...2].joined(separator: " ")
        result[description] = bagCount
    })
    return Bag(description: superBag, contents: contents)
})

print(bags)

func searchPart1(bagColor: String, bags: [Bag]) -> Set<String> {
    guard let bag = bags.first(where: ({ $0.description == bagColor })) else { return Set() }
    return bag.contents.reduce(into: Set<String>(), { (result, contents) in
        result.insert(contents.key)
        result.formUnion(searchPart1(bagColor: contents.key, bags: bags))
    })
}

searchPart1(bagColor: "shiny gold", bags: bags)

func searchPart2(bagColor: String, bags: [Bag]) -> Int {
    guard let bag = bags.first(where: { $0.description == bagColor }) else { return 0 }
    var n = 0

    for bagKey in bag.contents.keys {
        n += bag.contents[bagKey]! * (1 + searchPart2(bagColor: bagKey, bags: bags))
    }
    return n
}
searchPart2(bagColor: "shiny gold", bags: bags)


//: [Next](@next)
