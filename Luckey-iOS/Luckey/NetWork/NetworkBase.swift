import Moya
import HandyJSON
import SwifterSwift
import CryptoSwift
import Alamofire
import Reachability
import SwiftyJSON

enum NetworkError: Error {
    case networkUnreachable
    case mapObjectNil(msg: String)
}

public enum CacheKeyType {
    case base
    case custom(String)
}

public class BaseAPI {
    convenience init(path: String, method: Moya.Method = .post, requestParam: [String: Any]? = nil) {
        self.init()
        self.convenienceRequestPath = path
        self.convenienceRequestParam = requestParam
    }
    
    private var baseURLString = "https://www.starchat.cc"
//    private var baseURLString = "http://43.139.80.74:9000"

    open var requestTimeOut: TimeInterval {
        15.0
    }
    open var requestPath: String {
        return convenienceRequestPath
    }
    
    private var convenienceRequestPath: String = ""
    
    open var requestParam: [String: Any] {
        if let param = convenienceRequestParam, !param.isEmpty {
            return param
        }
        return [:]
    }
    private var convenienceRequestParam: [String: Any]?
    
    open var queryParam: [String: Any] {
        [:]
    }
    open var requestMethod: Moya.Method {
        if let method = convenienceRequestMethod {
            return method
        }
        return .post
    }
    private var convenienceRequestMethod: Moya.Method?
    
    open var cacheType: CacheKeyType {
        .base
    }
    
    open var needCache: Bool {
        false
    }
    
    open var useCache: Bool {
        false
    }
    
    open var cancelRequestWhenCacheExist: Bool {
        false
    }
    
    public func fetchCacheKey() -> String {
        switch cacheType {
        case .base:
            return cacheKey
        case let .custom(key):
            return cacheKey(with: key)
        }
    }
    
    private var baseCacheKey : String {
        return "[\(self.method)]\(self.baseURL.absoluteString)\(self.path)"
    }
    
    private var cacheKey: String {
        let baseKey = baseCacheKey
        if parameters.isEmpty { return baseKey }
        return baseKey + "?" + parameters
    }
    
    private func cacheKey(with customKey: String) -> String {
        return baseCacheKey + "?" + customKey
    }
    
    private var parameters: String {
        switch self.task {
        case let .requestParameters(parameters, _):
            return JSON(parameters).rawString() ?? ""
        case let .requestCompositeParameters(bodyParameters, _, _):
            var parameters = bodyParameters
            for (key, value) in queryParam {
                parameters[key] = value
            }
            return JSON(parameters).rawString() ?? ""
        case let .downloadParameters(parameters, _, _):
            return JSON(parameters).rawString() ?? ""
        case let .uploadCompositeMultipart(_, urlParameters):
            return JSON(urlParameters).rawString() ?? ""
        case let .requestCompositeData(_, urlParameters):
            return JSON(urlParameters).rawString() ?? ""
        default: return  ""
        }
    }
}

extension BaseAPI: TargetType {
    public var baseURL: URL {
        return URL(string: baseURLString)!
    }
    
    public var path: String {
        return requestPath
    }
    
    public var method: Moya.Method {
        return requestMethod
    }
    
    public var task: Task {
        var urlParams = queryParam
        urlParams.merge(NetworkParamsHelper.generationParams()) { $1 }
        return .requestCompositeParameters(bodyParameters: requestParam,
                                           bodyEncoding: JSONBodyEncoding(),
                                           urlParameters: urlParams)
    }
    
    public var headers: [String : String]? {
        return NetworkParamsHelper.generationHeader()
    }
}

public class BaseRequestResult: HandyJSON {
    public var code: Int = 0
    public var msg: String = ""
    public var data: [String: Any] = [:]
    
    required public init() { }
}

class BaseRequestResultWrapper: HandyJSON {
    required public init() { }
}
