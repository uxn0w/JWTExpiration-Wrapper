@propertyWrapper
struct JWTExpiration {
    
    private(set) var token: String
    
    var payload: [String: Any]? { decode(token: token) }

    init(wrappedValue: String) {
        self.token = wrappedValue
    }

    var wrappedValue: String {
        get {
            guard let payload = payload, let exp = payload["exp"] as? Double else {
                return String()
            }
            return Date().timeIntervalSince1970 < exp ? token : String()
        }
        set {
            token = newValue
        }
    }
    
    private func decode(token: String) -> [String: Any]? {
        let components = token.components(separatedBy: ".")
        if components.indices.contains(1) {
            return decode(payload: components[1]) ?? nil
        } else {
            return nil
        }
    }
    
    private func decode(payload: String) -> [String: Any]? {
        guard let bodyData = base64UrlDecode(payload),
              let json = try? JSONSerialization.jsonObject(with: bodyData, options: []),
              let payload = json as? [String: Any] else {
                  return nil
              }
        return payload
    }

    private func base64UrlDecode(_ value: String) -> Data? {
        var base64 = value
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        let requiredLength = 4 * ceil(length / 4.0)
        let paddingLength = requiredLength - length

        if paddingLength > 0 {
            base64 += "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
        }
        return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }
}
