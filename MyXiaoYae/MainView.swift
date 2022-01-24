import SwiftUI

struct MainView: View {
    @State private var themeColor = Color.yellow
    @State private var name = ""
    @State private var showToggle = false
    @State private var eatLateNightMeal = false
    @State private var selectDate = Date()
    @State private var shopPick = 0
    @State private var foodPick = 0
    @State private var foodCount = 1.0
    @State private var orders = [order]()
    @State private var showOrderView = false
    @State private var theSize: Double = 2
    let today = Date()
    let endDate =
        Calendar.current.date(byAdding: .day, value: 1,
                              to: Date())!
    
    var body: some View {
        VStack {
            Text("沙丁魚們吃東西咯！！！")
                .font(.title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            GeometryReader { geometry in
                Image("cover")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width,
                           height: geometry.size.width / 9 * 7)
                    .clipped()
            }.frame(height: 230)
            
            
            Form{
                ColorPicker("選個你喜歡的顏色吧", selection: $themeColor)
                HStack {
                    Text("版面大小")
                    Slider(value: self.$theSize, in: 2...25,minimumValueLabel: Image(systemName:"tv").imageScale(.small), maximumValueLabel: Image(systemName: "tv").imageScale(.large)) {
                            Text("")
                        }
                }
                HStack {
                    TextField("哪位沙丁魚餓了？", text: self.$name)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(themeColor, lineWidth: 3))
                    Button(action: {self.showToggle = true}){
                        Text("少囉唆我需要食物!")
                            .font(.system(size: 15))
                            .fontWeight(.bold)
                            .padding()
                            .foregroundColor(.white)
                            .background(themeColor)
                            .cornerRadius(50)
                    }
                }
                
                if (showToggle) {
                    Toggle(isOn : $eatLateNightMeal){
                        Text(eatLateNightMeal ? "今晚，\(name)想來點～" : "\(name)林北要餓死了拉")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: themeColor))
                    if (eatLateNightMeal){
                        DatePicker("幾點吃", selection: $selectDate, in: today...endDate)
                            .accentColor(themeColor)
                        shopPicker(shop: self.$shopPick)
                        foodPicker(food: self.$foodPick, shop: self.$shopPick)
                        foodStepper(foodCount: self.$foodCount)
                        HStack {
                            foodSlider(foodCount: self.$foodCount)
                            Button(action: {
                                orders.append(order(id: orders.count, shop: shops[shopPick].name, food: shops[shopPick].foods[foodPick], count: Int(foodCount)))
                            }){
                                Text("加入🛒")
                                    .font(.system(size: 15))
                                    .fontWeight(.bold)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(themeColor)
                                    .cornerRadius(50)
                            }
                        }
                        RandomOrder(themeColor: self.$themeColor, orders: self.$orders)
                    }
                }
                
            }
            Button(action: {
                self.showOrderView = true
            }
            ){
                Text("查看🛒")
                    .font(.headline)
                    .padding()
                    .background(themeColor)
                    .cornerRadius(30)
                    .foregroundColor(.white)
                    .padding(9)
                //                    .overlay(
                //                        RoundedRectangle(cornerRadius: 30)
                //                            .stroke(Color.orange, lineWidth: 5))
            }.sheet(isPresented: $showOrderView) {
                OrderView(orders: self.$orders, themeColor: self.$themeColor, showOrderView: self.$showOrderView)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

struct shopPicker: View {
    @Binding var shop: Int
    
    var body: some View {
        Picker("哪家店", selection: self.$shop){
            ForEach(shops.indices) { (index) in
                Text(shops[index].name)
            }
        }.pickerStyle(SegmentedPickerStyle())
    }
}

struct foodPicker: View {
    @Binding var food: Int
    @Binding var shop: Int
    
    var body: some View {
        Picker("吃什麼", selection: self.$food){
            ForEach(shops[shop].foods.indices) {
                (index) in
                Text(shops[shop].foods[index])
            }
        }.pickerStyle(WheelPickerStyle())
        .frame(height: 70)
        .clipped()
    }
}

struct foodStepper: View {
    @Binding var foodCount: Double
    
    var body: some View {
        Stepper("吃" + String(format: "%.f", foodCount) + "份", value: $foodCount, in: 1 ... 10)
    }
}

struct foodSlider: View {
    @Binding var foodCount: Double
    
    var body: some View {
        Slider(value: $foodCount, in: 1...10,step: 1.0, minimumValueLabel:Text("1份"), maximumValueLabel:Text("10份")){}
    }
}

struct OrderView: View {
    @Binding var orders: [order]
    @Binding var themeColor: Color
    @Binding var showOrderView: Bool
    @State private var showingSheet = false
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            Text("今晚，你點了...")
                .font(.title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .position(x: 200, y: 38)
                .frame(height: 50)
            GeometryReader { geometry in
                Image("cover1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width,
                           height: geometry.size.width / 9 * 7)
                    .clipped()
            }.frame(height: 230)
            
            Form {
                DisclosureGroup("🛒") {
                    VStack(alignment: .leading) {
                        ForEach(orders.indices) { (index) in
                            Text("\(orders[index].shop) 的 \(orders[index].food) \(orders[index].count) 份")
                        }
                    }
                }
                Button(action: {
                    self.showingSheet = true
                }) {
                    Text("加購購物袋？")
                }
                .actionSheet(isPresented: $showingSheet) {
                    ActionSheet(title: Text("確定要加購購物袋嗎？"), message: Text("很不環保哦"), buttons: [ActionSheet.Button.default(Text("YES")),
                        ActionSheet.Button.default(Text("No"))])
                }
            }
            
            Button(action: {
                self.showAlert = true
            }
            ){
                Text("送餐來")
                    .font(.headline)
                    .padding()
                    .background(themeColor)
                    .cornerRadius(30)
                    .foregroundColor(.white)
                    .padding(9)
            }
            .alert(isPresented: $showAlert) { () -> Alert in
                return Alert(title: Text("恭喜你！"), message: Text("點餐成功"), dismissButton: .default(Text("再吃更多宵"), action: {
                    self.showOrderView = false
                }))
            }
            
        }
    }
}

struct RandomOrder: View {
    @Binding var themeColor: Color
    @Binding var orders: [order]
    
    var body: some View {
        HStack {
            Text("不知道吃什麼嗎？")
            Spacer()
            Button(action: {
                let randShop = Int.random(in: 0...shops.count-1)
                let randFood = Int.random(in:0...shops[randShop].foods.count-1)
                let randCount = Int.random(in: 1...10)
                orders.append(order(id: orders.count, shop: shops[randShop].name, food: shops[randShop].foods[randFood], count: Int(randCount)))
            }){
                Text("幫我點餐")
                    .font(.system(size: 15))
                    .fontWeight(.bold)
                    .padding()
                    .foregroundColor(.white)
                    .background(themeColor)
                    .cornerRadius(50)
            }
        }
    }
}
