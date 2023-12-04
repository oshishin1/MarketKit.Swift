public struct Blockchain: Codable {
    public let type: BlockchainType
    public let name: String
    public let explorerUrl: String?

    public init(type: BlockchainType, name: String, explorerUrl: String?) {
        self.type = type
        self.name = name
        self.explorerUrl = explorerUrl
    }

    public var uid: String {
        type.uid
    }
    
    enum CodingKeys: String, CodingKey {
        case
        type,
        name,
        explorerUrl
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type.uid, forKey: .type)
        try container.encode(name, forKey: .name)
        try container.encode(explorerUrl, forKey: .explorerUrl)

    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeString = try container.decode(String.self, forKey: .type)
        self.type = BlockchainType.init(uid: typeString)
        self.name = try container.decode(String.self, forKey: .name)
        self.explorerUrl = try? container.decode(String.self, forKey: .explorerUrl)
    }

}

extension Blockchain: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(type)
    }

}

extension Blockchain: Equatable {

    public static func ==(lhs: Blockchain, rhs: Blockchain) -> Bool {
        lhs.type == rhs.type
    }

}

extension Blockchain: CustomStringConvertible {

    public var description: String {
        "Blockchain [type: \(type); name: \(name); explorerUrl: \(explorerUrl ?? "nil")]"
    }

}
