public struct Token: Codable{
    public let coin: Coin
    public let blockchain: Blockchain
    public let type: TokenType
    public let decimals: Int

    public init(coin: Coin, blockchain: Blockchain, type: TokenType, decimals: Int) {
        self.coin = coin
        self.blockchain = blockchain
        self.type = type
        self.decimals = decimals
    }

    public var blockchainType: BlockchainType {
        blockchain.type
    }

    public var tokenQuery: TokenQuery {
        TokenQuery(blockchainType: blockchainType, tokenType: type)
    }

    public var fullCoin: FullCoin {
        FullCoin(coin: coin, tokens: [self])
    }
    
    enum CodingKeys: String, CodingKey {
        case
        coin,
        blockchain,
        type,
        decimals
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(coin, forKey: .coin)
        try container.encode(blockchain, forKey: .blockchain)
        try container.encode(type.id, forKey: .type)
        try container.encode(decimals, forKey: .decimals)

    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.coin = try container.decode(Coin.self, forKey: .coin)
        self.blockchain = try container.decode(Blockchain.self, forKey: .blockchain)
        let typeString = try container.decode(String.self, forKey: .type)
        self.type = TokenType.init(id: typeString) ?? .native
        self.decimals = try container.decode(Int.self, forKey: .decimals)
    }

}

extension Token: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(coin)
        hasher.combine(blockchain)
        hasher.combine(type)
        hasher.combine(decimals)
    }

}

extension Token: Equatable {

    public static func ==(lhs: Token, rhs: Token) -> Bool {
        lhs.coin == rhs.coin
                && lhs.blockchain == rhs.blockchain
                && lhs.type == rhs.type
                && lhs.decimals == rhs.decimals
    }

}

extension Token: CustomStringConvertible {

    public var description: String {
        "Token [coin: \(coin); blockchain: \(blockchain); type: \(type); decimals: \(decimals)]"
    }

}
