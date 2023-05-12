//
//  Footer.swift
//  schedule
//
//  Created by 小原 宙 on 2020/09/27.
//  Copyright © 2020 小原 宙. All rights reserved.
//

import SwiftUI

struct Footer: View {
    @ObservedObject var user: User
    @Binding var showing: Int
    @Binding var showAddPlanView: Bool
    @Binding var showAddTodoView: Bool
    @Binding var showAddMemoView: Bool
    @Binding var lockPlus: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity)
                .frame(height: 0.5)
            
            HStack(spacing: 0) {
                VStack(spacing: 2) {
                    Image(systemName: "calendar")
                        .font(.system(size: 24, weight: .light))
                        .frame(height: 30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(showing == 0 ? .clear : Color("BaseColor"))
                                .frame(width: 18, height: 14)
                                .offset(y: 2)
                        )
                    Text("カレンダー")
                        .opacity(showing == 0 ? 1 : 0.8)
                        .font(.system(size: 10, weight: .regular))
                }
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    self.showing = 0
                }
                
                VStack(spacing: 2) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 24, weight: .black))
                        .frame(height: 30)
                        .overlay(
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(width: 3.5, height: 12.2)
                                    .foregroundColor(showing == 1 ? .clear : Color("BaseColor"))
                                    .rotationEffect(Angle(degrees: 318.5))
                                    .offset(x: -5.9, y: 4.4)
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(width: 3.4, height: 23.4)
                                    .foregroundColor(showing == 1 ? .clear : Color("BaseColor"))
                                    .rotationEffect(Angle(degrees: 33.6))
                                    .offset(x: 3.3, y: 0.2)
                            }
                        )
                    Text("ToDo")
                        .kerning(0.5)
                        .opacity(showing == 1 ? 1 : 0.8)
                        .font(.system(size: 10, weight: .regular))
                }
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    self.showing = 1
                }
                
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 40, weight: .regular))
                    .foregroundColor(themeColors[user.themeColor])
                    .offset(y: -2)
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        if self.showing == 0 {
                            self.showAddPlanView = true
                            simpleSuccess()
                        } else if self.showing == 1 {
                            self.showAddTodoView = true
                            simpleSuccess()
                        } else if self.showing == 2 && !self.lockPlus {
                            self.showAddMemoView = true
                            simpleSuccess()
                        }
                    }
                
                VStack(spacing: 2) {
                    Image(systemName: showing == 2 ? "book.fill" : "book")
                        .font(.system(size: 24, weight: .light))
                        .frame(height: 30)
                    Text("メモ")
                        .opacity(showing == 2 ? 1 : 0.8)
                        .font(.system(size: 10, weight: .regular))
                }
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    self.showing = 2
                }
                
                VStack(spacing: 2) {
                    Image(systemName: showing == 3 ? "magnifyingglass.circle.fill" : "magnifyingglass.circle")
                        .font(.system(size: 24, weight: .regular))
                        .frame(height: 30)
                    Text("検索")
                        .opacity(showing == 3 ? 1 : 0.8)
                        .font(.system(size: 10, weight: .regular))
                }
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    self.showing = 3
                }
            }
            .foregroundColor(.black)
            .offset(y: -10)
            .frame(maxWidth: .infinity)
            .frame(height: 90)
            .background(Color("BaseColor"))
        }
    }
}

func simpleSuccess() {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.success)
}

//struct Footer_Previews: PreviewProvider {
//    static var previews: some View {
//        Footer()
//    }
//}
