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
    
    @Environment(\.presentationMode) var presentationMode
    @State var dialogs: [QBChatDialog] = []
    let quickBloxServerAPI = QuickBloxServerAPI()
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            Color.clear
                .overlay(
                    List {
                        ForEach(dialogs, id: \.self) { dialog in
                            Text(dialog.name ?? "TestDialog" )
                        }
                    }
                        .listStyle(PlainListStyle())
                        .onAppear() {
                            self.fetchDialogs()
                        }
                )}
        .navigationBarTitle("Chats", displayMode: .inline)
    }
    
    func fetchDialogs() {
        quickBloxServerAPI.fetchDialogs { result in
            switch result {
            case .success(let dialogs):
                guard let dialogs = dialogs else { return }
                DispatchQueue.main.async {
                    self.dialogs = dialogs
                }
            case .failure(let error):
                debugPrint("[DialogsView] \(#function) error: \(error.localizedDescription)")
            }
        }
    }
}

struct DialogsView_Previews: PreviewProvider {
    static var previews: some View {
        DialogsView()
    }
}
