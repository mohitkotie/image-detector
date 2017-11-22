//
//  ViewController.swift
//  Photo Detector
//
//  Created by mohit kotie on 09/11/17.
//  Copyright © 2017 mohit kotie mohit. All rights reserved.
//

import UIKit
import CoreML
import Vision
class ViewController:
    
UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detectedLabel: UILabel!
    @IBOutlet weak var sureLabel: UILabel!
    
    let mylib = VGG16()
    let imagePicker = UIImagePickerController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func librarySelected(_ sender: Any) {
        
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cameraSelected(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let ima = info[UIImagePickerControllerOriginalImage] as? UIImage {
            machineLearn(image: ima)
            imageView.image = ima
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func machineLearn(image : UIImage){
        // request for model
        if let model = try? VNCoreMLModel(for : mylib.model){
            
            // check if error is nil
            
            let req = VNCoreMLRequest(model : model, completionHandler :{(req , error) in
                
                if let results = req.results as? [VNClassificationObservation]{
                    for i in results{
                        
                        print("\(i.identifier)and sure: \(i.confidence)")
                    }
                    self.detectedLabel.text = results.first?.identifier
                    self.sureLabel.text = "\((results.first?.confidence)! * 100)%"
                    
                }
            })
            
            // handler for request
            
            if let imgData = UIImagePNGRepresentation(image){
                let reqhandler = VNImageRequestHandler(data : imgData,options : [:])
                try?reqhandler.perform([req])
            }
        }
    }
}

