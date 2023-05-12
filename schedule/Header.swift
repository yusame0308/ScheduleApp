//
//  Header.swift
//  schedule
//
//  Created by 小原 宙 on 2020/09/26.
//  Copyright © 2020 小原 宙. All rights reserved.
//

import SwiftUI

let themeColors = [Color(#colorLiteral(red: 0.7426237309, green: 0.2492774332, blue: 0.2267826733, alpha: 1)), Color(#colorLiteral(red: 0.1803716347, green: 0.3789640651, blue: 0.7191584283, alpha: 1)), Color(#colorLiteral(red: 0.2172965368, green: 0.6209351206, blue: 0.3009713561, alpha: 1)), Color(#colorLiteral(red: 0.4571996793, green: 0.2939732194, blue: 0.6539697017, alpha: 1)), Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1))]

struct Header: View {
    @ObservedObject var user: User
    @Binding var showing: Int
    @Binding var selection: Int
    @Binding var scrollYear: String
    @Binding var scrollMonth: String
    @Binding var scroll: ScrollViewProxy?
    @Binding var BTIndex: Int
    @Binding var lockPlus: Bool
    @Binding var editMemoOrder: Bool
    @Binding var searchText: String
    @Binding var showSetting: Bool
    @Binding var typing: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "gearshape")
                .font(.system(size: 24, weight: .regular))
                .frame(width: 60, alignment: .center)
                .offset(x: showing == 3 ? 0 : 10)
                .frame(width: showing == 3 ? 60 : 100, alignment: .leading)
                .onTapGesture {
                    self.showSetting = true
                }
            
            ZStack {
                Text("\(scrollYear)年\(scrollMonth)月")
                    .font(.system(size: 20, weight: .regular))
                    .opacity(showing == 0 ? 1 : 0)
                
                Picker(selection: $selection, label: Text("")) {
                    Text("未完了").tag(0)
                    Text("完了").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 230)
                .background(Color.white.opacity(0.2))
                .cornerRadius(8)
                .opacity(showing == 1 ? 1 : 0)
                
                Text(lockPlus ? "メモ詳細" : "メモ一覧")
                    .font(.system(size: 20, weight: .medium))
                    .opacity(showing == 2 ? 1 : 0)
                
                TextField("\(Image(systemName: "magnifyingglass"))検索", text: $searchText,
                          onEditingChanged: { begin in
                            self.typing = begin
                          }
                          )
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.webSearch)
                    .foregroundColor(.black)
                    .opacity(showing == 3 ? 1 : 0)
            }
            .frame(maxWidth: .infinity)
            
            ZStack {
                if showing == 0 {
                    ZStack {
                        Image(systemName: "gobackward")
                            .font(.system(size: 24))
                        Text("今日")
                            .font(.system(size: 9, weight: .black, design: .rounded))
                            .kerning(-0.5)
                            .offset(y: 1.5)
                    }
                    .frame(width: 60, alignment: .center)
                    .onTapGesture {
                        withAnimation(Animation.easeOut) {
                            scroll?.scrollTo(BTIndex, anchor: .center)
                        }
                    }
                } else if showing == 1 {
                    
                } else if showing == 2 && !self.lockPlus {
                    Button(action: {
                        withAnimation {
                            self.editMemoOrder.toggle()
                        }
                    }) {
                        Text(editMemoOrder ? "完了" : "並べ替え")
                    }
                    .frame(width: 100, alignment: .center)
                }
            }
            .offset(x: showing == 3 ? 0 : -10)
            .frame(width: showing == 3 ? 60 : 100, alignment: .trailing)
        }
        .foregroundColor(.white)
        .offset(y: 20)
//        .frame(maxWidth: .infinity)
        .frame(width: UIScreen.main.bounds.width, height: 90)
        .background(themeColors[user.themeColor])
    }
}

//struct Header_Previews: PreviewProvider {
//    static var previews: some View {
//        Header(showing: .constant(1), selection: .constant(1), scrollYear: .constant("2020"), scrollMonth: .constant("12"))
//    }
//}
