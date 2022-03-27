//
//  UIColor+Ext.swift
//  Nimble Code Challenge
//
//  Created by Thien Huynh on 3/26/22.
//

import UIKit

extension UIColor {

    public convenience init(hex: String?) {
        let normalizedHexString: String = UIColor.normalize(hex)
        var c: CUnsignedLongLong = 0
        Scanner(string: normalizedHexString).scanHexInt64(&c)
        
        self.init(red:UIColorMasks.redValue(c), green:UIColorMasks.greenValue(c), blue:UIColorMasks.blueValue(c), alpha:UIColorMasks.alphaValue(c))
    }
    
    public func hexDescription(_ includeAlpha: Bool = false) -> String {
        guard self.cgColor.numberOfComponents == 4 else {
            return "Color not RGB."
        }
        let a = self.cgColor.components!.map { Int($0 * CGFloat(255)) }
        let color = String.init(format: "%02x%02x%02x", a[0], a[1], a[2])
        if includeAlpha {
            let alpha = String.init(format: "%02x", a[3])
            return "\(color)\(alpha)"
        }
        return color
    }
    
    fileprivate enum UIColorMasks: CUnsignedLongLong {
        case redMask    = 0xff000000
        case greenMask  = 0x00ff0000
        case blueMask   = 0x0000ff00
        case alphaMask  = 0x000000ff
        
        static func redValue(_ value: CUnsignedLongLong) -> CGFloat {
            return CGFloat((value & redMask.rawValue) >> 24) / 255.0
        }
        
        static func greenValue(_ value: CUnsignedLongLong) -> CGFloat {
            return CGFloat((value & greenMask.rawValue) >> 16) / 255.0
        }
        
        static func blueValue(_ value: CUnsignedLongLong) -> CGFloat {
            return CGFloat((value & blueMask.rawValue) >> 8) / 255.0
        }
        
        static func alphaValue(_ value: CUnsignedLongLong) -> CGFloat {
            return CGFloat(value & alphaMask.rawValue) / 255.0
        }
    }
    
    fileprivate static func normalize(_ hex: String?) -> String {
        guard var hexString = hex else {
            return "00000000"
        }
        if (hexString.hasPrefix("#")) {
            hexString = String(hexString.dropFirst())
        }
        if hexString.count == 3 || hexString.count == 4 {
            hexString = hexString.map{ "\($0)\($0)" }.joined()
        }
        let hasAlpha = hexString.count > 7
        if (!hasAlpha) {
            hexString = hexString + "ff"
        }
        return hexString;
    }
}
