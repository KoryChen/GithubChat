//
//  ImageCache.swift
//  GitHubDM
//
//  Created by Kory on 2020/3/9.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import UIKit

class ImageCache {
    static let shared = ImageCache(client: HTTPClient())
    var client: HTTPClient
    init(client: HTTPClient) {
        self.client = client
    }
    
    private var imageCache: [URL: UIImage] = [:]
    private var processingURL: Set<URL> = []
    private let urlQueue = DispatchQueue(
        label: "url.concurrent",
        attributes: .concurrent)
    private let queue = DispatchQueue(
       label: "image.concurrent",
       attributes: .concurrent)
    
    func downloadImage(
        with url: URL,
        handler: @escaping ((Result<UIImage, Error>)->Void)) {
        guard contain(url) == false else {
            return
        }
        
        client.performRequest(url) {
            [weak self] (data, response, error) in
            guard let self = self else { return }
            self.remove(url)
            if let error = error {
                handler(.failure(error))
                return
            }
            guard let data = data,
                let image = UIImage(data: data) else {
                    handler(.failure(APIError.nilData))
                    return
            }

            self.saveImage(image, for: url)
            handler(.success(image))
        }
        insert(url)
    }
    
    func saveImage(_ image: UIImage, for url: URL) {
        queue.async(flags: .barrier) {
            self.imageCache[url] = image
        }
    }
    
    func cachedImage(for url: URL) -> UIImage? {
        var image: UIImage?
        queue.sync {
            image = imageCache[url]
        }
        return image
    }
    
    private func insert(_ url: URL) {
        urlQueue.async(flags: .barrier) {
            self.processingURL.insert(url)
        }
    }
    
    private func remove(_ url: URL) {
        urlQueue.async(flags: .barrier) {
            self.processingURL.remove(url)
        }
    }
    
    private func contain(_ url: URL) -> Bool {
        var contain: Bool = false
        urlQueue.sync {
            contain = self.processingURL.contains(url)
        }
        return contain
    }
}
