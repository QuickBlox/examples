//
//  BaseTextField.swift
//  QuickbloxSwiftUIChat
//
//  Created by Injoit.
//

import SwiftUI

struct BaseTextField : View {
    @State var isSecure: Bool
    @State var textFieldName: String
    @State var invalidTextHint: String
    @State var regexes: [Regex]
    @State private var isFocused: Bool = false
    @State private var hint: String = ""
    @Binding var text: String {
        didSet {
            guard regexes.isEmpty == false else {
                isValidText = true
                return
            }
            isValidText = text.isValid(regexes: regexes.compactMap { "\($0.rawValue)" })
        }
    }
    
    @Binding var isValidText: Bool {
        didSet {
            hint = isValidText ? "" : Hint.login.rawValue
        }
    }
    
    var body: some View {
        return VStack(alignment: .leading, spacing: 11) {
            TextFieldName(name: textFieldName)
            
            RepresentableTextField(text: $text,
                                   isSecure: $isSecure,
                                   isFocused: $isFocused)
            .accentColor(.blue)
            .onChange(of: text, perform: { newValue in
                self.text = newValue
            })
            .font(.system(size: 17, weight: .thin))
            .foregroundColor(.primary)
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .frame(height: 44)
            .padding(.horizontal, 12)
            .background(Color.white)
            .cornerRadius(4.0)
            .shadow(color: isFocused == true ? .blue.opacity(0.2) : .blue.opacity(0.1),
                    radius: 4, x: 0, y: 8)
            
            TextFieldHint(hint: hint)
        }
    }
}

struct RepresentableTextField: UIViewRepresentable {
    
    @Binding var text: String
    @Binding var isSecure: Bool
    @Binding var isFocused: Bool
    
    func makeUIView(context: UIViewRepresentableContext<RepresentableTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.isUserInteractionEnabled = true
        textField.delegate = context.coordinator
        return textField
    }
    
    func makeCoordinator() -> RepresentableTextField.Coordinator {
        return Coordinator(text: $text, isFocused: $isFocused)
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        uiView.isSecureTextEntry = isSecure
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        @Binding var isFocused: Bool
        
        init(text: Binding<String>, isFocused: Binding<Bool>) {
            _text = text
            _isFocused = isFocused
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.isFocused = true
            }
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.isFocused = false
            }
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return false
        }
    }
}
