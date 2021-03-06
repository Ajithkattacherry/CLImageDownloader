//
//  CLCachedImageView.swift
//  CLImageDownloader
//
//  Created by Ajith Antony on 11/9/19.
//  Copyright © 2019 Color Labs. All rights reserved.
//

import UIKit

public class CLCachedImageView: UIImageView {
    public static let imageCache = NSCache<NSString, CLDiscardableImageCacheItem>()
    private var urlStringForChecking: String?
    private var emptyImage: UIImage?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// Load an image from a URL String and cache it to reduce network overhead later.
    ///
    /// - parameter urlString: The url location of your image, usually on a remote server somewhere.
    /// - parameter placehoderImage: to show placehoderImage till the originl image is downloaded
    public func loadImage(from urlString: String, placehoderImage: String? = nil) {
        image = nil
        
        urlStringForChecking = urlString
        let urlKey = urlString as NSString
        
        if let image = placehoderImage {
            emptyImage = UIImage(named: image)
        }
        
        if let cachedItem = CLCachedImageView.imageCache.object(forKey: urlKey) {
            image = cachedItem.image
            return
        }
        
        image = emptyImage
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            if error != nil {
                return
            }
            
            DispatchQueue.main.async {
                guard let data = data,
                    let image = UIImage(data: data) else {
                    return
                }
                
                let cacheItem = CLDiscardableImageCacheItem(image: image)
                CLCachedImageView.imageCache.setObject(cacheItem, forKey: urlKey)
                
                if urlString == self?.urlStringForChecking {
                    self?.image = image
                }
            }
        }).resume()
    }
}
