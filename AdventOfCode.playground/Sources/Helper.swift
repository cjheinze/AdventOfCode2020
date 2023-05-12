import Foundation

public struct FileHandler {
    
    public static func getInputs() -> [String] {
        let paths = Bundle.main.paths(forResourcesOfType: "txt", inDirectory: nil)
        return paths
    }
}

public extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

public extension Int {
    func mod(_ other: Int) -> Int {
        guard other != 0 else { return 0 }
        let m = self % other
        return m < 0 ? m + other : m
    }
}

public extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
