//
//  TodoListView.swift
//  schedule
//
//  Created by 小原 宙 on 2020/09/23.
//  Copyright © 2020 小原 宙. All rights reserved.
//

import SwiftUI

struct TodoListView: View {
    @Environment(\.managedObjectContext) var context
    
    var todos: FetchedResults<Todo>
    @State var todoCount: Int16 = 0
    @Binding var selection: Int
    @State var todoTitle = ""
    @State var limit = Date()
    @State var hasLimit = false
    @State var hasNotification = false
    @State var showSelectView = false
    @State var selectedNotificationDay = 1
    @State var selectedNotificationHour = 9
    @State var selectedNotificationMinute = 0
    @State var editTodo = false
    @State var todo: Todo?
    @Binding var showAddTodoView: Bool
    @State private var isEditing = false
    
//    init(selection: Binding<Int>, showAddTodoView: Binding<Bool>) {
//        self._selection = selection
//        self._showAddTodoView = showAddTodoView
//        UINavigationBar.appearance().frame.height = 40
//        UINavigationBar.appearance().backgroundColor = Color("BaseColor")
//    }
    
    var body: some View {
        ZStack {
//            NavigationView {
            VStack(spacing: 0) {
                Button(action: {
                    withAnimation {
                        self.isEditing.toggle()
                    }
                }) {
                    Text(isEditing ? "完了" : "並べ替え")
                }
                .frame(width: 100, height: 40)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .background(Color.white)
                
                Divider()
                
                List {
                        ForEach(todos, id: \.self) { todo in
                            let shows = check(todo.finished)
                            if shows[0] {
                                HStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 18, height: 18)
                                        .foregroundColor(.gray)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 4.5)
                                                .scaleEffect(0.9)
                                                .foregroundColor(.white)
                                        )
                                        .onTapGesture {
                                            self.toggleTodo(todo: todo)
                                        }
                                    
                                    Text(todo.title!)
                                        .font(.system(size: 18, weight: .light))
                                    
//                                    Text(String(todo.order))
                                    
                                    Spacer()
                                    
                                    if todo.hasLimit {
                                        let datas: [String] = MyCalendar.shared.datasFromDate(todo.limit!)
                                        let month = datas[1]
                                        let day = datas[2]
                                        Text("〜\(month)月\(day)日")
                                            .font(.footnote)
                                    }
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    self.todo = todo
                                    self.showAddTodoView = true
                                    self.editTodo = true
                                    self.todoTitle = todo.title!
                                    self.hasLimit = todo.hasLimit
                                    self.hasNotification = todo.hasNotification
                                    if todo.hasLimit {
                                        self.limit = todo.limit!
                                    }
                                    if todo.hasNotification {
                                        self.selectedNotificationDay = Int(todo.notificationDay)
                                        self.selectedNotificationHour = Int(todo.notificationHour)
                                        self.selectedNotificationMinute = Int(todo.notificationMinute)
                                    }
                                }
                            } else if shows[1] {
                                HStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 18, height: 18)
                                        .foregroundColor(.gray)
                                        .overlay(
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 4.5)
                                                    .scaleEffect(0.9)
                                                    .foregroundColor(.white)
                                                Image(systemName: "checkmark")
                                                    .scaleEffect(0.8)
                                                    .foregroundColor(.gray)
                                            }
                                        )
                                        .onTapGesture {
                                            self.toggleTodo(todo: todo)
                                        }
                                    
                                    Text(todo.title!)
                                        .strikethrough(color: Color.gray)
                                        .font(.system(size: 18, weight: .light))
                                        .foregroundColor(.gray)
                                    
//                                    Text(String(todo.order))
                                    
                                    Spacer()
                                    
                                    if todo.hasLimit {
                                        let datas: [String] = MyCalendar.shared.datasFromDate(todo.limit!)
                                        let month = datas[1]
                                        let day = datas[2]
                                        Text("〜\(month)月\(day)日")
                                            .foregroundColor(.gray)
                                            .font(.footnote)
                                    }
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    self.todo = todo
                                    self.showAddTodoView = true
                                    self.editTodo = true
                                    self.todoTitle = todo.title!
                                    self.hasLimit = todo.hasLimit
                                    self.hasNotification = todo.hasNotification
                                    if todo.hasLimit {
                                        self.limit = todo.limit!
                                    }
                                    if todo.hasNotification {
                                        self.selectedNotificationDay = Int(todo.notificationDay)
                                        self.selectedNotificationHour = Int(todo.notificationHour)
                                        self.selectedNotificationMinute = Int(todo.notificationMinute)
                                    }
                                }
                            }
                        }
                        .onDelete(perform: self.deleteTodo)
                        .onMove(perform: self.moveTodo)
                        .onAppear {
                            self.todoCount = self.todos.last?.order ?? 0
    //                        print(self.todoCount, self.todos.last?.order ?? 0)
                        }
                    }
    //                .navigationBarItems(trailing: Button(action: {
    //                    withAnimation {
    //                        self.isEditing.toggle()
    //                    }
    //                }) {
    //                    Text(isEditing ? "完了" : "並べ替え")
    //                }.background(Color.red))
                .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive))
            }
//            }
//            .navigationViewStyle(StackNavigationViewStyle())
            
            Color.black.opacity(showAddTodoView ? 0.3 : 0)
                .onTapGesture {
                    self.showAddTodoView = false
                    self.editTodo = false
                    self.todoTitle = ""
                    self.limit = Date()
                    self.hasLimit = false
                    self.hasNotification = false
                    self.showSelectView = false
                }
            
            AddTodoView(todoCount: $todoCount, todoTitle: $todoTitle, limit: $limit, hasLimit: $hasLimit, hasNotification: $hasNotification, showSelectView: $showSelectView, selectedNotificationDay: $selectedNotificationDay, selectedNotificationHour: $selectedNotificationHour, selectedNotificationMinute: $selectedNotificationMinute, editTodo: $editTodo, todo: $todo, showAddTodoView: $showAddTodoView)
                .offset(y: showAddTodoView ? UIScreen.main.bounds.height / 3.2 : UIScreen.main.bounds.height)
        }
    }
    
    func moveTodo(indexSet: IndexSet, destination: Int) {
        let source = indexSet.first!
        
        if source < destination {
            var startIndex = source + 1
            let endIndex = destination - 1
            var startOrder = todos[source].order
            while startIndex <= endIndex {
                todos[startIndex].order = startOrder
                startOrder = startOrder + 1
                startIndex = startIndex + 1
            }
            todos[source].order = startOrder
        } else if destination < source {
            var startIndex = destination
            let endIndex = source - 1
            var startOrder = todos[destination].order + 1
            let newOrder = todos[destination].order
            while startIndex <= endIndex {
                todos[startIndex].order = startOrder
                startOrder = startOrder + 1
                startIndex = startIndex + 1
            }
            todos[source].order = newOrder
        }
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func deleteTodo(at offsets: IndexSet) {
        for index in offsets {
            let todo = todos[index]
            context.delete(todo)
        }
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func toggleTodo(todo: Todo) {
        todo.finished.toggle()
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func check(_ isFinished: Bool) -> [Bool] {
        var shows: [Bool] = []
        let show1 = selection == 0 && !isFinished
        let show2 = selection == 1 && isFinished
        shows += [show1, show2]
        
        return shows
    }
}

//struct TodoListView_Previews: PreviewProvider {
//    @Environment(\.managedObjectContext) var managedObjectContext
//    static var previews: some View {
//        let context = (UIApplication.shared.delegate as! AppDelegate)
//            .persistentContainer.viewContext
//        return TodoListView(selection: .constant(1), showAddTodoView: .constant(false))
//            .environment(\.managedObjectContext, context)
//            .environment(\.locale, Locale(identifier: "ja_JP"))
//    }
//}
