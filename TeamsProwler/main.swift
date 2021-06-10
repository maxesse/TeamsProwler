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

let intBuild = Int(buildNumber)
let intVersions = Int(versionsAhead)
    if let intBuild = intBuild, let intVersions = intVersions {
        for n in intBuild...(intBuild + intVersions) {
            let currentUrl = URL(string: baseUrl + String(n) + "/Teams_osx.pkg")!
            print(currentUrl)
            currentUrl.isReachable { success in
                if success {
                    print("Version " + majorVersion + "." + String(n) + "exists!")
                }
            }
        }
    }

extension URL {
    func isReachable(completion: @escaping (Bool) -> ()) {
        var request = URLRequest(url: self)
        request.httpMethod = "HEAD"
        URLSession.shared.dataTask(with: request) { _, response, _ in
            completion((response as? HTTPURLResponse)?.statusCode == 200)
        }.resume()
    }
}
