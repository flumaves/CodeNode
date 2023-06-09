//
//  GraphView.swift
//  CodeNode
//
//  Created by xiong_jia on 2023/5/5.
//

import Foundation
import SwiftUI

/// 展示脑图的 view
struct GraphView: View {
    
    @ObservedObject var nodeManager: NodeManager
    @ObservedObject var selection: SelectionHandler
    
    @GestureState private var scale: CGFloat = 1.0
    @GestureState private var offSet = CGSize.zero
    @State private var currentScale: CGFloat = 1.0
    @State private var currentOffSet = CGSize.zero
    
    var body: some View {
        GeometryReader  { geo in
            ZStack {
                Rectangle()
                
                Path { path in
                    for i in 0..<Int(geo.size.height / 20) {
                        path.move(to: CGPoint(x: 0, y: i * 20))
                        path.addLine(to: CGPoint(x: geo.size.width, y: CGFloat(20 * i)))
                    }
                    
                    for i in 0..<Int(geo.size.width / 20) {
                        path.move(to: CGPoint(x: i * 20, y: 0))
                        path.addLine(to: CGPoint(x: CGFloat(20 * i), y: geo.size.height))
                    }
                }.stroke(.gray, lineWidth: 1)
                
                ZStack {
                    if let nodes = nodeManager.nodes {
                        ForEach(nodes) { node in
                            NodeView(node: node, selection: selection)
                                .offset(x: node.position.x, y: node.position.y)
                                .gesture(
                                    TapGesture()
                                        .onEnded { _ in
                                            selection.selectNode(node)
                                        }
                                        .exclusively(before: DragGesture()
                                            .onChanged{ value in
                                                selection.startDragging(node)
                                                if selection.isNodeCouldDragging(node) {
                                                    let originalPosition = selection.draggingNodes.first!.originalPosition
                                                    let newPosition = CGPoint(x: originalPosition.x + value.translation.width, y: originalPosition.y + value.translation.height)
                                                    nodeManager.change(node: node, location: newPosition)
                                                }
                                            }
                                            .onEnded { _ in
                                                selection.stopDragging()
                                            })
                                            
                                )
                        }
                    }
                }
                .scaleEffect(scale * currentScale)
                .offset(x: currentOffSet.width + offSet.width, y: currentOffSet.height + offSet.height)
            }
            .onTapGesture {
                selection.deselect()
            }
            .gesture(
                SimultaneousGesture(
                    MagnificationGesture()
                        .updating($scale, body: { value, scale, _ in
    //                        scale = newScale
                        })
                        .onEnded({ value in
    //                        currentScale *= value.magnitude
                        }),
                    DragGesture()
                        .updating($offSet, body: { value, offSet, _ in
                            offSet = value.translation
                        })
                        .onEnded { value in
                            currentOffSet.width += value.translation.width
                            currentOffSet.height += value.translation.height
                        }
                )
            )
        }
    }
}
