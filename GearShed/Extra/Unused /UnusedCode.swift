//
//  UnusedCode.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-15.
//
//
/*
 
 //Section 2+3.
 
// Section(header: Text("Shed").sectionHeader()) {
//     Picker(selection: $shedChooser, label: Text("Shed")) //{
//         Text("Choose Shed").tag(0)
//         Text("Create New Shed").tag(1)
//     }
//     .pickerStyle(SegmentedPickerStyle())
//     .onAppear {
//         if (self.sheds.count == 0) {
//             self.shedChooser = 1
//             }
//         }
//
//     // Choose Shed is selected in segemented control
//     if (shedChooser == 0) {
//         Picker(selection: $editableItemData.shed, label: //SLFormLabelText(labelText: "Shed: ")) {
//             ForEach(sheds) { shed in
//                 Text(shed.name).tag(shed)
//             }
//         }
//     }
//     // Create Shed is selected in segmented control
//     if (shedChooser == 1) {
//         HStack {
//             SLFormLabelText(labelText: "Name: ")
//             TextField("Shed name", text: //$editableItemData.shedName)
//         }
//     }
// }
 
 //Section(header: Text("Brand").sectionHeader()) {
 //    Picker(selection: $brandChooser, label: Text("Brand")) {
 //        Text("Choose Brand").tag(0)
 //        Text("Create New Brand").tag(1)
 //    }
 //    .pickerStyle(SegmentedPickerStyle())
 //    .onAppear {
 //        if (self.brands.count == 0) {
 //            self.brandChooser = 1
 //            }
 //        }
 //
 //    // Choose Brand is selected in segemented control
 //    if (brandChooser == 0) {
 //        Picker(selection: $editableItemData.brand, label: //SLFormLabelText(labelText: "Brand: ")) {
 //            ForEach(brands) { brand in
 //                Text(brand.name).tag(brand)
 //            }
 //        }
 //    }
 //    // Create Brand is selected in segmented control
 //    if (brandChooser == 1) {
 //        HStack {
 //            SLFormLabelText(labelText: "Name: ")
 //            TextField("Brand name", text: //$editableItemData.brandName)
 //        }
 //    }
 //}
 //End of Section 2+3.
 
 /*HStack(alignment: .firstTextBaseline) {
     Toggle(isOn: $editableItemData.onList) {
         SLFormLabelText(labelText: "On Shopping List: ")
     }
 }
 
 HStack(alignment: .firstTextBaseline) {
     Toggle(isOn: $editableItemData.isAvailable) {
         SLFormLabelText(labelText: "Is Available: ")
     }
 }
 
 if !editableItemData.dateText.isEmpty {
     HStack(alignment: .firstTextBaseline) {
         SLFormLabelText(labelText: "Last Purchased: ")
         Text("\(editableItemData.dateText)")
     }
 }*/
 
 /*func handleItemTapped(_ item: Item) {
     if !itemsChecked.contains(item) {
         // put the item into our list of what's about to be removed, and because
         // itemsChecked is a @State variable, we will see a momentary
         // animation showing the change.
         itemsChecked.append(item)
         // and we queue the actual removal long enough to allow animation to finish
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.40) {
             item.toggleOnListStatus()
             itemsChecked.removeAll(where: { $0 == item })
         }
     }
 }*/
 
 Brand Visitation order Section
 //if editableData.order != kUnknownBrandVisitationOrder {
 //    Stepper(value: $editableData.order, in: 1...100) {
 //        HStack {
 //            SLFormLabelText(labelText: "Visitation Order: ")
 //            Text("\(editableData.order)")
 //        }
 //    }
 //}
 
 Shed Visitation order section
 
 //if editableData.visitationOrder != kUnknownShedVisitationOrder {
 //    Stepper(value: $editableData.visitationOrder, in: 1...100) {
 //        HStack {
 //            SLFormLabelText(labelText: "Visitation Order: ")
 //            Text("\(editableData.visitationOrder)")
 //        }
 //    }
 //}
 
 //@ViewBuilder
 /*func CardView(story: Story) -> some View {
     VStack(alignment: .leading, spacing: 12) {
         
         // to get screen width
         GeometryReader{ proxy in
             
             let size = proxy.size
             
             Image(story.image)
                 .resizable()
                 .aspectRatio(contentMode: .fill)
                 .frame(width: size.width, height: size.height)
                 .cornerRadius(15)
         }
         .frame(height: 200)
         
         Text(story.title)
             .font(.title2)
             .fontWeight(.semibold)
             .foregroundColor(Color.white.opacity(0.8))
         
         Button(action: {}, label: {
             Text("Read Now")
                 .font(.caption2)
                 .fontWeight(.bold)
                 .foregroundColor(.white)
                 .padding(.vertical, 6)
                 .padding(.horizontal)
                 .background(
                     Capsule()
                         .fill(Color.red)
                 )
         })
     }
 }*/
 
 // Nav bar
 HStack {
     
     
     Spacer()
     
     /*Button(action: {}, label: {
             Image(systemName: "plus")
                 .resizable()
                 .renderingMode(.template)
                 .aspectRatio(contentMode: .fit)
                 .frame(width: 25, height: 25)
                 .shadow(radius: 1)
     })*/
 }
 .overlay(Text("Stories").font(.title2.bold()))
 .foregroundColor(Color.white.opacity(0.8))
 .padding([.horizontal, .top])
 .padding(.bottom,5)
 
 /*ScrollView(.vertical, showsIndicators: false) {
     
     VStack(spacing: 20) {
         // Sample Cards...
         ForEach(stories) { story in
            CardView(story: story)
         }
     }
     .padding()
     .padding(.top, 10)
     
 }*/
 
 struct Blur: UIViewRepresentable {
     
     var style: UIBlurEffect.Style = .systemMaterial
     
     func makeUIView(context: Context) -> UIVisualEffectView {
         return UIVisualEffectView(effect: UIBlurEffect(style: style))
     }
     func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
         uiView.effect = UIBlurEffect(style: style)
     }
 }

 struct BlurModifierSimple: ViewModifier {
     @Binding var showOverlay: Bool
     @State var blurRadius: CGFloat = 10
     
     func body(content: Content) -> some View {
         Group {
             content
                 .blur(radius: showOverlay ? blurRadius : 0)
                 .animation(.easeInOut)
         }
         .frame(maxWidth: .infinity, maxHeight: .infinity)
     }
 }

 struct BlurView: UIViewRepresentable {
     typealias UIViewType = UIVisualEffectView
     
     let style: UIBlurEffect.Style
     
     init(style: UIBlurEffect.Style = .systemMaterial) {
         self.style = style
     }
     
     func makeUIView(context: Context) -> UIVisualEffectView {
         return UIVisualEffectView(effect: UIBlurEffect(style: self.style))
     }
     
     func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
         uiView.effect = UIBlurEffect(style: self.style)
     }
 }
 
 
 
 struct SlideTabView: View {
     
     @State var showMenu: Bool = false
     @State var animatePath: Bool = false
     @State var animateBG: Bool = false

     var body: some View {
         ZStack {
             // Home View..
             VStack (spacing: 15) {
                 
             }
             .frame(maxWidth: .infinity, maxHeight: .infinity)
             .background(
             
                 // Gradient BG...
              LinearGradient(gradient: Gradient(colors: [Color("BG2"), Color("BG1")]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
             ) // Gradient BG
             
             Color.black
                 .opacity(animateBG ? 0.25 : 0)
                 .ignoresSafeArea()
             
             MenuView(showMenu: $showMenu, animatePath: $animatePath, animateBG: $animateBG)
                 .offset(x: showMenu ? 0 : -getRect().width)
         }
         .navigationBarTitle("Home", displayMode: .inline)
         .toolbar {
             ToolbarItem(placement: .navigationBarLeading, content: button)
         }
     }
     
     // a toggle button to change side menu
     func button() -> some View {
             Button(action: {
                 
                 if !showMenu {
                     withAnimation{
                         animateBG.toggle()
                     }
                     withAnimation(.spring()){
                         showMenu.toggle()
                     }
                     // Animating path with little delay...
                     withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.3, blendDuration: 0.3).delay(0.2)) {
                         animatePath.toggle()
                     }
                 } else {
                     // Closing Menu
                     // Animating path with little delay...
                     withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.3, blendDuration: 0.3)) {
                         animatePath.toggle()
                     }
                     withAnimation {
                         animateBG.toggle()
                     }
                     withAnimation(.spring().delay(0.1)) {
                         showMenu.toggle()
                     }
                 }
                 
             }, label: {
                 if !showMenu {
                     Image(systemName: "house")
                         .resizable()
                         .renderingMode(.template)
                         .aspectRatio(contentMode: .fit)
                         .frame(width: 25, height: 25)
                         .shadow(radius: 1)
                 } else {
                     Image(systemName: "xmark.circle")
                         .font(.title)
                 }
             }).foregroundColor(Color.white.opacity(0.8))
     }
 }

 // Menu View..

 struct MenuView: View {
     
     @Binding var showMenu: Bool
     @Binding var animatePath: Bool
     @Binding var animateBG: Bool
     
     var body: some View {
         ZStack {
             
             // Blur View ...
             VisualEffectBlur(blurStyle: .systemUltraThinMaterialDark)
             
             Color(.clear)
                 .opacity(0.7)
                 .blur(radius: 1)
             
             // Content....
             VStack(alignment: .leading, spacing: 25) {
                 // Menu Buttons....
                 MenuButton(title: "Premium Access", image: "square.grid.2x2", offset: 0)
                     .padding(.top, 40)
                 MenuButton(title: "Upload Content", image: "square.and.arrow.up.on.square", offset: 10)
                 
                 MenuButton(title: "My Account", image: "square.grid.2x2", offset: 30)
                 
                 MenuButton(title: "Make Money", image: "dollarsign.circle", offset: 10)
                 
                 MenuButton(title: "Help", image: "questionmark.circle", offset: 0)
                 
                 Spacer(minLength: 10)
                 
                 MenuButton(title: "LogOut", image: "questionmark.circle", offset: 0)
             }
             .padding(.trailing, 120)
             .padding()
             .padding(.top, getSafeArea().top)
             .padding(.bottom, getSafeArea().bottom)
             .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
         }
         .clipShape(MenuShape(value: animatePath ? 15 : 0))
         .background(
             MenuShape(value: animatePath ? 150 : 0)
                 .stroke(
                     LinearGradient(gradient: Gradient(colors: [
                         Color.blue,
                         Color.blue
                             .opacity(0.7),
                         Color.blue
                             .opacity(0.5),
                         Color.clear
                     ]), startPoint: .top, endPoint: .bottom)
                     ,lineWidth: animatePath ? 7 : 1
                 )
                 .padding(.leading, -50)
         )
         .ignoresSafeArea()
     }
     
     @ViewBuilder
     func MenuButton(title: String, image: String, offset: CGFloat)->some View {
         Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
             HStack(spacing: 12) {
                 if image == "Profile" {
                     // Assest Image
                     Image(image)
                         .resizable()
                         .aspectRatio(contentMode: .fill)
                         .frame(width: 50, height: 50)
                         .clipShape(Circle())
                 } else {
                     //SF Image
                     Image(systemName: image)
                         .resizable()
                         .aspectRatio(contentMode: .fill)
                         .frame(width: 25, height: 25)
                         .foregroundColor(.white)
                 }
                 
                 Text(title)
                     .font(.system(size: 17))
                     .fontWeight(title == "LOGOUT" ? .semibold : .medium)
                     .kerning(title == "LOGOUT" ? 1.2 : 0.8)
                     .foregroundColor(Color.white.opacity(title == "LOGOUT" ? 0.9 : 0.65))
             }
             .padding(.vertical)
         })
         .offset(x: offset)
     }
 }

 struct MenuShape: Shape {
     
     var value: CGFloat
     
     // Animating Path
     
     var animatableData: CGFloat {
         get{ return value }
         set{ value = newValue }
     }
     
     func path(in rect: CGRect) -> Path {
         
         return Path{ path in
             
             // For Curve Shape 100
             let width = rect.width - 100
             let height = rect.height
             
             path.move(to: CGPoint(x: width, y: height))
             path.addLine(to: CGPoint(x: 0, y: height))
             path.addLine(to: CGPoint(x: 0, y: 0))
             path.addLine(to: CGPoint(x: width, y: 0))
             
             // Curve...
             
             path.move(to: CGPoint(x: width, y: 0))
             path.addCurve(to: CGPoint(x: width, y: height + 100),
                 control1: CGPoint(x: width + 150, y: height / 3),
                 control2: CGPoint(x: width - 150, y: height / 2))
         }
         
     }
 }

 extension View {
     
     func getSafeArea()->UIEdgeInsets {
         guard let screen =
         UIApplication.shared.connectedScenes.first as?
         UIWindowScene else {
             return .zero
         }
         
         guard let safeArea = screen.windows.first?.safeAreaInsets
             else {
             return .zero
         }
         
         return safeArea
     }
     
     func getRect()->CGRect{
         return UIScreen.main.bounds
     }
 }

 /*struct SlideTabView_Previews: PreviewProvider {
     
     static var previews: some View {
         
         SlideTabView()
         
     }
 }*/


 /// ----------------------------------------------------

 /*ForEach(data,id: \.self){ i in
     
     Button(action: {
         
         self.index = i
         
         withAnimation(.spring()){
             
             self.show.toggle()
         }
         
     }) {
         
         HStack{
             
             Capsule()
             .fill(self.index == i ? Color.orange : Color.clear)
             .frame(width: 5, height: 30)
             
             Text(i)
                 .padding(.leading)
                 .foregroundColor(.black)
             
         }
     }
 }*/
 
 /*HStack {
     
     // Color Bar
     //Color(item.uiColor)
     //    .frame(width: 10, height: 36)
     
     // Name and Brand
     VStack(alignment: .leading) {
         
         
         Text(item.name)
         
         
         Text(item.brandName)
             .font(.caption)
             .foregroundColor(.secondary)
     }
     
     Spacer()
     
     // quantity at the right
     Text("\(item.weight)")
         .font(.headline)
         .foregroundColor(Color.blue)
     
 } */// end of HStack

 // this is the @FetchRequest that ties this view to Core Data Items
 //@FetchRequest(fetchRequest: Item.allItemsFR(onList: true))
 //private var allItems: FetchedResults<Item>

 // display format: one big section of Items, or sectioned by Shed?
 // (not sure we need a Binding here ... we only read the value)
 //@Binding var multiSectionDisplay: Bool
     
 //@StateObject private var viewModel = ItemsViewModel()
 
 // this implements a seemingly well-known strategy to get the list drawn
 // cleanly without any highlighting
//    @Binding var listDisplayID: UUID
 
 /*ScrollView(.horizontal, showsIndicators: false) {
     
     HStack (spacing: 30){
         Text("CATEGORIES")
             .font(.title)
             .bold()
         Text("BRANDS")
             .font(.title)
             .bold()
         Text("TAGS")
             .font(.title)
             .bold()
         Text("WISHLIST")
             .font(.title)
             .bold()
     }
     .padding(.horizontal, 30)
 }*/
 
 /*HStack {
     
     Button {viewModel.isAddNewItemSheetShowing.toggle()} label: {
         Image(systemName: "plus")
             .foregroundColor(Color.theme.accent)
     }
     
     NavigationLink(destination: AllItemsView()) {
         HStack {
             Text("All Items")
                 .font(.headline)
                 .foregroundColor(Color.theme.accent)
             
             Spacer()
                 
             Text("\(viewModel.allItems.count)")
                 .font(.headline)
                 .padding(.horizontal, 30)
         }
     }
 }
 //.padding(.horizontal, 20)
 //.padding(.top, 10)*/
 
 //.navigationBarTitle("All Items", displayMode: .inline)
 //.navigationBarColor(UIColor.blue)
 /*.toolbar {
     ToolbarItem(placement: .navigationBarTrailing, content: viewModel.trailingButtons)
 }*/
 
 func handleOnAppear() {
     // what follows here is a kludge for a very special case:
     // -- we were in the ShoppingListTabView
     // -- we navigate to this Add/ModifyItem view for an Item X at Shed Y
     // -- we use the tab bar to move to the Sheds tab
     // -- we select Shed Y and navigate to its Add/ModifyShed view
     // -- we tap Item X listed for Shed Y, opening a second Add/ModifyItem view for Item X
     // -- we delete Item X in this second Add/ModifyItem view
     // -- we use the tab bar to come back to the shopping list tab, and
     // -- this view is now what's on-screen, showing us an item that was deleted underneath us (!)
     //
     // the only thing that makes sense is to dismiss ourself in the case that we were instantiated
     // with a real item (editableData.id != nil) but that item does not exist anymore.
     
     if editableItemData.representsExistingItem && Item.object(withID: editableItemData.id!) == nil {
         presentationMode.wrappedValue.dismiss()
     }
     
     // by the way, this applies symmetrically to opening an Add/ModifyItem view from the
     // Add/ModifyShed view, then tabbing over to the shopping list, looking at a second
     // Add/ModifyItem view there and deleting.  the first Add/ModifyItem view will get the
     // same treatment in this code, getting dismissed when it tries to come back on screen.
     
     // ADDITIONAL DISCUSSION:
     //
     // apart from the delete operation, when two instances of the Add/ModifyItem view are
     // active, any edits made to item data in one will not be replicated in the other, because
     // these views copy data to their local @State variable editableData, and that is what
     // gets edited.  so if you do a partial edit in one of the views, when you visit the second
     // view, you will not see those changes.  this is a natural side-effect of doing an edit
     // on a draft copy of the data and not doing a live edit.  we are aware of the problem
     // and may look to fix this in the future.  (two strategies come to mind: a live edit of an
     // ObservableObject, which then means we have to rethink combining the add and modify
     // functions; or always doing the Add/Modify view as a .sheet so that you cannot so easily
     // navigate elsewhere in the app and make edits underneath this view.)
     
     // a third possibility offered by user jjatie on 7 Jan, 2021, on the Apple Developer's Forum
     //   https://developer.apple.com/forums/thread/670564
     // suggests tapping into the NotificationCenter to watch for changes in the NSManaged
     // context, and checking to see if the Item is among those in the notification's
     // userInfo[NSManagedObjectContext.NotificationKey.deletedObjectIDs].

 }
 
 //// EDIT CATEGORIES
 //NavigationLink(destination: ShedsTabView()) {
 //    Text("Edit Sheds")
 //    .foregroundColor(Color.blue)
 //    .padding(10)
 //}
 ////EDIT BRANDS
 //NavigationLink(destination: BrandsTabView()) {
 //    Text("Edit Brands")
 //    .foregroundColor(Color.blue)
 //    .padding(10)
 //}
 
 // a toggle button to change section display mechanisms
 //func sectionDisplayButton() -> some View {
 //    Button() { self.multiSectionDisplay.toggle() }
 //    label: { Image(systemName: multiSectionDisplay ? "tray.2" : "tray")
 //            .font(.title2)
 //    }
 //}
 
 // parameters to control triggering an Alert and defining what action
 // to take upon confirmation
 //@State private var confirmDeleteItemAlert: ConfirmDeleteItemAlert?
 
 /* /////////////////////////// */
 //Create a state var for the shed picker section
 //@State private var shedChooser = 0
 //Create a state var for the brand picker section
 //@State private var brandChooser = 0
 /* /////////////////////////// */
 
 // Brand Section
 //Section(header: Text("Brand").sectionHeader()) {
 //    Picker(selection: $editableItemData.brand, label: SLFormLabelText(labelText: "Brand: ")) {
 //        ForEach(brands) { brand in
 //            Text(brand.name).tag(brand)
 //        }
 //    }
 //}
 
 // Shed Section
  //Section(header: Text("Shed").sectionHeader()) {
  //   Picker(selection: $editableItemData.shed, label: SLFormLabelText(labelText: "Shed: ")) {
  //        ForEach(sheds) { shed in
  //            Text(shed.name).tag(shed)
  //      }
  //   }
  //}
 
 // Section 3: Items assigned to this Shed, if we are editing a Shed
 if editableData.representsExistingShed {
     SimpleItemsList(shed: editableData.associatedShed/*,
                                     isAddNewItemSheetShowing: $isAddNewItemSheetShowing*/)
 }
 
 struct SimpleItemsList: View {
     
     @FetchRequest    private var items: FetchedResults<Item>
     @State private var listDisplayID = UUID()
     //@Binding var isAddNewItemSheetShowing: Bool
     
     init(shed: Shed/*, isAddNewItemSheetShowing: Binding<Bool>*/) {
         let request = Item.allItemsFR(at: shed)
         _items = FetchRequest(fetchRequest: request)
         //_isAddNewItemSheetShowing = isAddNewItemSheetShowing
     }
     
     var body: some View {
         Section(header: ItemsListHeader()) {
             ForEach(items) { item in
                 NavigationLink(destination: AddOrModifyItemView(editableItem: item)) {
                     Text(item.name)
                 }
             }
         }
 //        .id(listDisplayID)
         .onAppear { listDisplayID = UUID() }
     }
     
     func ItemsListHeader() -> some View {
         HStack {
             Text("At this Shed: \(items.count) items").sectionHeader()
             Spacer()
             
             //Button {
             //    isAddNewItemSheetShowing = true
             //} label: {
             //    Image(systemName: "plus")
             //        .font(.title2)
             //}
         }
     }
 }
 
 // Local state for if we are a multi-section display or not.  the default here is false,
 // but an eager developer could easily store this default value in UserDefaults (?)
 //@Published var multiSectionDisplay: Bool = true
 
 struct ShedRowViewOld: View {
     var rowData: ShedRowData

     var body: some View {
         HStack {
             // color bar at left (new in this code)
             Color(rowData.uiColor)
                 .frame(width: 10, height: 36)
             
             VStack(alignment: .leading) {
                 Text(rowData.name)
                     .font(.headline)
                 Text(subtitle())
                     .font(.caption)
             }
             if rowData.visitationOrder != kUnknownShedVisitationOrder {
                 //Spacer()
                 //Text(String(rowData.visitationOrder))
             }
         } // end of HStack
     } // end of body: some View
     
     func subtitle() -> String {
         if rowData.itemCount == 1 {
             return "1 item"
         } else {
             return "\(rowData.itemCount) items"
         }
     }
     
 }
 
 // MARK: - ShedRowData Definition
 // this is a struct to transport all the incoming data about a Shed that we
 // will display.  see the commentary over in EditableItemData.swift and
 // SelectableItemRowView.swift about why we do this.
 struct ShedRowData {
     let name: String
     let itemCount: Int
     let visitationOrder: Int
     let uiColor: UIColor
     
     init(shed: Shed) {
         name = shed.name
         itemCount = shed.itemCount
         visitationOrder = shed.visitationOrder
         uiColor = shed.uiColor
     }
 }
 
 // MARK: - BrandRowData Definition
 // this is a struct to transport all the incoming data about a Brand that we
 // will display.  see the commentary over in EditableItemData.swift and
 // SelectableItemRowView.swift about why we do this.
 struct BrandRowData {
     let name: String
     let itemCount: Int
     let order: Int
     
     init(brand: Brand) {
         name = brand.name
         itemCount = brand.itemCount
         order = brand.order
     }
 }

 // MARK: - BrandRowView

 struct BrandRowViewOld: View {
      var rowData: BrandRowData

     var body: some View {
         HStack {
             VStack(alignment: .leading) {
                 Text(rowData.name)
                     .font(.headline)
                 Text(subtitle())
                     .font(.caption)
             }
             if rowData.order != kUnknownBrandVisitationOrder {
                 //Spacer()
                 //Text(String(rowData.order))
             }
         } // end of HStack
     } // end of body: some View
     
     func subtitle() -> String {
         if rowData.itemCount == 1 {
             return "1 item"
         } else {
             return "\(rowData.itemCount) items"
         }
     }
     
 }
 
 x// MARK: CustomPopOverz
 
 struct PopOverView: View {
     
     @State var graphicalDate: Bool = false
     @State var showPicker: Bool = false
     
     @State var show: Bool = false
     
     var colors = ["Red", "Green", "Blue", "Tartan"]
     
     @State private var selectedColor = "Red"
     
     var body: some View {
         
         NavigationView{
             
             List {
                 
                 Toggle(isOn: $showPicker) {
                     Text("Show Picker")
                 }
                 
                 Toggle(isOn: $graphicalDate) {
                     Text("Show Graphical Data Picker")
                 }
             }
             .navigationTitle("Popovers")
             .toolbar {
                 ToolbarItem(placement: .navigationBarLeading) {
                     Button {
                         withAnimation {
                             show.toggle()
                         }
                     } label: {
                         Image(systemName: "slider.horizontal.below.square.fill.and.square")
                     }
                 }
             }
             
         }
         .toolBarPopover(show: $show, placement: .leading) {
             Picker("Please choose a color", selection: $selectedColor) {
                 ForEach(colors, id: \.self) {
                     Text($0)
                 }
             }
         }
     }
 }

 extension View {
     
     func toolBarPopover<Content: View>(show: Binding<Bool>,placement: Placement = .leading ,@ViewBuilder content: @escaping ()->Content)->some View {
         self
             .frame(maxWidth: .infinity, maxHeight: .infinity)
             .overlay(
             
                 ZStack {
                     if show.wrappedValue {
                         content()
                             .padding()
                             .background(Color.white.clipShape(PopOverArrowShape(placement: placement)))
                             .shadow(color: Color.primary.opacity(0.05), radius: 5, x: 5, y: 5)
                             .shadow(color: Color.primary.opacity(0.05), radius: 5, x: -5, y: -5)
                             .padding(.horizontal, 35)
                             // Moving from top...
                             // Approx NavBar Height....
                             .offset(y: 25)
                             .offset(x: placement == .leading ? -20 : 20)
                         
                     }
                 }, alignment: placement == .leading ? .topLeading : .topTrailing
             )
     }
 }

 enum Placement{
     case leading
     case trailing
 }

 struct PopOverArrowShape: Shape {
     
     var placement: Placement
     
     func path(in rect: CGRect) -> Path {
         return Path{path in
         
             let pt1 = CGPoint(x: 0, y: 0)
             let pt2 = CGPoint(x: 50, y: 50)
             let pt3 = CGPoint(x: rect.width, y: rect.height)
             let pt4 = CGPoint(x: 0, y: rect.height)
         
             // Drawing Arcs with raduis..
             path.move(to: pt4)
             path.addArc(tangent1End: pt1, tangent2End: pt2, radius: 15)
             path.addArc(tangent1End: pt2, tangent2End: pt3, radius: 15)
             path.addArc(tangent1End: pt3, tangent2End: pt4, radius: 15)
             path.addArc(tangent1End: pt4, tangent2End: pt1, radius: 15)
             
             //Arrow...
             path.move(to: pt1)
             path.addLine(to: CGPoint(x: placement == .leading ? 10 : rect.width - 10, y: 0))
             path.addLine(to: CGPoint(x: placement == .leading ? 15 : rect.width - 15, y: 0))
             path.addLine(to: CGPoint(x: placement == .leading ? 25 : rect.width - 25, y: -15))
             path.addLine(to: CGPoint(x: placement == .leading ? 40 : rect.width - 40, y: 0))
         }
     }
 }
 
 // this collects the four uiColor components into a single uiColor.
 // if you change a shed's uiColor, its associated items will want to
 // know that their uiColor computed properties have been invalidated
 var uiColor: UIColor {
     get {
         UIColor(red: CGFloat(red_), green: CGFloat(green_), blue: CGFloat(blue_), alpha: CGFloat(opacity_))
     }
     set {
         if let components = newValue.cgColor.components {
             red_ = Double(components[0])
             green_ = Double(components[1])
             blue_ = Double(components[2])
             opacity_ = Double(components[3])
             items.forEach({ $0.objectWillChange.send() })
         }
     }
 }
 
 // the color = the color of its associated shed
 var uiColor: UIColor {
     shed_?.uiColor ?? UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
 }
 
 // addItemToShoppingList just means that by default, a new item will be added to
 // the shopping list, and so this is initialized to true.
 // however, if inserting a new item from the Purchased item list, perhaps
 // you might want the new item to go to the Purchased item list (?)
 //var addItemToShoppingList: Bool = true
 
 // OLD ADD OR MODIFY ITEM VIEW
 /*var bodyOld: some View {
     NavigationView {
         Form {
             
             // Section 1. Basic Information Fields
             Section(header: Text("Basic Information").sectionHeader()) {
                 HStack(alignment: .firstTextBaseline) {
                     SLFormLabelText(labelText: "Name: ")
                     TextField("Item name", text: $editableItemData.name)
                 }
             }
             Section(header: Text("Shed").sectionHeader()) {
                 
                 DisclosureGroup("Shed", isExpanded: $viewModel.expandedShed) {
                     NavigationLink(destination: AddShedView()) {
                         Text("Add New Shed")
                     }
                     ForEach(sheds) { shed in
                         Text(shed.name).tag(shed)
                             .onTapGesture {
                                 editableItemData.shed = shed
                                 viewModel.expandedShed.toggle()
                             }
                     }
                 }
             }
             Section(header: Text("Brand").sectionHeader()) {

                 DisclosureGroup("Brand", isExpanded: $viewModel.expandedBrand) {
                     NavigationLink(destination: AddBrandView()) {
                         Text("Add New Brand")
                     }
                     ForEach(brands) { brand in
                         Text(brand.name).tag(brand)
                             .onTapGesture {
                                 editableItemData.brand = brand
                                 viewModel.expandedBrand.toggle()
                             }
                     }
                 }
             }
             /*Section(header: Text("Tag").sectionHeader()) {

                 DisclosureGroup("Tag", isExpanded: $viewModel.expandedTag) {
                     NavigationLink(destination: AddOrModifyTagView()) {
                         Text("Add New Tag")
                     }
                     ForEach(tags) { tag in
                         Text(tag.name).tag(tag)
                             .onTapGesture {
                                 editableItemData.tag = tag
                                 viewModel.expandedTag.toggle()
                             }
                     }
                 }
             }*/

             // Item Stats
             Section (header: Text("Item Stats").sectionHeader()) {
                 Stepper(value: $editableItemData.quantity, in: 1...10) {
                     HStack {
                         SLFormLabelText(labelText: "Quantity: ")
                         Text("\(editableItemData.quantity)")
                     }
                 }
             }
             
             HStack(alignment: .firstTextBaseline) {
                 Toggle(isOn: $editableItemData.onList) {
                     SLFormLabelText(labelText: "Wishlist Item: ")
                 }
             }
             
             // Item Details
             Section (header: Text("Item Details").sectionHeader()) {
                 TextEditor(text: $editableItemData.details)
             }
             
             // Item Management (Delete), if present
             if editableItemData.representsExistingItem {
                 Section(header: Text("Item Management").sectionHeader()) {
                     SLCenteredButton(title: "Delete This Item",
                                      action: { viewModel.confirmDeleteItemAlert =
                             ConfirmDeleteItemAlert(item: editableItemData.associatedItem,
                                   destructiveCompletion: { presentationMode.wrappedValue.dismiss() })
                                                      })
                         .foregroundColor(Color.red)
                 }
             }
         }
         .navigationBarTitle(barTitle(), displayMode: .inline)
         .navigationBarBackButtonHidden(true)
         .toolbar {
             ToolbarItem(placement: .cancellationAction) { cancelButton() }
             ToolbarItem(placement: .confirmationAction) { saveButton().disabled(!editableItemData.canBeSaved) }
         }
         .onAppear {
             logAppear(title: "AddOrModifyItemView")
         }
         .onDisappear {
             logDisappear(title: "AddOrModifyItemView")
             PersistentStore.shared.saveContext()
         }
         .alert(item: $viewModel.confirmDeleteItemAlert) { item in item.alert() }
     }
     
 }*/
 
 // we only keep one "UnknownShed" in the data store.  you can find it because its
 // visitationOrder is the largest 32-bit integer. to make the app work, however, we need this
 // default shed to exist!
 //
 // so if we ever need to get the unknown shed from the database, we will fetch it;
 // and if it's not there, we will create it then.
 //let fetchRequest: NSFetchRequest<Shed> = Shed.fetchRequest()
 //
 //fetchRequest.predicate = NSPredicate(format: "name_ == %d", kUnknownShedName)
 //
 //do {
 //    let sheds = try PersistentStore.shared.context.fetch(fetchRequest)
 //    if sheds.count == 1 { // there should be no more than one
 //        return sheds[0]
 //    } else if sheds.count == 0 {
 //        return createUnknownShed()
 //    }
 //} catch let error as NSError {
 //    fatalError("Error fetching unknown shed: \(error.localizedDescription), \(error.userInfo)")
 //}
 
 
 /*class func unknownShedFR(unknShedName: String = kUnknownShedName) -> NSFetchRequest<Shed> {

     let request = NSFetchRequest<Shed>(entityName: "Shed")
     
     let filter = NSPredicate(format: "name_ == %d", unknShedName)
     request.predicate = filter
     
     return request

 }*/
 
 class func unknownBrandFR(unknBrandName: String = kUnknownBrandName) -> NSFetchRequest<Brand> {

     let request = NSFetchRequest<Brand>(entityName: "Brand")
     
     let filter = NSPredicate(format: "name_ == %d", unknBrandName)
     request.predicate = filter
     
     return request

 }
 
 
 /*
 The persistent container for the application. This implementation
 creates and returns a container, having loaded the store for the
 application to it. This property is optional since there are legitimate
 error conditions that could cause the creation of the store to fail.
 */
 
 // choose here whether you want the cloud or not
 // -- when i install this on a device, i may want the cloud (you will need an Apple Developer
 //    account to use the cloud an add the right entitlements to your project);
 // -- for some initial testing on the simulator, i may use the cloud;
 // -- but for basic app building in the simulator, i prefer a non-cloud store.
 // by the way: using NSPersistentCloudKitContainer in the simulator works fine,
 // but you will see lots of console traffic about sync transactions.  those are not
 // errors, but it will clog up your console window.
 //
 // by the way, just choosing to use NSPersistentCloudKitContainer is not enough by itself.
 // you will have to make some changes in the project settings. see
 //    https://developer.apple.com/documentation/coredata/mirroring_a_core_data_store_with_cloudkit/setting_up_core_data_with_cloudkit
 
 
 // let container = NSPersistentCloudKitContainer(name: "ShoppingList")

 // some of what follows are suggestions by "Apple Staff" on the Apple Developer Forums
 // for the case when you have an NSPersistentCloudKitContainer and iCloud synching
 // https://developer.apple.com/forums/thread/650173
 // you'll also see there how to use this code with the new XCode 12 App/Scene structure
 // that replaced the AppDelegate/SceneDelegate of XCode 11 and iOS 13.  additionally,
 // follow along with this discussion https://developer.apple.com/forums/thread/650876
 
 // (1) Enable history tracking.  this seems to be important when you have more than one persistent
 // store in your app (e.g., when using the cloud) and you want to do any sort of cross-store
 // syncing.  See WWDC 2019 Session 209, "Making Apps with Core Data."
 // also, once you use NSPersistentCloudKitContainer and turn these on, then you should leave
 // these on, even if you just now want to use what's on-disk with NSPersistentContainer and
 // without cloud access.
 /*struct Temp: View {
     
     var body: some View {
         //SearchBarView1(searchText: $viewModel.searchText)
         Rectangle()
         .frame(width: 0.01 ,height: 0.01)
         .actionSheet(isPresented: $viewModel.showDisplayAction) {
             ActionSheet(title: Text("Display:"), buttons: [
                 .default(Text("All Items")) {displayBy = 0},
                 .default(Text("Grouped by Shed")) {displayBy = 1},
                 .default(Text("Grouped by Brand")) {displayBy = 2}
             ])
         }
             .padding(.bottom, 10)
         
         if viewModel.itemsInCatelog.count == 0 {
             EmptyCatelogView()
         } else {
             ItemListDisplay(displayBy: $displayBy)
         }

         Rectangle()
             .frame(height: 1)
             .padding(.top, 5)
         
         Spacer(minLength: 80)
     }
     
     
 }*/
 
 struct TestView70: View {

     @Environment (\.presentationMode) var presentationMode

     //isFirstLaunch will default to true until it is set to false in the sheet and
     //then stored in UserDefaults
     @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true

     var body: some View {
         VStack(spacing: 40) {
             Text("Welcome")
             Button("Reset") {
                 isFirstLaunch = true
             }
             Text("is first launch? \(isFirstLaunch ? "YES" : "NO")")
         }
         .sheet(isPresented: $isFirstLaunch) {
             VStack(spacing: 40) {
                 Text("Sheet")
                 Button("Ok") {
                     isFirstLaunch = false
                 }
             }
         }
     }
 }
 
 /*.font(.largeTitle)
 .frame(width: 57, height: 50)
 .foregroundColor(Color.white)
 .padding(.bottom, 7)*/

// FetchRequest To Keep List of sheds Updated
/*@FetchRequest(fetchRequest: MainCatelogVM.allShedsFR())
private var allSheds: FetchedResults<Shed>*/

/*HStack {
 Button {viewModel.isAddNewItemShowing.toggle()} label: {
     Image(systemName: "plus")
 }
 NavigationLink(destination: AllItemsView()) {
     Text("Uncategorized")
         .font(.headline)
         .padding(.horizontal, 22.5)
     Spacer()
     
     Text("0")
         .font(.headline)
         .padding(.horizontal, 20)
 }
}
.padding(.horizontal)
.padding(.top, 15)*/
 
 /*ScrollView(.vertical, showsIndicators: false) {
     ForEach(allFavItems) { item in
         ItemRowView(item: item)
             .padding(.top, 10)
     }
 }*/
 struct SimpleItemsListForBrand: View {
     
     @FetchRequest    private var items: FetchedResults<Item>
     
     @State private var listDisplayID = UUID()
     //@Binding var isAddNewItemSheetShowing: Bool
     
     init(brand: Brand/*, isAddNewItemSheetShowing: Binding<Bool>*/) {
         let request = Item.allItemsFR(at: brand)
         _items = FetchRequest(fetchRequest: request)
         //_isAddNewItemSheetShowing = isAddNewItemSheetShowing
     }
     
     var body: some View {
         Section(header: ItemsListHeader()) {
             ForEach(items) { item in
                 NavigationLink(destination: AddItemView(editableItem: item)) {
                     Text(item.name)
                 }
             }
         }
 //        .id(listDisplayID)
         .onAppear { listDisplayID = UUID() }
     }
     
     func ItemsListHeader() -> some View {
         HStack {
             Text("At this Brand: \(items.count) items").sectionHeader()
             Spacer()
             
            //Button {
            //    isAddNewItemSheetShowing = true
            //} label: {
            //    Image(systemName: "plus")
            //        .font(.title2)
            //}
         }
     }
 }
 
 // Section 3: Items assigned to this Brand, if we are editing a Brand
 //if editableData.representsExistingBrand {
 //    SimpleItemsListForBrand(brand: editableData.associatedBrand/*,
 //                                    isAddNewItemSheetShowing: $isAddNewItemSheetShowing*/)
 //}
 
 /*ScrollView(.vertical, showsIndicators: false) {
     ForEach(allWishListItems) { item in
         ItemRowView(item: item)
     }
 }
 .padding(.top, 20)*/
 
 
 // MARK: OLD MAINCATELOG VM STUFF
 
 // Array that is initialized with all Items whenever the ViewModel is called
 @Published var allItemsInShed: [Item] = []
 
 // Array that is initialized with all Items whenever the ViewModel is called
 @Published var allItemsInWishList: [Item] = []
 
 // Array that is initialized with all Items whenever the ViewModel is called
 @Published var allFavItems: [Item] = []
 
 // Array that is initialized with all Sheds whenever the ViewModel is called
 @Published var itemInShed: [Item] = []
 
 // Array that is initialized with all Sheds whenever the ViewModel is called
 @Published var itemInBrand: [Item] = []
 
 // Array that is initialized with all Sheds whenever the ViewModel is called
 @Published var allUserSheds: [Shed] = []
 
 // Array that is initialized with all Sheds whenever the ViewModel is called
 @Published var allBrands: [Brand] = []
 
 // Array that is initialized with all Sheds whenever the ViewModel is called
 @Published var allTags: [Tag] = []
 
 func getItems(onList: Bool) {
     let request = NSFetchRequest<Item>(entityName: "Item")
     
     let sort = [NSSortDescriptor(key: "name_", ascending: true)]
     request.sortDescriptors = sort
     
     let filter = NSPredicate(format: "wishlist_ == %d", onList)
     request.predicate = filter
     
     do {
         if onList == false {
             allItemsInShed = try PersistentStore.shared.context.fetch(request)
         } else {
             allItemsInWishList = try PersistentStore.shared.context.fetch(request)
         }
     } catch let error {
         print("Error fetching. \(error.localizedDescription)")
     }
 }
 
 func getFavItems(isFavourite: Bool = true) {
     let request = NSFetchRequest<Item>(entityName: "Item")
     
     let sort = [NSSortDescriptor(key: "name_", ascending: true)]
     request.sortDescriptors = sort
     
     let filter = NSPredicate(format: "isFavourite_ == %d", isFavourite)
     request.predicate = filter
     
     do {
         allFavItems = try PersistentStore.shared.context.fetch(request)
     } catch let error {
         print("Error fetching. \(error.localizedDescription)")
     }
 }
 
 func getUserSheds(unknShedName: String = kUnknownShedName) {
     let request = NSFetchRequest<Shed>(entityName: "Shed")
     
     let sort = [NSSortDescriptor(key: "name_", ascending: true)]
     request.sortDescriptors = sort
     
     let filter = NSPredicate(format: "NOT name_ == %@", unknShedName)
     request.predicate = filter
     
     do {
         allUserSheds = try PersistentStore.shared.context.fetch(request)
     } catch let error {
         print("Error fetching. \(error.localizedDescription)")
     }
 }
 
 func getBrands() {
     let request = NSFetchRequest<Brand>(entityName: "Brand")
     
     let sort = [NSSortDescriptor(key: "name_", ascending: true)]
     request.sortDescriptors = sort
     
     do {
         allBrands = try PersistentStore.shared.context.fetch(request)
     } catch let error {
         print("Error fetching. \(error.localizedDescription)")
     }
 }
 
 func getTags() {
     let request = NSFetchRequest<Tag>(entityName: "Tag")
     
     let sort = [NSSortDescriptor(key: "name_", ascending: true)]
     request.sortDescriptors = sort
     
     do {
         allTags = try PersistentStore.shared.context.fetch(request)
     } catch let error {
         print("Error fetching. \(error.localizedDescription)")
     }
 }
 
 func getShedItems(shed: Shed, onList: Bool = false) {
     let request: NSFetchRequest<Item> = Item.fetchRequest()
     let p1 = NSPredicate(format: "shed_ == %@", shed)
     let p2 = NSPredicate(format: "wishlist_ == %d", onList)
     let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [p1, p2])
     request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
     request.predicate = predicate
     
     do {
         itemInShed = try PersistentStore.shared.context.fetch(request)
     } catch let error {
         print("Error fetching. \(error.localizedDescription)")
     }
 }
 
 func getBrandItems(brand: Brand) {
     let request = NSFetchRequest<Item>(entityName: "Item")
     
     let sort = [NSSortDescriptor(key: "name_", ascending: true)]
     request.sortDescriptors = sort
     
     let filter = NSPredicate(format: "brand_ == %@", brand)
     request.predicate = filter
     
     do {
         itemInBrand = try PersistentStore.shared.context.fetch(request)
     } catch let error {
         print("Error fetching. \(error.localizedDescription)")
     }
 }
 
 // MARK: - FetchRequests
 
 // a fetch request we can use in views to get all sheds, sorted by name.
 // by default, you get all sheds; setting onList = true returns only sheds that
 // have at least one of its shopping items currently on the shopping list
 class func allShedsFR(onList: Bool = false) -> NSFetchRequest<Shed> {
     let request: NSFetchRequest<Shed> = Shed.fetchRequest()
     request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
     if onList {
         request.predicate = NSPredicate(format: "ANY items_.wishlist_ == true")
     }
     return request
 }
 
 class func allItemsInWishListFR(onList: Bool = true) -> NSFetchRequest<Item> {
     let request: NSFetchRequest<Item> = Item.fetchRequest()
     request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
     request.predicate = NSPredicate(format: "wishlist_ == %d", onList)
     return request
 }
 
 class func allFavItemsFR(isFavourite: Bool = true) -> NSFetchRequest<Item> {
     let request: NSFetchRequest<Item> = Item.fetchRequest()
     request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
     request.predicate = NSPredicate(format: "isFavourite_ == %d", isFavourite)
     return request
 }
 
 // a fetch request we can use in views to get all User shedss, excluding the Unknown
 // shed, sorted by name by default; setting onList = true returns only sheds that
 // have at least one of its item currently in the Gear Shed list
 class func allUserShedsFR(unknShedName: String = kUnknownShedName) -> NSFetchRequest<Shed> {
     
     let request = NSFetchRequest<Shed>(entityName: "Shed")
     
     let sort = [NSSortDescriptor(key: "name_", ascending: true)]
     request.sortDescriptors = sort
     
     let filter = NSPredicate(format: "NOT name_ == %@", unknShedName)
     request.predicate = filter
     
     return request
 }
 
 // a fetch request we can use in views to get all brands, sorted by name.
 // by default, you get all brands; setting onList = true returns only brands that
 // have at least one of its shopping items currently on the shopping list
 class func allBrandsFR(onList: Bool = false) -> NSFetchRequest<Brand> {
     let request: NSFetchRequest<Brand> = Brand.fetchRequest()
     request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
     if onList {
         request.predicate = NSPredicate(format: "ANY items_.wishlist_ == true")
     }
     return request
 }
 
 // a fetch request we can use in views to get all User shedss, excluding the Unknown
 // shed, sorted by name by default; setting onList = true returns only sheds that
 // have at least one of its item currently in the Gear Shed list
 class func allUserBrandsFR(unknBrandName: String) -> NSFetchRequest<Brand> {
     
     let request = NSFetchRequest<Brand>(entityName: "Brand")
     
     let sort = [NSSortDescriptor(key: "name_", ascending: true)]
     request.sortDescriptors = sort
     
     let filter = NSPredicate(format: "NOT name_ == %@", unknBrandName)
     request.predicate = filter
     
     return request
 }
 
 // a fetch request we can use in views to get all brands, sorted by name.
 // by default, you get all brands; setting onList = true returns only brands that
 // have at least one of its shopping items currently on the shopping list
 class func allTagsFR() -> NSFetchRequest<Tag> {
     let request: NSFetchRequest<Tag> = Tag.fetchRequest()
     request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
     return request
 }
 //func editBrandButton() -> some View {
 //    Button { self.isEditBrandShowing.toggle() } label: { Image(systemName: "slider.horizontal.3") }
 //}
 
 //func editShedButton() -> some View {
 //    Button { self.isEditShedShowing.toggle() } label: { Image(systemName: "slider.horizontal.3") }
 //}
 //
 //func editItemButton() -> some View {
 //    Button { self.isEditItemShowing.toggle() } label: { Image(systemName: "slider.horizontal.3") }
 //}
 
 // state variable to control triggering confirmation of a delete, which is
 // one of three context menu actions that can be applied to an item
 @Published var confirmDeleteItemAlert: ConfirmDeleteItemAlert?
 
 // parameter to control triggering an Alert and defining what action
 // to take upon confirmation
 @Published var confirmDeleteBrandAlert: ConfirmDeleteBrandAlert?
 
 // parameter to control triggering an Alert and defining what action
 // to take upon confirmation
 @Published var confirmDeleteShedAlert: ConfirmDeleteShedAlert?
 
 // MARK: - Old Persistant Store Init

 // this makes sure we're the only one who can create one of these
 //private init() { }

 /// The lone CloudKit container used to store all our data.
 /*lazy var container: NSPersistentCloudKitContainer = {
     
     let defaults = UserDefaults.standard
     let container = NSPersistentCloudKitContainer(name: "GearShed")
     
     let groupID = "group.com.yourcompany.gearshed"

     if let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID) {
         container.persistentStoreDescriptions.first?.url = url.appendingPathComponent("GearShed.sqlite")
     }
     
     guard let persistentStoreDescriptions = container.persistentStoreDescriptions.first else {
         fatalError("\(#function): Failed to retrieve a persistent store description.")
     }
     persistentStoreDescriptions.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
     persistentStoreDescriptions.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
     
     container.loadPersistentStores(completionHandler: { (storeDescription, error) in
         if let error = error as NSError? {
             fatalError("Unresolved error \(error), \(error.userInfo)")
         }
     })
     
     // also suggested for cloud-based Core Data are the two lines below for syncing with the cloud.
     container.viewContext.automaticallyMergesChangesFromParent = true
     container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
     
     return container
     
 }()*/

 /*var body: some View {
     VStack (spacing: 0) {
         
         StatBar()
                     
         ScrollView(.vertical, showsIndicators: false) {
             
             
             ForEach(viewModel.allItemsInShed) { item in
                 ItemRowView(item: item)
             }
         }
         .padding(.top, 10)
         Rectangle()
             .frame(height: 1)
             .opacity(0)
         Spacer(minLength: 60)
     }
 }*/
 //private var selectedBrandName: String
 
 //@State private var altShedSelected: Bool = false
 
 //@State private var altBrandSelected: Bool = false
 
 //@State private var altShedName: String = ""
 
 //@State private var altBrandName: String = ""
 /*if selectedShed != Shed.theUnknownShed() {
     
 }
     
     editableItemData.shed = selectedShed! //?? Shed.theUnknownShed()
     print("loaded selected shed")
 }*/
 //if (selectedShed != nil) {
 //    editableItemData.shed = selectedShed! //?? Shed.theUnknownShed()
 //    print("loaded selected shed")
 //}
 //print("AI SC",selectedShed?.name ?? "")
 //print("STock", editableItemData.shed.name)
 // initialize the editableData struct for the incoming item, if any; and
 // also carry in whatever might be a suggested Item name for a new Item
 /*if let item = editableItem {
     _editableItemData = State(initialValue: EditableItemData(item: item))
 } else {
  // here's we'll see if a suggested name for adding a new item was supplied
  let initialValue = EditableItemData(initialItemName: initialItemName, initialItemDetails: initialItemDetails, shed: shed,  brand: brand)
  _editableItemData = State(initialValue: initialValue)
 }*/
 //selectedShedName = shed?.name ?? "Choose a shed"
 //selectedBrandName = brand?.name ?? "Choose a brand"
 /@State private var selectedShed: Shed? = Shed.theUnknownShed()
 /*func discolsureShedTitle() -> String {
     if !altShedSelected {
         return viewModel.selectedShed!.name
     } else {
         return altShedName
     }
 }*/
 
 /*func discolsureBrandTitle() -> String {
     if !altBrandSelected {
         return selectedBrandName
     } else {
         return altBrandName
     }
 }*/
 /*VStack (alignment: .leading, spacing: 10) {
     Text("Quantity")
         .font(.subheadline)
         .bold()
         .foregroundColor(Color.theme.green)
     
     Stepper(value: $editableItemData.quantity, in: 1...50) {
         HStack {
             Spacer()
             Text("\(editableItemData.quantity)")
             Spacer()
         }
     }
 }*/

 HStack {
     VStack (alignment: .leading, spacing: 5) {
         Text("Favorites")
             .font(.caption)
             .foregroundColor(Color.theme.accent)
         Text("\(viewModel.totalFavs(array: viewModel.items))")
             .font(.caption)
             .foregroundColor(Color.theme.accent)
     }
 }
 HStack {
     VStack (alignment: .leading, spacing: 5) {
         Text("Regrets")
             .font(.caption)
             .foregroundColor(Color.theme.accent)
         Text("\(viewModel.regretItems.count)")
             .font(.caption)
             .foregroundColor(Color.theme.accent)
     }
 }
 
 /*SPForShedView(selected: $selected)
 if self.selected == 0 {
     AllItemsView(persistentStore: persistentStore)
         .transition(.moveAndFade)
 } else if self.selected == 1 {
     AllShedView(persistentStore: persistentStore)
         .transition(.moveAndFade)
 }
 else if self.selected == 2 {
     AllBrandView(persistentStore: persistentStore)
         .transition(.moveAndFade)
 } else if self.selected == 3 {
     AllFavouriteView(persistentStore: persistentStore)
         .transition(.moveAndFade)
 } else if self.selected == 4 {
     AllWishListView(persistentStore: persistentStore)
         .transition(.moveAndFade)
 } else {
     EmptyView()
 }*/

 //Spacer()

 
 /*DisclosureGroup(editableItemData.shed.name, isExpanded: $expandedShed) {
     VStack(alignment: .leading) {
         NavigationLink(destination: AddShedView()) {
             Text("Add New Shed")
                 .font(.subheadline)
         }
         ForEach(viewModel.sheds) { shed in
             Text(shed.name).tag(shed)
                 .font(.subheadline)
                 //.foregroundColor(Color.theme.secondaryText)
                 .onTapGesture {
                     editableItemData.shed = shed
                     //altShedSelected = true
                     //altShedName = shed.name
                     DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                         expandedShed.toggle()
                     }
                 }
         }
     }
 }*/
 
 /*DisclosureGroup(editableItemData.brand.name, isExpanded: $expandedBrand) {
     VStack(alignment: .leading) {
         NavigationLink(destination: AddBrandView()) {
             Text("Add New Brand")
                 .font(.subheadline)
                 //.foregroundColor(Color.theme.secondaryText)
         }
         ForEach(viewModel.brands) { brand in
             Text(brand.name).tag(brand)
                 .font(.subheadline)
                 //.foregroundColor(Color.theme.secondaryText)
                 .onTapGesture {
                     editableItemData.brand = brand
                     //altBrandSelected = true
                     //altBrandName = brand.name
                     DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                         expandedBrand.toggle()
                         //altBrandSelected.toggle()
                     }
                 }
         }
     }
 }*/
 
 /*struct AppTabBarView_Previews: PreviewProvider {
     static var previews: some View {
         AppTabBarView()
     }
 }*/


 /*CustomTabView(selection: $tabSelection) {

     NavigationView { HomeView() }
         .tabBarItem(tab: .home, selection: $tabSelection)
     
     NavigationView { GearShedView(persistentStore: persistentStore) }
         .tabBarItem(tab: .shed, selection: $tabSelection)
     
     NavigationView { GearlistView(persistentStore: persistentStore) }
         .tabBarItem(tab: .trips, selection: $tabSelection)
     
 }*/

 /*struct AppTabBarView1: View {

     @State private var tabSelection: TabBarItem = .home
     
     var body: some View {
         NavigationView{
             CustomTabView(selection: $tabSelection) {
             
                 HomeView()
                     .offset(y: 50)
                     .tabBarItem(tab: .home, selection: $tabSelection)
                     .tag(TabBarItem.home)
                 
                 MainCatelogView()
                     .offset(y: 100)
                     .tabBarItem(tab: .shed, selection: $tabSelection)
                     .tag(TabBarItem.shed)

                                 
                 TripsTabView()
                     .offset(y: 100)
                     .tabBarItem(tab: .trips, selection: $tabSelection)
                     .tag(TabBarItem.trips)

                 
             }
             //.navigationBarTitle(returnNaviBarTitle(tabSelection: self.tabSelection))
             //.navigationViewStyle(StackNavigationViewStyle())
         }

     }

         
     func returnNaviBarTitle(tabSelection: TabBarItem) -> String {
         switch tabSelection {
             case .home: return "Tab1"
             case .shed: return "Tab2"
             case .trips: return "Tab2"
         }
     }
 }

 struct AppTabBarView2: View {

     @State private var tabSelection: TabBarItem = .home
     
     var body: some View {
         TabView(selection: $tabSelection) {
             
             NavigationView { HomeView() }
                 .tabItem({ Label("Home", systemImage: "list.bullet") })

                
             NavigationView { MainCatelogView() }
                 .tabItem({ Label("Gear Shed", systemImage: "house") })

             NavigationView { TripsTabView() }
                 .tabItem({ Label("Gear List", systemImage: "figure.walk") })

         }
     }
 }*/
 /*AutoSizingTF(hint: "Item Details", text: $editableItemData.details, containerHeight: $containerHeight) {
     UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
 }
 .frame(height: containerHeight <= 120 ? containerHeight : 120)
 //.background(Color.theme.green)
 //.cornerRadius(10)*/

 /*VStack(alignment: .leading, spacing: 10) {
     HStack {
         Text ("Shed")
             .font(.subheadline)
         Spacer()
         Text("Brand")
             .font(.subheadline)
         Spacer()
     } // Title
     
     HStack {
         // SHED
         Menu {
             Button {
                 shedNavLinkActive.toggle()
             } label: {
                 Text("Add New Shed")
                 .font(.subheadline)
             }
             ForEach(viewModel.sheds) { shed in
                 Button {
                     editableItemData.shed = shed
                 } label: {
                     Text(shed.name)
                         .tag(shed)
                         .font(.subheadline)
                 }
             }
         } label: {
             withAnimation (.spring()) {
                 Text(editableItemData.shed.name)
                     .format()
                     .frame(maxWidth: .infinity, maxHeight: .infinity)
                     .background(Color.blue)
             }
         }
         .background(
             NavigationLink(destination: AddShedView(shedOut: { shed in editableItemData.shed = shed }, isAddFromItem: true), isActive: $shedNavLinkActive) {
                 EmptyView()
             }
         )
         
         Spacer()
         
         // BRAND
         Menu {
             Button {
                 brandNavLinkActive.toggle()
             } label: {
                 Text("Add New Brand")
                     .font(.subheadline)
             }
             ForEach(viewModel.brands) { brand in
                 Button {
                     editableItemData.brand = brand
                 } label: {
                     Text(brand.name)
                         .tag(brand)
                         .font(.subheadline)
                 }
             }
         } label: {
             withAnimation (.spring()) {
                 Text(editableItemData.brand.name)
                     .format()
                     .frame(maxWidth: .infinity, maxHeight: .infinity)
                     .background(Color.blue)
             }
         }
         .background(
             NavigationLink(destination: AddBrandView(brandOut: { brand in editableItemData.brand = brand }, isAddFromItem: true), isActive: $brandNavLinkActive) {
                 EmptyView()
             }
         )
         
         Spacer()
     } // Menu Pickers
 }*/
 // custom init here to set up editableData state
 /*init(persistentStore: PersistentStore, editableItem: Item? = nil, initialItemName: String? = nil, initialItemDetails: String? = nil, shed: Shed? = nil, brand: Brand? = nil) {
     let viewModel = GearShedData(persistentStore: persistentStore)
     _viewModel = StateObject(wrappedValue: viewModel)
     
     
     // initialize the editableData struct for the incoming item, if any; and
     // also carry in whatever might be a suggested Item name for a new Item
     if let item = editableItem {
         _editableItemData = State(initialValue: EditableItemData(item: item))
     } else {
         // here's we'll see if a suggested name for adding a new item was supplied
         let initialValue = EditableItemData(initialItemName: initialItemName, initialItemDetails: initialItemDetails, shed: shed,  brand: brand)
         _editableItemData = State(initialValue: initialValue)
     }
 }*/

 /*NavigationView {
     ScrollView(.vertical, showsIndicators: false) {
         VStack (alignment: .leading, spacing: 20) {
             
             VStack (alignment: .leading, spacing: 10) {
                 Text("Item Name:")
                     .font(.subheadline)
                     .bold()
                     .foregroundColor(Color.theme.green)
                 
                 TextField(editableItemData.name, text: $editableItemData.name)
                     .disableAutocorrection(true)
                 
                 Rectangle()
                     .frame(maxWidth: .infinity)
                     .frame(maxHeight: 2)
                     .foregroundColor(Color.theme.green)
             }
             
             VStack (alignment: .leading, spacing: 20) {
                 Text("Item Stats:")
                     .font(.subheadline)
                     .bold()
                     .foregroundColor(Color.theme.green)
                 
                 HStack(alignment: .firstTextBaseline) {
                     
                     VStack {
                         TextField(editableItemData.weight, text: $editableItemData.weight)
                         Rectangle()
                             .frame(maxWidth: .infinity)
                             .frame(maxHeight: 1)
                             .foregroundColor(Color.theme.green)
                     }
                     
                     VStack {
                         TextField(editableItemData.price, text: $editableItemData.price)
                         Rectangle()
                             .frame(maxWidth: .infinity)
                             .frame(maxHeight: 1)
                             .foregroundColor(Color.theme.green)
                     }
                 }
             }
             
             VStack (alignment: .leading, spacing: 10) {
                 Text("Shed - Brand")
                     .font(.subheadline)
                     .bold()
                     .foregroundColor(Color.theme.green)
                 
                 HStack (alignment: .firstTextBaseline, spacing: 10) {
                     DisclosureGroup(editableItemData.shed.name, isExpanded: $expandedShed) {
                         VStack(alignment: .leading) {
                             NavigationLink(destination: AddShedView()) {
                                 Text("Add New Shed")
                                     .font(.subheadline)
                                     //.foregroundColor(Color.theme.green)
                             }
                             ForEach(viewModel.sheds) { shed in
                                 Text(shed.name).tag(shed)
                                     .font(.subheadline)
                                     //.foregroundColor(Color.theme.secondaryText)
                                     .onTapGesture {
                                         editableItemData.shed = shed
                                         //altShedSelected = true
                                         //altShedName = shed.name
                                         DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                             expandedShed.toggle()
                                         }
                                     }
                             }
                         }
                     }
                     
                     DisclosureGroup(editableItemData.brand.name, isExpanded: $expandedBrand) {
                         VStack(alignment: .leading) {
                             NavigationLink(destination: AddBrandView()) {
                                 Text("Add New Brand")
                                     .font(.subheadline)
                                     //.foregroundColor(Color.theme.secondaryText)
                             }
                             ForEach(viewModel.brands) { brand in
                                 Text(brand.name).tag(brand)
                                     .font(.subheadline)
                                     //.foregroundColor(Color.theme.secondaryText)
                                     .onTapGesture {
                                         editableItemData.brand = brand
                                         //altBrandSelected = true
                                         //altBrandName = brand.name
                                         DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                             expandedBrand.toggle()
                                             //altBrandSelected.toggle()
                                         }
                                     }
                             }
                         }
                     }
                 }
             }
             
             /*VStack (alignment: .leading, spacing: 10) {
                 Text("Quantity")
                     .font(.subheadline)
                     .bold()
                     .foregroundColor(Color.theme.green)
                 
                 Stepper(value: $editableItemData.quantity, in: 1...50) {
                     HStack {
                         Spacer()
                         Text("\(editableItemData.quantity)")
                         Spacer()
                     }
                 }
             }*/
             
             Toggle(isOn: $editableItemData.wishlist) {
                 Text("Wishlist Item")
                     .font(.subheadline)
                     .bold()
                     .foregroundColor(Color.theme.green)
             }
             
             VStack (alignment: .leading, spacing: 10) {
                 Text("Item Details:")
                     .font(.subheadline)
                     .bold()
                     .foregroundColor(Color.theme.green)
                 ZStack {
                     if editableItemData.details.isEmpty == true {
                         Text("placeholder")
                             .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                             .foregroundColor(Color.theme.secondaryText)
                     }
                     TextEditor(text: $editableItemData.details)
                         .frame(maxHeight: .infinity)
                         .padding(.horizontal, -5)
                 }
                 .font(.body)
             }
             .frame(maxHeight: .infinity)
             
             Spacer()
             
             // Item Management (Delete), if present
             if editableItemData.representsExistingItem {
                 SLCenteredButton(title: "Delete This Item", action: { confirmDeleteItemAlert =
                     ConfirmDeleteItemAlert(item: editableItemData.associatedItem,
                         destructiveCompletion: { presentationMode.wrappedValue.dismiss() })
                 })
                     .foregroundColor(Color.red)
             }
         }
         .padding()
         .navigationBarTitle("Modify Item", displayMode: .inline)
         .navigationBarBackButtonHidden(true)
         .toolbar {
             ToolbarItem(placement: .cancellationAction) { cancelButton() }
             ToolbarItem(placement: .confirmationAction) { saveButton().disabled(!editableItemData.canBeSaved) }
         }
         .onAppear {
             logAppear(title: "AddOrModifyItemView")
         }
         .onDisappear {
             logDisappear(title: "AddOrModifyItemView")
             PersistentStore.shared.saveContext()
         }
         .alert(item: $confirmDeleteItemAlert) { item in item.alert() }
     }
 }*/
 
 
 // MARK: Swipe to dismiss tab bar scroll View
 // For tab bar
 @State private var offset: CGFloat = 0
 @State private var lastOffset: CGFloat = 0
 private var bottomEdge: CGFloat
 
 ScrollView(.vertical, showsIndicators: false) {
     LazyVStack {
         ForEach(viewModel.sectionByShed(itemArray: viewModel.items)) { section in
             Section {
                 ForEach(section.items) { item in
                     ItemRowView(item: item)
                         .padding(.horizontal)
                         .padding(.bottom, 5)
                 }
             } header: {
                 sectionHeader(section: section)
                     .padding(.horizontal)
             }
         }
     }
     // Geometry Reader for calculating Offset...
     /*.overlay( GeometryReader { proxy -> Color in
             let minY = proxy.frame(in: .named("SCROLL")).minY
             let durationOffset: CGFloat = 35
             DispatchQueue.main.async {
                 
                 if minY < offset{
                     if offset < 0 && -minY > (lastOffset + durationOffset){
                         // HIding tab and updating last offset...
                         withAnimation(.easeOut.speed(1.5)){
                             tabManager.hideTab = true
                         }
                         lastOffset = -offset
                     }
                 }
                 if minY > offset && -minY < (lastOffset - durationOffset) {
                     withAnimation(.easeOut.speed(1.5)) {
                         tabManager.hideTab = false
                     }
                     lastOffset = -offset
                 }
                 
                 self.offset = minY
             }
             return Color.clear
         } )*/
     // Same as Bottom Tab Calcu...
     .padding(.bottom, 75)
 }
 //.fixFlickering()
 .coordinateSpace(name: "SCROLL")
// MARK: END OF CUSTOM GEO READER SCROLL VIEW
 extension ScrollView {
     private typealias PaddedContent = ModifiedContent<Content, _PaddingLayout>
     
     func fixFlickering() -> some View {
         GeometryReader { geo in
             ScrollView<PaddedContent>(axes, showsIndicators: showsIndicators) {
                 content.padding(geo.safeAreaInsets) as! PaddedContent
             }
             .edgesIgnoringSafeArea(.all)
         }
     }
 }
 
 
 /*SPForDetailView(selected: $selected)

 if self.selected == 1 {
     Color.black
         .transition(.moveAndFade)
 }
 else if self.selected == 2 {
     Color.black
         .transition(.moveAndFade)
 } else if self.selected == 3 {
     Color.black
         .transition(.moveAndFade)
 } else {
     Color.black
         .transition(.moveAndFade)
 }

 Spacer()*/
 
 /*ToolbarItem(placement: .navigationBarTrailing) {
     Button {
         hideTab.toggle()
     } label: {
         Text("Hide Tab")
     }
 }*/
 
 
 // all editableData is packaged here. its initial values are set using
 // a custom init.
 //@State private var editableGearlistData: EditableGearlistData
 // custom init to set up editable data
 /*init(gearlist: Gearlist) {
     _editableGearlistData = State(initialValue: EditableGearlistData(gearlist: gearlist))
     self.gearlist = gearlist
 }*/

 
 
 /*struct TabButton: View {
     
     var image: String
     @Binding var currentTab: String
     
     // Based On Color SCheme changing Color...
     @Environment(\.colorScheme) var scheme
     
     var body: some View{
         
         Button {
             
             withAnimation{currentTab = image}
             
         } label: {
             Image(image)
                 .renderingMode(.template)
                 .resizable()
                 .aspectRatio(contentMode: .fit)
                 .frame(width: 35, height: 35)
                 .foregroundColor(currentTab == image ? Color("Pink") : Color.gray.opacity(0.7))
                 .frame(maxWidth: .infinity)
         }

     }
 }*/


 /*struct CustomTabBar: View {
     
     @Binding var currentTab: String
     
     var bottomEdge: CGFloat
     
     var body: some View {
         HStack(spacing: 10) {
             
             Button {
                 withAnimation{currentTab = "Home"}
             } label: {
                 Text("Home")
             }
             Button {
                 withAnimation{currentTab = "GearShed"}
             } label: {
                 Text("GearShed")
             }
             Button {
                 withAnimation{currentTab = "Gearlist"}
             } label: {
                 Text("Gearlist")
             }
         }
         .padding(.top,15)
         .padding(.bottom,bottomEdge)
         .padding(.horizontal, 10)
         .background(
             Color.theme.green
         )
         .clipShape(RoundedRectangle(cornerRadius: 20))
     }*/

 /*ZStack {
     Color.theme.background
         .opacity(0.8)
     Color.white
         .opacity(0.3)
 }

 )*/
 
 
 */
