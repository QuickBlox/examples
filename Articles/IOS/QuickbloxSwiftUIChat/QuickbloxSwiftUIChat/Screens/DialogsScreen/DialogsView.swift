//
//  DialogsView.swift
//  QuickbloxSwiftUIChat
//
//  Created by Injoit.
//

import SwiftUI
import Quickblox
import Combine
import UIKit

struct DialogsView: View {
    
    init() {
        //MARK: Disable selection style.
        UITableViewCell.appearance().selectionStyle = .none
    }
    
    @Environment(\.presentationMode) var presentationMode
    @State var dialogs: [Dialog] = []
    
    var body: some View {
        //        NavigationView {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            Color.clear
                .overlay(
                    List {
                        ForEach(dialogs) { dialog in
                            ZStack {
                                //                                DialogView(dialog: dialog)
                                //                                NavigationLink(destination: ChatView(dialog: dialog)) {
                                //                                    EmptyView()
                                //                                }
                                .frame(width: 0)
                                .opacity(0)
                            }
                            .padding(.vertical, 4)
                            .padding(.leading, -3)
                            .listRowSeparator(.hidden)
                        }
                        .onDelete(perform: delete)
                    }
                        .listStyle(PlainListStyle())
                        .refreshable {
                            self.fetchDialogs()
                        }
                        .onAppear() {
                            self.fetchDialogs()
                            UITableView.appearance().allowsSelection = true
                            UITableViewCell.appearance().selectionStyle = .none
                        }
                )}
        
        
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: { didTapLogout() }) {
            Image(uiImage: UIImage(named: "exit") ?? UIImage())
        })
        .navigationBarTitle("Chats", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {}) {
            Image(uiImage: UIImage(named: "add") ?? UIImage())
        })
        .navigationBarItems(trailing: Button(action: {}) {
            Image(uiImage: UIImage(named: "icon-info") ?? UIImage())
        })
        
        
        
        
    }
    
    private func didTapLogout() {
        if QBChat.instance.isConnected == false {
            return
        }
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func fetchDialogs() {
        ChatManager.instance.updateAllDialogs(withPageLimit: 100,
                                              completion: { (response: QBResponse?) -> Void in
            if let error = response?.error?.error?.localizedDescription {
                //                self.errorMessage = error
            }
            DispatchQueue.main.async {
                self.dialogs = ChatManager.instance.storage.dialogsSortByUpdatedAt()
            }
            
        })
        
    }
    
    func delete(at offsets: IndexSet) {
        self.dialogs.remove(atOffsets: offsets)
    }
}

struct DialogsView_Previews: PreviewProvider {
    static var previews: some View {
        DialogsView()
    }
}
