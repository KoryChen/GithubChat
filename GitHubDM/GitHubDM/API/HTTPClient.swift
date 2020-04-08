//
//  HTTPClient.swift
//  GitHubDM
//
//  Created by Kory on 2020/3/7.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import Foundation

class HTTPClient {

    private let session: URLSession
    let decoder = JSONDecoder()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    @discardableResult
    func runTask<T: APIRequest>(
        with request: T,
        completion: @escaping (Result<T.Response, Error>)->Void) -> URLSessionDataTask {
        let request = request.buildRequest()
        return session.dataTask(with: request) {
            [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.nilData))
                return
            }
            
            do {
                let result = try self.decoder.decode(T.Response.self, from: data)
                completion(.success(result))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    @discardableResult
    func performRequest(_ url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = session.dataTask(with: url, completionHandler: completionHandler)
        task.resume()
        return task
    }
}
