import Cache
import Moya
import SwiftyJSON

public class NetworkCache: NSObject {
    static public let shared = NetworkCache()
    
    private lazy var storage: Storage<String, JSONDictionary>? = {
        let diskConfig = DiskConfig(name: "network_response_cache",
                                    expiry: .date(Date().addingTimeInterval(365 * 24 * 60 * 60)),
                                    maxSize: 100 * 1024 * 1024)
        let memoryConfig = MemoryConfig(expiry: .never,
                                        countLimit: 0,
                                        totalCostLimit: 30 * 1024 * 1024)
        return try? Storage<String, JSONDictionary>(diskConfig: diskConfig,
                                               memoryConfig: memoryConfig,
                                               transformer: TransformerFactory.forJSON())
    }()
    
    public func cache(_ dic: JSONDictionary, for key: String) {
        guard let storage = storage else {
            return
        }
        try? storage.setObject(dic, forKey: key)
    }
    
    public func cachedObject(for key: String) -> JSONDictionary? {
        guard let storage = storage else {
            return nil
        }
        let objcet = try? storage.object(forKey: key)
        return objcet
    }
}

extension TransformerFactory {
    static func forJSON() -> Transformer<JSONDictionary> {
        let toData: (JSONDictionary) throws -> Data = {
            try JSON($0).rawData()
        }
        let fromData: (Data) throws -> JSONDictionary = {
            return try JSON(data: $0).dictionaryObject ?? [:]
        }
        return Transformer<JSONDictionary>(toData: toData, fromData: fromData)
    }
    
    static func forResponse<T: Moya.Response>(_ type : T.Type) -> Transformer<T> {
        let toData: (T) throws -> Data = { $0.data }
        let fromData: (Data) throws -> T = {
            T(statusCode: 230, data: $0)
        }
        return Transformer<T>(toData: toData, fromData: fromData)
    }
}
