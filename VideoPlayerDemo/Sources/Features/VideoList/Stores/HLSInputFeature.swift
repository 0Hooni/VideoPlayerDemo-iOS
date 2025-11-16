//
//  HLSInputFeature.swift
//  VideoPlayerDemo
//
//  Created by 송영훈 on 11/16/25.
//

import ComposableArchitecture

@Reducer
struct HLSInputFeature {

	@ObservableState
	struct State: Equatable {
		var inputText: String = ""
	}

	enum Action {
		case textFieldDidChange(text: String)
		case playBtnTapped
	}

	var body: some Reducer<State, Action> {
		Reduce { state, action in
			switch action {
			case .textFieldDidChange(let text):
				state.inputText = text
				return .none

			case .playBtnTapped:
				print("Play Btn Tapped!")
				return .none
			}
		}
	}
}
