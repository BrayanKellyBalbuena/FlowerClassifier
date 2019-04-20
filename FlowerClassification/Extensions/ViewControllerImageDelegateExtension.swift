//
//  ViewControllerImageDelegateExtension.swift
//  FlowerClassification
//
//  Created by Brayan Kelly Balbuena on 4/18/19.
//  Copyright © 2019 Brayan Kelly Balbuena. All rights reserved.
//

import UIKit
import CoreML
import Vision

extension ViewController : UIImagePickerControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let userPickedImage = info[.originalImage] as? UIImage  else {
            fatalError("Error try to load image")
        }
        
        guard let cgImage = CIImage(image: userPickedImage) else {
            fatalError("Can't convert image")
        }
        
        detectImage(image: cgImage)
        
        imagePicker.dismiss(animated: true)
    }
    
    func detectImage(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: FlowerClassifier().model) else {
            fatalError("Loading Core Model Filed.")
        }
        
        let request = VNCoreMLRequest(model: model) {(request, error) in
            
            guard let classification = request.results?.first as? VNClassificationObservation else {
                fatalError("Can't Classify image")
            }
            
            self.navigationItem.title = classification.identifier.capitalized
            self.getFlawerIntro(named: classification.identifier)
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch  {
            print(error)
        }
    }
}
