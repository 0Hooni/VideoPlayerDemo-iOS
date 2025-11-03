//
//  TimeInterval+.swift
//  VideoPlayerDemo
//
//  Created by 송영훈 on 11/3/25.
//

import Foundation

extension TimeInterval {
	func toKRStyleString() -> String {
		let totalSeconds = Int(self)
		let hours = totalSeconds / 3600
		let minutes = (totalSeconds % 3600) / 60
		let secs = totalSeconds % 60

		var components: [String] = []

		if hours > 0 {
			components.append("\(hours)시간")
			components.append("\(minutes)분")
			components.append("\(secs)초")
		} else if minutes > 0 {
			components.append("\(minutes)분")
			components.append("\(secs)초")
		} else {
			components.append("\(secs)초")
		}

		return components.joined(separator: " ")
	}

	func toColonStyleString() -> String {
		let totalSeconds = Int(self)
		let hours = totalSeconds / 3600
		let minutes = (totalSeconds % 3600) / 60
		let secs = totalSeconds % 60

		var components: [String] = []

		if hours > 0 { components.append("\(hours)") }
		
		if minutes < 10 { components.append("0\(minutes)") }
		else { components.append("\(minutes)") }

		if secs < 10 { components.append("0\(secs)") }
		else { components.append("\(secs)") }

		return components.joined(separator: ":")
	}
}

