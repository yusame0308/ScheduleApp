//
//  SettingView.swift
//  schedule
//
//  Created by 小原 宙 on 2020/10/20.
//  Copyright © 2020 小原 宙. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject var user: User
    @Binding var showSetting: Bool
    let wdays = ["日", "月", "火", "水", "木", "金", "土"]
    @State var swActive = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    self.showSetting = false
                }) {
                    Text("閉じる")
                }
                .frame(width: 100)
                Text("設定")
                    .font(.system(size: 18, weight: .medium))
                    .frame(maxWidth: .infinity)
                Text("")
                    .frame(width: 100)
            }
            .foregroundColor(.white)
            .frame(height: 50)
            .background(themeColors[user.themeColor])
            
            NavigationView {
                Form {
                    Section(header: Text("全般")) {
                        Picker(selection: $user.themeColor, label: Text("テーマカラー").frame(width: 278, alignment: .leading)) {
                            ForEach(themeColors.indices) { num in
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(themeColors[num])
                                    .frame(maxWidth: 320)
                            }
                        }
                    }
                    Section(header: Text("カレンダー")) {
                        Picker(selection: $user.startWday, label: Text("週の開始日")) {
                            ForEach(wdays.indices) { num in
                                Text(wdays[num] + "曜日")
                            }
                        }
                        NavigationLink(destination: List {
                            ForEach(wdays.indices) { num in
                                let b = user.offDays.contains(num)
                                HStack {
                                    Text(wdays[num] + "曜日")
                                    Spacer()
                                    Image(systemName: "checkmark")
                                        .foregroundColor(b ? .blue : .clear)
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    if b {
                                        user.offDays.remove(value: num)
                                    } else {
                                        user.offDays.append(num)
                                    }
                                }
                            }
                        }, isActive: $swActive) {
                            HStack {
//                                var str = ""
                                Text("休日の曜日")
//                                    .onChange(of: swActive, perform: { value in
//                                        if !value {
//                                            for i in user.offDays {
//                                                str += wdays[i]
//                                                str += ","
//                                            }
//                                        }
//                                        print("a", str)
//                                    })
                                Spacer()
                            }
                        }
                    }
                    Section(header: Text("イベントの表示")) {
                        Picker(selection: $user.textSize, label: Text("予定の文字サイズ")) {
                            Text("大").tag(0)
                            Text("中").tag(1)
                            Text("小").tag(2)
                        }
                    }
                }
                .navigationBarHidden(true)
            }
//            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

extension Array where Element: Equatable {
    mutating func remove(value: Element) {
        if let i = self.firstIndex(of: value) {
            self.remove(at: i)
        }
    }
}

//struct SettingView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingView()
//    }
//}
