//
//  CMTime + Extension.swift
//  Imusic
//
//  Created by Роман Елфимов on 08.07.2021.
//

import Foundation

import AVKit

extension CMTime {
    
    func toDisplayString() -> String {
        guard !CMTimeGetSeconds(self).isNaN else { return "" }
        let totalSeconds = Int(CMTimeGetSeconds(self)) // общее количетво секунд в аудиофайле
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        let timeFormattedString = String(format: "%02d:%02d", minutes, seconds) // формат, в котором время будет отображаться на экране
        return timeFormattedString
    }
    
}
