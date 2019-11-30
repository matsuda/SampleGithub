plistBuddy="/usr/libexec/PlistBuddy"

infoPlistSource="${SRCROOT}/${INFOPLIST_FILE}"
currentToken=$($plistBuddy -c "Print GitHubAPIToken" $infoPlistSource)

tokenFile="${SRCROOT}/.github_api_token"
token=`cat .github_api_token`

infoPlistTemp="${TEMP_DIR}/Preprocessed-Info.plist"
$plistBuddy -c "Set :GitHubAPIToken $token" $infoPlistTemp
