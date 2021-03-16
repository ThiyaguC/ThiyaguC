//
//  Extensions.swift
//  Weather
//
//  Created by Thiyagu  on 16/03/21.
//  Copyright © 2021 Thiyagu . All rights reserved.
//

import Foundation
import UIKit

enum AlertAction{
    case Ok
    case Cancel
}

typealias AlertCompletionHandler = ((_ action: AlertAction)->())?

extension UIViewController {
    
    func showAlert(title:String?, message:String?, handler:AlertCompletionHandler){
        let alert = UIAlertController(title:title, message: message, preferredStyle:.alert)
        
        alert.addAction(UIAlertAction(title:"ok", style:.default, handler: { (alert) in
            handler?(AlertAction.Ok)
        }))
        self.present(alert, animated: true)
    }
    
}
