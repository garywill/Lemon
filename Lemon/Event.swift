//
//	Event.swift
//
//	Create by X140Yu Zhao on 13/3/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

enum EventType {
    // when user star a repo
    case WatchEvent(String)
    case ForkEvent(Repository)
    // ref_type ref master_branch description
    case CreateEvent(String, String?, String, String)
}

class Event {

    var actor: User!
    var createdAt: String!
    var id: String!
    var publicField: Bool!
    var repo: Repository!
    var type: String!
    var eventType: EventType!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(_ dictionary: [String:Any]) {
        if let actorData = dictionary["actor"] as? [String:Any] {
            actor = User(actorData)
        }
        createdAt = dictionary["created_at"] as? String
        id = dictionary["id"] as? String

        publicField = dictionary["public"] as? Bool
        if let repoData = dictionary["repo"] as? [String:Any] {
            repo = Repository(repoData)
        }
        type = dictionary["type"] as? String


        if let payloadData = dictionary["payload"] as? [String:Any] {
            if type == "WatchEvent" {
                if let action = payloadData["action"] as? String {
                    eventType = EventType.WatchEvent(action)
                }
            } else if type == "ForkEvent" {
                if let forkeeDict = payloadData["forkee"] as? [String:Any] {
                    let forkee = Repository(forkeeDict)
                    eventType = EventType.ForkEvent(forkee)
                }
            } else if type == "CreateEvent" {
                if let ref_type = payloadData["ref_type"] as? String,
                    let ref = payloadData["ref"] as? String,
                    let master_branch = payloadData["master_branch"] as? String,
                    let description = payloadData["description"] as? String {
                    eventType = EventType.CreateEvent(ref_type, ref, master_branch, description)
                }
            }
        }
    }
}

extension Event: CustomStringConvertible {
    var description: String {
        return "Event: `\(type ?? "")` Actor: `\(actor.login ?? "")` Repo: `\(repo.url ?? "")` `\(eventType ?? "")`"
    }
}
