//
//  MemeEditorViewController.swift
//  MemeMe
//  Udacity Nanodegree Project
//  Created by Andreas Kremling on 16.06.22.
//

import UIKit
class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate {
    
//Definition of text attributes
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth:  -3.0
    ]

//Outlets
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var textFieldBottom: UITextField!
    
    
    var memedImage: UIImage? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetView()
        //Hide navigation bar and tab bar
        self.navigationController!.navigationBar.isHidden = true
        self.tabBarController!.tabBar.isHidden = true
        //Resetting up the view
        //Dismiss keyboard when you tap outside of the text field
        dismissKeyboard()
        prepareTextField(textField: textFieldTop, defaultText: "TOP")
        prepareTextField(textField: textFieldBottom, defaultText: "BOTTOM")
        //Enable camera-button if a camera is available
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    func dismissKeyboard() {
        //Dismiss keyboard when you tap outside of the text field
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
            self.view.addGestureRecognizer(tapGesture)
    }
    
    //Preparation of textfields to avoid code repetition
        func prepareTextField(textField: UITextField, defaultText: String) {
            textField.defaultTextAttributes = memeTextAttributes
            textField.text = defaultText
            textField.textAlignment = .center
            textField.delegate = self
        }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func pickImage(_ sender: UIBarButtonItem) {
        switch sender.tag {
        case 0: pickImage(source: UIImagePickerController.SourceType.photoLibrary)
        case 1: pickImage(source: UIImagePickerController.SourceType.camera)
        default: return
        }
    }
    
//Method to pick an image out of photo library
    func pickImage(source: UIImagePickerController.SourceType){
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = source
            present(pickerController, animated: true, completion: nil)
            }
    
//Method to show activity view controller
    @IBAction func share(_ sender: Any) {
        memedImage = generateMemedImage()
        
        //Activity View Controller
        let activityViewController = UIActivityViewController(
            activityItems: [memedImage!],
            applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { (activity,completed,items,error) in
            if(completed) {
                // Save the image
                self.save()
                //Change label of cancel-button
                self.cancelButton.title = "Done"
                return
            }
        }
        //Present the Activity View Controller
        present(
            activityViewController, animated: true, completion: nil
        )
    }
    
//Method for cancel-button
    @IBAction func cancel(_ sender: Any) {
        //Resetting the view
        resetView()
        //Navigate back to RootViewController
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
//Method to reset the view
    private func resetView() {
        // Clear the image
        imageView.image = nil
        
        // Set the initial text to textfields
        self.textFieldTop.text = "TOP"
        self.textFieldBottom.text = "BOTTOM"
        
        // Disable the share button
        shareButton.isEnabled = false
        //Show navigation and tab bar
        self.navigationController!.navigationBar.isHidden = false
        self.tabBarController!.tabBar.isHidden = false
    }

//Move view when bottom text field is edited
    @objc func keyboardWillShow(_ notification: Notification) {
        if textFieldBottom.isFirstResponder && self.view.frame.origin.y == 0.0 {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }

//Move back view when editing in bottom text field is finished
    @objc func keyboardWillHide(_ notification: Notification) {
        // Move the view back to its original spot
        if textFieldBottom.isFirstResponder {
            view.frame.origin.y = 0.0
        }
    }

//Method to get height of the keyboard for moving the view
    private func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // ofCGRect
        return keyboardSize.cgRectValue.height
    }
    
    private func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    

    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //Get image
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage { imageView.image = image}
        
        //ImageView shall have the appropriate ratio
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        
        // Dismiss the UIImagePickerController
        picker.dismiss(animated: true, completion: nil)
        
        // Enable the share button if we have an image set
        self.shareButton.isEnabled = (imageView.image != nil)
    }

//Method to save the meme
    func save(){
        let meme = Meme(topText: self.textFieldTop.text ?? "TOP",
                 bottomText: self.textFieldBottom.text ?? "BOTTOM",
                 image: self.imageView.image!,
                 memedImage: memedImage!)
        
        // Store the meme in the array the AppDelegate
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }
    

//Method to generate a meme by making a screenshot
    func generateMemedImage() -> UIImage {
        // Hide toolbars
        toolBarVisible()
        
        //Create an image out of the view
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let meme : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbars after creation of image
        toolBarVisible()
        
        return meme
}
    
//Method to show/hide the toolbar
    func toolBarVisible() {
        self.topToolBar.isHidden = !topToolBar.isHidden
        self.bottomToolBar.isHidden = !bottomToolBar.isHidden
    }
    
//Method to clear textfields
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textFieldTop.text == "TOP" || textFieldBottom.text == "BOTTOM" {
            textField.text = ""
            }
        }
    
//Remove keyboard after "Enter"-button is clicked
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        }

    }
