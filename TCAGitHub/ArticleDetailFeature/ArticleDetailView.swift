//
//  ArticleDetailView.swift
//  TCAGitHub
//
//  Created by 井本智博 on 2024/08/04.
//

import SwiftUI
import ComposableArchitecture

public struct ArticleDetailView: View {
    let store: StoreOf<ArticleDetailReducer>

    public init(store: StoreOf<ArticleDetailReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Form {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        AsyncImage(url: viewStore.article.profileImageUrl) { image in image.image?.resizable() }
                            .frame(width: 40, height: 40)

                        Text(viewStore.article.title)
                            .font(.system(size: 24, weight: .bold))


                        Text(viewStore.article.name)


                        Label {
                            Text("\(viewStore.article.likesCount)")
                                .font(.system(size: 14, weight: .bold))
                        } icon: {
                            Image(systemName: "star.fill")
                                .foregroundStyle(Color.yellow)
                        }
                    }

                    Spacer(minLength: 16)

                    Button {
                        viewStore.$liked.wrappedValue.toggle()
                    } label: {
                        Image(systemName: viewStore.liked ? "heart.fill" : "heart")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.pink)
                    }
                }
            }
        }
    }
}

//
//#Preview {
//    ArticleDetailView(store: <#StoreOf<ArticleDetailReducer>#>)
//}
