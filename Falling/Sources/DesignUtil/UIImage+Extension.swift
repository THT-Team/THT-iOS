//
//  UIImage+Extension.swift
//  Falling
//
//  Created by Kanghos on 2023/07/18.
//

import UIKit

enum BX {
    static let authCompleted: UIImage = UIImage(named: "authcode_completed")!
    static let emailCompleted: UIImage = UIImage(named: "email_completed")!
    static let eventWin = UIImage(named: "event_win")!
    static let firstChoice = UIImage(named: "first_choice")!
    static let seatLeave = UIImage(named: "leave")!
    static let meatAllMudy = UIImage(named: "meet_all")!
    static let emptyBlocked = UIImage(named: "no_blocked")!
    static let emptyLiked = UIImage(named: "no_like")!
    static let emptyMudy = UIImage(named: "no_mudy")!
    static let emptyNoti = UIImage(named: "no_noti")!
    static let numberChangeCompleted = UIImage(named: "number_completed")!
    static let timeOver = UIImage(named: "topic_time_over")!
    static let transferError = UIImage(named: "transfer_error")!
    static let withdraw = UIImage(named: "withdraw")!
}

enum Icon {
    enum Chat {
        static let attach = UIImage(named: "attach")!
        static let attachSelected = UIImage(named: "attach.selected")!
        static let send = UIImage(named: "send")!
        static let sendSelected = UIImage(named: "send.selected")!
    }

    enum Noti {
        static let heart = UIImage(named: "noti_heart")!
        static let topic = UIImage(named: "noti_topic")!
    }

    enum Etc {
        static let closeCircle = UIImage(named: "close.circle")!
        static let editCircle = UIImage(named: "edit.circle")!
    }

    enum Basic {
        static let bellBadge = UIImage(named: "bell.badge")!
        static let bell = UIImage(named: "bell")!
        static let chevron = UIImage(named: "chevron")!
        static let close = UIImage(named: "close")!
        static let explain = UIImage(named: "explain")!
        static let explainFill = UIImage(named: "explain.fill")!
        static let report = UIImage(named: "report")!
        static let reportFill = UIImage(named: "report.fill")!
        static let info = UIImage(named: "setting")!
        static let shield = UIImage(named: "shield")!
        static let shieldFill = UIImage(named: "shield.fill")!
    }

    enum Profile {
        static let face = UIImage(named: "face")!
        static let glow = UIImage(named: "glow")!
        static let pin = UIImage(named: "pin")!
        static let pinSmall = UIImage(named: "pin.small")!
        static let message = UIImage(named: "message-square")!
        static let messageEllipsis = UIImage(named: "message-square-1")!
    }
}

// TODO: 주제어 한글 이름과 asset name 매핑해야함
enum Topic {
    enum Location: String {
        case top
        case popup
    }
    
    fileprivate enum Keyword: String {
        case values = "가치관"
        case happy = "행복"
        case daily = "일상"
        case hot = "19)HOT"
        case alone = "혼자있을때"
        case appear = "꾸밈(선글라스)"
        case blue = "울적할때"
        case good = "장점"
        case heart = "마음"
        case hobby = "취미"
        case interest = "관심사"
        case love = "연애"
        case melancholy = "기분이 안좋을때"
        case pet = "반려동물"
        case photo = "추억"
        case rest = "휴식"
        case skateboard = "FUN"
        case taste = "취향"
        case trip = "여행"
        case friends = "여럿이 놀 때"

        var imageTitle: String {
            switch self {
            case .values: return "values"
            case .happy: return "happy"
            case .daily: return "daily"
            case .hot: return "hot"
            case .alone: return "aloen"
            case .appear: return "appear"
            case .blue: return "blue"
            case .good: return "good"
            case .heart: return "heart"
            case .hobby: return "hobby"
            case .interest: return "interest"
            case .love: return "love"
            case .melancholy: return "melancholy"
            case .pet: return "pet"
            case .photo: return "photo"
            case .rest: return "rest"
            case .skateboard: return "skateboard"
            case .taste: return "taste"
            case .trip: return "trip"
            case .friends: return "friends"
            }
        }
    }

    static func image(keyword: String, type: Topic.Location) -> UIImage {
        let defaultImage = UIImage(named: type.rawValue + "_" + "happy")!

        guard let topic = Topic.Keyword(rawValue: keyword),
              let image = UIImage(named: type.rawValue + "_" + topic.imageTitle)
        else {
            return defaultImage
        }

        return image
    }
}



