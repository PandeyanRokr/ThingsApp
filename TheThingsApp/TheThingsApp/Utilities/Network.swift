//
//  Network.swift
//  TheThingsApp
//
//  Created by Pandeyan Rokr on 2022-07-28.
//

import Foundation
import Combine

protocol NetworkControllerProtocol: AnyObject {
    typealias Headers = [String: String]
    typealias Params = [String: Any]
    
    func getData<T>(type: T.Type,
                url: URL,
                requestType: REQUEST_TYPE,
                headers: Headers,
                params: Params
    ) -> Future<T, Error> where T: Decodable
    
    func getArrayOfData<T>(type: T.Type,
                url: URL,
                requestType: REQUEST_TYPE,
                headers: Headers,
                params: Params
    ) -> Future<[T], Error> where T: Decodable
}


final class NetworkController: NetworkControllerProtocol {
    
    init() {
        
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func getData<T: Decodable>(type: T.Type,
                            url: URL,
                            requestType: REQUEST_TYPE,
                            headers: Headers,
                            params: Params
    ) -> Future<T, Error> {
        
        let urlRequest = self.formURLRequest(url: url, requestType: requestType, param: params, header: headers)
        
        return Future<T, Error> { [weak self] promise in
            guard let self = self else {
                return promise(.failure(NetworkError.unknown))
            }
            
            URLSession.shared.dataTaskPublisher(for: urlRequest)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.unknown))
                        }
                    }
                }, receiveValue: { promise(.success($0)) })
                .store(in: &self.cancellables)
        }
    }
    
    func getArrayOfData<T: Decodable>(type: T.Type,
                            url: URL,
                            requestType: REQUEST_TYPE,
                            headers: Headers,
                            params: Params
    ) -> Future<[T], Error> {
        
        let urlRequest = self.formURLRequest(url: url, requestType: requestType, param: params, header: headers)
        
        return Future<[T], Error> { [weak self] promise in
            guard let self = self else {
                return promise(.failure(NetworkError.unknown))
            }
            
            URLSession.shared.dataTaskPublisher(for: urlRequest)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }
                    return data
                }
                .decode(type: [T].self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.unknown))
                        }
                    }
                }, receiveValue: { promise(.success($0)) })
                .store(in: &self.cancellables)
        }
    }
    
    private func formURLRequest(url:URL,requestType:REQUEST_TYPE, param: Params, header: Headers)->URLRequest {
        var urlRequest = URLRequest.init(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30.0)
        urlRequest.httpMethod = requestType.rawValue
        
        header.forEach { (key, value) in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        if !param.keys.isEmpty {
            let httpBody = try? JSONSerialization.data(withJSONObject: param, options:.prettyPrinted)
            urlRequest.httpBody = httpBody
        }
        return urlRequest
    }
}
