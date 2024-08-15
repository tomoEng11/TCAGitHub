//
//  CustomSearchBarView.swift
//  TCAGitHub
//
//  Created by 井本智博 on 2024/07/17.
//

import SwiftUI
import ComposableArchitecture

public struct CustomSearchBarView: View {
    let store: StoreOf<CustomSearchBarFeature>
    @FocusState var focus: Bool

    init(store: StoreOf<CustomSearchBarFeature>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            HStack {
                TextField("Search", text: viewStore.binding(
                    get: \.text,
                    send: {.binding(.set(\.$text, $0)) }
                    ))
                    .focused($focus)
                    .padding(.leading, 10)

                if focus {
                    Button(action: {
                        focus = false
                        viewStore.send(.didTapCancelButton)
                    }, label: {
                        Text("キャンセル")
                    })
                }

                Button(action: {
                    //searchのアクション発火
                    viewStore.send(.didTapSearchButton)
                    focus = false
                },
                       label: {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                        .frame(width: 24, height: 24)
                })
                .padding()
            }//: HSTACK
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
            .padding()
        }
    }
}

#Preview {
    CustomSearchBarView(store: StoreOf<CustomSearchBarFeature>.init(initialState: CustomSearchBarFeature.State(), reducer: {
        CustomSearchBarFeature()
    }))
}


