//
//  AddMemoView.swift
//  schedule
//
//  Created by 小原 宙 on 2020/10/18.
//  Copyright © 2020 小原 宙. All rights reserved.
//

import SwiftUI

struct AddMemoView: View {
    @Environment(\.managedObjectContext) var context
    
    @Binding var memoTitle: String
    @Binding var memoText: String
    //    @State var editted = false
    @State var saving = false
    var editMemo = false
    @Binding var showAddMemoView: Bool
    @Binding var lockPlus: Bool
    @Binding var memoCount: Int16
    @Binding var memo: Memo?
    @Binding var typing: Bool
    
    init(memoTitle: Binding<String>, memoText: Binding<String>, editMemo: Bool, showAddMemoView: Binding<Bool>, lockPlus: Binding<Bool>, memoCount: Binding<Int16>, memo: Binding<Memo?>, typing: Binding<Bool>) {
        UITextView.appearance().backgroundColor = .clear
        self._memoTitle = memoTitle
        self._memoText = memoText
        self.editMemo = editMemo
        self._showAddMemoView = showAddMemoView
        self._lockPlus = lockPlus
        self._memoCount = memoCount
        self._memo = memo
        self._typing = typing
    }
    
    var body: some View {
        ZStack {
            if editMemo {
                Color("BaseColor")
                    .edgesIgnoringSafeArea(.all)
            }
            
            GeometryReader { geo in
                VStack(spacing: 20) {
                    TextField("タイトル", text: $memoTitle,
                              onEditingChanged: { begin in
                                self.typing = begin
                              }
                    )
                    .font(.system(size: 20))
                    .padding(.horizontal, 15)
                    .keyboardType(.webSearch)
                    //                    .frame(width: UIScreen.main.bounds.width - 40, height: 45)
                    //                    .background(Color.white)
                    .neumorphism(width: UIScreen.main.bounds.width - 40, height: 45, active: false)
                    
                    ZStack {
                        TextEditor(text: $memoText)
                            .font(.body)
                            .padding(.horizontal, 11)
                            .padding(.vertical, 10)
                        
                        if memoText.isEmpty {
                            Text("本文")
                                .font(.body)
                                .foregroundColor(.gray)
                                .opacity(0.6)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                .padding(.leading, 16)
                                .padding(.top, 19)                }
                    }
                    //                .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height - 380)
                    //                .background(Color.white)
                    .neumorphism(width: UIScreen.main.bounds.width - 40, height: editMemo ? UIScreen.main.bounds.height - 350 : UIScreen.main.bounds.height - 580, active: false)
                    .onTapGesture {
                        self.typing = true
                    }
                    
                    if !editMemo {
                        HStack(spacing: 90) {
                            Button(action: {
                                self.showAddMemoView = false
                            }) {
                                Text("閉じる")
                                    .foregroundColor(Color.black.opacity(0.8))
                            }
                            .neumorphism(width: 80, height: 40, radius: 10)
                            
                            Button(action: {
                                self.showAddMemoView = false
                                self.addMemo()
                            }) {
                                HStack(spacing: 3) {
                                    Text("追加")
                                    Image(systemName: "checkmark").font(.caption)
                                }
                            }
                            .neumorphism(width: 80, height: 40, radius: 10)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.top, editMemo ? 0 : 30)
                .frame(maxWidth: .infinity)
                .frame(height: 700)
                .background(Color("BaseColor"))
                .cornerRadius(editMemo ? 0 : 30)
                .animation(.easeInOut(duration: 0.3))
                .offset(y: editMemo ? -15 : 0)
                //            .onAppear {
                //                if editted {
                //                    self.lockPlus = true
                //                    print("ap")
                //                }
                //            }
                //            .onDisappear {
                //                self.lockPlus = false
                //                print("di")
                //            }
                .onChange(of: showAddMemoView, perform: { value in
                    if !value {
                        self.memoTitle = ""
                        self.memoText = ""
                    }
                })
                .onChange(of: lockPlus, perform: { value in
                    if !value {
                        self.memoTitle = ""
                        self.memoText = ""
                    }
            })
            }
            //            .background(NavigationConfigurator { nc in
            //                nc .navigationBar.barTintColor = .green
            //            })
            //            .navigationBarColor(.green)
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.gray)
                .opacity(saving ? 1 : 0)
            
//            Color.red.opacity(0.3)
//                .onLongPressGesture(pressing: { pressing in
//                    if pressing {
//                        hideKeyboard()
//                        self.typing = false
//                    }
//                }) { }
//                .frame(height: 360)
//                .offset(y: typing ? editMemo ? -100 : -320 : 1000)
            
        }
        .navigationBarItems(trailing:
                                Button(action: {
                                    self.updateMemo(memo: self.memo!)
                                    withAnimation {
                                        self.saving = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        withAnimation {
                                            self.saving = false
                                        }
                                    }
                                }) {
                                    Text("保存")
                                        //                                                            .font(.callout)
                                        .fontWeight(.regular)
                                        .frame(width: 50, height: 30)
                                        .overlay(RoundedRectangle(cornerRadius: 5)
                                                    .stroke(lineWidth: 1)
                                                    .foregroundColor(.blue)
                                        )
                                }
        )
    }
    
    func addMemo() {
        let newMemo = Memo(context: context)
        newMemo.order = memoCount + 1
        newMemo.title = memoTitle
        newMemo.text = memoText
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func updateMemo(memo: Memo) {
        memo.title = memoTitle
        memo.text = memoText
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}

extension UIColor {
    var color: Color {
        return Color(self)
    }
}

//struct NavigationBarModifier: ViewModifier {
//
//    var backgroundColor: UIColor?
//
//    init( backgroundColor: UIColor?) {
//        self.backgroundColor = backgroundColor
//        let coloredAppearance = UINavigationBarAppearance()
//        coloredAppearance.configureWithTransparentBackground()
//        coloredAppearance.backgroundColor = .clear
//        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
//
//        UINavigationBar.appearance().standardAppearance = coloredAppearance
//        UINavigationBar.appearance().compactAppearance = coloredAppearance
//        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
//        UINavigationBar.appearance().tintColor = .white
//
//    }
//
//    func body(content: Content) -> some View {
//        ZStack{
//            content
//            VStack {
//                GeometryReader { geometry in
//                    Color(self.backgroundColor ?? .clear)
//                        .frame(height: geometry.safeAreaInsets.top)
//                        .edgesIgnoringSafeArea(.top)
//                    Spacer()
//                }
//            }
//        }
//    }
//}
//extension View {
//
//    func navigationBarColor(_ backgroundColor: UIColor?) -> some View {
//        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor))
//    }
//
//}
//
//struct NavigationConfigurator: UIViewControllerRepresentable {
//    var configure: (UINavigationController) -> Void = { _ in }
//
//    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
//        UIViewController()
//    }
//    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
//        if let nc = uiViewController.navigationController {
//            self.configure(nc)
//        }
//    }
//}

//struct AddMemoView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddMemoView(editMemo: false, showAddMemoView: .constant(false), lockPlus: .constant(false), memoCount: .constant(0))
//    }
//}
