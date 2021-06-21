//
//  ViewController.swift
//  LoginWithAppDemo
//
//  Created by ahmed moharam on 22/06/2021.
//

import UIKit

class ViewController: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var loginWithAppleBtn: UIButton!
        
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        designSetup()
    }
    
    //MARK:- Memory Management
    deinit {
        print("ViewController deinit success")
    }
    
    //MARK:- Methods
    private func designSetup() {
        loginWithAppleBtn.layer.cornerRadius = 25
        loginWithAppleBtn.backgroundColor = .black
        loginWithAppleBtn.setTitleColor(.white, for: .normal)
        loginWithAppleBtn.titleLabel?.font = .systemFont(ofSize: 16)
        loginWithAppleBtn.setTitle("Continue With Apple", for: .normal)
    }
    
    //MARK:- Binding Setup
    @IBAction func loginContinueWithApple(_ sender: Any) {
        if #available(iOS 13.0, *) {
            AppleSignInClient.shared.handleAppleIdRequest(block: { fullName, email, userId, message  in
                print("full name: \(fullName ?? "") \n emial: \(email ?? "") \n user id: \(userId ?? "") \n message: \(message ?? "")" )
            })
        } else {
            // Add toast ---> "Login with apple is not available below iOS 13"
            // OR
            loginWithAppleBtn.isHidden = true
        }
    }
}

