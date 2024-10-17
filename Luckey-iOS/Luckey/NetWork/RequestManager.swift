import Moya
import HandyJSON
import SwifterSwift
import CryptoSwift
import Alamofire
import Reachability
import SwiftyJSON

public class RequestManager<T: HandyJSON> {
    @discardableResult
    public func requestModule(api: BaseAPI,
                              rawJSONHandler: ((_ jsonDic: [String: Any]?) -> Void)? = nil,
                              done: @escaping ((_ result: Result<T, Error>, _ cache: Bool) -> Void)) -> Cancellable? {
        let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
            do {
                var request = try endpoint.urlRequest()
                request.timeoutInterval = api.requestTimeOut
                done(.success(request))
            } catch {
                done(.failure(MoyaError.parameterEncoding(error)))
            }
        }
        
        let provider = MoyaProvider<BaseAPI>(requestClosure: requestClosure)
        if api.useCache,
           let cachedObject = cache.cachedObject(for: api.fetchCacheKey()) {
            if let cachedT = T.deserialize(from: BaseRequestResult.deserialize(from: cachedObject)?.data) {
                done(.success(cachedT), true)
                if api.cancelRequestWhenCacheExist {
                    return nil
                }
            }
        }
        guard UIDevice.isReachable else {
            done(.failure(NetworkError.networkUnreachable), false)
            return nil
        }
        return provider.request(api) { responseResult in
            self.handleResult(api: api, result: responseResult) { result, rawResult, cache in
                rawJSONHandler?(rawResult)
                done(result, false)
            }
        }
    }
    
    private var cache: NetworkCache = NetworkCache.shared
    
    private func handleResult(api: BaseAPI,
                              result: Result<Moya.Response, MoyaError>,
                              done: @escaping ((_ result: Result<T, Error>,
                                                _ rawResult: [String: Any]?,
                                                _ cache: Bool) -> Void)) {
        switch result {
        case .success(let response):
            guard let dic = try? response.mapJSON() as? [String: Any] else {
                done(.failure(NetworkError.mapObjectNil(msg: "deserialize fail")), nil, false)
                return
            }
            if let result = BaseRequestResult.deserialize(from: dic),
               result.code <= 200,
               let value = T.deserialize(from: result.data) {
                if api.needCache {
                    NetworkCache.shared.cache(dic, for: api.fetchCacheKey())
                }
                done(.success(value), dic, false)
            } else {
                done(.failure(NetworkError.mapObjectNil(msg: "deserialize fail")), dic, false)
            }
        case .failure(let error):
            debugPrint(error)
            done(.failure(error), nil,false)
        }
    }
}

