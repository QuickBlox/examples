//
//  DialogsView.swift
//  QuickbloxSwiftUIChat
//
//  Created by Injoit.
//

import SwiftUI
import Quickblox
import UIKit

struct DialogsView: View {
    
    init() {
        //MARK: Disable selection style.
        UITableViewCell.appearance().selectionStyle = .none
    }
    
    @Environment(\.presentationMode) var presentationMode
    @State var dialogs: [Dialog] = []
    let quickBloxServerAPI = QuickBloxServerAPI()
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            Color.clear
                .overlay(
                    List {
                        ForEach(dialogs) { dialog in
                            ZStack {
                                DialogView(dialog: dialog)
                                NavigationLink(destination: ChatView()) {
                                    EmptyView()
                                }
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
    
    private func fetchDialogs() {
        quickBloxServerAPI.fetchDialogs { result in
            switch result {
            case .success(let dialogs):
                if dialogs.isEmpty { return }
                DispatchQueue.main.async {
                    self.dialogs = dialogs
                }
            case .failure(let error):
                debugPrint("[DialogsView] \(#function) error: \(error.localizedDescription)")
            }
        }
    }
    
    private func delete(at offsets: IndexSet) {
        self.dialogs.remove(atOffsets: offsets)
    }
}

struct DialogsView_Previews: PreviewProvider {
    static var previews: some View {
        DialogsView()
    }
}
