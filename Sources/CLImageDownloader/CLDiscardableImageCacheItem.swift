//
//  CLDiscardableImageCacheItem.swift
//  CLImageDownloader
//
//  Created by Ajith Antony on 11/9/19.
//  Copyright © 2019 Color Labs. All rights reserved.
//

import UIKit

public class CLDiscardableImageCacheItem: NSObject, NSDiscardableContent {
    private(set) public var image: UIImage?
    var accessCount: UInt = 0
    
    public init(image: UIImage) {
        self.image = image
    }
    
    public func beginContentAccess() -> Bool {
        if image == nil {
            return false
        }
        
        accessCount += 1
        return true
    }
    
    public func endContentAccess() {
        if accessCount > 0 {
            accessCount -= 1
        }
    }
    
    public func discardContentIfPossible() {
        if accessCount == 0 {
            image = nil
        }
    }
    
    public func isContentDiscarded() -> Bool {
        return image == nil
    }
    
}

