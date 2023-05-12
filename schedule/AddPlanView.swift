//
//  AddPlanView.swift
//  schedule
//
//  Created by 小原 宙 on 2020/08/28.
//  Copyright © 2020 小原 宙. All rights reserved.
//

import SwiftUI

//struct CustomTextField: UIViewRepresentable {
//
//    class Coordinator: NSObject, UITextFieldDelegate {
//
//        @Binding var text: String
//        @Binding var isFirstResponder: Bool
//
//        init(text: Binding<String>, isFirstResponder: Binding<Bool>) {
//            _text = text
//            _isFirstResponder = isFirstResponder
//        }
//
//        func textFieldDidChangeSelection(_ textField: UITextField) {
//            DispatchQueue.main.async {
//                self.text = textField.text ?? ""
//            }
//        }
//
//        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//            textField.resignFirstResponder()
//            isFirstResponder = false
//            return true
//        }
//    }
//
//    @Binding var text: String
//    @Binding var isFirstResponder: Bool
//
//    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextField {
//        let textField = UITextField(frame: .zero)
//        textField.delegate = context.coordinator
//        textField.placeholder = "タイトル"
//        return textField
//    }
//
//    func makeCoordinator() -> CustomTextField.Coordinator {
//        return Coordinator(text: $text, isFirstResponder: $isFirstResponder)
//    }
//
//    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomTextField>) {
//        uiView.text = text
//        if isFirstResponder {
//            uiView.becomeFirstResponder()
//        }
//    }
//}
//
//class TextBindingManager: ObservableObject {
//    @Published var text = "" {
//        didSet {
//            if text.count > characterLimit && oldValue.count <= characterLimit {
//                text = oldValue
//            }
//        }
//    }
//    let characterLimit: Int
//
//    init(limit: Int = 5){
//        characterLimit = limit
//    }
//}

struct AddPlanView: View {
    @Environment(\.managedObjectContext) var context
    
//    @ObservedObject var planTitle = TextBindingManager(limit: 20)
    @Binding var planTitle: String
    @State private var editing = false
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var onlyDay: Bool
    @Binding var notification: Bool
    @Binding var showSelectView: Bool
    @Binding var selectedNotificationTime: Int
    @Binding var selectedNotificationDay: Int
    @Binding var selectedNotificationHour: Int
    @Binding var selectedNotificationMinute: Int
    @Binding var selectedColorNumber: Int
    @Binding var showAddPlanView: Bool
    @Binding var editPlan: Bool
    @Binding var plan: Plan?
    @Binding var planCount: Int16
    @State var typing = false
    @State var showDatePickerView = false
    @State var startTime = MyDateFormatter.shared.dateFromString("2020/12/25/12:00")
    @State var endTime = MyDateFormatter.shared.dateFromString("2020/12/25/13:00")
    @State var selectingStartDate = false
    let notificationTimes = ["予定時刻", "5分前", "10分前", "15分前", "30分前", "1時間前", "2時間前", "1日前", "2日前", "3日前", "4日前", "5日前", "6日前", "1週間前", "2週間前"]
    let notificationDays = ["当日", "前日", "2日前", "3日前", "4日前", "5日前", "6日前", "1週間前", "2週間前"]
    
    var body: some View {
//        VStack(spacing: 10) {
//            RoundedRectangle(cornerRadius: 5)
//                .foregroundColor(Color("DarkShadow"))
//                .frame(width: 35, height: 4)
//                .padding(8)
        ZStack {
            VStack(spacing: 25) {
                TextField("タイトル", text: $planTitle,
                          onEditingChanged: { begin in
                            self.typing = begin
                          }
                          )
                    .padding(.horizontal, 15)
                    .keyboardType(.webSearch)
                    .neumorphism(width: UIScreen.main.bounds.width - 40, height: 45)
                    .onTapGesture(perform: {
                        editing = true
                    })
                
                if #available(iOS 14.0, *) {
                    HStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 10) {
//                            DatePicker("", selection: $startDate, displayedComponents: .date)
////                                .datePickerStyle(GraphicalDatePickerStyle())
//                                .labelsHidden()
////                                .frame(width: onlyDay ? 120 : 190, height: 30)
////                                .colorInvert()
////                                .colorMultiply(Color.black)
//                                .colorScheme(.light)
////                                .scaleEffect(1.1)
//                                .frame(width: 250, height: 38, alignment: .leading)
//                                .padding(.leading, 7)
////                                .opacity(0.01)
////                                .background(Color("BaseColor"))
                            
                            if onlyDay {
                                HStack(spacing: 8) {
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(MyDateFormatter.shared.onlyWString(startDate) + "曜日")
                                        Text(MyDateFormatter.shared.onlyMDString(startDate))
                                            .font(.system(size: 20, weight: .medium))
                                    }
                                    .neumorphism(width: 100, height: 70, radius: 8)
                                    .onTapGesture {
                                        selectingStartDate = true
                                        showDatePickerView = true
                                    }
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color("DarkShadow"))
                                        .font(.system(size: 32, weight: .regular))
                                        .frame(width: 30)
                                    
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(MyDateFormatter.shared.onlyWString(endDate) + "曜日")
                                        Text(MyDateFormatter.shared.onlyMDString(endDate))
                                            .font(.system(size: 20, weight: .medium))
                                    }
                                    .neumorphism(width: 100, height: 70, radius: 8)
                                    .onTapGesture {
                                        selectingStartDate = false
                                        showDatePickerView = true
                                    }
                                }
                            } else {
                                Text(MyDateFormatter.shared.onlyDateString(startDate))
    //                                .frame(width: 250, height: 38, alignment: .leading)
                                    .neumorphism(width: 200, height: 30, radius: 5)
    //                                .padding(.leading, 8)
                                    .onTapGesture {
                                        selectingStartDate = true
                                        showDatePickerView = true
                                }
                                
                                HStack(spacing: 5) {
                                    DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)
                                        .datePickerStyle(GraphicalDatePickerStyle())
                                        .labelsHidden()
    //                                    .frame(width: onlyDay ? 120 : 190, height: 30)
                                        .frame(width: 100)
                                        .scaleEffect(1.3)
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color("DarkShadow"))
                                        .font(.system(size: 32, weight: .regular))
                                        .frame(width: 30, alignment: .trailing)
    //                                    .background(Color.red)
                                    
                                    DatePicker("", selection: $endTime, in: startTime..., displayedComponents: .hourAndMinute)
                                        .datePickerStyle(GraphicalDatePickerStyle())
                                        .labelsHidden()
    //                                    .frame(width: onlyDay ? 120 : 190, height: 30)
                                        .frame(width: 100)
                                        .scaleEffect(1.3)
                                }
                                .frame(width: 250, height: 50, alignment: .leading)
    //                            .frame(width: 300, alignment: .leading)
                            }
                        }
//                        .padding(.leading, 20)
//                        .background(Color.blue)
                        .frame(maxWidth: .infinity)
                        .offset(x: 7)
                        .animation(.easeInOut(duration: 0.3))
                        
                        VStack(spacing: 5) {
                            Text(onlyDay ? "終日オン" : "終日オフ").font(.footnote)
                            Toggle("", isOn: $onlyDay)
                                .labelsHidden()
                                .scaleEffect(0.9)
                        }
                        .frame(width: 80)
                        .padding(.trailing)
                    }
                    .neumorphism(width: UIScreen.main.bounds.width - 40, height: 120)
                }
                
                HStack(spacing: 0) {
                    if !showSelectView {
                        Text(onlyDay ? "\(notificationDays[selectedNotificationDay])(\(String(format: "%02d", selectedNotificationHour)):\(String(format: "%02d", selectedNotificationMinute)))" : String(notificationTimes[selectedNotificationTime]))
                            .frame(width: 150)
                            .foregroundColor(.white)
                            .colorMultiply(notification ? .blue : .gray)
                            .neumorphism(width: 160, height: 40, radius: 15, active: notification)
                            .onTapGesture {
                                if notification {
                                    showSelectView = true
                                }
                            }
                            .frame(maxWidth: .infinity)
                    } else {
                        VStack {
                            if onlyDay {
                                HStack(spacing: 0) {
                                    Picker(selection: $selectedNotificationDay, label: Text("")) {
                                        ForEach(0 ..< notificationDays.count) { num in
                                            Text(self.notificationDays[num])
                                        }
                                    }
                                    .labelsHidden()
                                    .scaleEffect(0.8)
                                    .frame(width: 60, height: 85)
                                    .clipped()
                                    
                                    Picker(selection: $selectedNotificationHour, label: Text("")) {
                                        ForEach(0 ..< 24, id: \.self) { num in
                                            let textHour: String = String(format: "%02d", num)
                                            Text("\(textHour)時")
                                        }
                                    }
                                    .labelsHidden()
                                    .scaleEffect(0.8)
                                    .frame(width: 60, height: 85)
                                    .clipped()
                                    
                                    Picker(selection: $selectedNotificationMinute, label: Text("")) {
                                        ForEach(0 ..< 56, id: \.self) { num in
                                            if num % 5 == 0 {
                                                let textMinute: String = String(format: "%02d", num)
                                                Text("\(textMinute)分")
                                            }
                                        }
                                    }
                                    .labelsHidden()
                                    .scaleEffect(0.8)
                                    .frame(width: 60, height: 85)
                                    .clipped()
                                }
                            } else {
                                Picker(selection: $selectedNotificationTime, label: Text("")) {
                                    ForEach(0 ..< notificationTimes.count) { num in
                                        Text(self.notificationTimes[num])
                                    }
                                }
                                .labelsHidden()
                                .scaleEffect(0.8)
                                .frame(width: 140, height: 85)
                                .clipped()
                            }
                        }
                        .neumorphism(width: onlyDay ? 200 : 160, height: 100, radius: 15)
                        .frame(maxWidth: .infinity)
                    }
                    
                    VStack(spacing: 5) {
                        if showSelectView {
                            Button(action: {
                                self.showSelectView = false
                            }) {
                                HStack(spacing: 3) {
                                    Text("完了").font(.callout)
                                    Image(systemName: "checkmark").font(.callout)
                                }
                            }
                            .neumorphism(width: 70, height: 30, radius: 10)
                        } else {
                            Text(notification ? "通知オン" : "通知オフ").font(.footnote)
                            Toggle("", isOn: $notification)
                                .labelsHidden()
                                .scaleEffect(0.9)
                        }
                    }
                    .frame(width: 80)
                    .padding(.trailing)
                    .animation(.easeInOut(duration: 0.3))
                }
                .neumorphism(width: UIScreen.main.bounds.width - 40, height: showSelectView ? 140 : 80)
                
                HStack(spacing: 40) {
                    Circle()
                        .fill(Color.red)
                        .padding(selectedColorNumber == 0 ? 1 : 0)
                        .frame(width: 25, height: 25)
                        .overlay(
                            Circle()
                                .stroke(lineWidth: 2)
                                .fill(Color("BaseColor"))
                                .frame(width: selectedColorNumber == 0 ? 15 : 0, height: selectedColorNumber == 0 ? 15 : 0)
                        )
                        .neumorphism(width: 40, height: 40, radius: 40, active: false, isOn: selectedColorNumber == 0)
                        .frame(width: 40, height: 40)
                        .onTapGesture{
                            self.selectedColorNumber = 0
                        }
                    
                    Circle()
                        .fill(Color.blue)
                        .padding(selectedColorNumber == 1 ? 1 : 0)
                        .frame(width: 25, height: 25)
                        .overlay(
                            Circle()
                                .stroke(lineWidth: 2)
                                .fill(Color("BaseColor"))
                                .frame(width: selectedColorNumber == 1 ? 15 : 0, height: selectedColorNumber == 1 ? 15 : 0)
                        )
                        .neumorphism(width: 40, height: 40, radius: 40, active: false, isOn: selectedColorNumber == 1)
                        .frame(width: 40, height: 40)
                        .onTapGesture{
                            self.selectedColorNumber = 1
                        }
                    
                    Circle()
                        .fill(Color.green)
                        .padding(selectedColorNumber == 2 ? 1 : 0)
                        .frame(width: 25, height: 25)
                        .overlay(
                            Circle()
                                .stroke(lineWidth: 2)
                                .fill(Color("BaseColor"))
                                .frame(width: selectedColorNumber == 2 ? 15 : 0, height: selectedColorNumber == 2 ? 15 : 0)
                        )
                        .neumorphism(width: 40, height: 40, radius: 40, active: false, isOn: selectedColorNumber == 2)
                        .frame(width: 40, height: 40)
                        .onTapGesture{
                            self.selectedColorNumber = 2
                        }
                    
                    Circle()
                        .fill(Color.purple)
                        .padding(selectedColorNumber == 3 ? 1 : 0)
                        .frame(width: 25, height: 25)
                        .overlay(
                            Circle()
                                .stroke(lineWidth: 2)
                                .fill(Color("BaseColor"))
                                .frame(width: selectedColorNumber == 3 ? 15 : 0, height: selectedColorNumber == 3 ? 15 : 0)
                        )
                        .neumorphism(width: 40, height: 40, radius: 40, active: false, isOn: selectedColorNumber == 3)
                        .frame(width: 40, height: 40)
                        .onTapGesture{
                            self.selectedColorNumber = 3
                        }
                    
                    //                    if #available(iOS 14.0, *) {
                    //                        ColorPicker("", selection: $userColor, supportsOpacity: false)
                    //                            .labelsHidden()
                    //                    }
                }
                .animation(.easeInOut(duration: 0.3))
                .neumorphism(width: UIScreen.main.bounds.width - 40, height: 60)
                
                HStack(spacing: 90) {
                    Button(action: {
                        self.showAddPlanView = false
                        self.planTitle = ""
                        self.startDate = Date()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self.endDate = Date() + (60 * 30)
                        }
                        self.onlyDay = true
                        self.notification = false
                        self.showSelectView = false
                    }) {
                        Text("閉じる")
                            .foregroundColor(Color.black.opacity(0.8))
                    }
                    .neumorphism(width: 80, height: 40, radius: 10)
                    
                    if editPlan {
                        Button(action: {
                            //                        print(self.startDate, self.endDate)
                            
                            self.updateTask(plan: self.plan!)
                            
                            self.showAddPlanView = false
                            
                            self.planTitle = ""
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                self.endDate = Date() + (60 * 30)
                            }
                            self.onlyDay = true
                            self.notification = false
                            self.showSelectView = false
                        }) {
                            HStack(spacing: 3) {
                                Text("保存").font(.body)
                                Image(systemName: "checkmark").font(.body)
                            }
                        }
                        .neumorphism(width: 80, height: 40, radius: 10)
                    } else {
                        Button(action: {
                            //                        print(self.startDate, self.endDate)
                            
                            self.addTask()
                            
                            self.showAddPlanView = false
                            
                            self.planTitle = ""
                            self.startDate = Date()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                self.endDate = Date() + (60 * 30)
                            }
                            self.onlyDay = true
                            self.notification = false
                            self.showSelectView = false
                        }) {
                            HStack(spacing: 3) {
                                Text("追加").font(.body)
                                Image(systemName: "checkmark").font(.body)
                            }
                        }
                        .neumorphism(width: 80, height: 40, radius: 10)
                    }
                }
                
                Spacer()
            }
//        }
        .padding(.top, 20)
        .frame(maxWidth: .infinity)
        .frame(height: 600)
        .background(Color("BaseColor"))
        .cornerRadius(30)
        .offset(y: showSelectView ? -60 : 0)
        .animation(.easeInOut(duration: 0.3))
            .onChange(of: showAddPlanView, perform: { value in
                if !value {
                    showDatePickerView = false
                }
            })
            
            Color.white.opacity(0.001)
            .onLongPressGesture(pressing: { pressing in
                if pressing {
                    hideKeyboard()
                    self.typing = false
                }
            }) { }
            .offset(y: typing ? -300 : 1000)
            
            
            VisualEffectView(effect: UIBlurEffect(style: .regular))
                .onTapGesture {
                    showDatePickerView = false
                }
                .opacity(showDatePickerView ? 0.95 : 0)
                .animation(.easeInOut)
                .frame(maxWidth: .infinity)
                .frame(height: 600)
                .cornerRadius(30)
                .offset(y: showSelectView ? -60 : 0)
                .animation(.easeInOut(duration: 0.2))
            
            DatePickerView(startDate: $startDate, endDate: $endDate, bool: $selectingStartDate)
                .opacity(showDatePickerView ? 1 : 0)
                .scaleEffect(showDatePickerView ? 1 : 0.3)
                .animation(.easeInOut(duration: 0.3))
        }
    }
    
    func addTask() {
        let newPlan = Plan(context: context)
        newPlan.order = planCount + 1
        newPlan.title = planTitle
        if onlyDay {
            newPlan.startDate = startDate
            newPlan.endDate = endDate
        } else {
            let dateString = MyDateFormatter.shared.onlyDSString(startDate)
            let sStartTime = MyDateFormatter.shared.onlyTSString(startTime)
            let sEndTime = MyDateFormatter.shared.onlyTSString(endTime)
            newPlan.startDate = MyDateFormatter.shared.dateFromString(dateString + "/" + sStartTime)
            newPlan.endDate = MyDateFormatter.shared.dateFromString(dateString + "/" + sEndTime)
        }
        newPlan.onlyDay = onlyDay
        newPlan.notification = notification
        if notification {
            if onlyDay {
                newPlan.notificationDay = Int16(selectedNotificationDay)
                newPlan.notificationHour = Int16(selectedNotificationHour)
                newPlan.notificationMinute = Int16(selectedNotificationMinute)
            } else {
                newPlan.notificationTime = Int16(selectedNotificationTime)
            }
        }
        newPlan.color = Int16(selectedColorNumber)
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func updateTask(plan: Plan) {
        plan.title = planTitle
        if onlyDay {
            plan.startDate = startDate
            plan.endDate = endDate
        } else {
            let dateString = MyDateFormatter.shared.onlyDSString(startDate)
            let sStartTime = MyDateFormatter.shared.onlyTSString(startTime)
            let sEndTime = MyDateFormatter.shared.onlyTSString(endTime)
            plan.startDate = MyDateFormatter.shared.dateFromString(dateString + "/" + sStartTime)
            plan.endDate = MyDateFormatter.shared.dateFromString(dateString + "/" + sEndTime)
        }
        plan.onlyDay = onlyDay
        plan.notification = notification
        if notification {
            if onlyDay {
                plan.notificationDay = Int16(selectedNotificationDay)
                plan.notificationHour = Int16(selectedNotificationHour)
                plan.notificationMinute = Int16(selectedNotificationMinute)
            } else {
                plan.notificationTime = Int16(selectedNotificationTime)
            }
        }
        plan.color = Int16(selectedColorNumber)
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}

struct DatePickerView: View {
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var bool: Bool
    
    var body: some View {
//        ZStack {
        DatePicker("", selection: bool ? $startDate : $endDate, in: startDate.addingTimeInterval(bool ? -60*60*24*365*5 : 0)..., displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .labelsHidden()
                .padding(10)
                .frame(width: 320, height: 320)
                .background(Color.white)
                .cornerRadius(15)
                .offset(y: -40)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .cornerRadius(20)
    }
}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

struct Neumorphism: ViewModifier {
    var width: CGFloat
    var height: CGFloat
    var radius: CGFloat
    var active: Bool
    
    func body(content: Content) -> some View {
        //        ZStack {
        //            if !active {
        //                RoundedRectangle(cornerRadius: radius)
        //                    .foregroundColor(Color("BaseColor"))
        //                    .frame(width: width - 10, height: height - 10)
        //                    .shadow(color: Color("LightShadow"), radius: 6, x: 6, y: 6)
        //                    .shadow(color: Color("DarkShadow"), radius: 6, x: -6, y: -6)
        //                    .frame(width: width, height: height)
        //                    .cornerRadius(radius + 5)
        //                    .clipped()
        //                    .blur(radius: 1)
        //            }
        //
        //            content
        //                .frame(width: active ? width : width - 10, height: active ? height : height - 10)
        //                .background(Color("BaseColor"))
        //                .cornerRadius(radius)
        //                .clipped()
        //                .shadow(color: active ? Color("LightShadow") : Color.clear, radius: 6, x: -6, y: -6)
        //                .shadow(color: active ? Color("DarkShadow") : Color.clear, radius: 6, x: 6, y: 6)
        //        }
        
        content
            .frame(width: width, height: height)
            .overlay(
                Group {
                    if !active {
                        RoundedRectangle(cornerRadius: radius - 5)
                            .stroke(Color("BaseColor"), lineWidth: 4)
                            .shadow(color: Color("DarkShadow"), radius: 3, x: 3, y: 3)
                            .clipShape(RoundedRectangle(cornerRadius: radius - 5))
                            .shadow(color: Color("LightShadow"), radius: 2, x: -2, y: -2)
                            .clipShape(RoundedRectangle(cornerRadius: radius - 5))
                    }
                }
            )
            .animation(.easeInOut(duration: active ? 0.2 : 0.3))
            .background(Color("BaseColor"))
            .cornerRadius(radius)
            .shadow(color: active ? Color("DarkShadow") : Color.clear, radius: 3, x: 3, y: 3)
            .shadow(color: active ? Color("LightShadow") : Color.clear, radius: 2, x: -2, y: -2)
            .animation(.easeInOut(duration: active ? 0.3 : 0.2))
    }
}

extension View {
    func neumorphism(width: CGFloat, height: CGFloat, radius: CGFloat = 20, active: Bool = true, isOn: Bool = true) -> some View {
        Group {
            if isOn {
                self.modifier(Neumorphism(width: width, height: height, radius: radius, active: active))
            } else {
                self
            }
        }
    }
}

//struct AddPlanView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddPlanView(startDate: Date(), showAddPlanView: .constant(true))
//            .environment(\.locale, Locale(identifier: "ja_JP"))
//    }
//}
