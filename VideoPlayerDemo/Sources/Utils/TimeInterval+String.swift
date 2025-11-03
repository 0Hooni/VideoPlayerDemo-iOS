//
//  TimeInterval+.swift
//  VideoPlayerDemo
//
//  Created by 송영훈 on 11/3/25.
//

import Foundation

extension TimeInterval {
	func toKRStyleString() -> String {
		guard self.isFinite, self >= 0 else {
			return "0초"
		}

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
		// NaN, 무한대, 음수 값 검증
		guard self.isFinite, self >= 0 else {
			return "00:00"
		}

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

