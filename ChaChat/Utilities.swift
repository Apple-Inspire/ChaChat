//
//  Utilities.swift
//  ChaChat
//
//  Created by Yash Nayak on 17/01/19.
//  Copyright © 2019 Yash Nayak. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    func ShowAlert (title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    func GetDate () -> String {
        let today: Date = Date()
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: today)
    }
    
}
