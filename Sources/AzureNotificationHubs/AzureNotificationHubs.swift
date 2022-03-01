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

public struct NotificationHub {
    private let hubName: String
    private let baseUri: URL
    private let tokenProvider: TokenProvider
    
    public init(connectionString: String, hubName: String) {
        self.hubName = hubName
        var endpoint = ""
        var keyName = ""
        var keyValue = ""
        for entry in connectionString.split(separator: ";") {
            let keyValuePair = entry.split(separator: "=", maxSplits: 1, omittingEmptySubsequences: true)
            if keyValuePair[0].caseInsensitiveCompare("endpoint")  == .orderedSame {
                endpoint = String(keyValuePair[1])
            }
            if keyValuePair[0].caseInsensitiveCompare("sharedaccesskeyname") == .orderedSame {
                keyName = String(keyValuePair[1])
            }
            if keyValuePair[0].caseInsensitiveCompare("sharedaccesskey") == .orderedSame {
                keyValue = String(keyValuePair[1])
            }
        }
        
        self.baseUri = URL.init(string: endpoint)!
        self.tokenProvider = TokenProvider.init(keyName: keyName, keyValue: keyValue)
    }
    
    
}
