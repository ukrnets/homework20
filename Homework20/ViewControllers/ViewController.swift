//
//  ViewController.swift
//  Homework20
//
//  Created by Darya Grabowskaya on 2.11.22.
//

import UIKit

class ViewController: UIViewController {
   
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.placeholder = "Password"
    }
    // MARK: - IBOutlets
    @IBOutlet weak var passwordField: UITextField!
    
    // MARK: - IBActions
    @IBAction func buttonOpen(_ sender: UIButton) {
        
        view.endEditing(true)
        if passwordField.text == "1111" {
            let gallery = GalleryViewController()
            let navigation = UINavigationController(rootViewController: gallery)
            navigation.modalPresentationStyle = .fullScreen
            present(navigation, animated: false)
        } else {
            showAlert(withTitle: "Invalid password", message: "")
            passwordField.text?.removeAll()
        }
        
        func showAlert(withTitle title: String, message: String) {
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Try again", style: .cancel)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
        
    }
    
}

