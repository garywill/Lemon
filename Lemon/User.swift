//
//	User.swift
//
//	Create by X140Yu on 13/3/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class User {

    var avatarUrl: String!
    var bio: String!
    var blog: String!
    var collaborators: Int!
    var company: String!
    var createdAt: String!
    var diskUsage: Int!
    var email: String!
    var eventsUrl: String!
    var followers: Int!
    var followersUrl: String!
    var following: Int!
    var followingUrl: String!
    var gistsUrl: String!
    var gravatarId: String!
    var hireable: Bool!
    var htmlUrl: String!
    var id: Int!
    var location: String!
    var login: String!
    var name: String!
    var organizationsUrl: String!
    var ownedPrivateRepos: Int!
    var privateGists: Int!
    var publicGists: Int!
    var publicRepos: Int!
    var receivedEventsUrl: String!
    var reposUrl: String!
    var siteAdmin: Bool!
    var starredUrl: String!
    var subscriptionsUrl: String!
    var totalPrivateRepos: Int!
    var twoFactorAuthentication: Bool!
    var type: String!
    var updatedAt: String!
    var url: String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(_ dictionary: [String:Any]) {
        avatarUrl = dictionary["avatar_url"] as? String
        bio = dictionary["bio"] as? String
        blog = dictionary["blog"] as? String
        collaborators = dictionary["collaborators"] as? Int
        company = dictionary["company"] as? String
        createdAt = dictionary["created_at"] as? String
        diskUsage = dictionary["disk_usage"] as? Int
        email = dictionary["email"] as? String
        eventsUrl = dictionary["events_url"] as? String
        followers = dictionary["followers"] as? Int
        followersUrl = dictionary["followers_url"] as? String
        following = dictionary["following"] as? Int
        followingUrl = dictionary["following_url"] as? String
        gistsUrl = dictionary["gists_url"] as? String
        gravatarId = dictionary["gravatar_id"] as? String
        hireable = dictionary["hireable"] as? Bool
        htmlUrl = dictionary["html_url"] as? String
        id = dictionary["id"] as? Int
        location = dictionary["location"] as? String
        login = dictionary["login"] as? String
        name = dictionary["name"] as? String
        organizationsUrl = dictionary["organizations_url"] as? String
        ownedPrivateRepos = dictionary["owned_private_repos"] as? Int
        privateGists = dictionary["private_gists"] as? Int
        publicGists = dictionary["public_gists"] as? Int
        publicRepos = dictionary["public_repos"] as? Int
        receivedEventsUrl = dictionary["received_events_url"] as? String
        reposUrl = dictionary["repos_url"] as? String
        siteAdmin = dictionary["site_admin"] as? Bool
        starredUrl = dictionary["starred_url"] as? String
        subscriptionsUrl = dictionary["subscriptions_url"] as? String
        totalPrivateRepos = dictionary["total_private_repos"] as? Int
        twoFactorAuthentication = dictionary["two_factor_authentication"] as? Bool
        type = dictionary["type"] as? String
        updatedAt = dictionary["updated_at"] as? String
        url = dictionary["url"] as? String
    }

}

extension User: CustomStringConvertible {
    var description: String {
        return "User: `\(login ?? "")` `\(bio ?? "")` `\(blog ?? "")` `\(company ?? "")`"
    }
}
