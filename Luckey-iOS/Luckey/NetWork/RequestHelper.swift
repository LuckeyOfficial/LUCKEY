import Moya
import HandyJSON
import SwifterSwift
import CryptoSwift
import Alamofire
import Reachability
import SwiftyJSON

class NetworkParamsHelper {
    static public func generationHeader() -> [String: String] {
        return ["Content-Type": "application/json", "charset": "utf-8", "X-Token": ""/*UserInfoManager.manager.currentToken*/]
    }
    
    static public func generationParams() -> [String: Any] {
        let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        let net = try? Reachability().connection.description
        var para: [String: Any] = ["pf": UIDevice.current.systemName,
                                   "ver": version ?? "0.0.0",
                                   "osver": UIDevice.current.systemVersion,
                                   "device": UIDevice.current.model,
                                   "net": net ?? "unknow",
                                   "timezone": TimeZone.autoupdatingCurrent.identifier,
                                   "timestamp": Int64((CFAbsoluteTimeGetCurrent() + kCFAbsoluteTimeIntervalSince1970) * 1000),
                                   "lang": Locale.preferredLanguages.first ?? "unknow"]
//        if let uid = UserInfoManager.manager.currentUser?.userId, uid > 0 {
//            para["uid"] = uid
//        }
        return para
    }
}

public struct JSONBodyEncoding: ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        guard let parameters = parameters else {
            return urlRequest
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: .sortedKeys)
            urlRequest.httpBody = data
        } catch {
            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }
        return urlRequest
    }
}
