import Foundation

extension Data {
    
    static func fromFileName(_ fileName: String, ofType type: String) -> Data? {
        guard
            let filePath = Bundle.main.path(forResource: fileName, ofType: type),
            let fileContent = try? String(contentsOfFile: filePath),
            let fileData = fileContent.data(using: .utf8)
            else {
                return nil
        }
        return fileData
    }
    
}
extension Data {
    
    init<T>(from value: T) {
        var value = value
        self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }
    
    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.pointee }
    }
}
