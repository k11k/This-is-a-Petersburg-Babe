import Foundation

extension KeyedDecodingContainer {
    func decode<T>(forKey key: KeyedDecodingContainer.Key) throws -> T where T : Decodable {
        return try decode(T.self, forKey: key)
    }
}
