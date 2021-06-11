//
//  Downloader.swift
//  TeamsProwler
//
//  Created by Max Sanna on 11/06/2021.
//

import Foundation

class FileDownloader {

    static func loadFileSync(url: URL, completion: @escaping (String?, Error?) -> Void) {
        let documentsUrl = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
        if FileManager().fileExists(atPath: destinationUrl.path) {
            print("File already exists [\(destinationUrl.path)]")
            completion(destinationUrl.path, nil)
        }
        else if let dataFromURL = NSData(contentsOf: url) {
            if dataFromURL.write(to: destinationUrl, atomically: true) {
                print("file saved [\(destinationUrl.path)]")
                completion(destinationUrl.path, nil)
            }
            else {
                print("error saving file")
                let error = NSError(domain:"Error saving file", code:1001, userInfo:nil)
                completion(destinationUrl.path, error)
            }
        }
        else {
            let error = NSError(domain:"Error downloading file", code:1002, userInfo:nil)
            completion(destinationUrl.path, error)
        }
    }
}
