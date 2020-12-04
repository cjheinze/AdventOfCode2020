//: [Previous](@previous)

import Foundation

enum Field: Equatable {
    
    enum Key: String {
        case byr
        case iyr
        case eyr
        case hgt
        case hcl
        case ecl
        case pid
        case cid
    }
    
    case byr(Int)       // (Birth Year)
    case iyr(Int)       // (Issue Year)
    case eyr(Int)       // (Expiration Year)
    case hgt(String)    // (Height)
    case hcl(String)    // (Hair Color)
    case ecl(EyeColor?)  // (Eye Color)
    case pid(String)    // (Passport ID)
    case cid            // (Country ID)
    
    init?(key: Key?, value: String?) {
        guard let key = key else { return nil }
        let value = value ?? ""
        switch key {
        case .byr:
            if let intValue = Int(value) {
                self = .byr(intValue)
            } else {
                return nil
            }
            
        case .iyr:
            if let intValue = Int(value) {
                self = .iyr(intValue)
            } else {
                return nil
            }
        case .eyr:
            if let intValue = Int(value) {
                self = .eyr(intValue)
            } else {
                return nil
            }
        case .hgt:
            self = .hgt(value)
        case .hcl:
            self = .hcl(value)
        case .ecl:
            self = .ecl(EyeColor.init(rawValue: value))
        case .pid:
            self = .pid(value)
        case .cid:
            self = .cid
        }
    }
    
    func isValid() -> Bool {
        switch self {
        case let .byr(year):
            return (1920...2002).contains(year)
        case let .iyr(year):
            return (2010...2020).contains(year)
        case let .eyr(year):
            return (2020...2030).contains(year)
        case let .hgt(heightString):
            let unitString = heightString.suffix(2)
            let length = heightString.prefix(while: { "0"..."9" ~= $0 })
            switch unitString {
            case "cm":
                return ("150"..."193").contains(length)
            case "in":
                return ("59"..."76").contains(length)
            default:
                return false
            }
        case let .hcl(color):
            return color.hasPrefix("#") && color.count == 7 && (Int(color.dropFirst(), radix: 16) != nil)
        case let .ecl(eyeColor):
            return eyeColor != nil
        case let .pid(value):
            return value.count == 9 && value.filter({ "0"..."9" ~= $0 }).count == 9
        case .cid:
            return true
        }
    }
    
    enum EyeColor: String {
        case amb, blu, brn, gry, grn, hzl, oth
    }
}

struct Passport {
    var fields: [Field] = []
    
    func hasCorrectNumberOfFields() -> Bool {
        fields.count == 8 || (fields.count == 7 && !fields.contains(.cid))
    }
    
    func hasValidFields() -> Bool {
        return fields.allSatisfy({ $0.isValid() }) && hasCorrectNumberOfFields()
    }
}

let files = FileHandler.getInputs()
let path = files[0]
let inputString = try String(contentsOfFile: path)
let components: [String] = inputString.components(separatedBy: .whitespacesAndNewlines)
let inputs: [[String]] = components.split(separator: "").map({ Array($0) })

func parsePassports(inputs: [[String]]) -> [Passport] {
    return inputs.map { input -> Passport in
        let fields: [Field] = input.compactMap { fieldString in
            let keyValue = fieldString.split(separator: ":").map({ String($0) })
            if let key = keyValue.first {
                let fieldKey = Field.Key(rawValue: key)
                return Field(key: fieldKey, value: keyValue.last)
            }
            return nil
        }
        return Passport(fields: fields)
    }
}

let passports = parsePassports(inputs: inputs)
let validPassportsPart1 = passports.filter { $0.hasCorrectNumberOfFields() }.count
print(validPassportsPart1)

let validPassportsPart2 = passports.filter { $0.hasValidFields() }.count
print(validPassportsPart2)

//: [Next](@next)
