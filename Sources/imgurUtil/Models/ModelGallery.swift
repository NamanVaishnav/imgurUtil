//
//  File.swift
//  
//
//  Created by Naman Vaishnav on 02/01/24.
//

import Foundation

public struct GalleryRootModel:Decodable{
    public let data:[Gallery]?
    public let error: ErrorResponse?
}

public struct Gallery:Decodable, Identifiable{
    public let id:String
    public let title:String
    public let dateTime:Int
    public let imageCount:Int?
    public let images:[ImageInfo]?
    
    // Computed property to get the first image URL
    public var imageURL: String {
        if let images = self.images, let firstImage = images.first, firstImage.type == "image/jpeg" {
            return firstImage.link ?? ""
        }
        return ""
    }
    
    public var filterdDate : String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd/MM/yy hh:mm a"
        return dateFormater.string(from: Date(timeIntervalSince1970: TimeInterval(self.dateTime)))
    }
    
    enum CodingKeys: String,CodingKey{
        case id
        case title
        case dateTime = "datetime"
        case imageCount = "images_count"
        case images
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.dateTime = try container.decode(Int.self, forKey: .dateTime)
        self.imageCount = try container.decodeIfPresent(Int.self, forKey: .imageCount)
        
        self.images = try container.decodeIfPresent([ImageInfo].self, forKey: .images)
    }
    
    public init(id: String, title: String, dateTime: Int, imageCount: Int? = nil, images: [ImageInfo]? = nil) {
        self.id = id
        self.title = title
        self.dateTime = dateTime
        self.imageCount = imageCount
        self.images = images
    }
}


public struct ImageInfo:Decodable{
    public let type:String?
    public let link:String?
}
