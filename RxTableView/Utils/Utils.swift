//
//  Utils.swift
//  RxTableView
//
//  Created by Paul Matar on 02/07/2022.
//

import Foundation
import UIKit

struct Utils {
    static func displaySimpleAlert(title: String, message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .destructive)
        alert.addAction(action)
        viewController.present(alert, animated: true)
    }
}
