//
//  CustomSearchBarFeature.swift
//  TCAGitHub
//
//  Created by 井本智博 on 2024/07/17.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct CustomSearchBarFeature: Sendable {

    public struct State: Equatable, Sendable {
      @BindingState var text: String = ""
    }

    public enum Action: BindableAction, Equatable, Sendable {

        //output
        case submit

        //private
        case binding(BindingAction<State>)
        case didTapSearchButton
        case didTapCancelButton
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .didTapSearchButton:
                return .run { send in
                    await send(.submit)
                }
            case .submit:
                return .none
            case .didTapCancelButton:
                return .none
            }
        }
    }
}
