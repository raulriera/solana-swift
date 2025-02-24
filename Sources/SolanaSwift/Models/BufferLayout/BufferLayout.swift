import Foundation

public enum BufferLayoutError: Error {
    case NotImplemented
}

public protocol BufferLayout: Codable, BorshCodable {}

public extension BufferLayout {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

//        // decode parsedJSON
//        if let parsedData = try? container.decode(Self.self) {
//            self = parsedData
//            return
//        }

        // Unable to get parsed data, fallback to decoding base64
        let stringData = (try? container.decode([String].self).first) ?? (try? container.decode(String.self))
        guard let string = stringData else {
            throw SolanaError.couldNotRetrieveAccountInfo
        }

        if string.isEmpty, !(Self.self == EmptyInfo.self) {
            throw SolanaError.couldNotRetrieveAccountInfo
        }

        let data = Data(base64Encoded: string) ?? Data(Base58.decode(string))

        var reader = BinaryReader(bytes: data.bytes)
        try self.init(from: &reader)
    }
}
