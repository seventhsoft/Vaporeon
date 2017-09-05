//
//  FacebookMananager.swift
//  Kuni
//
//  Created by Daniel on 13/08/17.
//  Copyright © 2017 Promotora Digital de Cultura. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit


/**
 *  Structure that holds the properties on the current Facebook user.
 */
struct FacebookUser {
    var id: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var pictureURL: String = ""
}

let kFacebookLoggedOutNotification: String = "kFacebookLoggedOutNotification"
let kFacebookLoginSuccessNotification: String = "kFacebookLoginSuccessNotification"

/// Singleton class that handles all of Facebook's API calls in the app.
class FacebookManager: NSObject {
    // MARK: - Constants
    
    /// The shared instance of the FacebookManager.
    static let sharedInstance: FacebookManager = FacebookManager()
    
    // The permissions to request from the Facebook API
    private let readPermissions = [
        "public_profile",
        "email",
    ]
    
    /// The parameters for fetching users.
    private let userParameters = [
        "fields" : "id,first_name,last_name,email,picture.type(large)"
    ]
    
    /// The Facebook login manager for the application.
    private let loginManager: FBSDKLoginManager = FBSDKLoginManager()
    
    // MARK: - API Routes
    
    /// The API route to access the current user.
    private let currentUserPath: String = "me"
    
    // MARK: - Variables
    
    /// The current user logged in through Facebook.
    var currentUser: FacebookUser?
    
    // MARK: - Initializers
    
    private override init(){
        super.init()
        
        self.fetchCurrentUser(completionHandler: { (currentUser) -> Void in
            if currentUser != nil {
                self.currentUser = currentUser
            }
        })
    }
    
    // MARK: - User Access Methods
    
    /**
     This method checks if the app has access to the user's Facebook account.     
     - returns: true if the app is connected to Facebook, false otherwise
     */
    
    func hasUserAccess() -> Bool {
        if let _ = FBSDKAccessToken.current(){
            return true
        }
        return false
    }
    
    /**
     This method handles the user's access inside the app.
     It will either ask the user to connect with Facebook,
     or logout, depending on the current status of the app.
     */
    
    func handleUserAccess(){
        // If the user is already connected, confirm the logout
        if (hasUserAccess()) {
            loginManager.logOut()
            // Notify observers that the user logged out of their Facebook account
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kFacebookLoggedOutNotification), object: nil)
            print("Haciendo Login después de logout")
            doLogin()
        } else {
            print("Haciendo Login sin acceso previo")
            doLogin()
        }
    }
    
    private func doLogin(){
        // Present the user with the Facebook login screen
        // Ejecuta login
        self.loginManager.logIn(withReadPermissions: self.readPermissions, from: nil) {
            [weak self] (result, error) -> Void in
            
            // Check if the app received access to the Facebook account
            if (self?.hasUserAccess() == true) {
                // Notify observers that the Facebook login was successful
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kFacebookLoginSuccessNotification), object: nil)
                // Fetch the current user
                if (self?.currentUser == nil){
                    self?.fetchCurrentUser(completionHandler: { (currentUser) -> Void in
                        if currentUser != nil {
                            self?.currentUser = currentUser
                        }
                    })
                    
                }
            }
            
        }
    
    }
    
    func getCurrentUser() -> FacebookUser? {
        return self.currentUser
    }
    
    // MARK: - User Methods
    private func fetchCurrentUser(completionHandler: @escaping (_ currentUser: FacebookUser?) -> Void) {
        // Initialize the request for the current user
        let request: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: self.currentUserPath, parameters: self.userParameters)
        
        // Request the current user
        request.start(completionHandler: { [weak self] (connection, result, error) -> Void in
            
            // Logged an error if we have one
            if let error = error {
                print("Error fetching Facebook user: \(error.localizedDescription)")
            } else {
                
                // Initialize the new facebook user info
                var currentUser:FacebookUser = FacebookUser()
                
                // Get the result as a dictionary
                if let result = result as? NSDictionary{
                    
                    // Get the facebook user's id
                    if let id = result["id"] as? String {
                        currentUser.id = id
                        currentUser.pictureURL = "https://graph.facebook.com/\(id)/picture?type=large&return_ssl_resources=1"
                    }
                    
                    // Get the facebook user's first name
                    if let firstName = result["first_name"] as? String {
                        currentUser.firstName = firstName
                    }
                    
                    // Get the facebook user's last name
                    if let lastName = result["last_name"] as? String {
                        currentUser.lastName = lastName
                    }
                    
                    // Get the facebook user's email
                    if let email = result["email"] as? String {
                        currentUser.email = email
                    }
                    
                    // Get the facebook user's picture URL
                    
                }
                print("Se obtuvieron los datos del usuario")
                // Set the current user
                //self?.currentUser = currentUser
                completionHandler(currentUser)
            }
            
        })
    }
}
