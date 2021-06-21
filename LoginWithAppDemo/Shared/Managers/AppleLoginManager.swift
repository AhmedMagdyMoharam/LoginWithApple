//
//  AppleLoginManager.swift
//  LoginWithAppDemo
//
//  Created by ahmed moharam on 22/06/2021.
//

import Foundation
import UIKit
import AuthenticationServices

protocol AppleSignInClientProtocol {
    func handleAppleIdRequest(block: @escaping (_ fullname: String?, _ email: String?, _ userId: String?, _ message: String?) -> Void)
}

class AppleSignInClient: NSObject, AppleSignInClientProtocol {
    
    //MARK: Properties
    static var shared: AppleSignInClientProtocol = AppleSignInClient()
    var completionHandler: (_ fullname: String?, _ email: String?, _ userId: String?, _ message: String?) -> Void = { _, _, _,_  in }

    //MARK: Methods
    @available(iOS 13.0, *) // sign in with apple is not available below iOS13
    @objc func handleAppleIdRequest(block: @escaping (_ fullname: String?, _ email: String?, _ userId: String?, _ message: String?) -> Void) {
        completionHandler = block
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }

    @available(iOS 13.0, *) // sign in with apple is not available below iOS13
    private func getCredentialState(fullname: String, email: String, userID: String ) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: userID) { [weak self] credentialState, _ in
            guard let self = self else { return }
            switch credentialState {
            case .authorized:
                // The Apple ID credential is valid.
                self.completionHandler(fullname, email, userID, nil)
                break
            case .revoked:
                self.completionHandler(nil, nil, nil, "The Apple ID credential is revoked")
                break
            case .notFound:
                self.completionHandler(nil, nil, nil, "No Account Found")
                break
            default:
                break
            }
        }
    }
}

@available(iOS 13.0, *)
extension AppleSignInClient: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = "\(appleIDCredential.fullName?.givenName ?? "")\(appleIDCredential.fullName?.familyName ?? "")"
            let email = appleIDCredential.email

            getCredentialState(fullname: fullName, email: email ?? "", userID: userIdentifier)
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        self.completionHandler(nil, nil, nil, "Sign in canceled using Apple")
    }
}
