//
//  Poll.swift
//  Travelhub
//
//  Created by Jonas Groll on 11.02.26.
//

import Foundation
import SwiftData

// A small wrapper to make the votes dictionary explicitly codable/transformable
struct PollVotes: Codable, Hashable {
    var map: [String: [String]]
    static let empty = PollVotes(map: [String: [String]]())
    init(map: [String: [String]] = [String: [String]]()) {
        self.map = map
    }
}

@Model
final class Poll {
    // Use static factory methods for defaults to avoid SwiftData default ambiguity
    @Attribute(.unique) var id: String
    var tripId: String
    var question: String
    var options: [String]

    @Attribute(.externalStorage) private var votesData: Data

    var votes: PollVotes {
        get {
            (try? JSONDecoder().decode(PollVotes.self, from: votesData)) ?? .empty
        }
        set {
            // Best-effort encode; keep previous data if encoding fails
            if let encoded = try? JSONEncoder().encode(newValue) {
                votesData = encoded
            }
        }
    }

    var deadline: Date
    var createdBy: String
    var createdDate: Date
    var isClosed: Bool

    init(id: String = Poll.makeID(),
         tripId: String,
         question: String,
         options: [String],
         createdBy: String,
         deadline: Date = Poll.defaultDeadline(),
         createdDate: Date = Poll.now(),
         isClosed: Bool = false) {
        self.id = id
        self.tripId = tripId
        self.question = question
        self.options = options
        let initialVotes = PollVotes(map: Dictionary(uniqueKeysWithValues: options.map { ($0, []) }))
        self.votesData = (try? JSONEncoder().encode(initialVotes)) ?? Data()
        self.deadline = deadline
        self.createdBy = createdBy
        self.createdDate = createdDate
        self.isClosed = isClosed
    }
}
// MARK: - Helpers
private extension Poll {
    static func makeID() -> String { UUID().uuidString }
    static func defaultDeadline() -> Date { Date().addingTimeInterval(7 * 24 * 3600) }
    static func now() -> Date { Date() }
}

// MARK: - Voting API
extension Poll {
    func vote(option: String, by voterID: String) {
        guard options.contains(option) else { return }
        var currentVotes = votes
        var list = currentVotes.map[option] ?? []
        if !list.contains(voterID) {
            list.append(voterID)
            currentVotes.map[option] = list
            votes = currentVotes
        }
    }

    func revokeVote(option: String, by voterID: String) {
        var currentVotes = votes
        guard var list = currentVotes.map[option] else { return }
        list.removeAll { $0 == voterID }
        currentVotes.map[option] = list
        votes = currentVotes
    }

    func voteCount(for option: String) -> Int {
        votes.map[option]?.count ?? 0
    }
}

