//
//  GearPlanView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-01.
//

import SwiftUI
import CoreData

struct GearPlanView: View {
    static let tag: String? = "GearShed"
    
    @EnvironmentObject var persistentStore: PersistentStore
    
    @StateObject private var viewModel: GearShedData
    
    @State private var currentSelection: Int = 0
    
    init(persistentStore: PersistentStore) {
        let viewModel = GearShedData(persistentStore: persistentStore)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        DevView()
        
        /*PagerTabView(tint: Color.theme.accent,selection: $currentSelection) {
            HStack(spacing: 0) {
                Text("GENERIC LIST")
                    .pageLabel()
                    .font(.system(size: 12).bold())
                
                Text("LABELS")
                    .pageLabel()
                    .font(.system(size: 12).bold())
            }
        }
        content: {
            Text("Generic List")
                .pageView(ignoresSafeArea: true, edges: .bottom)
            
            Text("Labels")
                .pageView(ignoresSafeArea: true, edges: .bottom)

        }
        .padding(.top, 10)
        .ignoresSafeArea(.container, edges: .bottom)
        .navigationBarTitle("Gear Plan", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    //showPDFScreen.toggle()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }*/
    }
}

struct DevView: View {
    
    @FetchRequest(entity: Item.entity(), sortDescriptors: [])
    private var items: FetchedResults<Item>
    
    @FetchRequest(entity: Shed.entity(), sortDescriptors: [])
    private var sheds: FetchedResults<Shed>
    
    @FetchRequest(entity: Brand.entity(), sortDescriptors: [])
    private var brands: FetchedResults<Brand>
    
    @FetchRequest(entity: Gearlist.entity(), sortDescriptors: [])
    private var gearlists: FetchedResults<Gearlist>
    
    @FetchRequest(entity: Cluster.entity(), sortDescriptors: [])
    private var listGroups: FetchedResults<Cluster>
    
    @FetchRequest(entity: Container.entity(), sortDescriptors: [])
    private var packingGroups: FetchedResults<Container>
    
    @FetchRequest(entity: ContainerBool.entity(), sortDescriptors: [])
    private var packingBools: FetchedResults<ContainerBool>
    
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                /*VStack {
                    Text("Items")
                        .font(.headline)
                    ForEach(items) { item in
                        Text(item.name)
                    }
                }
                VStack {
                    Text("Sheds")
                        .font(.headline)
                    ForEach(sheds) { shed in
                        Text(shed.name)
                    }
                }
                
                VStack {
                    Text("Brands")
                        .font(.headline)
                    ForEach(brands) { brand in
                        Text(brand.name)
                    }
                }*/
                
                VStack {
                    Text("Lists")
                        .font(.headline)
                    ForEach(gearlists) { gearlist in
                        Text(gearlist.name)
                    }
                }
                
                VStack {
                    Text("Clusters")
                        .font(.headline)
                    ForEach(listGroups) { listGroup in
                        HStack {
                            Text(listGroup.name)
                            ForEach(listGroup.items) { item in
                                Text(item.name)
                            }
                        }
                    }
                }
                
                VStack {
                    Text("Containers")
                        .font(.headline)
                    ForEach(packingGroups) { packingGroup in
                        HStack {
                            Text(packingGroup.name)
                            ForEach(packingGroup.items) { item in
                                Text(item.name)
                            }
                        }
                    }
                }
                
                VStack {
                    Text("ContainerBools")
                        .font(.headline)
                    ForEach(packingBools) { packingBool in
                        HStack {
                            Text(packingBool.item.name)
                            Text(packingBool.container?.name ?? "")
                        }
                        
                    }
                }
        
            }
        }
    }
}

