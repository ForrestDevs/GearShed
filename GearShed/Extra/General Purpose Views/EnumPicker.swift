//
//  EnumPicker.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-02-17.
//

import SwiftUI

struct CaseIterablePicker<T: CaseIterable & Hashable> : View
  where T.AllCases: RandomAccessCollection {

  var title: String = ""
  var selection: Binding<T>
  var display: (T) -> String = { "\($0)" }

  var body: some View {
    Picker(title, selection: selection) {
      ForEach(T.allCases, id:\.self) {
        Text(display($0)).tag($0)
      }
    }
    .pickerStyle(.segmented)
  }
}
