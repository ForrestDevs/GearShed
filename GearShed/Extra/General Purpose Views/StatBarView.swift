//
//  StatBarView.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-19.
//

import SwiftUI

enum StatType {
    case shed, brand, fav, regret, wish, adventure, activity, list, pile, pack, diary
}

struct StatBar: View {
    
    @EnvironmentObject private var persistentStore: PersistentStore

    @EnvironmentObject private var gsData: GearShedData
    
    @EnvironmentObject private var glData: GearlistData
    
    @State var statType: StatType
    
    @State var gearlist: Gearlist?
    
    var body: some View {
        VStack (spacing: 0) {
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
                .foregroundColor(Color.theme.green)
                .padding(.bottom, 2)
            switch statType {
            case .shed:
                shedStats
                    .padding(.leading)
            case .brand:
                brandStats
                    .padding(.leading)
            case .fav:
                favStats
                    .padding(.leading)
            case .regret:
                regretStats
                    .padding(.leading)
            case .wish:
                wishStats
                    .padding(.leading)
            case .adventure:
                adventureStats
                    .padding(.leading)
            case .activity:
                actvivtyStats
                    .padding(.leading)
            case .list:
                listStats
                    .padding(.leading)
            case .pile:
                pileStats
                    .padding(.leading)
            case .pack:
                packStats
                    .padding(.leading)
            case .diary:
                diaryStats
                    .padding(.leading)
            }
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
                .foregroundColor(Color.theme.green)
                .padding(.top, 4)
        }
        .padding(.top, 2)
        .padding(.bottom, 5)
    }
    
    private var shedStats: some View {
        HStack (spacing: 20) {
            
            VStack (alignment: .leading, spacing: 2) {
                Text("Shelves (#)")
                    .formatStatBarTitle()
                Text("\(gsData.sheds.count)")
                    .formatStatBarContent()
            }
            
            VStack (alignment: .leading, spacing: 2) {
                Text("Gear (#)")
                    .formatStatBarTitle()
                Text("\(gsData.items.count)")
                    .formatStatBarContent()
            }
            VStack (alignment: .leading, spacing: 2) {
                Text("Weight (g)")
                    .formatStatBarTitle()
                Text("\(gsData.totalWeight(array: gsData.items))")
                    .formatStatBarContent()
            }
            VStack (alignment: .leading, spacing: 2) {
                Text("Invested ($)")
                    .formatStatBarTitle()
                Text("\(gsData.totalCost(array: gsData.items))")
                    .formatStatBarContent()
            }
            Spacer()
        }
    }
    
    private var brandStats: some View {
        HStack (spacing: 20) {
            VStack (alignment: .leading, spacing: 2) {
                Text("Brands (#)")
                    .formatStatBarTitle()
                Text("\(gsData.brands.count)")
                    .formatStatBarContent()
            }
            Spacer()
        }
    }
    
    private var favStats: some View {
        HStack (spacing: 20) {
            VStack (alignment: .leading, spacing: 2) {
                Text("Gear (#)")
                    .formatStatBarTitle()
                Text("\(gsData.favItems.count)")
                    .formatStatBarContent()
            }
            VStack (alignment: .leading, spacing: 2) {
                Text("Weight (g)")
                    .formatStatBarTitle()
                Text("\(gsData.totalWeight(array: gsData.favItems))")
                    .formatStatBarContent()
            }
            VStack (alignment: .leading, spacing: 2) {
                Text("Invested ($)")
                    .formatStatBarTitle()
                Text("\(gsData.totalCost(array: gsData.favItems))")
                    .formatStatBarContent()
            }
            Spacer()
        }
    }
    
    private var regretStats: some View {
        HStack (spacing: 20) {
            VStack (alignment: .leading, spacing: 2) {
                Text("Gear (#)")
                    .formatStatBarTitle()
                Text("\(gsData.regretItems.count)")
                    .formatStatBarContent()
            }
            VStack (alignment: .leading, spacing: 2) {
                Text("Invested ($)")
                    .formatStatBarTitle()
                Text("\(gsData.totalCost(array: gsData.regretItems))")
                    .formatStatBarContent()
            }
            Spacer()
        }
    }
    
    private var wishStats: some View {
        HStack (spacing: 20) {
            VStack (alignment: .leading, spacing: 2) {
                Text("Gear (#)")
                    .formatStatBarTitle()
                Text("\(gsData.wishListItems.count)")
                    .formatStatBarContent()
            }
            VStack (alignment: .leading, spacing: 2) {
                Text("Cost ($)")
                    .formatStatBarTitle()
                Text("\(gsData.totalCost(array: gsData.wishListItems))")
                    .formatStatBarContent()
            }
            Spacer()
        }
    }
    
    private var adventureStats: some View {
        HStack (spacing: 20) {
            VStack (alignment: .leading, spacing: 2) {
                Text("Adventures (#)")
                    .formatStatBarTitle()
                Text("\(glData.adventures.count)")
                    .formatStatBarContent()
            }
            VStack (alignment: .leading, spacing: 2) {
                Text("Bucketlist (#)")
                    .formatStatBarTitle()
                Text("\(glData.bucklists.count)")
                    .formatStatBarContent()
            }
            Spacer()
        }
    }
    
    private var actvivtyStats: some View {
        HStack (spacing: 20) {
            VStack (alignment: .leading, spacing: 2) {
                Text("Activities (#)")
                    .formatStatBarTitle()
                Text("\(glData.activities.count)")
                    .formatStatBarContent()
            }
            VStack (alignment: .leading, spacing: 2) {
                Text("Types (#)")
                    .formatStatBarTitle()
                Text("\(glData.activityTypes.count)")
                    .formatStatBarContent()
            }
            Spacer()
        }
    }

    private var listStats: some View {
        HStack (spacing: 20) {
            VStack (alignment: .leading, spacing: 2) {
                Text("Gear (#)")
                    .formatStatBarTitle()
                Text("\(gearlist!.items.count)")
                    .formatStatBarContent()
            }
            VStack (alignment: .leading, spacing: 2) {
                Text("Weight (g)")
                    .formatStatBarTitle()
                Text("\(glData.gearlistTotalWeight(gearlist: gearlist!))")                    .formatStatBarContent()
            }
            Spacer()
        }
    }
    
    private var pileStats: some View {
        HStack (spacing: 20) {
            VStack (alignment: .leading, spacing: 2) {
                Text("Gear (#)")
                    .formatStatBarTitle()
                Text("\(glData.gearlistClusterTotalItems(gearlist: gearlist!))")
                    .formatStatBarContent()
            }
            VStack (alignment: .leading, spacing: 2) {
                Text("Weight (g)")
                    .formatStatBarTitle()
                Text("\(glData.gearlistClusterTotalWeight(gearlist: gearlist!))" )                    .formatStatBarContent()
            }
            Spacer()
        }
    }
    
    private var packStats: some View {
        HStack (spacing: 20) {
            VStack (alignment: .leading, spacing: 2) {
                Text("Gear Packed")
                    .formatStatBarTitle()
                Text(
                    "\(glData.gearlistContainerBoolTotals(gearlist: gearlist!))" +
                     " of " +
                     "\(glData.gearlistContainerTotalItems(gearlist: gearlist!))"
                )
                    .formatStatBarContent()
            }
            VStack (alignment: .leading, spacing: 2) {
                Text("Weight (g)")
                    .formatStatBarTitle()
                Text("\(glData.gearlistContainerTotalWeight(gearlist: gearlist!))")
                    .formatStatBarContent()
            }
            Spacer()
        }
    }
    
    private var diaryStats: some View {
        HStack (spacing: 20) {
            VStack (alignment: .leading, spacing: 2) {
                Text("Entry (#)")
                    .formatStatBarTitle()
                Text("\(gearlist!.diaries.count)")
                    .formatStatBarContent()
            }
            Spacer()
        }
    }
    
}

struct VLine: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        }
    }
}

struct HLine: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        }
    }
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

struct CustomLineShapeWithAlignment: Shape {
    
    let stratPoint: Alignment
    let endPoint: Alignment
    
    init(stratPoint: Alignment, endPoint: Alignment) {
        self.stratPoint = stratPoint
        self.endPoint = endPoint
    }
    
    private func cgPointTranslator(alignment: Alignment, rect: CGRect) -> CGPoint {
        
        switch alignment {
        case .topLeading: return CGPoint(x: rect.minX, y: rect.minY)
        case .top: return CGPoint(x: rect.midX, y: rect.minY)
        case .topTrailing: return CGPoint(x: rect.maxX, y: rect.minY)
            
        case .leading: return CGPoint(x: rect.minX, y: rect.midY)
        case .center: return CGPoint(x: rect.midX, y: rect.midY)
        case .trailing: return CGPoint(x: rect.maxX, y: rect.midY)
            
        case .bottomLeading: return CGPoint(x: rect.minX, y: rect.maxY)
        case .bottom: return CGPoint(x: rect.midX, y: rect.maxY)
        case .bottomTrailing: return CGPoint(x: rect.maxX, y: rect.maxY)
        default: return CGPoint(x: rect.minX, y: rect.minY)
        }
        
    }

    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: cgPointTranslator(alignment: stratPoint, rect: rect))
            path.addLine(to: cgPointTranslator(alignment: endPoint, rect: rect))
        }
    }
    
}
