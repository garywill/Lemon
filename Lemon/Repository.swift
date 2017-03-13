//
//	Repository.swift
//
//	Create by X140Yu on 11/3/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class Repository {

    var archiveUrl: String!
    var assigneesUrl: String!
    var blobsUrl: String!
    var branchesUrl: String!
    var cloneUrl: String!
    var collaboratorsUrl: String!
    var commentsUrl: String!
    var commitsUrl: String!
    var compareUrl: String!
    var contentsUrl: String!
    var contributorsUrl: String!
    var createdAt: String!
    var defaultBranch: String!
    var deploymentsUrl: String!
    var descriptionField: String!
    var downloadsUrl: String!
    var eventsUrl: String!
    var fork: Bool!
    var forks: Int!
    var forksCount: Int!
    var forksUrl: String!
    var fullName: String!
    var gitCommitsUrl: String!
    var gitRefsUrl: String!
    var gitTagsUrl: String!
    var gitUrl: String!
    var hasDownloads: Bool!
    var hasIssues: Bool!
    var hasPages: Bool!
    var hasWiki: Bool!
    var homepage: String!
    var hooksUrl: String!
    var htmlUrl: String!
    var id: Int!
    var issueCommentUrl: String!
    var issueEventsUrl: String!
    var issuesUrl: String!
    var keysUrl: String!
    var labelsUrl: String!
    var language: String!
    var languagesUrl: String!
    var mergesUrl: String!
    var milestonesUrl: String!
    var mirrorUrl: String!
    var name: String!
    var notificationsUrl: String!
    var openIssues: Int!
    var openIssuesCount: Int!
    var owner: User!
    var privateField: Bool!
    var pullsUrl: String!
    var pushedAt: String!
    var releasesUrl: String!
    var size: Int!
    var sshUrl: String!
    var stargazersCount: Int!
    var stargazersUrl: String!
    var statusesUrl: String!
    var subscribersUrl: String!
    var subscriptionUrl: String!
    var svnUrl: String!
    var tagsUrl: String!
    var teamsUrl: String!
    var treesUrl: String!
    var updatedAt: String!
    var url: String!
    var watchers: Int!
    var watchersCount: Int!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(_ dictionary: [String:Any]) {
        archiveUrl = dictionary["archive_url"] as? String
        assigneesUrl = dictionary["assignees_url"] as? String
        blobsUrl = dictionary["blobs_url"] as? String
        branchesUrl = dictionary["branches_url"] as? String
        cloneUrl = dictionary["clone_url"] as? String
        collaboratorsUrl = dictionary["collaborators_url"] as? String
        commentsUrl = dictionary["comments_url"] as? String
        commitsUrl = dictionary["commits_url"] as? String
        compareUrl = dictionary["compare_url"] as? String
        contentsUrl = dictionary["contents_url"] as? String
        contributorsUrl = dictionary["contributors_url"] as? String
        createdAt = dictionary["created_at"] as? String
        defaultBranch = dictionary["default_branch"] as? String
        deploymentsUrl = dictionary["deployments_url"] as? String
        descriptionField = dictionary["description"] as? String
        downloadsUrl = dictionary["downloads_url"] as? String
        eventsUrl = dictionary["events_url"] as? String
        fork = dictionary["fork"] as? Bool
        forks = dictionary["forks"] as? Int
        forksCount = dictionary["forks_count"] as? Int
        forksUrl = dictionary["forks_url"] as? String
        fullName = dictionary["full_name"] as? String
        gitCommitsUrl = dictionary["git_commits_url"] as? String
        gitRefsUrl = dictionary["git_refs_url"] as? String
        gitTagsUrl = dictionary["git_tags_url"] as? String
        gitUrl = dictionary["git_url"] as? String
        hasDownloads = dictionary["has_downloads"] as? Bool
        hasIssues = dictionary["has_issues"] as? Bool
        hasPages = dictionary["has_pages"] as? Bool
        hasWiki = dictionary["has_wiki"] as? Bool
        homepage = dictionary["homepage"] as? String
        hooksUrl = dictionary["hooks_url"] as? String
        htmlUrl = dictionary["html_url"] as? String
        id = dictionary["id"] as? Int
        issueCommentUrl = dictionary["issue_comment_url"] as? String
        issueEventsUrl = dictionary["issue_events_url"] as? String
        issuesUrl = dictionary["issues_url"] as? String
        keysUrl = dictionary["keys_url"] as? String
        labelsUrl = dictionary["labels_url"] as? String
        language = dictionary["language"] as? String
        languagesUrl = dictionary["languages_url"] as? String
        mergesUrl = dictionary["merges_url"] as? String
        milestonesUrl = dictionary["milestones_url"] as? String
        mirrorUrl = dictionary["mirror_url"] as? String
        name = dictionary["name"] as? String
        notificationsUrl = dictionary["notifications_url"] as? String
        openIssues = dictionary["open_issues"] as? Int
        openIssuesCount = dictionary["open_issues_count"] as? Int
        if let ownerData = dictionary["owner"] as? [String:Any] {
            owner = User(ownerData)
        }
        privateField = dictionary["private"] as? Bool
        pullsUrl = dictionary["pulls_url"] as? String
        pushedAt = dictionary["pushed_at"] as? String
        releasesUrl = dictionary["releases_url"] as? String
        size = dictionary["size"] as? Int
        sshUrl = dictionary["ssh_url"] as? String
        stargazersCount = dictionary["stargazers_count"] as? Int
        stargazersUrl = dictionary["stargazers_url"] as? String
        statusesUrl = dictionary["statuses_url"] as? String
        subscribersUrl = dictionary["subscribers_url"] as? String
        subscriptionUrl = dictionary["subscription_url"] as? String
        svnUrl = dictionary["svn_url"] as? String
        tagsUrl = dictionary["tags_url"] as? String
        teamsUrl = dictionary["teams_url"] as? String
        treesUrl = dictionary["trees_url"] as? String
        updatedAt = dictionary["updated_at"] as? String
        url = dictionary["url"] as? String
        watchers = dictionary["watchers"] as? Int
        watchersCount = dictionary["watchers_count"] as? Int
    }
    
}


extension Repository: CustomStringConvertible {
    var description: String {
        return "Repository: `\(name ?? "")` `\(owner.login ?? "")` `\(url ?? "")`"
    }
}
