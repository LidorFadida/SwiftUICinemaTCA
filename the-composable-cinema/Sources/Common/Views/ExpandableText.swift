//
//  ExpandableText.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 02/05/2024.
//

import SwiftUI

///Credit : Prafulla Singh https://prafullkumar77.medium.com/swiftui-how-to-make-see-more-see-less-style-button-at-the-end-of-text-675f859c2c4f
public struct ExpandableText: View {
    
    @State private var expanded: Bool = false
    @State private var truncated: Bool = false
    @State private var shrinkText: String
    
    private var text: String
    public let font: UIFont
    public let lineLimit: Int
    
    public init(_ text: String, lineLimit: Int, font: UIFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)) {
        self.text = text
        _shrinkText =  State(wrappedValue: text)
        self.lineLimit = lineLimit
        self.font = font
    }
    
    public var body: some View {
        ZStack(alignment: .bottomLeading) {
            Group {
                HStack {
                    Text(self.expanded ? text : shrinkText) + Text(moreLessText)
                        .font(.from(uiFont: font))
                        .bold()
                        .foregroundColor(.primary)
                }
            }
            .animation(.easeInOut(duration: 1.0), value: false)
            .lineLimit(expanded ? nil : lineLimit)
            .background(
                // Render the limited text and measure its size
                Text(text)
                    .lineLimit(lineLimit)
                    .background(GeometryReader { visibleTextGeometry in
                        Color.clear.onAppear() {
                            let size = CGSize(width: visibleTextGeometry.size.width, height: .greatestFiniteMagnitude)
                            let attributes:[NSAttributedString.Key:Any] = [NSAttributedString.Key.font: font]

                            ///Binary search until mid == low && mid == high
                            var low  = 0
                            var heigh = shrinkText.count
                            var mid = heigh ///start from top so that if text contain we does not need to loop
                            ///
                            while ((heigh - low) > 1) {
                                let attributedText = NSAttributedString(string: shrinkText + moreLessText, attributes: attributes)
                                let boundingRect = attributedText.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
                                if boundingRect.size.height > visibleTextGeometry.size.height {
                                    truncated = true
                                    heigh = mid
                                    mid = (heigh + low)/2
                                    
                                } else {
                                    if mid == text.count {
                                        break
                                    } else {
                                        low = mid
                                        mid = (low + heigh)/2
                                    }
                                }
                                shrinkText = String(text.prefix(mid))
                            }
                            
                            if truncated {
                                shrinkText = String(shrinkText.prefix(shrinkText.count - 2))  //-2 extra as highlighted text is bold
                            }
                        }
                    })
                    .hidden() // Hide the background
            )
            .font(Font(font)) ///set default font
            ///
            if truncated {
                Button(action: {
                    expanded.toggle()
                }, label: {
                    HStack { //taking tap on only last line, As it is not possible to get 'see more' location
                        Spacer()
                        Text("")
                    }.opacity(0)
                })
            }
        }
    }
    
    private var moreLessText: String {
        if !truncated {
            return ""
        } else {
            return self.expanded ? " Less" : " ... More"
        }
    }
    
}
