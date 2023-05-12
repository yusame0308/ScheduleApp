//
//  CalendarView.swift
//  schedule
//
//  Created by 小原 宙 on 2020/08/24.
//  Copyright © 2020 小原 宙. All rights reserved.
//

import SwiftUI

struct CalendarView: View {
    var plans: FetchedResults<Plan>
    var todos: FetchedResults<Todo>
    
    @Binding var showAddPlanView: Bool
    @State var startDate: Date = Date()
    @State var endDate: Date = Date() + (60 * 30)
    @State private var showDayPlanView = false
    @State var year = "2020"
    @State var month = "12"
    @State var date = "31"
    @State var editPlan = false
    @State var planTitle = ""
    @State var onlyDay = true
    @State var notification = false
    @State var showSelectView = false
    @State var selectedNotificationTime = 2
    @State var selectedNotificationDay = 1
    @State var selectedNotificationHour = 9
    @State var selectedNotificationMinute = 0
    @State var selectedColorNumber = 0
    @State var plan: Plan?
    @Binding var scrollYear: String
    @Binding var scrollMonth: String
    @Binding var scroll: ScrollViewProxy?
    @Binding var BTIndex: Int
    @State var planCount: Int16 = 0
    @State var isEditing = false
    @ObservedObject var user: User
    
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            ScrollCalendarView(user: user, plans: plans, todos: todos, startDate: $startDate, endDate: $endDate, editPlan: $editPlan, showAddPlanView: $showAddPlanView, showDayPlanView: $showDayPlanView, year: $year, month: $month, date: $date, planTitle: $planTitle, onlyDay: $onlyDay, notification: $notification, showSelectView: $showSelectView, scrollYear: $scrollYear, scrollMonth: $scrollMonth, scroll: $scroll, BTIndex: $BTIndex, isEditing: $isEditing)
            
            DayPlanView(user: user, plans: plans, year: year, month: month, date: date, showDayPlanView: $showDayPlanView, showAddPlanView: $showAddPlanView, editPlan: $editPlan, startDate: $startDate, endDate: $endDate, planTitle: $planTitle, onlyDay: $onlyDay, notification: $notification, selectedNotificationTime: $selectedNotificationTime, selectedNotificationDay: $selectedNotificationDay, selectedNotificationHour: $selectedNotificationHour, selectedNotificationMinute: $selectedNotificationMinute, selectedColorNumber: $selectedColorNumber, plan: $plan, isEditing: $isEditing, planCount: $planCount)
                .offset(y: showDayPlanView ? (UIScreen.main.bounds.height / 2) - 115 - 90 + 30 : UIScreen.main.bounds.height)
//                .offset(y: UIScreen.main.bounds.height / 2 - 125)
            
            AddPlanView(planTitle: $planTitle, startDate: $startDate, endDate: $endDate, onlyDay: $onlyDay, notification: $notification, showSelectView: $showSelectView, selectedNotificationTime: $selectedNotificationTime, selectedNotificationDay: $selectedNotificationDay, selectedNotificationHour: $selectedNotificationHour, selectedNotificationMinute: $selectedNotificationMinute, selectedColorNumber: $selectedColorNumber, showAddPlanView: $showAddPlanView, editPlan: $editPlan, plan: $plan, planCount: $planCount)
                .offset(y: showAddPlanView ? UIScreen.main.bounds.height / 6 : UIScreen.main.bounds.height)
//                .offset(y: dragDistance.height)
//                .gesture(
//                    DragGesture(coordinateSpace: .local)
//                        .onChanged { value in
//                            if value.translation.height > 0 {
//                                self.dragDistance = value.translation
//                            }
//                        }
//                        .onEnded { value in
//                            if self.dragDistance.height > 80 {
//                                showAddPlanView = false
//                            }
//                            self.dragDistance = .zero
//                        }
//                )
        }
        .onChange(of: showAddPlanView, perform: { value in
            if value {
                self.showDayPlanView = false
            }
        })
        .edgesIgnoringSafeArea(.all)
        .animation(.easeInOut(duration: 0.3))
    }
}

struct ScrollCalendarView: View {
    @ObservedObject var user: User
    var plans: FetchedResults<Plan>
    var todos: FetchedResults<Todo>
//    let datesList = dates()
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var editPlan: Bool
    @Binding var showAddPlanView: Bool
    @Binding var showDayPlanView: Bool
    @Binding var year: String
    @Binding var month: String
    @Binding var date: String
    @Binding var planTitle: String
    @Binding var onlyDay: Bool
    @Binding var notification: Bool
    @Binding var showSelectView: Bool
    static let todayDatas = MyCalendar.shared.datasFromDate(Date())
    @Binding var scrollYear: String
    @Binding var scrollMonth: String
    let topLimit = UIScreen.main.bounds.height / 4
    let bottomLimit = UIScreen.main.bounds.height / 2
    @Binding var scroll: ScrollViewProxy?
    @Binding var BTIndex: Int
    @Binding var isEditing: Bool
    let textSizes: [CGFloat] = [12, 10, 8]
    @State var watchingDate = -1
    
    var body: some View {
        let tIndex = todayIndex()
        ScrollView(.vertical, showsIndicators: false) {
            ScrollViewReader { scroll in
//                Button(action: {
//                    scrollToday()
//                }) {
//                    Text("PUSH")
                //                        .frame(width: 200, height: 200)
                //                        .background(Color.red)
                //                }
                ZStack {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 0) {
                        ForEach(datesArray.indices) { i in
                            if i >= user.startWday {
                                let data = datesArray[i]
                                let year = data[0]
                                let month = data[1]
                                let date = data[2]
                                let wday = data[3]
                                let holiday = data[4]
                                //                            let intYear = Int(data[0])!
                                //                            let intMonth = Int(data[1])!
                                //                            let intDate = Int(data[2])!
                                let showMonth = wday == String(user.startWday > 3 ? user.startWday - 4 : user.startWday + 3) && Int(data[2])! > 14 && Int(data[2])! < 22
                                //                            let isToday = todayDatas[2] == date && todayDatas[1] == month && todayDatas[0] == year
                                
                                ZStack {
                                    if i == tIndex {
                                        themeColors[user.themeColor].opacity(0.1)
                                        //                                        .id(10000)
                                        //                                        .border(Color("ThemeColor"), width: 1)
                                    }
                                    
                                    if showMonth {
                                        GeometryReader { geo -> Text in
                                            let geoY = geo.frame(in: .global).origin.y
                                            if geoY > topLimit && geoY < bottomLimit {
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                    self.scrollYear = year
                                                    self.scrollMonth = month
                                                }
                                            }
                                            
                                            return Text("")
                                        }
                                        Text(month)
                                            .italic()
                                            .font(.system(size: 24, weight: .bold))
                                            .foregroundColor(Color.black.opacity(0.15))
                                            .scaleEffect(2.5)
                                            .frame(width: UIScreen.main.bounds.width / 7, alignment: .center)
                                            .offset(y: -45)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(date)
                                            .font(.system(size: 12, weight: .regular))
                                            //                                        .overlay(
                                            //                                            RoundedRectangle(cornerRadius: 5)
                                            //                                                .stroke(Color("BaseColor"), lineWidth: 4)
                                            //                                                .shadow(color: Color("DarkShadow"), radius: 3, x: 3, y: 3)
                                            //                                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                            //                                                .shadow(color: Color("LightShadow"), radius: 2, x: -2, y: -2)
                                            //                                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                            //                                        )
                                            //                                        .offset(x: -1)
                                            .padding(.horizontal, 1)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .ifc(i == tIndex) { $0.background(themeColors[user.themeColor]).foregroundColor(.white) }
                                            .modifier(OffDay(user: user, wday: wday, holiday: holiday))
                                        
                                        VStack(spacing: 1) {
                                            if holiday != "" {
                                                Text(holiday)
                                                    .event(Color(#colorLiteral(red: 0.9034144988, green: 0, blue: 0.3924532572, alpha: 1)), size: textSizes[user.textSize])
                                                //                                            .neumorphism(width: 50, height: 17, radius: 0)
                                            }
                                            ForEach(todos) { todo in
                                                if todo.hasLimit && !todo.finished {
                                                    let hasTodo = MyDateFormatter.shared.compareDate(year + "/" + month + "/" + date, start: todo.limit!, end: todo.limit!)
                                                    
                                                    if hasTodo {
                                                        Text(todo.title ?? "No Title")
                                                            .event(Color.black, size: textSizes[user.textSize])
                                                    }
                                                }
                                            }
                                            ForEach(plans) { plan in
                                                let hasPlan = MyDateFormatter.shared.compareDate(year + "/" + month + "/" + date, start: plan.startDate!, end: plan.endDate!)
                                                
                                                if hasPlan {
                                                    let colors = [Color.red, Color.blue, Color.green, Color.purple]
                                                    
                                                    Text(plan.title ?? "No Title")
                                                        .event(colors[Int(plan.color)], size: textSizes[user.textSize])
                                                    //                                                .neumorphism(width: 50, height: 17, radius: 0)
                                                }
                                            }
                                        }
                                        //                                    .padding(.horizontal, 1)
                                        .padding(1)
                                        
                                        Spacer(minLength: 0)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 90)
                                    .background(Color.white.opacity(0.001))
                                    .animation(.easeInOut(duration: 0.3))
                                    .border(themeColors[user.themeColor].opacity(0.8), width: watchingDate == i ? 2 : 0)
                                    .onTapGesture {
                                        watchingDate = i
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            self.isEditing = false
                                            self.editPlan = false
                                            self.year = year
                                            self.month = month
                                            self.date = date
                                            self.showDayPlanView = true
                                        }
                                    }
                                    .onLongPressGesture(
                                        //                                    minimumDuration: 0.1
                                        //                                    pressing: { value in
                                        //                                        if value {
                                        //                                            print("true")
                                        //                                        } else {
                                        //                                            print("false")
                                        //                                        }
                                        //                                    }
                                    ) {
                                        simpleSuccess()
                                        self.showAddPlanView = true
                                        self.editPlan = false
                                        let dateString = MyDateFormatter.shared.dateFromString(year + "/" + month + "/" + date + "/09:00")
                                        startDate = dateString
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            endDate = dateString
                                        }
                                    }
                                    //                                .neumorphism(width: UIScreen.main.bounds.width/7, height: 80, radius: 5, active: false)
                                    
                                    
                                    Rectangle()
                                        .frame(width: UIScreen.main.bounds.width / 7, height: Int(data[2])! < 8 ? 1.5 : 0.5)
                                        .foregroundColor(Int(data[2])! < 8 ? Color.black : Color.gray)
                                        .offset(y: -45)
                                    
                                    Rectangle()
                                        .frame(width: Int(data[2])! == 1 ? 1.5 : 0.5, height: 91)
                                        .foregroundColor(Int(data[2])! == 1 ? Color.black : Color.gray)
                                        .offset(x: UIScreen.main.bounds.width / -14, y: 1)
//                                        .opacity(wday == "0" ? 0 : 1)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 4)
                    .onAppear {
                        DispatchQueue.main.async {
                        scroll.scrollTo(tIndex, anchor: .center)
                        }
                        self.scroll = scroll
                        self.BTIndex = tIndex
                        UIScrollView.appearance().scrollsToTop = false
                    }
                    .onChange(of: showDayPlanView, perform: { value in
                        if !value {
                            watchingDate = -1
                        }
                    })
                    
                    Color.black.opacity(showAddPlanView ? 0.3 : 0)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showAddPlanView = false
                            self.planTitle = ""
                            self.startDate = Date()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                self.endDate = Date() + (60 * 30)
                            }
                            self.onlyDay = true
                            self.notification = false
                            self.showSelectView = false
                        }
                }
            }
        }
    }
    
//    func scrollToday() {
//        let tIndex = todayIndex()
//        withAnimation {
//            self.scroll?.scrollTo(tIndex, anchor: .center)
//        }
//    }
    
    func todayIndex() -> Int {
        for i in datesArray.indices where datesArray[i][2] == ScrollCalendarView.todayDatas[2] && datesArray[i][1] == ScrollCalendarView.todayDatas[1] && datesArray[i][0] == ScrollCalendarView.todayDatas[0] {
            return i
        }
        return 0
    }
}

struct OffDay: ViewModifier {
    @ObservedObject var user: User
    let wday: String
    let holiday: String
    
    func body(content: Content) -> some View {
        Group {
            if holiday != "" || calcInt() {
                if holiday != "" {
                    content.foregroundColor(Color(#colorLiteral(red: 0.801217481, green: 0, blue: 0.04495445221, alpha: 1)))
                } else if wday == "6" {
                    content.foregroundColor(Color(#colorLiteral(red: 0.03694729508, green: 0, blue: 0.8258248731, alpha: 1)))
                } else {
                    content.foregroundColor(Color(#colorLiteral(red: 0.801217481, green: 0, blue: 0.04495445221, alpha: 1)))
                }
            } else {
                content
            }
        }
    }
    func calcInt() -> Bool {
        for i in user.offDays {
//            var j = i + 1
//            if i == 6 {
//                j = 0
//            }
            if i == Int(wday)! {
                return true
            }
        }
        return false
    }
}

extension Text {
    func event(_ color: Color, size: CGFloat) -> some View {
        self
            .kerning(-0.4)
            .font(.system(size: size, weight: .medium))
            .foregroundColor(.white)
            .lineLimit(1)
            .fixedSize()
            .frame(width: UIScreen.main.bounds.width/7-6, height: 12, alignment: .leading)
            .clipped()
            .padding(1)
            .padding(.horizontal, 1)
            .background(color)
            .cornerRadius(2)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

extension View {
    func ifc<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> TupleView<(Self?, Content?)> {
        if conditional { return TupleView((nil, content(self))) }
        else { return TupleView((self, nil)) }
    }
}

//extension View {
//    func event(_ color: Color) -> some View {
//        self.modifier(Event(color: color))
//    }
//}



//func dateFromString(_ dateString: String, _ dateFormat: String) -> Date {
////    extension DateFormatter {
////        static var formatter: DateFormatter = {
////            let f = DateFormatter()
////            f.dateFormat = "yyyy/MM/dd/HH:mm"
////            return f
////        }()
////    }
//    let f = DateFormatter.Current
//    f.dateFormat = dateFormat
//    return f.date(from: dateString)!
//}

//func datasFromDate(_ date: Date) -> [String] {
//    let calendar = Calendar.Current
//    let datas = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
//    var stringDatas: [String]  = []
//    stringDatas += [String(datas.year!), String(datas.month!), String(datas.day!), String(datas.hour!), String(datas.minute!)]
//    return stringDatas
//}

//func roundDate(_ date: Date) -> Date {
//    let cal = Calendar.Current
//  return cal.date(from: DateComponents(year: cal.component(.year, from: date), month: cal.component(.month, from: date), day: cal.component(.day, from: date)))!
//}

//func compareDate(_ date: String, start: Date, end: Date) -> Bool {
//    let f = DateFormatter.Current
//
//    let theDate = f.date(from: date)!
//    let startDate = roundDate(start)
//    let endDate = roundDate(end)
//
//    return theDate >= startDate && endDate >= theDate
//}

//extension DateFormatter {
//    static var Current: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.locale = .current
//        formatter.timeZone = .current
//        formatter.dateFormat = "yyyy/MM/dd"
//        return formatter
//    }()
//}
//
//extension Calendar {
//    static var Current: Calendar = {
//        var calendar = Calendar(identifier: .gregorian)
//        calendar.timeZone = .current
//        calendar.locale = .current
//        return calendar
//    }()
//}

class MyCalendar {
    static let shared = MyCalendar()
    private let calendar = Calendar(identifier: .gregorian)
    
    func roundDate(_ date: Date) -> Date {
      return calendar.date(from: DateComponents(year: calendar.component(.year, from: date), month: calendar.component(.month, from: date), day: calendar.component(.day, from: date)))!
    }
    
    func datasFromDate(_ date: Date) -> [String] {
        let datas = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        var stringDatas: [String]  = []
        stringDatas += [String(datas.year!), String(datas.month!), String(datas.day!), String(datas.hour!), String(datas.minute!)]
        return stringDatas
    }
}


class MyDateFormatter {
    static let shared = MyDateFormatter()
    private let ymdDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy/MM/dd"
        return f
    }()
    
    private let ymdhmDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy/MM/dd/HH:mm"
        return f
    }()
    
    private let onlyDate: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .full
        f.timeStyle = .none
        return f
    }()
    
    private let onlyMD: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = DateFormatter.dateFormat(fromTemplate: "dMMM", options: 0, locale: Locale(identifier: "ja_JP"))
        return f
    }()
    
    private let onlyW: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEEE", options: 0, locale: Locale(identifier: "ja_JP"))
        return f
    }()
    
    private let onlyDateShort: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .none
        return f
    }()
    
    private let onlyTimeShort: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .none
        f.timeStyle = .short
        return f
    }()
    
    func onlyDateString(_ date: Date) -> String {
        return onlyDate.string(from: date)
    }
    
    func onlyMDString(_ date: Date) -> String {
        return onlyMD.string(from: date)
    }
    
    func onlyWString(_ date: Date) -> String {
        return onlyW.string(from: date)
    }
    
    func onlyDSString(_ date: Date) -> String {
        return onlyDateShort.string(from: date)
    }
    
    func onlyTSString(_ date: Date) -> String {
        return onlyTimeShort.string(from: date)
    }
    
    func dateFromString(_ dateString: String) -> Date {
        return ymdhmDateFormatter.date(from: dateString)!
    }
    
    func compareDate(_ date: String, start: Date, end: Date) -> Bool {
        let theDate = ymdDateFormatter.date(from: date)!
        let startDate = MyCalendar.shared.roundDate(start)
        let endDate = MyCalendar.shared.roundDate(end)
        
        return theDate >= startDate && endDate >= theDate
    }
}

//extension DateComponents {
//    static var Current: DateComponents = {
//        var comp = DateComponents()
//        comp.calendar = Calendar.Current
//        comp.timeZone = .current
//        return comp
//    }()
//}

//struct CalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        let context = (UIApplication.shared.delegate as! AppDelegate)
//            .persistentContainer.viewContext
//        return CalendarView(showAddPlanView: .constant(false), scrollYear: .constant("2020"), scrollMonth: .constant("12"), scroll: .constant(nil), BTIndex: .constant(100), planCount: 0)
//            .environment(\.managedObjectContext, context)
//            .environment(\.locale, Locale(identifier: "ja_JP"))
//    }
//}
