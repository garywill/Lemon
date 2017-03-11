//
//	Owner.swift
//
//	Create by X140Yu Zhao on 11/3/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class Owner {

    var avatarUrl: String!
    var eventsUrl: String!
    var followersUrl: String!
    var followingUrl: String!
    var gistsUrl: String!
    var gravatarId: String!
    var htmlUrl: String!
    var id: Int!
    var login: String!
    var organizationsUrl: String!
    var receivedEventsUrl: String!
    var reposUrl: String!
    var siteAdmin: Bool!
    var starredUrl: String!
    var subscriptionsUrl: String!
    var type: String!
    var url: String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(_ dictionary: [String:Any]) {
        avatarUrl = dictionary["avatar_url"] as? String
        eventsUrl = dictionary["events_url"] as? String
        followersUrl = dictionary["followers_url"] as? String
        followingUrl = dictionary["following_url"] as? String
        gistsUrl = dictionary["gists_url"] as? String
        gravatarId = dictionary["gravatar_id"] as? String
        htmlUrl = dictionary["html_url"] as? String
        id = dictionary["id"] as? Int
        login = dictionary["login"] as? String
        organizationsUrl = dictionary["organizations_url"] as? String
        receivedEventsUrl = dictionary["received_events_url"] as? String
        reposUrl = dictionary["repos_url"] as? String
        siteAdmin = dictionary["site_admin"] as? Bool
        starredUrl = dictionary["starred_url"] as? String
        subscriptionsUrl = dictionary["subscriptions_url"] as? String
        type = dictionary["type"] as? String
        url = dictionary["url"] as? String
    }
    
}
