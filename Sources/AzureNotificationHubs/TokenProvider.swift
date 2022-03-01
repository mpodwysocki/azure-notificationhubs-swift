// --------------------------------------------------------------------------
//
// Copyright (c) Microsoft Corporation. All rights reserved.
//
// The MIT License (MIT)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the ""Software""), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
//
// --------------------------------------------------------------------------

import Foundation
import CommonCrypto

public struct TokenProvider {
    private let keyName: String
    private let keyValue: String
    
    public init(keyName: String, keyValue: String) {
        self.keyName = keyName
        self.keyValue = keyValue
    }
    
    public func generateSasToken(audience: URL) -> String {
        let interval = NSDate().timeIntervalSince1970
        let timeToExpireinMins = 60.0
        let totalSeconds = interval + timeToExpireinMins * 60.0
        let expiresOn = String(format: "%.f", totalSeconds)
        let audienceString = audience.absoluteString.addingPercentEncoding(withAllowedCharacters: .azureUrlQueryAllowed)!.lowercased()
        let stringToSign = String(format: "%@\n%@", audienceString, expiresOn)
        
        let signature = self.signString(str: stringToSign, withKey: self.keyValue).addingPercentEncoding(withAllowedCharacters: .azureUrlQueryAllowed)!
        
        return String(format: "SharedAccessSignature sr=%@&sig=%@&se=%@&skn=%@", audienceString, signature, expiresOn, self.keyName)
    }
    
    private func signString(str: String, withKey key: String) -> String {
        let cKey = Data(base64Encoded: key)!
        let cData = str.data(using: .utf8)!
        let hmac = cData.hmac(algorithm: .sha256, key: cKey)
        return hmac.base64EncodedString()
    }
    
}

extension CharacterSet {
    static let azureUrlQueryAllowed = urlQueryAllowed.subtracting(.init(charactersIn: "!*'();:@&=+$,/?"))
    static let azureUrlPathAllowed = urlPathAllowed.subtracting(.init(charactersIn: "!*'()@&=+$,/:"))
}
