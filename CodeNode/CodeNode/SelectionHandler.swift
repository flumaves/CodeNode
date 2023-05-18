//
//  SelectionHandler.swift
//  CodeNode
//
//  Created by xiong_jia on 2023/5/16.
//

import Foundation

struct DragInfo {
    var id: NodeID
    var originalPosition: CGPoint
}


class SelectionHandler: ObservableObject {
    @Published var draggingNodes: [DragInfo] = []
    @Published private(set) var selectedNodeIDs: [NodeID] = []
    
    func selectNode(_ node: Node) {
        selectedNodeIDs = [node.id]
    }
    
    func isNodeSelected(_ node: Node) -> Bool {
        return selectedNodeIDs.contains(node.id)
    }
    
    func startDragging(_ node: Node) {
        /// 拖动的 node 要先被选中
        if !selectedNodeIDs.contains(node.id) { return }
        
        if draggingNodes.contains(where: { dragInfo in
            dragInfo.id == node.id
        }) { return }
        
        draggingNodes = [DragInfo(id: node.id, originalPosition: node.position)]
    }
    
    func stopDragging() {
        draggingNodes = []
    }
    
    func isNodeCouldDragging(_ node: Node) -> Bool {
        return draggingNodes.contains { dragInfo in
            dragInfo.id == node.id
        }
    }
    
}
