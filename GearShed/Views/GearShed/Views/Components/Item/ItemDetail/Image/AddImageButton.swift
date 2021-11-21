//
//  AddImageButton.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-20.
//

import SwiftUI

struct AddImageButton: View {
    
    @EnvironmentObject private var viewModel: GearShedData
    
    @ObservedObject var item: Item

    @State private var image: UIImage?

    @State private var showSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera

    var body: some View {
        VStack {
            if #available(iOS 15.0, *) {
                Button {
                    self.showSheet.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                .confirmationDialog("Select Photo", isPresented: $showSheet, actions: {
                    Button {
                        self.showImagePicker = true
                        self.sourceType = .photoLibrary
                    } label: {
                        Text("Photo Library")
                    }
                    
                    Button {
                        self.showImagePicker = true
                        self.sourceType = .camera
                    } label: {
                        Text("Camera")
                    }
                    
                }, message: {
                    Text("Choose")
                })

            } else {
                Button {
                    self.showSheet.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                .actionSheet(isPresented: $showSheet) {
                    ActionSheet(title: Text("Select Photo"),
                                message: Text("Choose"),
                                buttons: [
                                    .default(Text("Photo Library")) {
                                        self.showImagePicker = true
                                        self.sourceType = .photoLibrary
                                    },
                                    .default(Text("Camera")) {
                                        self.showImagePicker = true
                                        self.sourceType = .camera
                                    },
                                    .cancel()
                                ])
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            saveImg()
        } content: {
            ImagePicker(image: self.$image, isShown: self.$showImagePicker, sourceType: self.sourceType)
        }
    }
    
    private func saveImg() {
        viewModel.updateItemImg(img: image!, item: item)
    }
}
