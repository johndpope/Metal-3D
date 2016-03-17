//
//  Texture.swift
//  HelloMetal
//
//  Created by Chris on 2015-02-21.
//  Copyright (c) 2015 Chris. All rights reserved.
//

import Foundation
import Metal
import UIKit

class Texture {

    var texture : MTLTexture! = nil
    var textureType : MTLTextureType! = nil
    var width, height, depth : Int
    var pixelFormat : MTLPixelFormat
    var flip : Bool!
    var path : String! = nil
    
    init?(name: String, ext: String, device: MTLDevice) {

        
        path = NSBundle.mainBundle().pathForResource(name, ofType: ext)
        
        let image = UIImage(contentsOfFile: path)
        let colorSpace : CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()!
        
        width = Int(image!.size.width)
        height = Int(image!.size.height)
        depth = 1
        pixelFormat = MTLPixelFormat.RGBA8Unorm
        
        let bytesPerRow : Int = width * 4
        let bytesPerComponent : Int = 8
        let context : CGContextRef = CGBitmapContextCreate(nil, width, height, bytesPerComponent, bytesPerRow, colorSpace, CGImageAlphaInfo.PremultipliedLast.rawValue)!
        
        
        let bounds : CGRect = CGRectMake(0.0, 0.0, CGFloat(width), CGFloat(height))
        
        CGContextClearRect(context, bounds)
        CGContextDrawImage(context, bounds, image?.CGImage)

        let textureDescriptor: MTLTextureDescriptor! = MTLTextureDescriptor.texture2DDescriptorWithPixelFormat(MTLPixelFormat.RGBA8Unorm, width: Int(width), height: Int(height), mipmapped: true)
        
        textureType = textureDescriptor.textureType
        texture = device.newTextureWithDescriptor(textureDescriptor)
        
        let pixels : UnsafeMutablePointer<Void> = CGBitmapContextGetData(context)
        let region : MTLRegion = MTLRegionMake2D(0, 0, Int(width), Int(height))
        
        texture.replaceRegion(region, mipmapLevel: 0, withBytes: pixels, bytesPerRow: Int(bytesPerRow))
        
    }
    
    func setFlip(flip: Bool){
        self.flip = flip
    }
    
    
}