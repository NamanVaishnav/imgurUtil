//
//  File.swift
//
//
//  Created by Naman Vaishnav on 02/01/24.
//

import imgurUtil
import Foundation

@main
struct ImgurUtilExec {
    static func main() async {
        let objImgurUtil = ImgurUtil(clientID: "")
        do {
            let data = try await objImgurUtil.searchImages(query: "cat")
            print(data)
        } catch {
            print(error)
        }
    }
}
