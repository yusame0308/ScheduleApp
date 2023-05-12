//
//  DayPlanView.swift
//  schedule
//
//  Created by 小原 宙 on 2020/09/19.
//  Copyright © 2020 小原 宙. All rights reserved.
//

import SwiftUI

struct DayPlanView: View {
    @Environment(\.managedObjectContext) var context
    @ObservedObject var user: User
    
    var plans: FetchedResults<Plan>
    let year: String
    let month: String
    let date: String
    @State var geo: CGFloat = 0
    @Binding var showDayPlanView: Bool
    let colors = [Color.red, Color.blue, Color.green, Color.purple]
    @Binding var showAddPlanView: Bool
    @Binding var editPlan: Bool
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var planTitle: String
    @Binding var onlyDay: Bool
    @Binding var notification: Bool
    @Binding var selectedNotificationTime: Int
    @Binding var selectedNotificationDay: Int
    @Binding var selectedNotificationHour: Int
    @Binding var selectedNotificationMinute: Int
    @Binding var selectedColorNumber: Int
    @Binding var plan: Plan?
    @Binding var isEditing: Bool
    @Binding var planCount: Int16
    @State var lock = false
    
    var body: some View {
        let offset = geo - (UIScreen.main.bounds.height - 90 - 240 + 27.2)
        let offsetSize = Int(offset) >= 0 ? offset : 0
        let checkOffset = offsetSize >= 100
        
        VStack(spacing: 0) {
            HStack {
                Text(String(format: "%02d", Int(month)!) + "月" + String(format: "%02d", Int(date)!) + "日")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium))
                Spacer()
                Button(action: {
                    withAnimation {
                        self.isEditing.toggle()
                    }
                }) {
                    Text(isEditing ? "完了" : "並べ替え")
                }
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .regular))
            }
            .padding(.horizontal, 10)
            .frame(height: 30)
            .background(themeColors[user.themeColor])
            .animation(checkOffset ? .default : nil)
            .offset(y: checkOffset ? 0 : offsetSize)
            .zIndex(1)
            .onChange(of: showDayPlanView, perform: { value in
//                if value {
//                    lock = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        lock = value
                    }
//                }
            })
            
            List {
                GeometryReader { topGeo -> Text in
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if topGeo.frame(in: .global).origin.y > 300 {
                            geo = topGeo.frame(in: .global).origin.y
                        }
//                    }
//                    print(geo)
//                    offsetSize = showDayPlanView ? offsetSize : 600
//                    let off = UIScreen.main.bounds.height - 90 - 230 + 12.2
//                    print(geo, off, off - geo, offsetSize)
                    if showDayPlanView {
                        if !checkOffset && offsetSize >= 50 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                showDayPlanView = false
                            }
                        }
                    }
                    
                    return Text("")
                }
                .frame(height: lock ? 30 : 34)
                .opacity(0.001)
                
//                if lock {
//                    Color.white
//                        .frame(height: 1)
//                }
                
                ForEach(plans, id: \.self) { plan in
                    let hasPlan = MyDateFormatter.shared.compareDate(year + "/" + month + "/" + date, start: plan.startDate!, end: plan.endDate!)
                    
                    if hasPlan {
                        HStack {
                            Circle()
                                .fill(colors[Int(plan.color)])
                                .frame(width: 15, height: 15)
                            
                            if plan.onlyDay {
                                Text("終日")
                                    .font(.system(size: 14, weight: .light))
                                    .frame(width: 35)
                            } else {
                                let startDate = MyCalendar.shared.datasFromDate(plan.startDate!)
                                let endDate = MyCalendar.shared.datasFromDate(plan.endDate!)
                                    
                                VStack(alignment: .center, spacing: 1) {
                                    Text(String(format: "%02d", Int(startDate[3])!) + ":" + String(format: "%02d", Int(startDate[4])!))
                                        .font(.caption)
                                        .fontWeight(.light)
                                    
                                    Image(systemName: "chevron.compact.down")
                                        .font(.caption)
                                    
                                    Text(String(format: "%02d", Int(endDate[3])!) + ":" + String(format: "%02d", Int(endDate[4])!))
                                        .font(.caption)
                                        .fontWeight(.light)
                                }
                                .frame(width: 35)
                            }
                            
                            Text(plan.title!)
                                .font(.system(size: 18, weight: .light))
                            
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.showAddPlanView = true
                            self.plan = plan
                            self.editPlan = true
                            self.planTitle = plan.title!
                            self.startDate = plan.startDate!
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                self.endDate = plan.endDate!
                            }
                            self.onlyDay = plan.onlyDay
                            self.notification = plan.notification
                            if plan.notification {
                                if plan.onlyDay {
                                    self.selectedNotificationDay = Int(plan.notificationDay)
                                    self.selectedNotificationHour = Int(plan.notificationHour)
                                    self.selectedNotificationMinute = Int(plan.notificationMinute)
                                } else {
                                    self.selectedNotificationTime = Int(plan.notificationTime)
                                }
                            }
                            self.selectedColorNumber = Int(plan.color)
                        }
//                        .onAppear{print(plan.startDate!, plan.endDate!)}
//                            .listRowInsets(EdgeInsets())
                    }
                }
                .onDelete(perform: self.deletePlan)
                .onMove(perform: self.movePlan)
                .onAppear {
                    self.planCount = self.plans.last?.order ?? 0
                }
            }
            .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive))
//            .environment(\.defaultMinListRowHeight, 1)
            .offset(y: -45)
            .frame(height: 230) // 260
            .clipped()
            .onChange(of: showDayPlanView, perform: { value in
                if !value {
                    self.isEditing = false
                }
            })
        }
        .onAppear {
            UITableView.appearance().showsVerticalScrollIndicator = false
        }
        .frame(maxWidth: .infinity)
        .opacity(checkOffset ? 1 : 1 - Double(offsetSize) / 40)
    }
    
    func movePlan(indexSet: IndexSet, destination: Int) {
        let source = indexSet.first!
        
        if source < destination {
            var startIndex = source + 1
            let endIndex = destination - 1
            var startOrder = plans[source].order
            while startIndex <= endIndex {
                plans[startIndex].order = startOrder
                startOrder = startOrder + 1
                startIndex = startIndex + 1
            }
            plans[source].order = startOrder
        } else if destination < source {
            var startIndex = destination
            let endIndex = source - 1
            var startOrder = plans[destination].order + 1
            let newOrder = plans[destination].order
            while startIndex <= endIndex {
                plans[startIndex].order = startOrder
                startOrder = startOrder + 1
                startIndex = startIndex + 1
            }
            plans[source].order = newOrder
        }
        do {
            try context.save()
        } catch {
            print(error)
        }
    }

    
    func deletePlan(at offsets: IndexSet) {
        for index in offsets {
            let plan = plans[index]
            context.delete(plan)
        }
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}

//struct DayPlanView_Previews: PreviewProvider {
//    static var previews: some View {
//        DayPlanView()
//    }
//}
