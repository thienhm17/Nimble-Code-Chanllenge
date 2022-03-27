//
//  GradientView.swift
//  Nimble Code Challenge
//
//  Created by Thien Huynh on 3/27/22.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    
    let gradientLayer = CAGradientLayer()
    
    @IBInspectable var startColor:UIColor = UIColor.yellow {
        didSet{
            configure()
        }
    }
    
    @IBInspectable var midColor:UIColor = UIColor.orange {
        didSet{
            configure()
        }
    }
    
    @IBInspectable var endColor:UIColor = UIColor.red {
        didSet{
            configure()
        }
    }
    
    @IBInspectable var direction: UInt = 1 {
        didSet{
            configure()
        }
    }
    
    func setup() {
        if !(layer.sublayers?.contains(where: {$0 === gradientLayer}) ?? false) {
            layer.addSublayer(gradientLayer)
        }
    }
    
    func configure() {
        gradientLayer.frame = bounds
        gradientLayer.colors = [startColor.cgColor,midColor.cgColor,endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y:0 )
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.locations = [0.25,0.5,0.75]
        
        switch direction % 5 {
        case 0:
            gradientLayer.startPoint = CGPoint(x: 0, y:0 )
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        case 1:
            gradientLayer.startPoint = CGPoint(x: 0, y:0 )
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        case 2:
            gradientLayer.startPoint = CGPoint(x: 0, y:0 )
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        case 3:
            gradientLayer.startPoint = CGPoint(x: 1, y:0 )
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
            
        default:
            gradientLayer.startPoint = CGPoint(x: 1, y:0 )
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        setup()
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
        configure()
    }
}

