# SampleGithub

A sample application using GitHub API

## Environment

* Xcode 11.2
* Swift 5.1.2
* iOS >= 11.0

## Setup

`$ carthage bootstrap --platform iOS`

### 認証トークンを利用する場合

プロジェクト直下に `.github_api_token` ファイルを作成し、トークン（personal access token）を記載。

```
% cat .github_api_token
1234xxxxxxxxxx7890
```

作成しない場合はデフォルトのRate Limit

## License

All icon by [https://icons8.jp](https://icons8.com)
