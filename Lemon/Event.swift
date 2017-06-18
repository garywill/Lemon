//
//	Event.swift
//
//	Create by X140Yu Zhao on 13/3/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper



enum EventType {
  // when user stars a repo
  case WatchEvent(String)
  /// repo
  case ForkEvent(Repository)
  /// ref_type ref master_branch description
  case CreateEvent(String, String?, String, String)
}

// currently only support WatchEvent
fileprivate let KnownEvents = [
  "WatchEvent"
  //"ForkEvent",
  //"CreateEvent"
]

class Event: Mappable {
  
  var actor: User?
  var createdAt: Date?
  var id: String?
  var publicField: Bool?
  var repo: Repository?
  var type: String?
  var eventType: EventType?
  private var payloadData: [String : AnyObject] = [:]
  
  public init(){}
  
  public required init?(map: Map){
    guard let type = map.JSON["type"] as? String else { return nil }
    
    // ignore unknown events
    for t in KnownEvents {
      if t == type {
        return
      }
    }
    
    return nil
  }
  
  public func mapping(map: Map)
  {
    actor <- map["actor"]
    createdAt <- (map["created_at"], DateFormatterTransform(dateFormatter: dateFormatter))
    id <- map["id"]
    publicField <- map["public"]
    repo <- map["repo"]
    type <- map["type"]
    payloadData <- map["payload"]
    
    guard let typeString = type else { return }
    
    switch typeString {
    case "WatchEvent":
      if let action = payloadData["action"] as? String {
        eventType = EventType.WatchEvent(action)
      }
    case "ForkEvent":
      if let forkeeDict = payloadData["forkee"] as? Map, let forkee = Repository(map: forkeeDict) {
        eventType = EventType.ForkEvent(forkee)
      }
    case "CreateEvent":
      if let ref_type = payloadData["ref_type"] as? String,
        let ref = payloadData["ref"] as? String,
        let master_branch = payloadData["master_branch"] as? String,
        let description = payloadData["description"] as? String {
        eventType = EventType.CreateEvent(ref_type, ref, master_branch, description)
      }
    default:
      break
    }
  }
}

extension Event: CustomStringConvertible {
  var description: String {
    return "Event: `\(type ?? "")` Actor: `\(actor?.login ?? "")` Repo: `\(repo?.url ?? "")`"
  }
}
