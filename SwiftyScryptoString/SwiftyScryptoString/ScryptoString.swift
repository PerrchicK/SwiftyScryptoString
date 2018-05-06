//
//  ScryptoString.swift
//  ScryptoString
//
//  Created by Perry Sh on 02/05/2018.
//  Copyright © 2018 Perry Sh. All rights reserved.
//

import Foundation
import JavaScriptCore

public class ScryptoString {
    public static let shared = ScryptoString()

    let decryptCommand: JSValue?
    let encryptCommand: JSValue?

    init() {
        // From: https://developer.apple.com/documentation/foundation/bundle
        let frameworkBundle: Bundle = Bundle(for: ScryptoString.self)
        
        // load the javascript file as a String
        guard let path = frameworkBundle.path(forResource: "scrypto-algorithm", ofType: "js"),
            var jsSource: String = try? String(contentsOfFile: path) else {
                decryptCommand = nil
                encryptCommand = nil
                return
        }

        // Make browserify work
        jsSource = "var window = this; \(jsSource)"

        // create a javascript context environment and evaluate the script
        guard let context = JSContext() else {
            decryptCommand = nil
            encryptCommand = nil
            return
        }

        context.evaluateScript(jsSource)

        decryptCommand = context.objectForKeyedSubscript("decrypt")
        encryptCommand = context.objectForKeyedSubscript("encrypt")

        let argPassword: String = "1234"
        let argPhrase: String = "toast... toast"

        let encrypted = encryptCommand?.call(withArguments: [argPassword, argPhrase])

        // Testing...
        if let encryptedString = encrypted?.toString() {
            print(encryptedString)
            let decrypted = decryptCommand?.call(withArguments: [argPassword, encryptedString])
            if let decryptedString = decrypted?.toString() {
                print(decryptedString)
            }
        }
    }

    //MARK: - Encrypt / Decrypt methods

    public func encrypt(phrase phraseToEncrypt: String, withPassword password: String) -> String {
        guard phraseToEncrypt.count > 0, password.count > 0, let encryptCommand = encryptCommand,
        let encrypted = encryptCommand.call(withArguments: [password, phraseToEncrypt]) else {
            print("Error occurred on JS code")
            return ""
        }

        return encrypted.toString()
    }

    public func decrypt(phrase phraseToDecrypt: String, withPassword password: String) -> String {
        guard phraseToDecrypt.count > 0, password.count > 0, let decryptCommand = decryptCommand,
        let decrypted = decryptCommand.call(withArguments: [password, phraseToDecrypt]) else {
            print("Error occurred on JS code")
            return ""
        }

        return decrypted.toString()
    }
}

extension String {
    public func encrypt(withPassword password: String) -> String {
        return ScryptoString.shared.encrypt(phrase: self, withPassword: password)
    }
    
    public func decrypt(withPassword password: String) -> String {
        return ScryptoString.shared.decrypt(phrase: self, withPassword: password)
    }
}
