//
//  SegmentedPicker.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-23.
//

import SwiftUI

struct SPForShedView: View {
    
    @Binding var selected: Int
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Button {
                    withAnimation {
                        self.selected = 1
                    }
                }
                    label: { Text("SHED")
                        //.fontWeight(self.selected == 1 ? .bold : .regular)
                                //.padding(.vertical,12)
                                .padding(.horizontal,10)
                                //.background(self.selected == 1 ? Color.white : Color.clear)
                }
                .foregroundColor(self.selected == 1 ? .white : .black)
                
                Button { withAnimation {
                    self.selected = 2
                } }
                    label: { Text("BRAND")
                        //.fontWeight(self.selected == 2 ? .bold : .regular)
                                //.padding(.vertical,12)
                                .padding(.horizontal,10)
                                //.background(self.selected == 2 ? Color.white : Color.clear)
                }
                .foregroundColor(self.selected == 2 ? .white : .black)
                
                Button { withAnimation {
                    self.selected = 3
                }}
                    label: { Text("FAV")
                                //.fontWeight(self.selected == 3 ? .bold : .regular)
                                //.padding(.vertical,12)
                                .padding(.horizontal,10)
                                //.background(self.selected == 3 ? Color.white : Color.clear)
                }
                .foregroundColor(self.selected == 3 ? .white : .black)
                
                Button { withAnimation {
                    self.selected = 4
                }}
                    label: { Text("WISHLIST")
                                //.fontWeight(self.selected == 3 ? .bold : .regular)
                                //.padding(.vertical,12)
                                .padding(.horizontal,10)
                                //.background(self.selected == 3 ? Color.white : Color.clear)
                }
                .foregroundColor(self.selected == 4 ? .white : .black)
                
                Button {withAnimation {
                    self.selected = 5
                }}
                    label: { Text("REGRET")
                        //.fontWeight(self.selected == 4 ? .bold : .regular)
                                //.padding(.vertical,12)
                                .padding(.horizontal,10)
                                //.fontWeight(self.selected == 4 ? .bold : .body)
                                //.background(self.selected == 4 ? Color.white : Color.clear)
                }
                .foregroundColor(self.selected == 5 ? .white : .black)
            }
        }
        .padding(.vertical, 10)
        .background(Color.theme.green)
        .animation(.easeInOut)
        
    }
}

struct SPForDetailView: View {
    
    @Binding var selected: Int
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Button {
                    withAnimation {
                        self.selected = 1
                    }
                }
                    label: { Text("TRIP")
                        //.fontWeight(self.selected == 1 ? .bold : .regular)
                                //.padding(.vertical,12)
                                .padding(.horizontal,10)
                                //.background(self.selected == 1 ? Color.white : Color.clear)
                }
                .foregroundColor(self.selected == 1 ? .white : .black)
                
                Button { withAnimation {
                    self.selected = 2
                } }
                    label: { Text("ACTIVITY")
                        //.fontWeight(self.selected == 2 ? .bold : .regular)
                                //.padding(.vertical,12)
                                .padding(.horizontal,10)
                                //.background(self.selected == 2 ? Color.white : Color.clear)
                }
                .foregroundColor(self.selected == 2 ? .white : .black)
                
                Button { withAnimation {
                    self.selected = 3
                }}
                    label: { Text("DIARY")
                                //.fontWeight(self.selected == 3 ? .bold : .regular)
                                //.padding(.vertical,12)
                                .padding(.horizontal,10)
                                //.background(self.selected == 3 ? Color.white : Color.clear)
                }
                .foregroundColor(self.selected == 3 ? .white : .black)
                
                Button { withAnimation {
                    self.selected = 4
                }}
                    label: { Text("PHOTO")
                                //.fontWeight(self.selected == 3 ? .bold : .regular)
                                //.padding(.vertical,12)
                                .padding(.horizontal,10)
                                //.background(self.selected == 3 ? Color.white : Color.clear)
                }
                .foregroundColor(self.selected == 4 ? .white : .black)
            }
        }
        .padding(.vertical, 10)
        .background(Color.theme.green)
        .animation(.easeInOut)
        
    }
}
