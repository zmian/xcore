//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UIActivity.ActivityType: CustomAnalyticsValueConvertible {
    public var analyticsValue: String {
        switch self {
            case .postToFacebook:
                return "facebook"
            case .postToTwitter:
                return "twitter"
            case .postToWeibo, .postToTencentWeibo:
                return "weibo"
            case .message:
                return "message"
            case .mail:
                return "mail"
            case .print:
                return "print"
            case .copyToPasteboard:
                return "copy"
            case .assignToContact:
                return "assign_to_contact"
            case .saveToCameraRoll:
                return "save_to_camera_roll"
            case .addToReadingList:
                return "reading_list"
            case .postToFlickr:
                return "flickr"
            case .postToVimeo:
                return "vimeo"
            case .airDrop:
                return "airdrop"
            case .openInIBooks:
                return "ibooks"
            case .markupAsPDF:
                return "markup_as_pdf"
            case .init(rawValue: "com.apple.DocumentManagerUICore.SaveToFiles"):
                return "save_to_files"
            case .init(rawValue: "com.apple.reminders.sharingextension"):
                return "reminders"
            default:
                return "other_\(rawValue.snakecased())"
        }
    }
}
