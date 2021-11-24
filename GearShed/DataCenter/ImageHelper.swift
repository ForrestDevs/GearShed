//
//  ImageHelper.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-13.
//

import Foundation
import SwiftUI

class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var image: UIImage?
    @Binding var isShown: Bool
    @Binding var imageURL: URL?
    
    init(image: Binding<UIImage?>, isShown: Binding<Bool>, imageURL: Binding<URL?>) {
        _image = image
        _isShown = isShown
        _imageURL = imageURL
    }
    
    /*func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            url = uiImage.fil
            image = uiImage
            isShown = false
        }
        
    }*/
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.image = image
            print("Edited")
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.image = image
            print("ORG")
        }
        
        if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            self.imageURL = imageURL
            print (String(describing: self.imageURL))
        }
        
        if picker.sourceType == UIImagePickerController.SourceType.camera {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let url = documentDirectory
                .appendingPathComponent("\(UUID().uuidString)")
                .appendingPathExtension("jpeg")
            
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                self.image = image
                print("EditedCam")
            } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.image = image
                print("ORGCam")
            }
            
            let data = self.image?.jpegData(compressionQuality: 0.3)
            
            do {
                try data?.write(to: url)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            self.imageURL = url
            print(String(describing: imageURL))
        }
        
        self.isShown = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
    
}

struct ImagePicker: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = ImagePickerCoordinator
    
    @Binding var image: UIImage?
    @Binding var isShown: Bool
    @Binding var imageURL: URL?
    
    var sourceType: UIImagePickerController.SourceType = .camera
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePickerCoordinator(image: $image, isShown: $isShown, imageURL: $imageURL)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
}
