# SwiftUI example
Just open `App/GithubApp.xocdeproj` and you can build the app.

```
open App/GithubApp.xcodeproj
```

[GitHub REST API uses rate limiting to control API traffic](https://docs.github.com/en/rest/overview/resources-in-the-rest-api?apiVersion=2022-11-28#rate-limiting). To increase the rate limit, edit [GithubRequest.swift](Sources/GithubClientLive/GithubRequest.swift):

```swift
params["Authorization"] = "Bearer <TOKEN>"  // replace <TOKEN> with your personal access token
```
