# JWTExpiration-Wrapper
Property wrapper for token expiration check.

### Usage
#### Example 1
```swift

struct Token {
    @JWTExpiration var access: String
    @JWTExpiration var refresh: String
}

let token = Token(access: "/* access /*", refresh: "/* refresh /*")

func checkPermissions(token: Token) {
    if !token.access.isEmpty {
        // Ok
    } else {
        if !token.refresh.isEmpty {
            // Refresh access
        } else {
            // Make re-auth
        }
    }
}
checkPermissions(token: token)
```
#### Example 2
```swift

struct Token {
    var access: JWTExpiration
    var refresh: JWTExpiration
}

let token = Token(
    access: JWTExpiration(wrappedValue: "/* access /*"),
    refresh: JWTExpiration(wrappedValue: "/* refresh /*")
)
// Wrapped Token
let token = token.access.token
// Payload from Wrapped Token
let payload = token.access.payload
// Token after validation. 
// If the token hasn't expired then you'll get the wrapped token back, otherwise it will be empty.
let verified_token = token.access.wrappedValue

```
