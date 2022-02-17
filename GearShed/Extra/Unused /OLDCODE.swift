//
//  OLDCODE.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2022-02-15.
//
/*
 
 if (Prefs.shared.weightUnit == "g") {
     TextField("Weight in g", text: $editableData.weight)
         .textFieldStyle(RoundedBorderTextFieldStyle())
         .disableAutocorrection(true)
         .font(.subheadline)
         .keyboardType(.numberPad)
 }
 if (Prefs.shared.weightUnit == "lb + oz") {
     HStack (spacing: 10) {
         TextField("lb", text: $editableData.lbs)
             .textFieldStyle(RoundedBorderTextFieldStyle())
             .disableAutocorrection(true)
             .font(.subheadline)
             .keyboardType(.numberPad)
             .onReceive(Just(editableData.lbs)) { (newValue: String) in
                 self.editableData.lbs = newValue.prefix(20).filter {"1234567890".contains($0)  }
             }
         
         TextField("oz", text: $editableData.oz)
             .textFieldStyle(RoundedBorderTextFieldStyle())
             .disableAutocorrection(true)
             .font(.subheadline)
             .keyboardType(.decimalPad)
             .onReceive(Just(editableData.oz)) { (newValue: String) in
                 self.editableData.oz = newValue.prefix(5).filter {"1234567890.".contains($0)  }
             }
     }
 }




 if (persistentStore.stateUnit == "g") {
     TextField("Weight in g", text: $editableData.weight)
         .textFieldStyle(RoundedBorderTextFieldStyle())
         .disableAutocorrection(true)
         .font(.subheadline)
         .keyboardType(.numberPad)
 }

 if (persistentStore.stateUnit == "lb + oz") {
     HStack (spacing: 10) {
         TextField("lb", text: $editableData.lbs)
             .textFieldStyle(RoundedBorderTextFieldStyle())
             .disableAutocorrection(true)
             .font(.subheadline)
             .keyboardType(.numberPad)
             .onReceive(Just(editableData.lbs)) { (newValue: String) in
                 self.editableData.lbs = newValue.prefix(20).filter {"1234567890".contains($0)  }
             }
         
         TextField("oz", text: $editableData.oz)
             .textFieldStyle(RoundedBorderTextFieldStyle())
             .disableAutocorrection(true)
             .font(.subheadline)
             .keyboardType(.decimalPad)
             .onReceive(Just(editableData.oz)) { (newValue: String) in
                 self.editableData.oz = newValue.prefix(5).filter {"1234567890.".contains($0)  }
             }
     }
 }

 
 
 
 if (Prefs.shared.weightUnit == "g") {
     TextField("Weight in g", text: $editableData.weight)
         .textFieldStyle(RoundedBorderTextFieldStyle())
         .disableAutocorrection(true)
         .font(.subheadline)
         .keyboardType(.numberPad)
         .onReceive(Just(editableData.oz)) { (newValue: String) in
             self.editableData.oz = newValue.prefix(20).filter {"1234567890".contains($0)  }
         }
 }
 if (Prefs.shared.weightUnit == "lb + oz") {
     HStack (spacing: 10) {
         TextField("lb", text: $editableData.lbs)
             .textFieldStyle(RoundedBorderTextFieldStyle())
             .disableAutocorrection(true)
             .font(.subheadline)
             .keyboardType(.numberPad)
             .onReceive(Just(editableData.lbs)) { (newValue: String) in
                 self.editableData.lbs = newValue.prefix(20).filter {"1234567890".contains($0)  }
             }
         
         TextField("oz", text: $editableData.oz)
             .textFieldStyle(RoundedBorderTextFieldStyle())
             .disableAutocorrection(true)
             .font(.subheadline)
             .keyboardType(.decimalPad)
             .onReceive(Just(editableData.oz)) { (newValue: String) in
                 self.editableData.oz = newValue.prefix(5).filter {"1234567890.".contains($0)  }
             }
     }
 }

 if (persistentStore.stateUnit == "g") {
     TextField("Weight in g", text: $editableData.weight)
         .textFieldStyle(RoundedBorderTextFieldStyle())
         .disableAutocorrection(true)
         .font(.subheadline)
         .keyboardType(.numberPad)
         .onReceive(Just(editableData.oz)) { (newValue: String) in
             self.editableData.oz = newValue.prefix(20).filter {"1234567890".contains($0)  }
         }
 }

 if (persistentStore.stateUnit == "lb + oz") {
     HStack (spacing: 10) {
         TextField("lb", text: $editableData.lbs)
             .textFieldStyle(RoundedBorderTextFieldStyle())
             .disableAutocorrection(true)
             .font(.subheadline)
             .keyboardType(.numberPad)
             .onReceive(Just(editableData.lbs)) { (newValue: String) in
                 self.editableData.lbs = newValue.prefix(20).filter {"1234567890".contains($0)  }
             }
         
         TextField("oz", text: $editableData.oz)
             .textFieldStyle(RoundedBorderTextFieldStyle())
             .disableAutocorrection(true)
             .font(.subheadline)
             .keyboardType(.decimalPad)
             .onReceive(Just(editableData.oz)) { (newValue: String) in
                 self.editableData.oz = newValue.prefix(5).filter {"1234567890.".contains($0)  }
             }
     }
 }

 
 
 
 
 */
