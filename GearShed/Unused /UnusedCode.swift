//
//  UnusedCode.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 2021-10-15.
//
//
/*
 
 //Section 2+3.
 
// Section(header: Text("Category").sectionHeader()) {
//     Picker(selection: $categoryChooser, label: Text("Category")) //{
//         Text("Choose Category").tag(0)
//         Text("Create New Category").tag(1)
//     }
//     .pickerStyle(SegmentedPickerStyle())
//     .onAppear {
//         if (self.categorys.count == 0) {
//             self.categoryChooser = 1
//             }
//         }
//
//     // Choose Category is selected in segemented control
//     if (categoryChooser == 0) {
//         Picker(selection: $editableItemData.category, label: //SLFormLabelText(labelText: "Category: ")) {
//             ForEach(categorys) { category in
//                 Text(category.name).tag(category)
//             }
//         }
//     }
//     // Create Category is selected in segmented control
//     if (categoryChooser == 1) {
//         HStack {
//             SLFormLabelText(labelText: "Name: ")
//             TextField("Category name", text: //$editableItemData.categoryName)
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
 
 Category Visitation order section
 
 //if editableData.visitationOrder != kUnknownCategoryVisitationOrder {
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

 // display format: one big section of Items, or sectioned by Category?
 // (not sure we need a Binding here ... we only read the value)
 //@Binding var multiSectionDisplay: Bool
     
 //@StateObject private var viewModel = ItemsViewModel()
 
 // this implements a seemingly well-known strategy to get the list drawn
 // cleanly without any highlighting
//    @Binding var listDisplayID: UUID
 
 

 
 */
