//
//  EdgeView.swift
//  CodeNode
//
//  Created by xiong_jia on 2023/5/23.
//

import SwiftUI

/// 两个点之间的边
struct EdgeView: View {
    
    @State var startPoint: CGPoint
    
    @State var endPoint: CGPoint
    
    private let cornerRadius: CGFloat = 10
    
    var body: some View {
        Path { path in
            path.move(to: startPoint)
            
            if (startPoint.x == endPoint.x || startPoint.y == endPoint.y) {
                path.addLine(to: endPoint)
                return
            }

            var arcCenter: CGPoint = .zero
            var clockwise: Bool = false
            var startAngle: Angle = Angle(degrees: 0)
            var endAngle: Angle = Angle(degrees: 0)
            
            if (startPoint.x < endPoint.x && startPoint.y < endPoint.y) {
                clockwise = false
                startAngle = Angle(degrees: -90)
                endAngle = Angle(degrees: 0)
                arcCenter = CGPoint(x: endPoint.x - cornerRadius, y: startPoint.y + cornerRadius)
            } else if (startPoint.x < endPoint.x && startPoint.y > endPoint.y) {
                clockwise = true
                startAngle = Angle(degrees: 90)
                endAngle = Angle(degrees: 0)
                arcCenter = CGPoint(x: endPoint.x - cornerRadius, y: startPoint.y - cornerRadius)
            } else if (startPoint.x > endPoint.x && startPoint.y < endPoint.y) {
                clockwise = true
                startAngle = Angle(degrees: -90)
                endAngle = Angle(degrees: -180)
                arcCenter = CGPoint(x: endPoint.x + cornerRadius, y: startPoint.y + cornerRadius)
            } else {    // startPoint.x > endPoint.x && startPoint.y > endPoint.y
                clockwise = false
                startAngle = Angle(degrees: 90)
                endAngle = Angle(degrees: 180)
                arcCenter = CGPoint(x: endPoint.x + cornerRadius, y: startPoint.y - cornerRadius)
            }
            
            path.addLine(to: CGPoint(x: arcCenter.x, y: startPoint.y))
            
            path.addArc(
                center: arcCenter,
                radius: cornerRadius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: clockwise
            )
            path.addLine(to: endPoint)

        }.stroke(.blue, lineWidth: 2)
    }
}

struct EdgeView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            EdgeView(startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 100, y: 100))
            
            EdgeView(startPoint: CGPoint(x: 100, y: 0), endPoint: CGPoint(x: 0, y: 100))
            
            EdgeView(startPoint: CGPoint(x: 0, y: 100), endPoint: CGPoint(x: 100, y: 0))
            
            EdgeView(startPoint: CGPoint(x: 100, y: 100), endPoint: CGPoint(x: 0, y: 0))
            
            EdgeView(startPoint: CGPoint(x: 100, y: 0), endPoint: CGPoint(x: 100, y: 100))
        }
        .padding()
    }
}
