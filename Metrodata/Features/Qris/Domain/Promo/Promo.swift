//
//  Promo.swift
//  Metrodata
//
//  Created by Adhitya Bagas on 12/10/23.
//

import Foundation

struct Promo: Decodable {
    let id: Int
    let title: String?
    let publishedAt: String
    let createdAt: String
    let updatedAt: String
    let promoName: String?
    let promoDesc: String?
    let name: String
    let desc: String
    let latitude: String?
    let longitude: String?
    let alt: String?
    let location: String
    let count: Int
    let img: PromoImage
    
    enum CodingKeys: String, CodingKey {
        case id
        case desc
        case latitude
        case longitude
        case alt
        case count
        case img
        case title = "Title"
        case publishedAt = "published_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case promoName = "name_promo"
        case promoDesc = "desc_promo"
        case name = "nama"
        case location = "lokasi"
    }
    
    init(id: Int, title: String?, publishedAt: String, createdAt: String, updatedAt: String, promoName: String?, promoDesc: String?, name: String, desc: String, latitude: String?, longitude: String?, alt: String?, location: String, count: Int, img: PromoImage) {
        self.id = id
        self.title = title
        self.publishedAt = publishedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.promoName = promoName
        self.promoDesc = promoDesc
        self.name = name
        self.desc = desc
        self.latitude = latitude
        self.longitude = longitude
        self.alt = alt
        self.location = location
        self.count = count
        self.img = img
    }
}

struct PromoImage: Decodable {
    let id: Int
    let name: String
    let alternativeText: String
    let caption: String
    let width: Int
    let height: Int
    let formats: Formats
    let hash: String
    let ext: String
    let mime: String
    let size: Double
    let url: String
    let previewURL: String?
    let provider: String
    let providerMetadata: String?
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case alternativeText
        case caption
        case width
        case height
        case formats
        case hash
        case ext
        case mime
        case size
        case url
        case provider
        case previewURL = "previewUrl"
        case providerMetadata = "provider_metadata"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(id: Int, name: String, alternativeText: String, caption: String, width: Int, height: Int, formats: Formats, hash: String, ext: String, mime: String, size: Double, url: String, previewURL: String?, provider: String, providerMetadata: String?, createdAt: String, updatedAt: String) {
        self.id = id
        self.name = name
        self.alternativeText = alternativeText
        self.caption = caption
        self.width = width
        self.height = height
        self.formats = formats
        self.hash = hash
        self.ext = ext
        self.mime = mime
        self.size = size
        self.url = url
        self.previewURL = previewURL
        self.provider = provider
        self.providerMetadata = providerMetadata
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

struct Formats: Decodable {
    let small: ImageFormats
    let medium: ImageFormats
    let thumbnail: ImageFormats
    let large: ImageFormats?
    
    enum CodingKeys: String, CodingKey {
        case small
        case medium
        case thumbnail
        case large
    }
    
    init(small: ImageFormats, medium: ImageFormats, thumbnail: ImageFormats, large: ImageFormats?) {
        self.small = small
        self.medium = medium
        self.thumbnail = thumbnail
        self.large = large
    }
}

struct ImageFormats: Decodable {
    let ext: String
    let url: String
    let hash: String
    let mime: String
    let name: String
    let path: String?
    let size: Double
    let width: Int
    let height: Int
    
    enum CodingKeys: String, CodingKey {
        case ext
        case url
        case hash
        case mime
        case name
        case path
        case size
        case width
        case height
    }
    
    init(ext: String, url: String, hash: String, mime: String, name: String, path: String?, size: Double, width: Int, height: Int) {
        self.ext = ext
        self.url = url
        self.hash = hash
        self.mime = mime
        self.name = name
        self.path = path
        self.size = size
        self.width = width
        self.height = height
    }
}
