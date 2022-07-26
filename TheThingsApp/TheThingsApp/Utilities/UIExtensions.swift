//
//  UIExtensions.swift
//  TheThingsApp
//
//  Created by Pandeyan Rokr on 2022-07-28.
//

import Foundation
import UIKit

extension UIViewController {
    
    var theClassName: String {
        return NSStringFromClass(type(of: self))
    }
    
    //MARK: - Global Alert View
    func throwAlert(title:String?,msg:String) {
        DispatchQueue.main.async {
            let alertView = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            let btnDismiss = UIAlertAction(title: "OK", style: .default) { (action) in
                alertView.dismiss(animated: true, completion: nil)
            }
            alertView.addAction(btnDismiss)
            self.present(alertView, animated: true, completion: nil)
        }
    }
}

extension UIColor {
    class func defaultDarkGray() -> UIColor {
        return UIColor(red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1.0)
    }
}

extension UITextField {
    func addDefaulBorderForNameField() {
        self.layer.borderColor = UIColor.systemOrange.cgColor
    }
    
    func addRedBorder() {
        self.layer.borderColor = UIColor.red.cgColor
    }
}

extension MutableCollection {
    mutating func mapProperty<T>(_ keyPath: WritableKeyPath<Element, T>, _ value: T) {
        indices.forEach { self[$0][keyPath: keyPath] = value }
    }
}
