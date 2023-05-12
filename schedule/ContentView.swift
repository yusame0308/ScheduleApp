//
//  ContentView.swift
//  schedule
//
//  Created by 小原 宙 on 2020/08/24.
//  Copyright © 2020 小原 宙. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @FetchRequest(
        entity: Plan.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Plan.order, ascending: true)]
    ) var plans: FetchedResults<Plan>
    @FetchRequest(
        entity: Todo.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Todo.order, ascending: true)]
//        predicate: NSPredicate(format: "finished == %@", false)
    ) var todos: FetchedResults<Todo>
    @ObservedObject var user = User()
    @State private var showing = 0
    @State private var selection = 0
    @State private var showAddPlanView = false
    @State private var showAddTodoView = false
    @State private var showAddMemoView = false
    @State private var scrollYear = ""
    @State private var scrollMonth = ""
    @State private var scroll: ScrollViewProxy?
    @State private var BTIndex = 0
    @State private var lockPlus = false
    @State private var editMemoOrder = false
    @State private var searchText = ""
    @State private var showSetting = false
    @State private var typing = false
    @State private var typingM = false
    
    var body: some View {
        ZStack {
            GeometryReader { _ in
                VStack(spacing: 0) {
                    Header(user: user, showing: $showing, selection: $selection, scrollYear: $scrollYear, scrollMonth: $scrollMonth, scroll: $scroll, BTIndex: $BTIndex, lockPlus: $lockPlus, editMemoOrder: $editMemoOrder, searchText: $searchText, showSetting: $showSetting, typing: $typing)
                    
                    ZStack {
                        CalendarView(plans: plans, todos: todos, showAddPlanView: $showAddPlanView, scrollYear: $scrollYear, scrollMonth: $scrollMonth, scroll: $scroll, BTIndex: $BTIndex, user: user)
                            .opacity(showing == 0 ? 1 : 0)
//                            .offset(x : showing == 0 ? 0 : (showing < 0 ? 100 : -100))
//                            .animation(Animation.spring())
                        TodoListView(todos: todos, selection: $selection, showAddTodoView: $showAddTodoView)
                            .opacity(showing == 1 ? 1 : 0)
//                            .offset(x : showing == 1 ? 0 : (showing < 1 ? 100 : -100))
//                            .animation(Animation.spring())
                        MemoView(showAddMemoView: $showAddMemoView, lockPlus: $lockPlus, editMemoOrder: $editMemoOrder, typing: $typingM)
                            .opacity(showing == 2 ? 1 : 0)
//                            .offset(x : showing == 2 ? 0 : (showing < 2 ? 100 : -100))
//                            .animation(Animation.spring())
                        SearchView(user: user, plans: plans, searchText: $searchText, showing: $showing)
                            .opacity(showing == 3 ? 1 : 0)
//                            .offset(x : showing == 3 ? 0 : (showing < 3 ? 100 : -100))
//                            .animation(Animation.spring())
                    }
                    
                    Footer(user: user, showing: $showing, showAddPlanView: $showAddPlanView, showAddTodoView: $showAddTodoView, showAddMemoView: $showAddMemoView, lockPlus: $lockPlus)
                }
                .sheet(isPresented: $showSetting) {
                    SettingView(user: user, showSetting: $showSetting)
                }
            }
            Color.white.opacity(0.001)
                .onLongPressGesture(pressing: { pressing in
                    if pressing {
                        hideKeyboard()
                        self.typing = false
                        self.typingM = false
                    }
                }) { }
                .offset(y: typing || typingM ? 0 : 1000)
        }
        .ignoresSafeArea(.keyboard)
        .edgesIgnoringSafeArea(.all)
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate)
            .persistentContainer.viewContext
        return ContentView()
            .environment(\.managedObjectContext, context)
            .environment(\.locale, Locale(identifier: "ja_JP"))
    }
}
