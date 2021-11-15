//
//  GearlistContainerView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-10.
//

import SwiftUI

struct GearlistContainerView: View {
    
    @EnvironmentObject private var persistentStore: PersistentStore
    
    @EnvironmentObject private var viewModel: GearlistData
    
    @ObservedObject var gearlist: Gearlist
        
    @State private var showAddContainer: Bool = false

    var body: some View {
        VStack (spacing: 0) {
            statBar
            ZStack {
                packingContainerList
                addContainerButtonOverlay
            }
        }
        .fullScreenCover(isPresented: $showAddContainer) {
            AddContainerView(persistentStore: persistentStore, gearlist: gearlist)
        }
    }

}

extension GearlistContainerView {
    
    private var packingContainerList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                ForEach(gearlist.containers) { container in
                    ContainerRowView(container: container, gearlist: gearlist)
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 75)
        }
    }
    
    private var addContainerButtonOverlay: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    showAddContainer.toggle()
                }
                label: {
                    VStack{
                        Text("Add")
                        Text("Pack")
                    }
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color.theme.background)
                }
                .frame(width: 55, height: 55)
                .background(Color.theme.accent)
                .cornerRadius(38.5)
                .padding(.bottom, 20)
                .padding(.trailing, 15)
                .shadow(color: Color.theme.accent.opacity(0.3), radius: 3,x: 3,y: 3)
            }
        }
    }
    
    private var statBar: some View {
        HStack (spacing: 20){
            
            Text (
                "Packed: " +
                "\(viewModel.gearlistContainerBoolTotals(gearlist: gearlist))" +
                " of " +
                "\(viewModel.gearlistContainerTotalItems(gearlist: gearlist))"
            )
            
            Text (
                "Weight: " +
                "\(viewModel.gearlistContainerTotalWeight(gearlist: gearlist))" +
                "g"
            )
            
            Spacer()
        }
        .font(.subheadline)
        .foregroundColor(Color.white)
        .padding(.horizontal)
        .padding(.vertical, 5)
        .background(Color.theme.green)
        .padding(.top, 10)
    }
}

/* Text("Packed:")
 Text("\(viewModel.gearlistContainerBoolTotals(gearlist: gearlist))")
 Text("of")
 Text("\(gearlist.gearlistContainerTotals(gearlist: gearlist))")*/
