//
//  Node.swift
//  CodeNode
//
//  Created by xiong_jia on 2023/5/5.
//

import Cocoa

typealias NodeID = UUID

struct Node: Hashable, Identifiable, Codable {
    // 节点的名称
    var name: String?
    // 节点拥有的属性，以 NSString 的形式保存
    var properties: [String]?
    // 到 node 的边
    var edgesTo: [Node]?
    
    var position: CGPoint = .zero
    
    init(name: String? = nil, properties: [String]? = []) {
        self.name = name
        self.properties = properties
    }
    
    var id: NodeID = NodeID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(properties)
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.name == rhs.name && lhs.properties == rhs.properties
    }
}
