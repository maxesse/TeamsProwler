//
//  main.swift
//  TeamsProwler
//
//  Created by Max Sanna on 10/06/2021.
//

import Foundation

var baseUrl = ""

print("TeamsProwler v1.0")
print()

print("Please enter the major version to look for (i.e. 1.4.00):")
guard let majorVersion = readLine() else { exit(1) }

print("Please enter the build number to start the search from (i.e. 10000):")
guard let buildNumber = readLine() else { exit(2) }

print("How many versions ahead do you want to scan for?")
guard let versionsAhead = readLine() else { exit(3) }

baseUrl = "https://statics.teams.microsoft.com/production-osx/" + majorVersion + "."
let sema = DispatchSemaphore(value: 0)
var versionArray: [String] = []
var versionsToCheck: [String] = []
var existingVersions: [String] = []
let intBuild = Int(buildNumber)
let intVersions = Int(versionsAhead)
var urlList: [URL] = []
if let intBuild = intBuild, let intVersions = intVersions {
    for n in intBuild...(intBuild + intVersions) {
        versionsToCheck.append(String(n))
        //urlList.append(URL(string: baseUrl + String(n) + "/Teams_osx.pkg")!)
    }
    FileDownloader.checkVersionList(versionArray: versionsToCheck, majorVersion: majorVersion) { response in
        existingVersions = response
    }
    
}

if existingVersions.count > 0 {
    let downloadURL = URL(string: baseUrl + (existingVersions.last!) + "/Teams_osx.pkg")!
    FileDownloader.loadFileSync(url: downloadURL) { (path, error) in
        print("Teams version " + majorVersion + "." + existingVersions.last! + " was downloaded correctly!")
        exit(EXIT_SUCCESS)
    }
}

extension URL {
    func isReachable(completion: @escaping (Bool) -> ()) {
        var request = URLRequest(url: self)
        request.httpMethod = "HEAD"
        URLSession.shared.dataTask(with: request) { _, response, _ in
            completion((response as? HTTPURLResponse)?.statusCode == 200)
            sema.signal()
        }.resume()
    }
}

