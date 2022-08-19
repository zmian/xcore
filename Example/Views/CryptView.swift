//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

@available(iOS 15.0, *)
struct CryptView: View {
    @State private var inputFilename = ""
    @State private var encryptionKey = ""

    var body: some View {
        List {
            InternalSection("Generate Secure Secret") {
                String(describing: Crypt.generateSecureRandom().bytes)
            }

            InternalSection("Generate Random Password") {
                Crypt.generateRandomPassword()
            }

            Section("Encrypt / Decrypt File") {
                DynamicTextField("Filename", value: $inputFilename, configuration: .plain)
                DynamicTextField("Secret", value: $encryptionKey, configuration: .plain)

                Button("Copy File Directory") {
                    UIPasteboard.general.string = cryptTempPathIfNeeded()
                }

                Button("Encrypt File") {
                    encryptAndWriteToDisk()
                }
                .disabled(!isEncryptDecryptButtonEnabled)

                Button("Decrypt File") {
                    decryptAndWriteToDisk()
                }
                .disabled(!isEncryptDecryptButtonEnabled)
            }
        }
    }

    private var isEncryptDecryptButtonEnabled: Bool {
        !inputFilename.isEmpty && !encryptionKey.isEmpty
    }

    private func cryptTempPathIfNeeded() -> String {
        let path = NSTemporaryDirectory().appendingPathComponent("crypt")

        try? FileManager.default.createDirectory(
            atPath: path,
            withIntermediateDirectories: true
        )

        return path
    }

    private func encryptAndWriteToDisk() {
        let filename = inputFilename.deletingPathExtension + ".enc"

        writeToDisk(newFilename: filename) { filePath, secret in
            try Crypt.encrypt(contentsAt: filePath, secret: secret)
        }
    }

    private func decryptAndWriteToDisk() {
        var filename = inputFilename

        if filename.pathExtension == "enc" {
            filename = filename.deletingPathExtension + ".json"
        }

        writeToDisk(newFilename: filename) { filePath, secret in
            try Crypt.decrypt(contentsAt: filePath, secret: secret)
        }
    }

    private func writeToDisk(newFilename: String, data: (_ filePath: String, _ secret: [UInt8]) throws -> Data) {
        do {
            let secret = try JSONDecoder().decode([UInt8].self, from: Data(encryptionKey.utf8))

            guard !secret.isEmpty else {
                print("Incorrect secret")
                return
            }

            print("Encryption Key: \(secret)")
            let originalFilePath = cryptTempPathIfNeeded().appendingPathComponent(inputFilename)
            let content = try data(originalFilePath, secret)

            // Write data to disk
            let filePath = cryptTempPathIfNeeded().appendingPathComponent(newFilename)
            try content.write(to: URL(fileURLWithPath: filePath), options: .atomic)

            print("File Created: \(filePath)")
        } catch {
            print(error)
        }
    }
}

@available(iOS 15.0, *)
private struct InternalSection: View {
    @State private var value = ""
    private let title: String
    private let generate: () -> String

    init(_ title: String, generate: @escaping () -> String) {
        self.title = title
        self.generate = generate
    }

    var body: some View {
        Section(title) {
            if !value.isEmpty {
                Text(value)
                    .padding(.vertical)
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundColor(.white)
                    .listRowBackground(Color.black)
                    .fixedSize(horizontal: false, vertical: true)
                    .transition(.move(edge: .top))
            }

            Button("Generate") {
                withAnimation {
                    value = generate()
                }
            }

            if !value.isEmpty {
                Button("Copy") {
                    UIPasteboard.general.string = value
                }
                .transition(.opacity)
            }
        }
    }
}
