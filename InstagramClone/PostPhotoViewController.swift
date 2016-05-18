//
//  PostPhotoViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Fangsheng Tong on 2016-05-18.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

import Parse

class PostPhotoViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet var photoToPost: UIImageView!
    
    @IBOutlet var message: UITextField!
    
    @IBAction func choosePhoto(sender: AnyObject) {
        
        let photo = UIImagePickerController()
        photo.delegate = self
        photo.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        photo.allowsEditing = false
        
        self.presentViewController(photo, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        photoToPost.image = image
        
    }
    
    @IBAction func postPhoto(sender: AnyObject) {
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    
        let post = PFObject(className: "Post")
        
        post["message"] = message.text
        
        post["userId"] = PFUser.currentUser()!.objectId!
        
        let photoData = UIImagePNGRepresentation(photoToPost.image!)
        
        let photoFile = PFFile(name: "photo.png", data: photoData!)
        
        post["photoFile"] = photoFile
        
        post.saveInBackgroundWithBlock{(success, error) in
            
            self.activityIndicator.stopAnimating()
            
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if error == nil {
                self.displayAlert("Photo Posted", message: "Your photo has been posted successfully")
                
                self.photoToPost.image = UIImage(named: "Instagram-Image-Placeholder.jpg")
                
                self.message.text = ""
                
            } else {
                
                self.displayAlert("Photo Not Posted", message: "Please try again later")
                
            }
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
