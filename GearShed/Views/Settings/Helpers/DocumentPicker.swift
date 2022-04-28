//
//  DocumentPicker.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-02-03.
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

struct DocumentPicker: UIViewControllerRepresentable {
    var URLs: [URL]
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forExporting: URLs)
        return picker
    }
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>){}
}
