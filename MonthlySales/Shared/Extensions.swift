//
//  Extensions.swift
//  MonthlySales
//
//  Created by René Fouquet on 11.06.17.
//  Copyright © 2017 René Fouquet. All rights reserved.
//

import UIKit

extension Date {
    func isBetween(firstDate: Date, lastDate: Date) -> Bool {
        return (firstDate...lastDate).contains(self)
    }
}

extension UIViewController {
    func showErrorAlert(title: String = "Error", message: String, actions: [UIAlertAction]? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let actions = actions {
            actions.forEach( {alertController.addAction($0)} )
        } else {
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
        
        present(alertController, animated: true, completion: nil)
    }
}
