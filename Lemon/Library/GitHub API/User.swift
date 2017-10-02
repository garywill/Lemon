//
//	User.swift
//
//	Create by X140Yu Zhao on 20/5/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper

class User: Mappable {
  
  var avatarUrl : String?
  var bio : String?
  var blog : String?
  var company : String?
  var createdAt : String?
  var email : String?
  var eventsUrl : String?
  var followers : Int?
  var followersUrl : String?
  var following : Int?
  var followingUrl : String?
  var gistsUrl : String?
  var gravatarId : String?
  var hireable : Bool?
  var htmlUrl : String?
  var id : Int?
  var location : String?
  var login : String?
  var name : String?
  var organizationsUrl : String?
  var publicGists : Int?
  var publicRepos : Int?
  var receivedEventsUrl : String?
  var reposUrl : String?
  var siteAdmin : Bool?
  var starredUrl : String?
  var subscriptionsUrl : String?
  var type : String?
  var updatedAt : String?
  var url : String?
  
  public init(){}
  public required init?(map: Map){}
  public func mapping(map: Map)
  {
    avatarUrl <- map["avatar_url"]
    bio <- map["bio"]
    blog <- map["blog"]
    company <- map["company"]
    createdAt <- map["created_at"]
    email <- map["email"]
    eventsUrl <- map["events_url"]
    followers <- map["followers"]
    followersUrl <- map["followers_url"]
    following <- map["following"]
    followingUrl <- map["following_url"]
    gistsUrl <- map["gists_url"]
    gravatarId <- map["gravatar_id"]
    hireable <- map["hireable"]
    htmlUrl <- map["html_url"]
    id <- map["id"]
    location <- map["location"]
    login <- map["login"]
    name <- map["name"]
    organizationsUrl <- map["organizations_url"]
    publicGists <- map["public_gists"]
    publicRepos <- map["public_repos"]
    receivedEventsUrl <- map["received_events_url"]
    reposUrl <- map["repos_url"]
    siteAdmin <- map["site_admin"]
    starredUrl <- map["starred_url"]
    subscriptionsUrl <- map["subscriptions_url"]
    type <- map["type"]
    updatedAt <- map["updated_at"]
    url <- map["url"]
    
  }
}

extension User: CustomStringConvertible {
  var description: String {
    return "User: `\(login ?? "")` `\(bio ?? "")` `\(blog ?? "")` `\(company ?? "")`"
  }
}