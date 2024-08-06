//
//  ArticleItemView.swift
//  TCAGitHub
//
//  Created by 井本智博 on 2024/08/04.
//
import SwiftUI
import ComposableArchitecture

struct ArticleItemView: View {
    let store: StoreOf<ArticleItemReducer>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewStore.article.title)
                        .font(.system(size: 20, weight: .bold))
                        .lineLimit(1)

                    HStack {
                        Text(viewStore.article.name)

                        Label {
                            Text("\(viewStore.article.likesCount)")
                                .font(.system(size: 14))
                        } icon: {
                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(Color.yellow)
                        }
                    }
                }

                Spacer(minLength: 16)

                Button {
                    viewStore.$liked.wrappedValue.toggle()
                } label: {
                    Image(systemName: viewStore.liked ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.pink)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

//#Preview {
//    ArticleItemView()
//}
