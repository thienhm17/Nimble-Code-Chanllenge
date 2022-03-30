//
//  DotIndicatorCell.swift
//  Nimble Code Challenge
//
//  Created by Thien Huynh on 3/31/22.
//

import UIKit

class DotIndicatorCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func updateCell(isFocused: Bool) {
        imageView.image = UIImage(named: isFocused ? "Dot_focused" : "Dot_unfocused")
    }
}
