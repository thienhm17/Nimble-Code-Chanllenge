//
//  UIViewController+Ext.swift
//  Nimble Code Challenge
//
//  Created by Thien Huynh on 3/26/22.
//

import UIKit

extension UIViewController {
    
    class func initFromStoryboard(_ name: String = "Main") -> Self {
        return initFromStoryboardHelper(name)
    }
    
    class func initFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }

        return instantiateFromNib()
    }
    
    private class func initFromStoryboardHelper<T: UIViewController>(_ name: String) -> T {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! T
        return controller
    }
    
    func showError(message: String, onDismiss: (()->())? = nil) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { action in
            onDismiss?()
        }))
        present(alert, animated: true, completion: nil)
    }
}
