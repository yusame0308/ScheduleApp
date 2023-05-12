//
//  MemoView.swift
//  schedule
//
//  Created by 小原 宙 on 2020/10/18.
//  Copyright © 2020 小原 宙. All rights reserved.
//

import SwiftUI

struct MemoView: View {
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(
        entity: Memo.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Memo.order, ascending: true)]
    ) var memos: FetchedResults<Memo>
    @Binding var showAddMemoView: Bool
    @Binding var lockPlus: Bool
    @State var memoCount: Int16 = 0
    @Binding var editMemoOrder: Bool
    @State var memoTitle = ""
    @State var memoText = ""
    @State var memo: Memo?
    @Binding var typing: Bool
    
    var body: some View {
        ZStack {
            NavigationView {
                List {
                    ForEach(memos, id: \.self) { memo in
                        VStack {
                            NavigationLink(destination: AddMemoView(memoTitle: $memoTitle, memoText: $memoText, editMemo: true, showAddMemoView: $showAddMemoView, lockPlus: $lockPlus, memoCount: $memoCount, memo: $memo, typing: $typing), isActive: $lockPlus) {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(memo.title!)
                                        .font(.system(size: 20, weight: .medium))
                                        .lineLimit(1)
                                    Text(memo.text!)
                                        .font(.system(size: 16))
                                        .lineLimit(2)
                                }
                            }
//                            .padding(.vertical, 10)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                self.memoTitle = memo.title!
                                self.memoText = memo.text!
                                self.memo = memo
                                self.lockPlus = true
                            }
//                            .simultaneousGesture(TapGesture().onEnded {
//                            })
//                            .onChange(of: lockPlus, perform: { value in
//                                if value {
//                                    self.memoTitle = memo.title!
//                                    self.memoText = memo.text!
//                                    self.memo = memo
//                                }
//                            })
                        }
//                        .frame(height: 60)
                    }
                    .onDelete(perform: self.deleteMemo)
                    .onMove(perform: self.moveMemo)
                    .onAppear {
                        self.memoCount = self.memos.last?.order ?? 0
                    }
                }
//                .environment(\.defaultMinListRowHeight, 60)
                .environment(\.editMode, .constant(self.editMemoOrder ? EditMode.active : EditMode.inactive))
                .navigationBarHidden(true)
            }
            
            
            Color.black.opacity(showAddMemoView ? 0.3 : 0)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    self.showAddMemoView = false
                }
            
            AddMemoView(memoTitle: $memoTitle, memoText: $memoText, editMemo: false, showAddMemoView: $showAddMemoView, lockPlus: $lockPlus, memoCount: $memoCount, memo: .constant(nil), typing: $typing)
                .offset(y: showAddMemoView ? UIScreen.main.bounds.height / 4.2 : UIScreen.main.bounds.height)
        }
    }
    
    func moveMemo(indexSet: IndexSet, destination: Int) {
        let source = indexSet.first!
        
        if source < destination {
            var startIndex = source + 1
            let endIndex = destination - 1
            var startOrder = memos[source].order
            while startIndex <= endIndex {
                memos[startIndex].order = startOrder
                startOrder = startOrder + 1
                startIndex = startIndex + 1
            }
            memos[source].order = startOrder
        } else if destination < source {
            var startIndex = destination
            let endIndex = source - 1
            var startOrder = memos[destination].order + 1
            let newOrder = memos[destination].order
            while startIndex <= endIndex {
                memos[startIndex].order = startOrder
                startOrder = startOrder + 1
                startIndex = startIndex + 1
            }
            memos[source].order = newOrder
        }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func deleteMemo(at offsets: IndexSet) {
        for index in offsets {
            let memo = memos[index]
            context.delete(memo)
        }
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

func hideKeyboard() {
    UIApplication.shared.endEditing()
}

//struct MemoView_Previews: PreviewProvider {
//    static var previews: some View {
//        MemoView(showAddMemoView: .constant(false), lockPlus: .constant(false))
//    }
//}
