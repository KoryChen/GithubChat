//
//  UIImageView+Extension.swift
//  GitHubDM
//
//  Created by Kory on 2020/3/9.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import UIKit

enum ImageType {
    case normal
    case avatar
}

extension UIImageView {
    func p_setImage(
        with url: URL,
        placeholder: UIImage?,
        type: ImageType = .normal) {
        if let cachedImage = ImageCache.shared.cachedImage(for: url) {
            image = type == .avatar ? cachedImage.roundedImage : cachedImage
            return
        }
        image = placeholder
        
        taskIdentifier = url.absoluteString
        ImageCache.shared.downloadImage(with: url) { (result) in
            DispatchQueue.main.async {
                guard self.taskIdentifier == url.absoluteString else {
                    return
                }
                switch result {
                case .success(let image):
                    self.image = type == .avatar ? image.roundedImage : image
                case .failure(_):
                    //TODO: failure handle
                    break
                }
            }
        }
    }
    
    private struct AssociatedKeys {
        static var downloadTaskKey = "downloadKey"
    }
    
    public private(set) var taskIdentifier: String? {
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.downloadTaskKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.downloadTaskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
