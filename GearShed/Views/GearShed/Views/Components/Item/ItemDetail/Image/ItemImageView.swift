//
//  ItemImageView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-11-20.
//

import SwiftUI

struct ItemImageView: View {

    @ObservedObject var item: Item
    
    @EnvironmentObject private var gsData: GearShedData
    
    var body: some View {
        VStack {
            if item.image == nil {
                Image("NulImg")
                    .resizable()
                    .frame(width: 120, height: 120)
            } else {
                Image(uiImage: UIImage(data: item.image!.img)!)
                    .resizable()
                    .frame(width: 120, height: 120)
            }
        }
    }

}
