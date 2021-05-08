//
//  ViewController.swift
//  MemeMeV1.0
//
//  Created by Mohammed Al-harbi on 5/7/21.
//

import UIKit

class ViewController: UIViewController, UISearchTextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var cameraButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.delegate = self
        bottomTextField.delegate = self
        topTextField.defaultTextAttributes = memeTextFeildsTextAttributes
        bottomTextField.defaultTextAttributes = memeTextFeildsTextAttributes
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super .viewWillAppear(true)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super .viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }
    
    
    let memeTextFeildsTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!,
        NSAttributedString.Key.strokeWidth: 4
    ]
    
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    
    
    
    
    
    // MARK: Begining of imageView setUp and related functions
    
    // action that triggers the choosing sequence once it's been clicked
    @IBAction func pickAnImageFromPhotosApp(_ sender: Any) {
        
        // creating the image picker object which accesses photos and pick the image
        let imagePickerController = UIImagePickerController()
        
        // confirm to the UI Image Picker Delegate to get access to necessary methods
        imagePickerController.delegate = self
        
        // to present the picking image view that we created with animated transaction
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    // the method that allows me to handle the chosen image and assign it to the image view
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // very important line, it dismisses the image picker view after the picture was chosen
        picker.dismiss(animated: true, completion: nil)
        
        /*
         we retrieve the chosen picture by accessing the info dictionary
         it contains many details about the chosen image mainly related to any modification about the image
         after specifying the original image key, we get the original image unmodified as the value
         it's an optional so we unwrap it, then we assign it as the image of the image view
         */
        
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
        }
    }
    
    @IBAction func takeImageFromCamera(_ sender: Any) {
        // creating the image picker object which accesses the camera and take the image
        let imageTakerController = UIImagePickerController()
        
        // confirm to the UI Image Picker Delegate to get access to necessary methods
        imageTakerController.delegate = self
        
        // here we specify the source of the incoming image, by default it's assigned to the Photos library however we need to access the camera
        imageTakerController.sourceType = .camera
        
        // to present the taking image view that we created with animated transaction
        present(imageTakerController, animated: true, completion: nil)
    }
    
    // to dismiss the image picker view in case the picking process was canceled
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Begining of kyboard transtion setUp
    
    // this function will retrive the height of the keyboard needed by the view so that it could move up
    //
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
}

