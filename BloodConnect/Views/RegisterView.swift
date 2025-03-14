import SwiftUI

import Security

import Combine



// Keychain Utility

class KeychainUtility {

    static func save(key: String, data: String) {

        if let data = data.data(using: .utf8) {

            let query: [CFString: Any] = [

                kSecClass: kSecClassGenericPassword,

                kSecAttrAccount: key,

                kSecValueData: data

            ]

            

            SecItemDelete(query as CFDictionary)

            

            let status = SecItemAdd(query as CFDictionary, nil)

            assert(status == errSecSuccess, "Error saving to Keychain")

        }

    }

    

    static func load(key: String) -> String? {

        let query: [CFString: Any] = [

            kSecClass: kSecClassGenericPassword,

            kSecAttrAccount: key,

            kSecReturnData: true,

            kSecMatchLimit: kSecMatchLimitOne

        ]

        

        var item: CFTypeRef?

        let status = SecItemCopyMatching(query as CFDictionary, &item)

        

        guard status == errSecSuccess, let data = item as? Data else {

            return nil

        }

        

        return String(data: data, encoding: .utf8)

    }

}



// ContentView

struct RegisterView: View {

    @State private var name: String = UserDefaults.standard.string(forKey: "userName") ?? ""
    
    private var namePublisher = PassthroughSubject<String,Never>()

    @State private var secret: String = ""

    @State private var fileText: String = ""

    

    var body: some View {
        
        NavigationView {
            
            VStack {
                
                // TextField for Name
                
                TextField("Enter your name", text: $name)
                
                    .padding()
                
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                    .onReceive(namePublisher) { newValue in
                        
                        UserDefaults.standard.set(newValue, forKey: "userName")
                        
                    }
                    .onChange(of: name) { newName in
                        
                        namePublisher.send(newName)
                        
                    }
                
                Text("Saved name")
                    .padding()
                
                Spacer()
            }
            .padding()
        
    
                

                // SecureField for Secret

                SecureField("Enter a secret", text: $secret)

                    .padding()

                    .textFieldStyle(RoundedBorderTextFieldStyle())

                

                Button(action: {

                    KeychainUtility.save(key: "userSecret", data: secret)

                }) {

                    Text("Save Secret")

                        .padding()

                        .background(Color.blue)

                        .foregroundColor(.white)

                        .cornerRadius(8)

                }

                

                Button(action: {

                    if let loadedSecret = KeychainUtility.load(key: "userSecret") {

                        self.secret = loadedSecret

                    }

                }) {

                    Text("Load Secret")

                        .padding()

                        .background(Color.green)

                        .foregroundColor(.white)

                        .cornerRadius(8)

                }

                

                Button(action: {

                    self.loadFileData()

                }) {

                    Text("Load File Data")

                        .padding()

                        .background(Color.purple)

                        .foregroundColor(.white)

                        .cornerRadius(8)

                }

                

                // Text to show File content

                Text(fileText)

                    .padding()

                

                Spacer()

            }

            .navigationBarTitle("Local Storage Example")

            .padding()

        }

    

    

    // Load file data from the local file system

    private func loadFileData() {

        let fileURL = getDocumentsDirectory().appendingPathComponent("data.txt")

        do {

            let fileContents = try String(contentsOf: fileURL,encoding:.utf8)

            self.fileText = fileContents

        } catch {

            self.fileText = "Failed to load file"

        }

    }

    

    // Get the directory to save files in the app's sandboxed file system

    private func getDocumentsDirectory() -> URL {

        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        return paths[0]

    }

}



struct Register_Previews: PreviewProvider {

    static var previews: some View {

        RegisterView()

    }

}



