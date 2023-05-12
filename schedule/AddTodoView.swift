//
//  AddTodoView.swift
//  schedule
//
//  Created by 小原 宙 on 2020/09/27.
//  Copyright © 2020 小原 宙. All rights reserved.
//

import SwiftUI

struct AddTodoView: View {
    @Environment(\.managedObjectContext) var context
    
    @Binding var todoCount: Int16
    @Binding var todoTitle: String
    @Binding var limit: Date
    @Binding var hasLimit: Bool
    @Binding var hasNotification: Bool
    @Binding var showSelectView: Bool
    @Binding var selectedNotificationDay: Int
    @Binding var selectedNotificationHour: Int
    @Binding var selectedNotificationMinute: Int
    @Binding var editTodo: Bool
    @Binding var todo: Todo?
    @Binding var showAddTodoView: Bool
    @State var typing = false
    let notificationDays = ["当日", "前日", "2日前", "3日前", "4日前", "5日前", "6日前", "1週間前", "2週間前"]
    
    var body: some View {
        ZStack {
        VStack(spacing: 20) {
            TextField("タイトル", text: $todoTitle,
                      onEditingChanged: { begin in
                        self.typing = begin
                      }
                      )
                .padding(.horizontal, 15)
                .keyboardType(.webSearch)
                .neumorphism(width: UIScreen.main.bounds.width - 40, height: 45)
            
            HStack(spacing: 0) {
                Text("期限")
                    .foregroundColor(Color.black.opacity(0.7))
                    .neumorphism(width: 60, height: 35, radius: 15, active: false)
                
                Spacer()
                
                VStack {
                    if self.hasLimit {
                        DatePicker("", selection: $limit, displayedComponents: .date)
                            .labelsHidden()
                            .onTapGesture {
                            }
                    } else {
                        Text("未設定")
                            .foregroundColor(.gray)
                    }
                }
                .animation(.easeInOut(duration: 0.3))
                .neumorphism(width: 110, height: 35, radius: 15, active: hasLimit)
            }
            .padding(.horizontal, 20)
            .neumorphism(width: UIScreen.main.bounds.width - 40, height: 60)
            .onTapGesture {
                self.hasLimit.toggle()
                self.hasNotification = false
                self.showSelectView = false
            }
            
            HStack(spacing: 0) {
                Text("通知")
                    .foregroundColor(Color.black.opacity(0.7))
                    .neumorphism(width: 60, height: 35, radius: 15, active: false)
                
                Spacer()
                
                VStack {
                    if self.hasNotification {
                        if showSelectView {
                            ZStack {
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
                                Button(action: {
                                    self.showSelectView = false
                                }) {
                                    Text("完了")
                                        .font(.subheadline)
                                }
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color("BaseColor"))
                                .cornerRadius(8)
                                .offset(x: 75, y: -35)
                            }
                        } else {
                            Text("\(notificationDays[selectedNotificationDay])(\(String(format: "%02d", selectedNotificationHour)):\(String(format: "%02d", selectedNotificationMinute)))")
                                .foregroundColor(.blue)
                                .onTapGesture {
                                    self.showSelectView = true
                                }
                        }
                    } else {
                        Text("なし")
                            .foregroundColor(.gray)
                    }
                }
                .animation(.easeInOut(duration: 0.5))
                .neumorphism(width: showSelectView ? 200 : 110, height: showSelectView ? 100 : 35, radius: 15, active: hasNotification)
            }
            .padding(.horizontal, 20)
            .neumorphism(width: UIScreen.main.bounds.width - 40, height: showSelectView ? 130 : 60)
            .onTapGesture {
                if !self.showSelectView {
                    self.hasNotification.toggle()
                }
            }
            .opacity(hasLimit ? 1 : 0)
            
            HStack(spacing: 90) {
                Button(action: {
                    self.showAddTodoView = false
                    self.editTodo = false
                    self.todoTitle = ""
                    self.limit = Date()
                    self.hasLimit = false
                    self.hasNotification = false
                    self.showSelectView = false
                }) {
                    Text("閉じる")
                        .foregroundColor(Color.black.opacity(0.8))
                }
                .neumorphism(width: 80, height: 40, radius: 10)
                
                if editTodo {
                    Button(action: {
                        self.updateTodo(todo: self.todo!)
                        
                        self.showAddTodoView = false
                        self.editTodo = false
                        self.todoTitle = ""
                        self.limit = Date()
                        self.hasLimit = false
                        self.hasNotification = false
                        self.showSelectView = false
                    }) {
                        HStack(spacing: 3) {
                            Text("保存").font(.body)
                            Image(systemName: "checkmark").font(.body)
                        }
                    }
                    .neumorphism(width: 80, height: 40, radius: 10)
                    .animation(.easeInOut(duration: 0.3))
                } else {
                    Button(action: {
                        self.addTodo()
                        
                        self.showAddTodoView = false
                        self.editTodo = false
                        self.todoTitle = ""
                        self.limit = Date()
                        self.hasLimit = false
                        self.hasNotification = false
                        self.showSelectView = false
                    }) {
                        HStack(spacing: 3) {
                            Text("追加").font(.body)
                            Image(systemName: "checkmark").font(.caption)
                        }
                    }
                    .neumorphism(width: 80, height: 40, radius: 10)
                }
            }
            .animation(.easeInOut(duration: 0.3))
            
            Spacer()
        }
        .padding(.top, 30)
        .frame(maxWidth: .infinity)
        .frame(height: 500)
        .background(Color("BaseColor"))
        .cornerRadius(30)
        .animation(.easeInOut(duration: 0.3))
        .offset(y: showSelectView ? -70 : 0)
        .offset(y: typing ? -150 : 0)
            
            Color.white.opacity(0.001)
                .onLongPressGesture(pressing: { pressing in
                    if pressing {
                        hideKeyboard()
                        self.typing = false
                    }
                }) { }
                .offset(y: typing ? -400 : 1000)
        }
    }
    
    func addTodo() {
//        print(todoCount)
        let newTodo = Todo(context: context)
        newTodo.order = todoCount + 1
        newTodo.title = todoTitle
        newTodo.finished = false
        newTodo.hasLimit = hasLimit
        newTodo.hasNotification = hasNotification
        if hasLimit {
            newTodo.limit = limit
        }
        if hasNotification {
            newTodo.notificationDay = Int16(selectedNotificationDay)
            newTodo.notificationHour = Int16(selectedNotificationHour)
            newTodo.notificationMinute = Int16(selectedNotificationMinute)
        }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func updateTodo(todo: Todo) {
        todo.title = todoTitle
        todo.hasLimit = hasLimit
        todo.hasNotification = hasNotification
        if hasLimit {
            todo.limit = limit
        }
        if hasNotification {
            todo.notificationDay = Int16(selectedNotificationDay)
            todo.notificationHour = Int16(selectedNotificationHour)
            todo.notificationMinute = Int16(selectedNotificationMinute)
        }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}

//struct AddTodoView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTodoView(todo: .constant(Todo()), showAddTodoView: .constant(false))
//    }
//}
