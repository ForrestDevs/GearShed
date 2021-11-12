//
//  AddShedView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

struct AddShedView: View {
	@Environment(\.presentationMode) var presentationMode
	
    @EnvironmentObject var persistentStore: PersistentStore

	@State private var editableData: EditableShedData
    
    @StateObject private var viewModel: GearShedData
    
    private var isAddFromItem: Bool
    private var shedOut: ((Shed) -> ())?
	private var shed: Shed?
	
	init(persistentStore: PersistentStore, shed: Shed? = nil,shedOut: ((Shed) -> ())? = nil, isAddFromItem: Bool? = nil) {
    
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
        
		_editableData = State(initialValue: EditableShedData(persistentStore: persistentStore, shed: shed))
		self.shed = shed
        self.shedOut = shedOut
        self.isAddFromItem = isAddFromItem ?? false
	}

	var body: some View {
        NavigationView {
            ZStack {
                backgroundLayer
                scrollViewLayer
            }
            .navigationBarTitle("Add New Shed", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                cancelToolBarItem
                saveToolBarItem
            }
        }
	}
    
}

extension AddShedView {
    
    private var cancelToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Cancel")
            }
        }
    }
    
    private var saveToolBarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                if isAddFromItem {
                    viewModel.addNewShedFromItem(using: editableData, shedOut: { shed in shedOut!(shed) })
                } else {
                    viewModel.addNewShed(using: editableData)
                }
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Save")
            }
            .disabled(!editableData.canShedBeSaved)
        }
    }
    
    private var backgroundLayer: some View {
        Color.theme.silver
            .ignoresSafeArea()
    }
    
    private var scrollViewLayer: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 10) {
                Section {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Name")
                            .formatEntryTitle()
                        TextField("Shed name", text: $editableData.shedName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .font(.subheadline)
                    }
                }
            }
            .padding()
        }
    }
    
}




