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
