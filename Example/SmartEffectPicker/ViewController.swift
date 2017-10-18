//
//  ViewController.swift
//  SmartEffectPicker
//
//  Created by ShockUtility on 10/18/2017.
//  Copyright (c) 2017 ShockUtility. All rights reserved.
//

import UIKit
import SmartEffectPicker

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onClickPhoto(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            dismiss(animated: true, completion: {
                SmartEffectPicker.startEffect(self, title: NSLocalizedString("Effect", comment: "Effect"), sourceImage: pickedImage) { (effectedImage) in
                    self.imageView.image = effectedImage
                }
            })
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

