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

 
 
 /*
 extension View {
     func detailOverlays(detailManager: DetailViewManager, persistentStore: PersistentStore) -> some View {
         
         //@Published var showAddItem: Bool = false
         //@Published var showModifyItem: Bool = false
         //@Published var showItemDetail: Bool = false
         //@Published var showAddItemFromShed: Bool = false
         //@Published var showAddItemFromBrand: Bool = false
         
         if detailManager.showAddItem {
             return self
                 
         }
         
         /*
         // Add Item
          .overlay(detailManager.showAddItem ? (AddItemView(persistentStore: persistentStore, standard: true).environmentObject(detailManager)): nil)
         // Add item with selected shed initialized
         .overlay(detailManager.showAddItemFromShed ?
                  (AddItemView(persistentStore: persistentStore, shedIn: detailManager.selectedShed!)
                     .environmentObject(detailManager)
                  ) : nil
         )
         // Add item with selected brand initialized
         .overlay(detailManager.showAddItemFromBrand ?
                  (AddItemView(persistentStore: persistentStore, brandIn: detailManager.selectedBrand!)
                     .environmentObject(detailManager)
                  ) : nil
         )
         
         // Item detail view
         .overlay(detailManager.showItemDetail ?
                  (ItemDetailView(persistentStore: persistentStore, item: detailManager.selectedItem!)
                     .environmentObject(detailManager)
                  ) : nil
         )
         // Modify Item View
         .overlay(detailManager.showModifyItem ?
                  (ModifyItemView(persistentStore: persistentStore, editableItem: detailManager.selectedItem!)
                     .environmentObject(detailManager)
                  ) : nil
         )
         // Item Diary DetailView
         .overlay(detailManager.showItemDiaryDetail ?
                  (ItemDiaryDetailView(diary: detailManager.selectedItemDiary!)
                     .environmentObject(detailManager)
                  ) : nil
         )
         // MARK: SHED Stuff -----------------------------------
         // Standard add shed.
         .overlay(detailManager.showAddShed ?
                  (AddShedView(persistentStore: persistentStore)
                     .environmentObject(detailManager)
                  ) : nil
         )
         // Modify Shed view
         .overlay(detailManager.showModifyShed ?
                  (ModifyShedView(persistentStore: persistentStore, shed: detailManager.selectedShed!)
                     .environmentObject(detailManager)
                  ) : nil
         )
         // MARK: Brand Stuff -----------------------------------
         // Standard Add Brand
         .overlay(detailManager.showAddBrand ?
                  (AddBrandView(persistentStore: persistentStore)
                     .environmentObject(detailManager)
                  ) : nil
         )
         // Modify Brand View
         .overlay(detailManager.showModifyBrand ?
                  (ModifyBrandView(persistentStore: persistentStore, brand: detailManager.selectedBrand!)
                     .environmentObject(detailManager)
                  ) : nil
         )
         // MARK: Adventure Stuff -------------------------------------
         // Standard Add New Adventure
         .overlay(detailManager.showAddAdventure ?
                  (AddAdventureView(persistentStore: persistentStore)
                     .environmentObject(detailManager)
                  ) : nil
         )
         // Modify existing Adventure
         .overlay(detailManager.showModifyAdventure ?
                  (ModifyAdventureView(persistentStore: persistentStore, adventure: detailManager.selectedGearlist!)
                     .environmentObject(detailManager)
                  ) : nil
         )
         // MARK: Activity Stuff -------------------------------------
         // Standard add Activity
         .overlay(detailManager.showAddActivity ?
                  (AddActivityView(persistentStore: persistentStore)
                     .environmentObject(detailManager)
                  ) : nil
         )
         // Add Activity from type
         .overlay(detailManager.showAddActivityFromActivityType ?
                  (AddActivityView(persistentStore: persistentStore, activityTypeIn: detailManager.selectedActivityType!)
                     .environmentObject(detailManager)
                  ) : nil
         )
         // Modify existing Adventure
         .overlay(detailManager.showModifyActivity ?
                  (ModifyActivityView(persistentStore: persistentStore, activity: detailManager.selectedGearlist!)
                     .environmentObject(detailManager)
                  ) : nil
         )
         // MARK: Activity Type Stuff -------------------------------------
         // Add new Activity Type
         .overlay(detailManager.showAddActivityType ?
                  (AddActivityTypeView(persistentStore: persistentStore)
                     .environmentObject(detailManager)
                  ) : nil
         )
         // Modify Existing Activity Type
         .overlay(detailManager.showModifyActivityType ?
                  (ModifyActivityTypeView(persistentStore: persistentStore, activityType: detailManager.selectedActivityType!)
                     .environmentObject(detailManager)
                  ) : nil
         )
         // MARK: Gearlist Detail View Stuff --------------------------------------
         // Gearlist Detail View
         .overlay(detailManager.showGearlistDetail ?
                  (GearlistDetailView (persistentStore: persistentStore, gearlist: detailManager.selectedGearlist!)
                     .environmentObject(persistentStore)
                     .environmentObject(detailManager)
                  ) : nil
         )
         // Add Item Diary View
         .overlay(detailManager.showAddItemDiary ?
                  (AddItemDiaryView(persistentStore: persistentStore, gearlist: detailManager.selectedGearlist!)
                     .environmentObject(detailManager)
                  ) : nil
         )
         // Modify Item Diary View
         .overlay(detailManager.showModifyItemDiary ?
                  (ModifyItemDiaryView(persistentStore: persistentStore, diary: detailManager.selectedItemDiary!)
                     .environmentObject(detailManager)
                  ) : nil
         )
         // Select items to add/ remove from gearlist view
         .overlay(detailManager.showAddItemsToGearlist ?
                  (AddItemsToGearListView(persistentStore: persistentStore, type: .gearlistItem, gearlist: detailManager.selectedGearlist!)
                     .environmentObject(detailManager)
                  ) : nil
         )
         // MARK: Pile Stuff -----------------------------------------
         // Add new Pile View
         .overlay(detailManager.showAddCluster ?
                  (AddClusterView(persistentStore: persistentStore, gearlist: detailManager.selectedGearlist!)
                     .environmentObject(detailManager)
                  ) : nil
         )
         // Modify pile name view
         .overlay(detailManager.showModifyCluster ?
                  (EditClusterView(persistentStore: persistentStore, cluster: detailManager.selectedCluster!)
                     .environmentObject(detailManager)
                  ) : nil
         )
         // Select items to add/remove from pile view
         .overlay(detailManager.showAddItemsToCluster ?
                  (AddItemsToGearListView(persistentStore: persistentStore, type: .pileItem, gearlist: detailManager.selectedGearlist!, pile: detailManager.selectedCluster!)
                     .environmentObject(detailManager)
                  ) : nil
         )
         // MARK: Pack Stuff -----------------------------------------
         // Add new Pack view
         .overlay(detailManager.showAddContainer ?
                  (AddContainerView(persistentStore: persistentStore, gearlist: detailManager.selectedGearlist!)
                     .environmentObject(detailManager)
                  ) : nil
         )
         // Edit pack name view
         .overlay(detailManager.showModifyContainer ?
                  (EditContainerView(persistentStore: persistentStore, container: detailManager.selectedContainer!)
                     .environmentObject(detailManager)
                  ) : nil
         )
         // Select items to add/remove from pack
         .overlay(detailManager.showAddItemsToContainer ?
                  (AddItemsToGearListView(persistentStore: persistentStore, type: .packItem, gearlist: detailManager.selectedGearlist!, pack: detailManager.selectedContainer!)
                     .environmentObject(detailManager)
                  ) : nil
         )
         // MARK: Generic Overlay Views -----------------------------------------
         // First layer content
         .overlay(detailManager.showContent ? detailManager.content.animation(.default, value: detailManager.showContent) : nil)
         // Second layer content
         .overlay(detailManager.showSecondaryContent ? detailManager.secondaryContent.animation(.default, value: detailManager.showSecondaryContent) : nil)*/
     }
 }
 */

 
 /*
 struct AppTabBarView: View {
     
     @EnvironmentObject var persistentStore: PersistentStore
         
     @State var tabInt: Double = 0
     
     @State var offset: CGFloat = 0

     @State var tabOffset: CGFloat = 0

     var body: some View {
         ZStack {
             backgroundLayer
             tabLayer
             contentLayer
         }
     }
 }

 extension AppTabBarView {
     
     private var backgroundLayer: some View {
         Color.theme.background
             .ignoresSafeArea()
     }
     
     private var tabLayer: some View {
         VStack {
             Spacer()
             HStack (spacing: 50) {
                 gearShedButton
                 gearListButton
                 //gearPlanButton
             }
             .frame(maxWidth: .infinity)
             .frame(height: 30)
         }
         .edgesIgnoringSafeArea(.top)
         .padding(.bottom, 20)
         .background(Color.theme.green)
     }
     
     private var contentLayer: some View {
         VStack {
             PagerTabView1(selection: $tabInt, offset: $offset, tabOffset: $tabOffset) {
                 
                 NavigationView { GearShedView(persistentStore: persistentStore) }
                 .navigationViewStyle(.stack)
                 //.navigationViewStyle(.stack)
                     .pageView(ignoresSafeArea: true)
                 
                 NavigationView { GearlistView(persistentStore: persistentStore) }
                 .navigationViewStyle(.stack)
                 //.navigationViewStyle(.stack)
                     .pageView(ignoresSafeArea: true)
                 
                 /*NavigationView { ImageView1() }
                     .pageView(ignoresSafeArea: true)*/
             }
             .frame(maxWidth: .infinity)
         }
         .padding(.bottom, 60)
         .edgesIgnoringSafeArea(.top)
     }
     
     private var gearShedButton: some View {
         VStack (alignment: .center, spacing: 1) {
             Image(systemName: "house")
             Text("Gear Shed")
                 .formatNoColorSmall()
         }
         .onTapGesture {
             let newOffset = CGFloat(0) * getScreenBounds().width
             self.offset = newOffset
         }
         .foregroundColor (
             (-1 <= tabInt && tabInt <= 0.30) ?  Color.white : Color.theme.accent
         )
     }

     private var gearListButton: some View {
         VStack (alignment: .center, spacing: 1) {
             Image(systemName: "list.bullet.rectangle")
             Text("Gear List")
                 .formatNoColorSmall()
         }
         .onTapGesture {
             let newOffset = CGFloat(1) * getScreenBounds().width
             self.offset = newOffset
         }
         .foregroundColor (
             (0.31 <= tabInt && tabInt <= 1) ? Color.white : Color.theme.accent
         )

     }
     
     private var gearPlanButton: some View {
         VStack (alignment: .center, spacing: 0) {
             Text("Gear Plan")
                 .formatNoColorSmall()
         }
         .onTapGesture {
             let newOffset = CGFloat(2) * getScreenBounds().width
             self.offset = newOffset
         }
         .foregroundColor (
             (0.50 <= tabInt && tabInt <= 1) ? Color.white : Color.black
         )

     }
     
 }


 // Specify the decimal place to round to using an enum
 public enum RoundingPrecision {
     case ones
     case tenths
     case hundredths
 }

 // Round to the specific decimal place
 public func preciseRound(
     _ value: Double,
     precision: RoundingPrecision = .ones) -> Double
 {
     switch precision {
     case .ones:
         return round(value)
     case .tenths:
         return round(value * 10) / 10.0
     case .hundredths:
         return round(value * 100) / 100.0
     }
 }
 */
 
 
 
 
 
 
 /*
  
  
  struct LaunchAnimation_Previews: PreviewProvider {
      static var previews: some View {
          LaunchAnimation()
              .preferredColorScheme(.light)
      }
  }

  
  struct ShedRoof: Shape {
      func path(in rect: CGRect) -> Path {
          var path = Path()
          path.move(to: CGPoint(x: rect.maxX, y: rect.maxY + 15))
          path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
          path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY + 15))
          path.move(to: CGPoint(x: rect.minX, y: rect.maxY + 15))
          path.closeSubpath()
          return path
      }
  }
  
  /*VStack {
      GeometryReader { geo in
          let centerX = geo.frame(in: .local).midX
          let centerY = geo.frame(in: .local).midY
          ShedRoof()
              .stroke(Color.theme.green, style: StrokeStyle(lineWidth: 17, lineJoin: .round))
              .frame(width: 220, height: 40)
              //
              .position(x: centerX, y: centerY - 80)
              //.offset(y: moveIt ? -410 : 0)
      
          Text("GEAR")
              .font(.custom("HelveticaNeue", size: 65).bold().italic())
              .position(x: centerX, y: centerY)
              //
          
          Text("SHED")
              .font(.custom("HelveticaNeue", size: 65).bold().italic())
              .position(x: centerX, y: centerY + 70)
              //.offset(x: moveIt ? 0 : 330)
      }
      .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
  }*/
  struct Example7: View {
      @State private var moveIt = false

      var body: some View {
          let animation = Animation.easeInOut(duration: 1.0)

          return VStack {
              LabelView(text: "The SwiftUI Lab", offset: moveIt ? 120 : -120, pct: moveIt ? 1 : 0, backgroundColor: .red)
                  .animation(animation)

              LabelView(text: "The SwiftUI Lab", offset: moveIt ? 120 : -120, pct: moveIt ? 1 : 0, backgroundColor: .orange)
                  .animation(animation.delay(0.1))

              LabelView(text: "The SwiftUI Lab", offset: moveIt ? 120 : -120, pct: moveIt ? 1 : 0, backgroundColor: .yellow)
              .animation(animation.delay(0.2))

              LabelView(text: "The SwiftUI Lab", offset: moveIt ? 120 : -120, pct: moveIt ? 1 : 0, backgroundColor: .green)
                  .animation(animation.delay(0.3))

              LabelView(text: "The SwiftUI Lab", offset: moveIt ? 120 : -120, pct: moveIt ? 1 : 0, backgroundColor: .blue)
                  .animation(animation.delay(0.4))

              LabelView(text: "The SwiftUI Lab", offset: moveIt ? 120 : -120, pct: moveIt ? 1 : 0, backgroundColor: .purple)
              .animation(animation.delay(0.5))

              LabelView(text: "The SwiftUI Lab", offset: moveIt ? 120 : -120, pct: moveIt ? 1 : 0, backgroundColor: .pink)
              .animation(animation.delay(0.6))

              Button(action: { self.moveIt.toggle() }) { Text("Animate") }.padding(.top, 50)
          }
          .onTapGesture { self.moveIt.toggle() }
          .navigationBarTitle("Example 7")

      }
  }
  
  
  HStack {
      VStack (alignment: .center, spacing: -7) {
          Text("GE ")
              .font(.custom("HelveticaNeue", size: 65).bold().italic())
          Text("SH ")
              .font(.custom("HelveticaNeue", size: 65).bold().italic())
      }
      .position(x: centerX - 37, y: centerY + 35)
      
      
      VStack (alignment: .center, spacing: -7)  {
          HStack (spacing: 0) {
              Text("i")
                  .opacity(0.0)
              Text(" AR")
                  .font(.custom("HelveticaNeue", size: 65).bold().italic())
          }
          Text(" ED")
              .font(.custom("HelveticaNeue", size: 65).bold().italic())
      }
      .position(x: centerX - 164, y: centerY + 35)
      .offset(x: moveIt ? 210 : 0)
  }
  .opacity(appear ? 1 : 0)

  struct LabelView: View {
      let text: String
      var offset: CGFloat
      var pct: CGFloat
      let backgroundColor: Color

      var body: some View {

          Text("The SwiftUI Lab")
              .font(.headline)
              .padding(5)
              .background(RoundedRectangle(cornerRadius: 5).foregroundColor(backgroundColor))
              .foregroundColor(Color.black)
              .modifier(SkewedOffset(offset: offset, pct: pct, goingRight: offset > 0))

      }
  }
  
  
  VStack (alignment: .center, spacing: 15) {
      VStack {
          HStack {
              Button {
                  withAnimation(.spring()) {
                      //self.firstLaunch = true
                      intialRoofPosition = UIScreen.main.bounds.midY //+ 50
                  }
              } label: {
                  Text("Start")
              }
              Button {
                  withAnimation() {
                      self.firstLaunch = false
                  }
              } label: {
                  Text("End")
              }
          }
          Spacer()
      }
      
      ShedRoof()
          .stroke(Color.theme.green, style: StrokeStyle(lineWidth: 17, lineJoin: .round))
          .frame(width: 220, height: 40)
          //.offset(intialRoofPosition)
          .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true).speed(4))
      
      
      if self.firstLaunch == true {
          ShedRoof()
              .stroke(Color.theme.green, style: StrokeStyle(lineWidth: 17, lineJoin: .round))
              .frame(width: 220, height: 40)
              .offset(y: intialRoofPosition)
              //.transition(AnyTransition.move(edge: .top).combined(with: .opacity))
              //.transition(.offset(x: , y: ))
              //.transition(AnyTransition.move(edge: .top))
      }
      
      if self.firstLaunch == true {
          VStack (alignment: .center, spacing: 0) {
              HStack {
                  VStack {
                      
                  }
                  VStack {
                      
                  }
              }
              Text("GEAR")
                  .font(.custom("HelveticaNeue", size: 65).bold().italic())
                  
                  //.transition(.offset(x: minX - 10))
              Text("SHED")
                  .font(.custom("HelveticaNeue", size: 65).bold().italic())
                  //.transition(.slide)

                  //.transition(.offset(x: maxX + 10))
          }
          .transition(.slide)
          
      }
      
      
  }
  .animation(.spring())
  .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          withAnimation(.spring()) {
              self.firstLaunch = true
          }
      }
      
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
          withAnimation (.easeOut) {
              self.firstLaunch = false
          }
      }
   }
  
  
  VStack {
          GeometryReader { geo in
              let centerX = geo.frame(in: .local).midX
              let centerY = geo.frame(in: .local).midY
              
              
              
              ShedRoof()
                  .stroke(Color.theme.green, style: StrokeStyle(lineWidth: 17, lineJoin: .round))
                  .frame(width: 220, height: 40)
                  .position(x: centerX, y: centerY - 80)
              
              Text("GEAR")
                  .font(.custom("HelveticaNeue", size: 65).bold().italic())
                  .position(x: centerX, y: centerY)
              
              Text("SHED")
                  .font(.custom("HelveticaNeue", size: 65).bold().italic())
                  .position(x: centerX, y: centerY + 70)
              
              HStack {
                  Text("GE ")
                      .font(.custom("HelveticaNeue", size: 65).bold().italic())
                      .position(x: centerX - 37, y: centerY)
                  Text(" AR")
                      .font(.custom("HelveticaNeue", size: 65).bold().italic())
                      .position(x: centerX - 162, y: centerY)
              }
              HStack {
                  Text("SH ")
                      .font(.custom("HelveticaNeue", size: 65).bold().italic())
                      .position(x: centerX - 37, y: centerY + 70)
                  Text(" ED")
                      .font(.custom("HelveticaNeue", size: 65).bold().italic())
                      .position(x: centerX - 163, y: centerY + 70)
              }
              
              
          }
          .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
  }
  .opacity(0.2)
  
  
  Rectangle()
      .frame(width: 2, height: 800, alignment: .center)
      .opacity(0.4)
  Rectangle()
      .frame(width: 500, height: 2, alignment: .center)
      .opacity(0.4)
  
  
  struct Arc: Shape {
      var startAngle: Angle
      var endAngle: Angle
      var clockwise: Bool

      func path(in rect: CGRect) -> Path {
          let rotationAdjustment = Angle.degrees(90)
          let modifiedStart = startAngle - rotationAdjustment
          let modifiedEnd = endAngle - rotationAdjustment

          var path = Path()
          path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)

          return path
      }
  }

  struct Star: Shape {
      // store how many corners the star has, and how smooth/pointed it is
      let corners: Int
      let smoothness: CGFloat
      
      func path1(in rect: CGRect) -> Path {
          
          let top = CGPoint(x: rect.width / 2, y: rect.maxY)
          let start = CGPoint(x: rect.width / 2, y: rect.maxY - rect.height / 4)
          
          var path = Path()
          
          path.move(to: top)
          path.addLine(to: start)
          
          return path
      }

      func path(in rect: CGRect) -> Path {
          // ensure we have at least two corners, otherwise send back an empty path
          guard corners >= 2 else { return Path() }

          // draw from the center of our rectangle
          let center = CGPoint(x: rect.width / 2, y: rect.height / 2)

          // start from directly upwards (as opposed to down or to the right)
          var currentAngle = -CGFloat.pi / 2

          // calculate how much we need to move with each star corner
          let angleAdjustment = .pi * 2 / CGFloat(corners * 2)

          // figure out how much we need to move X/Y for the inner points of the star
          let innerX = center.x * smoothness
          let innerY = center.y * smoothness

          // we're ready to start with our path now
          var path = Path()

          // move to our initial position
          path.move(to: CGPoint(x: center.x * cos(currentAngle), y: center.y * sin(currentAngle)))

          // track the lowest point we draw to, so we can center later
          var bottomEdge: CGFloat = 0

          // loop over all our points/inner points
          for corner in 0..<corners * 2  {
              // figure out the location of this point
              let sinAngle = sin(currentAngle)
              let cosAngle = cos(currentAngle)
              let bottom: CGFloat

              // if we're a multiple of 2 we are drawing the outer edge of the star
              if corner.isMultiple(of: 2) {
                  // store this Y position
                  bottom = center.y * sinAngle

                  // …and add a line to there
                  path.addLine(to: CGPoint(x: center.x * cosAngle, y: bottom))
              } else {
                  // we're not a multiple of 2, which means we're drawing an inner point

                  // store this Y position
                  bottom = innerY * sinAngle

                  // …and add a line to there
                  path.addLine(to: CGPoint(x: innerX * cosAngle, y: bottom))
              }

              // if this new bottom point is our lowest, stash it away for later
              if bottom > bottomEdge {
                  bottomEdge = bottom
              }

              // move on to the next corner
              currentAngle += angleAdjustment
          }

          // figure out how much unused space we have at the bottom of our drawing rectangle
          let unusedSpace = (rect.height / 2 - bottomEdge) / 2

          // create and apply a transform that moves our path down by that amount, centering the shape vertically
          let transform = CGAffineTransform(translationX: center.x, y: center.y + unusedSpace)
          return path.applying(transform)
      }
  }
  
  HStack {
      Button {
          withAnimation(.easeIn(duration: 1)) {
              self.appear = true
              //self.moveIt = true
              //self.offsetL = 0
              //self.offsetR = 0
          }
      } label: {
          Text("Start")
      }
      Button {
          withAnimation(.easeOut(duration: 1)) {
              //self.dim = false
              self.moveIt = true
              //self.offsetL = 120
              //self.offsetR = 120
          }
      } label: {
          Text("End")
      }
      
      Button {
          withAnimation(.easeOut(duration: 1)) {
              self.appear = false
              self.moveIt = false
              //self.offsetL = 120
              //self.offsetR = 120
          }
      } label: {
          Text("Reset")
      }
  }
  .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 50)
  
  
  //let minX = UIScreen.main.bounds.minX
  //let maxX = UIScreen.main.bounds.maxX
  //Intial Roof Position
  //@State var intialRoofPosition: CGPoint = (x:UIScreen.main.bounds.midX, y: UIScreen.main.bounds.minY)
  //@State private var firstLaunch: Bool = false
  //@State private var half: Bool = false
  @State var offsetL: CGFloat = 0
  @State var offsetR: CGFloat = 0
  //@State var pct: CGFloat = 0
  
  struct SkewedOffset: GeometryEffect {
      var offset: CGFloat
      var pct: CGFloat
      let goingRight: Bool

      init(offset: CGFloat, pct: CGFloat, goingRight: Bool) {
          self.offset = offset
          self.pct = pct
          self.goingRight = goingRight
      }

      var animatableData: AnimatablePair<CGFloat, CGFloat> {
          get { return AnimatablePair<CGFloat, CGFloat>(offset, pct) }
          set {
              offset = newValue.first
              pct = newValue.second
          }
      }

      func effectValue(size: CGSize) -> ProjectionTransform {
          var skew: CGFloat

          if pct < 0.2 {
              skew = (pct * 5) * 0.5 * (goingRight ? -1 : 1)
          } else if pct > 0.8 {
              skew = ((1 - pct) * 5) * 0.5 * (goingRight ? -1 : 1)
          } else {
              skew = 0.5 * (goingRight ? -1 : 1)
          }

          return ProjectionTransform(CGAffineTransform(a: 1, b: 0, c: skew, d: 1, tx: offset, ty: 0))
      }
  }
  
  ZStack {
      Text("Hello")
      if appear {
          Color.blue
              .transition(.opacity)
      }
      
  }
  .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          withAnimation(.easeIn(duration: 1)) {
              self.appear = true
          }
          DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
              withAnimation(.easeOut(duration: 1)) {
                  self.appear = false
                  self.moveIt = true
              }
          }
      }
  }
  
  
  */
 
 
 /*VStack (alignment: .center, spacing: 0.5)  {
     Image(systemName: "chevron.up")
         .foregroundColor(gsData.showAll ? Color.theme.green : Color.theme.accent)
     Image(systemName: "chevron.down")
         .foregroundColor(gsData.showAll ? Color.theme.accent : Color.theme.green)
 }*/
 /*private var filterButton: some ToolbarContent {
     ToolbarItem(placement: .navigationBarLeading) {
         Menu {
             Text("Filter by:")
                 .foregroundColor(Color.theme.accent)
             Divider()
             VStack {
                 Button {
                     viewModel.viewFilter = .shed
                     showFilterOptions.toggle()
                 } label: {
                     HStack {
                         Text("Shed").frame(alignment: .center)
                         if viewModel.viewFilter == .shed {
                             Image(systemName: "checkmark")
                                 .foregroundColor(.blue)
                         }
                     }
                     
                 }
                 
                 Button {
                     viewModel.viewFilter = .brand
                     showFilterOptions.toggle()
                 } label: {
                     HStack {
                         Text("Brand").frame(alignment: .center)
                         if viewModel.viewFilter == .brand {
                             Image(systemName: "checkmark")
                                 .foregroundColor(.blue)
                         }
                     }
                 }
                 
                 Button {
                     viewModel.viewFilter = .fav
                     showFilterOptions.toggle()
                 } label: {
                     HStack {
                         Text("Favourite").frame(alignment: .center)
                         if viewModel.viewFilter == .fav {
                             Image(systemName: "checkmark")
                                 .foregroundColor(.blue)
                         }
                     }
                     
                 }
                 
                 Button {
                     viewModel.viewFilter = .regret
                     showFilterOptions.toggle()
                 } label: {
                     HStack {
                         Text("Regret").frame(alignment: .center)
                         if viewModel.viewFilter == .regret {
                             Image(systemName: "checkmark")
                                 .foregroundColor(.blue)
                         }
                     }
                     
                 }
                 
                 Button {
                     viewModel.viewFilter = .wish
                     showFilterOptions.toggle()
                 } label: {
                     HStack {
                         Text("Wish").frame(alignment: .center)
                         if viewModel.viewFilter == .wish {
                             Image(systemName: "checkmark")
                                 .foregroundColor(.blue)
                         }
                     }
                     
                 }
             }
         } label: {
             Image(systemName: "text.magnifyingglass")
                 .resizable()
                 .frame(width: 20, height: 20)
                 .padding(.horizontal, 5)
             }
         
     }
 }

 private var statBar: some View {
     VStack (spacing: 0) {
         HStack (spacing: 20) {
             if viewModel.viewFilter == .shed {
                 HStack {
                     Text("Items:")
                     Text("\(gsData.items.count)")
                 }
                 HStack {
                     Text("Weight:")
                     Text("\(gsData.totalWeight(array: gsData.items))g")
                 }
                 HStack {
                     Text("Invested:")
                     Text("$\(gsData.totalCost(array: gsData.items))")
                 }
             } else if viewModel.viewFilter == .brand {
                 HStack {
                     Text("Items:")
                     Text("\(gsData.items.count)")
                 }
                 HStack {
                     Text("Weight:")
                     Text("\(gsData.totalWeight(array: gsData.items))g")
                 }
                 HStack {
                     Text("Invested:")
                     Text("$\(gsData.totalCost(array: gsData.items))")
                 }
             } else if viewModel.viewFilter == .fav {
                 HStack {
                     Text("Items:")
                     Text("\(gsData.favItems.count)")
                 }
                 HStack {
                     Text("Weight:")
                     Text("\(gsData.totalWeight(array: gsData.favItems))g")
                 }
                 HStack {
                     Text("Invested:")
                     Text("$\(gsData.totalCost(array: gsData.favItems))")
                 }
             } else if viewModel.viewFilter == .regret {
                 HStack {
                     Text("Items:")
                     Text("\(gsData.regretItems.count)")
                 }
                 HStack {
                     Text("Invested:")
                     Text("$\(gsData.totalCost(array: gsData.regretItems))")
                 }
             } else if viewModel.viewFilter == .wish {
                 HStack {
                     Text("Items:")
                     Text("\(gsData.wishListItems.count)")
                 }
                 HStack {
                     Text("Cost:")
                     Text("$\(gsData.totalCost(array: gsData.wishListItems))")
                 }
             }
             Spacer()
         }
         .font(.custom("HelveticaNeue", size: 14))
         .foregroundColor(Color.white)
         .padding(.horizontal)
         .padding(.vertical, 5)
         .background(Color.theme.green)
     }
 }

 private var content: some View {
     VStack {
         if viewModel.viewFilter == .shed {
             ShedItemsView()
                 .environmentObject(gsData)
         } else if viewModel.viewFilter == .brand {
             BrandItemsView()
                 .environmentObject(gsData)
         } else if viewModel.viewFilter == .fav {
             FavsView()
                 .environmentObject(gsData)
         } else if viewModel.viewFilter == .regret {
             RegretsView()
                 .environmentObject(gsData)
         } else if viewModel.viewFilter == .wish {
             WishesView()
                 .environmentObject(gsData)
         }
     }
 }

 // Stress Test

  
  private func navTitle() -> String {
      var title: String = ""
      
      if viewModel.viewFilter == .shed {
          title = "Gear Shed"
      }
      if viewModel.viewFilter == .brand {
          title = "Brand"

      }
      if viewModel.viewFilter == .fav {
          title = "Favourite"

      }
      if viewModel.viewFilter == .regret {
          title = "Regret"
      }
      if viewModel.viewFilter == .wish {
          title = "Wishlist"
      }
      
      return title
  }
  
  */
 
 
 /*List {
     ForEach(gsData.sectionByShed(itemArray: gsData.wishListItems)) { section in
         Section {
             ForEach(section.items) { item in
                 ItemRowView(item: item)
             }
         } header: {
             HStack {
                 Text(section.title).textCase(.none)
                     .font(.custom("HelveticaNeue", size: 16.5).bold())
                 Spacer()
             }
             
         }
     }
 }
 .listStyle(.plain)*/
 
 /*List {
     ForEach(gsData.sectionByShed(itemArray: gsData.favItems)) { section in
         Section {
             ForEach(section.items) { item in
                 ItemRowView(item: item)
             }
         } header: {
             HStack {
                 Text(section.title).textCase(.none)
                     .font(.custom("HelveticaNeue", size: 16.5).bold())
                 Spacer()
             }
             
         }
     }
 }
 .listStyle(.plain)*/


 /*List {
     ForEach(gsData.sectionByShed(itemArray: gsData.regretItems)) { section in
         Section {
             ForEach(section.items) { item in
                 ItemRowView(item: item)
             }
         } header: {
             HStack {
                 Text(section.title).textCase(.none)
                     .font(.custom("HelveticaNeue", size: 16.5).bold())
                 Spacer()
             }
             
         }
     }
 }
 .listStyle(.plain)*/
 
 /*List {
     ForEach(gsData.sectionByShed(itemArray: gsData.regretItems)) { section in
         Section {
             ForEach(section.items) { item in
                 ItemRowView(item: item)
             }
         } header: {
             HStack {
                 Text(section.title).textCase(.none)
                     .font(.custom("HelveticaNeue", size: 16.5).bold())
                 Spacer()
             }
             
         }
     }
 }
 .listStyle(.plain)*/
 
 /*if (persistentStore.stateUnit == "g") {
     if (Int(item.weight) ?? 0 > 0) {
         Text("\(item.weight) g")
             .formatItemWeightBlack()
     }
 }
 
 if (persistentStore.stateUnit == "lb + oz") {
     if (Int(item.itemLbs) ?? 0 > 0 || Double(item.itemOZ) ?? 0.0 > 0.0) {
         Text("\(item.itemLbs) lbs \(item.itemOZ) oz")
             .formatItemWeightBlack()
     }
 }*/
 
 /*if (persistentStore.stateUnit == "g") {
     Text("\(item.weight) g")
         .formatItemWeightBlack()
     /*if (item.itemLbs.isEmpty && item.itemOZ.isEmpty) {
         
     } else {
         let weight = persistentStore.convertImpToMetric(lbs: item.itemLbs, oz: item.itemOZ)
         Text("\(weight) g")
             .formatItemWeightBlack()
     }*/
 }
 
 if (persistentStore.stateUnit == "lb + oz") {
     Text("\(item.itemLbs) lbs \(item.itemOZ) oz")
         .formatItemWeightBlack()
     /*if (item.weight.isEmpty) {
     } else {
         let weight = persistentStore.convertMetricToImp(value: item.weight)
         let lbs = weight.lbs
         let ozText = String(format: "%.2f", weight.oz)
         Text("\(lbs) lbs \(ozText) oz")
             .formatItemWeightBlack()
     }*/
 }*/
 
 
 /* Discussion

 update 25 December: better reorganization and removal of previous misconceptions!

 (1) Fronting of Core Data Attributes

 Notice that all except one of the Core Data attributes on an Item in the
 CD model appear with an underscore (_) at the end of their name.
 (the only exception is "id" because tweaking that name is a problem due to
 conformance to Identifiable.)

 my general theory of the case is that no one outside of this class (and its Core
 Data based brethren, like Shed+Extensions.swift and DataController.swift) should really
 be touching these attributes directly -- and certainly no SwiftUI views should
 ever touch these attributes directly.

 therefore, i choose to "front" each of them in this file, as well as perhaps provide
 other computed properties of interest.

 doing so helps smooth out the awkwardness of nil-coalescing (we don't want SwiftUI views
 continually writing item.name ?? "Unknown" all over the place); and in the case of an
 item's quantity, "fronting" its quantity_ attribute smooths the transition from
 Int32 to Int.  indeed, in SwiftUI views, these Core Data objects should
 appear just as objects, without any knowledge that they come from Core Data.

 we do allow SwiftUI views to write to these fronted properties; and because we front them,
 we can appropriately act on the Core Data side, sometimes performing only a simple Int --> Int32
 conversion.  similarly, if we move an item off the shopping list, we can take the opportunity
 then to timestamp the item as purchased.

 (2) Computed Properties Based on Relationships

 the situation for SwiftUI becomes more complicated when one CD object has a computed property
 based on something that's not a direct attribute of the object.  examples:

     -- an Item has a `shedName` computed property = the name of its associated Shed

     -- a Shed has an `itemCount` computed property = the count of its associated Items.

 for example, if a view holds on to (is a subscriber of) an Item as an @ObservedObject, and if
 we change the name of its associated Shed, the view will not see this change because it
 is subscribed to changes on the Item (not the Shed).

 assuming the view displays the name of the associated shed using the item's shedName,
 we must have the shed tell all of its items that the shedName computed property is now
 invalid and some views may need to be updated, in order to keep such a view in-sync.  thus
 the shed must execute

     items.forEach({ $0.objectWillChange.send() })

 the same holds true for a view that holds on to (is a subscriber of) a Shed as an @ObservedObject.
 if that view displays the number of items for the shed, based on the computed property
 `itemCount`, then when an Item is edited to change its shed, the item must tell both its previous
 and new sheds about the change by executing objectWillChange.send() for those sheds:

     (see the computed var shed: Shed setter below)

 as a result, you may see some code below (and also in Shed+Extensions.swift) where, when
 a SwiftUI view writes to one of the fronted properties of the Item, we also execute
 shed_?.objectWillChange.send().

 (3) @ObservedObject References to Items

 only the SelectableItemRowView has an @ObservedObject reference to an Item, and in development,
 this view (or whatever this view was during development) had a serious problem:

     if a SwiftUI view holds an Item as an @ObservedObject and that object is deleted while the
     view is still alive, the view is then holding on to a zombie object.  (Core Data does not immediately
     save out its data to disk and update its in-memory object graph for a deletion.)  depending on how
     view code accesses that object, your program may crash.

 when you front all your Core Data attributes as i do below, the problem above seems to disappear, for
 the most part, but i think it's really still there.  it's possible that iOS 14.2 and later have done
 something about this ...
     
 anyway, it's something to think about.  in this app, if you show a list of items on the shopping list,
 navigate to an item's detail view, and press "Delete this Item," the row view for the item in the shopping
 list is still alive and has a dead reference to the item.  SwiftUI may try to use that; and if you had
 to reference that item, you should expect that every attribute will be 0 (e.g., nil for a Date, 0 for an
 Integer 32, and nil for every optional attribute).

 */



 // tripCount: computed property from Core Data trips_
 //var listGroupsCount: Int { listgroups_?.count ?? 0 }

 /// Function to return an Items Packing Group In a specifc Gearlist.
 /*func listGroupPackingGroup(gearlist: Gearlist, listGroup: Cluster) -> PackingGroup? {
     // First Filter out all the packingGroups by Gearlist
     let packingGroups = packingGroups.filter({ $0.gearlist == gearlist })
     // Second Filter out all the packingGroups by listGroup
     let packingGroup = packingGroups.first(where: { $0.packingCluster(listGroup: listGroup) == listGroup })
     
     return packingGroup ?? nil
 }*/

 /// Function to return an Items PackingBool in a specific Packing Group.
 /*func packingGroupPackingBool(packingGroup: Container, item: Item) -> PackingBool? {
     // First Filter out all the packingBools by PackingGroup
     let packingBools = packingBools.filter({$0.packingGroup_ == packingGroup })
     // Second return the packingBool associated with the item
     let packingBool = packingBools.first(where: {$0.item == item })
     
     return packingBool ?? nil
 }*/



 /*class func object(withID id: UUID) -> Item? {
     return object(id: id, context: PersistentStore.shared.context) as Item?
 }*/

 // MARK: - Useful Fetch Requests

 /*class func allItemsFR(at shed: Shed, onList: Bool = false) -> NSFetchRequest<Item> {
     let request: NSFetchRequest<Item> = Item.fetchRequest()
     let p1 = NSPredicate(format: "shed_ == %@", shed)
     let p2 = NSPredicate(format: "wishlist_ == %d", onList)
     let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2])
     request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
     request.predicate = predicate
     return request
 }

 class func allItemsFR(at brand: Brand) -> NSFetchRequest<Item> {
     let request: NSFetchRequest<Item> = Item.fetchRequest()
     request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
     request.predicate = NSPredicate(format: "brand_ == %@", brand)
     return request
 }

 static func allItemsFR(at gearlist: Gearlist) -> NSFetchRequest<Item> {
     let request: NSFetchRequest<Item> = Item.fetchRequest()
     request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
     request.predicate = NSPredicate(format: "gearlists_ == %@", gearlist)
     return request
 }

 class func allItemsFR(onList: Bool) -> NSFetchRequest<Item> {
     let request: NSFetchRequest<Item> = Item.fetchRequest()
     request.predicate = NSPredicate(format: "wishlist_ == %d", onList)
     request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
     return request
 }*/

 // MARK: - Class functions for CRUD operations

 // this whole bunch of static functions lets me do a simple fetch and
 // CRUD operations.

 /*class func count() -> Int {
     return count(context: PersistentStore.context)
 }

 class func allItems() -> [Item] {
     return allObjects(context: PersistentStore.shared.context) as! [Item]
 }



 // addNewItem is the user-facing add of a new entity.  since these are
 // Identifiable objects, this makes sure we give the entity a unique id, then
 // hand it back so the user can fill in what's important to them.
 class func addNewItem() -> Item {
     let context = PersistentStore.shared.context
     let newItem = Item(context: context)
     newItem.id = UUID()
     return newItem
 }

 // updates data for an Item that the user has directed from an Add or Modify View.
 // if the incoming data is not associated with an item, we need to create it first
 class func updateData(using editableData: EditableItemData) {
     // if we can find an Item with the right id, use it, else create one
     if let id = editableData.id,
     let item = Item.object(id: id, context: PersistentStore.shared.context) {
         item.updateValues(from: editableData)
     } else {
         let newItem = Item.addNewItem()
         newItem.updateValues(from: editableData)
     }
 }*/



 /*class func moveAllItemsOffWishlist() {
     for item in allItems() where item.wishlist {
         item.wishlist_ = false
     }
 }*/

 // MARK: - Object Methods



 /*private func updateValues(from editableData: EditableItemData) {
     name_ = editableData.name
     detail_ = editableData.details
     quantity_ = Int32(editableData.quantity)
     weight_ = editableData.weight
     price_ = editableData.price
     wishlist_ = editableData.wishlist
     isFavourite_ = editableData.isFavourite
     isRegret_ = editableData.isRegret
     shed = editableData.shed
     brand = editableData.brand
     datePurchased_ = editableData.datePurchased
     
     gearlists.forEach({ $0.objectWillChange.send() })
     
 }*/


 
 */




















/*private var filterButton: some ToolbarContent {
    ToolbarItem (placement: .navigationBarLeading) {
        Menu {
            Button {
                viewFilter = .all
            } label: {
                Text("All")
            }
            
            Button {
                viewFilter = .singleDay
            } label: {
                Text("Single-Day")
            }
            
            Button {
                viewFilter = .multiDay
            } label: {
                Text("Multi-Day")
            }
            
            Button {
                viewFilter = .noDay
            } label: {
                Text("No-Date")
            }
        } label: {
            Image(systemName: "text.magnifyingglass")
        }
    }
    
}

private var statBar: some View {
    HStack (spacing: 20){
        HStack {
            Text("Items:")
            //Text("\(gsData.items.count)")
        }
        HStack {
            Text("Weight:")
            //Text("\(gsData.totalWeight(array: gsData.items))g")
        }
        HStack {
            Text("Invested:")
            //Text("$\(gsData.totalCost(array: gsData.items))")
        }
        Spacer()
    }
    .font(.custom("HelveticaNeue", size: 14))
    .foregroundColor(Color.white)
    .padding(.horizontal)
    .padding(.vertical, 5)
    .background(Color.theme.green)
}

private var content: some View {
    VStack {
        if viewFilter == .all {
            TripView()
        } else if viewFilter == .singleDay {
            TripView()
        } else if viewFilter == .multiDay {
            TripView()
        } else if viewFilter == .noDay {
            ActivityView()
        }
    }
}

private var addButtonOverlay: some View {
    VStack {
        Spacer()
        HStack {
            Spacer()
            Button {
                withAnimation {
                    detailManager.showAddGearlist = true
                }
            }
            label: {
                VStack{
                    Text("Create")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color.theme.background)
                        
                    Text("List")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color.theme.background)
                }
            }
            .frame(width: 55, height: 55)
            .background(Color.theme.accent)
            .cornerRadius(38.5)
            .padding(.bottom, 20)
            .padding(.trailing, 15)
            .shadow(color: Color.theme.accent.opacity(0.3), radius: 3,x: 3,y: 3)
        }
    }
}*/


//@State private var currentScreen: Int = 0

/*PagerTabView(tint: Color.theme.accent, selection: $currentScreen) {
    Text("Activity")
        .pageLabel()
        .font(.system(size: 12).bold())

    Text("Trip")
        .pageLabel()
        .font(.system(size: 12).bold())
} content: {
    ActivityView()
    .pageView(ignoresSafeArea: true, edges: .bottom)
    TripView()
    .pageView(ignoresSafeArea: true, edges: .bottom)
}*/

//@State private var currentSelection: Int = 0

/*PagerTabView(tint: Color.theme.accent, selection: $currentSelection) {
    Text("PERSONAL LIST")
        .pageLabel()
        .font(.system(size: 12).bold())
    Text("GENARIC LIST")
        .pageLabel()
        .font(.system(size: 12).bold())
} content: {
    AllGearLists(persistentStore: persistentStore)
        .pageView(ignoresSafeArea: true, edges: .bottom)
        
    EmptyTripView()
        .pageView(ignoresSafeArea: true, edges: .bottom)
}*/

/*
struct Home : View {
    
    @State var show = false
    @State var txt = ""
    @State var data = ["p1","p2","p3","p4","p5","p6"]
    
    var body : some View{
        
        VStack(spacing: 0){
            
            HStack{
                
                if !self.show{
                    
                     Text("Food")
                        .fontWeight(.bold)
                        .font(.title)
                        .foregroundColor(.white)
                }
                
                Spacer(minLength: 0)
                
                HStack{
                    
                    if self.show{
                        
                        Image("search").padding(.horizontal, 8)
                        
                        TextField("Search Food", text: self.$txt)
                        
                        Button(action: {
                            
                            withAnimation {
                                
                                self.txt = ""
                                self.show.toggle()
                            }
                            
                        }) {
                            
                            Image(systemName: "xmark").foregroundColor(.black)
                        }
                        .padding(.horizontal, 8)
                        
                    }
                    
                    else{
                        
                        Button(action: {
                            
                            withAnimation {
                                
                                self.show.toggle()
                            }
                            
                        }) {
                            
                            Image("search").foregroundColor(.black).padding(10)
                            
                        }
                    }
                }
                .padding(self.show ? 10 : 0)
                .background(Color.white)
                .cornerRadius(20)
                
                
            }
            .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top)! + 15)
            .padding(.horizontal)
            .padding(.bottom, 10)
            .background(Color.orange)
            
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 15){
                    
                    if self.txt != ""{
                        
                        if data.filter({$0.lowercased().contains(self.txt.lowercased())}).count == 0{
                            
                            Text("No Results Found").padding(.top, 10)
                        }
                        else{
                            
                            ForEach(data.filter({$0.lowercased().contains(self.txt.lowercased())}),id: \.self){i in
                                
                                cellView(image: i)
                            }
                        }
                    }
                    
                    else{
                        
                        ForEach(data,id: \.self){i in
                            
                            cellView(image: i)
                        }
                    }

                }
                .padding(.horizontal, 15)
                .padding(.top, 10)
            }
            
            
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct cellView : View {
    
    var image : String
    
    var body : some View {
        
        ZStack(alignment: .bottomTrailing) {
            
            Image(image).resizable().frame(height: 200).cornerRadius(20)
            
            Button(action: {
                
            }) {
                
                Image(systemName: "arrow.right").foregroundColor(.black).padding()
            }
            .background(Color.white)
            .clipShape(Circle())
            .padding()
            
        }
    }
}

class Host: UIHostingController<ContentView> {
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        
        return .lightContent
    }
}
*/
