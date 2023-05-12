//
//  SearchView.swift
//  schedule
//
//  Created by 小原 宙 on 2020/10/19.
//  Copyright © 2020 小原 宙. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var user: User
    var plans: FetchedResults<Plan>
//    @State var datesList: [[String]] = []
    @Binding var searchText: String
    @State var heads: [[String]] = []
    @Binding var showing: Int
    
    var body: some View {
        ScrollViewReader { proxy in
            List {
                ForEach(heads.indices, id: \.self) { t in
                    let inHeaders = heads[t]
                    Group {
                        if searchText == "" {
                            Section(header: SectionHeader(user: user, text: inHeaders.first!)) {
                                ForEach(inHeaders.indices, id: \.self) { i in
                                    if i != 0 {
                                        if let j = Int(inHeaders[i]) {
                                            RowView(plan: plans[j])
                                        } else {
                                            HStack {
                                                Circle()
                                                    .fill(Color(#colorLiteral(red: 0.9034144988, green: 0, blue: 0.3924532572, alpha: 1)))
                                                    .frame(width: 15, height: 15)
                                                Text("終日")
                                                    .font(.system(size: 14, weight: .light))
                                                    .frame(width: 35)
                                                Text(inHeaders[i])
                                                    .font(.system(size: 18, weight: .light))
                                                Spacer()
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            if showHeader(headers: inHeaders) {
                                Section(header: SectionHeader(user: user, text: inHeaders.first!)) {
                                    ForEach(inHeaders.indices, id: \.self) { i in
                                        if i != 0 {
                                            if let j = Int(inHeaders[i]) {
                                                if plans[j].title!.lowercased().contains(searchText.lowercased()) {
                                                    RowView(plan: plans[j])
                                                }
                                            } else {
                                                if inHeaders[i].lowercased().contains(searchText.lowercased()) {
                                                    HStack {
                                                        Circle()
                                                            .fill(Color(#colorLiteral(red: 0.9034144988, green: 0, blue: 0.3924532572, alpha: 1)))
                                                            .frame(width: 15, height: 15)
                                                        Text("終日")
                                                            .font(.system(size: 14, weight: .light))
                                                            .frame(width: 35)
                                                        Text(inHeaders[i])
                                                            .font(.system(size: 18, weight: .light))
                                                        Spacer()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }.id(t)
                }
            }
            .onAppear {
                self.heads = headers()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    proxy.scrollTo(25)
                }
            }
            .onChange(of: showing, perform: { value in
                if value == 3 {
                    self.heads = headers()
                }
            })
        }
//        .onAppear {
//            self.datesList = dates()
//        }
    }
    
    func showHeader(headers: [String]) -> Bool {
        for i in headers.indices {
            if i != 0 {
                if let j = Int(headers[i]) {
                    if plans[j].title!.lowercased().contains(searchText.lowercased()) {
                        return true
                    }
                } else {
                    if headers[i].lowercased().contains(searchText.lowercased()) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func headers() -> [[String]] {
        var strings: [[String]] = []
        var string: [String] = []
        let wdays = ["日", "月", "火", "水", "木", "金", "土"]
        for i in datesArray.indices where datesArray[i][4] != "" || hasPlans(year: datesArray[i][0], month: datesArray[i][1], date: datesArray[i][2]) != [] {
            string.append(String(format: "%02d", Int(datesArray[i][1])!) + "月" + String(format: "%02d", Int(datesArray[i][2])!) + "日" + "(\(wdays[Int(datesArray[i][3])!]))")
            if datesArray[i][4] != "" {
                string.append(datesArray[i][4])
            }
            if hasPlans(year: datesArray[i][0], month: datesArray[i][1], date: datesArray[i][2]) != [] {
                for j in hasPlans(year: datesArray[i][0], month: datesArray[i][1], date: datesArray[i][2]) {
                    string.append(String(j))
                }
            }
            
            strings.append(string)
            string = []
        }
        return strings
    }
    
    func hasPlans(year: String, month: String, date: String) -> [Int] {
        var nums: [Int] = []
        for i in plans.indices {
            if MyDateFormatter.shared.compareDate(year + "/" + month + "/" + date, start: plans[i].startDate!, end: plans[i].endDate!) {
                nums.append(i)
            }
        }
        return nums
    }
    
    func planIndices(year: String, month: String, date: String) -> [Int] {
        var nums: [Int] = []
        
        for i in plans.indices where MyDateFormatter.shared.compareDate(year + "/" + month + "/" + date, start: plans[i].startDate!, end: plans[i].endDate!) {
            nums.append(i)
        }
        return nums
    }
}

struct SectionHeader: View {
    @ObservedObject var user: User
    let text: String
    var body: some View {
        Text(text)
            .padding(10)
            .frame(width: UIScreen.main.bounds.width, height: 28, alignment: .leading)
            .background(themeColors[user.themeColor].opacity(0.4))
            .foregroundColor(Color.white)
    }
}

struct RowView: View {
    let plan: Plan
    let colors = [Color.red, Color.blue, Color.green, Color.purple]
    var body: some View {
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
    }
}

//struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchView()
//    }
//}
