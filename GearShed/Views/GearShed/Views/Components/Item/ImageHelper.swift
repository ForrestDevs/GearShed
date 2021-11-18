//
//  ImageHelper.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-13.
//

import Foundation
import SwiftUI

struct ImageView1: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: ItemImage.entity(), sortDescriptors: [])
    var images: FetchedResults<ItemImage>
    
    @State public var image: Data = .init(count: 0)
    @State public var show : Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(images, id: \.self) { image in
                Image(uiImage: UIImage(data: image.img ?? self.image)!)
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .scaledToFit()
                    .cornerRadius(15)
            }
            .padding()
            
            
        }
        .navigationTitle("SavingInCoreData")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    self.show.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button{
                    for img in images {
                        moc.delete(img)
                        try! self.moc.save()
                    }
                } label: {
                    Text("Delete")
                }
            }
        }
        .sheet(isPresented: self.$show) {
            CreateNew().environment(\.managedObjectContext, self.moc)
        }
    }
}

struct CreateNew: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var dismiss
    
    @State public var image : Data = .init(count: 0)
    @State public var show : Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                if self.image.count != 0 {
                    Button {
                        self.show.toggle()
                    } label: {
                        Text("First")
                        /*Image(uiImage: UIImage(data: self.image)!)
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(6)
                            .shadow(radius: 4)*/
                    }
                } else {
                    Button {
                        self.show.toggle()
                    } label: {
                        Text("Second")
                        /*Image(systemName: "photo.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.secondary)
                            .cornerRadius(6)
                            .shadow(radius: 4)*/
                    }
                }
                
                Button {
                    saveImg()
                } label: {
                    Text("Create new")
                        .bold()
                        .foregroundColor(self.image.count > 0  ? .white : .black)
                        .background(self.image.count > 0 ? Color.blue : Color.gray)
                        .padding()
                        .frame(width: 130, height: 40)
                        .cornerRadius(10)
                        .shadow(radius: 8)
                }
                .disabled(self.image.count > 0 ? false : true)
                Spacer()
            }
            .navigationTitle("Create new")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.dismiss.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
        .sheet(isPresented: self.$show) {
            ImagePicker(show: self.$show, image: self.$image)
        }
    }
    
    func saveImg() {
        let newImage = ItemImage(context: self.moc)
        newImage.id = UUID()
        newImage.img = self.image
        try! self.moc.save()
        self.dismiss.wrappedValue.dismiss()
    }
}

struct ImagePicker : UIViewControllerRepresentable {
    
    @Binding public var show : Bool
    @Binding public var image : Data
    
    func makeCoordinator() -> Coordinator {
        return ImagePicker.Coordinator(img1: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator // This delegate allows the imgs to appear on the wherever we want to, after choose any image
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<ImagePicker>) {
        //This will keeping empty, we dont have to implement anything on here
        //because we dont need it.
    }
    
    class Coordinator: NSObject,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        //This allows us to navigate into the ImagePicker to choose any image!!!
        var img0 : ImagePicker
        init(img1: ImagePicker) {
            img0 = img1
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.img0.show.toggle() // This allows us to cancel with no choose any image
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            let images = info[.originalImage] as! UIImage
            
            let dataImg = images.jpegData(compressionQuality: 0.50)//This convert the image in Data
            
            self.img0.image = dataImg!
            self.img0.show.toggle()
        }
    }
}

