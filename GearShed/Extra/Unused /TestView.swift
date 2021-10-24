//
//  TestView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-15.
//

/*import SwiftUI

struct TestView1: View {
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 370, height: 50)
                .foregroundColor(.secondary.opacity(0.3))
            
            
            HStack {
                
                Image(systemName: "square.fill")
                    .resizable()
                    .font(.title)
                    .frame(width: 35, height: 35)
                    .foregroundColor(.white)
                    .padding(.horizontal,4)
                
                // Name and Brand
                VStack (alignment: .leading) {
                    
                    HStack {
                        Text("Northface")
                            .font(.title3)
                            .foregroundColor(.black)
                        
                        Text("-")
                        
                        Text("VE 25")
                            .font(.title3)
                            .foregroundColor(.black)
                    }
                    
                    Text("Mountain Weather Tent")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // quantity at the right
                Text("2030 g")
                    .font(.headline)
                    .foregroundColor(Color.blue)
                    .padding(.horizontal)
                
            }
            .padding(.horizontal)
        }
        
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView1()
    }
}


import ActionOver

struct Test3: View {

    @State var presented = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 40) {
                Text("""
                Hi, this is the Action Over modifier.

                With this modifier you will preset an Action Sheet on iPhone
                and a Popover on iPad and Mac.

                You will write just once your actions, and with a single modifier
                you will dislay the proper menu according the user's device.
                """)
                Button(action: {
                    self.presented = true
                }, label: {
                    Text("Show Action Over")
                })
                    .actionOver(
                        presented: $presented,
                        title: "Settings",
                        message: "Wich setting will you enamble?",
                        buttons: buttons,
                        ipadAndMacConfiguration: ipadMacConfig
                )
                HStack {
                    Spacer()
                }
                Spacer()
            }
            .padding()
                .navigationBarTitle("Action Over", displayMode: .large)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private var buttons: [ActionOverButton] = {
        return [
            ActionOverButton(
                title: "Option one",
                type: .normal,
                action: {}
            ),
            ActionOverButton(
                title: "Option two",
                type: .normal,
                action: {}
            ),
            ActionOverButton(
                title: "Delete",
                type: .destructive,
                action: {}
            ),
            ActionOverButton(
                title: nil,
                type: .cancel,
                action: nil
            ),
        ]
    }()

    private var ipadMacConfig = {
        IpadAndMacConfiguration(anchor: nil, arrowEdge: nil)
    }()
}

struct ContentView1_Previews: PreviewProvider {
    static var previews: some View {
        Test3()
    }
}*/
