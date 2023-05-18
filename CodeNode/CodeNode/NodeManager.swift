//
//  NodeManager.swift
//  CodeNode
//
//  Created by xiong_jia on 2023/5/5.
//

import Foundation
import SwiftUI

/// 管理 node
class NodeManager: ObservableObject {
    /// 对应的文件的名字
    @Published var file: String = ""
    
    /// 选中的 node
    @Published var selectedNodeIndex: Int?
    
    @Published private(set) var model: Nodes = Nodes()
    
    var nodes: [Node]? {
        return model.nodes
    }
    
    var text: String = "" {
        didSet { model.repaser(text) }
    }
}


/// 处理文件处理相关
extension NodeManager {
    
    /// 从 file 中读取内容
    func loadFile(_ file: String?) {
        guard let file = file else { return }

        do {
            let fileData = try FileCenter().readFile(file)
            
            guard let fileData = fileData else { return }
            
            self.text = fileData.text
            self.model = Nodes(nodes: fileData.nodes)
            
            self.file = file
        } catch {
            print("ERROR: load data from file \(file) failed --- \(error.localizedDescription)")
        }
        
        
    }
    
    /// 保存文件
    func saveFile() {
        let fileData = FileData(text: text, nodes: model.nodes)
        do {
            try FileCenter().save(fileData, to: file)
        } catch {
            print("ERROR: save data to file \(file) failed --- \(error.localizedDescription)")
        }
    }
    
    /// 创建新的未命名文件
    func createNewFile() {
        let fileData = FileData()
        let newFile = "未命名文件"
        
        do {
            try FileCenter().save(fileData, to: newFile)
            
            file = newFile
            text = fileData.text
            model.nodes = fileData.nodes
            
        } catch {
            print("ERROR: create new file failed --- \(error.localizedDescription)")
        }
    }
}


/// 改变 node 位置
extension NodeManager {
    
    func change(node: Node, location: CGPoint) {
        model.change(node: node, location: location)
    }
}







struct Nodes {
    var nodes: [Node] = []
}


extension Nodes {
    
    mutating func repaser(_ text: String) {
        var newNodes = Paser().parse(text)
        
        // find nodes already exist, hold their position
        for i in 0..<newNodes.count {
            for j in 0..<nodes.count {
                var newNode = newNodes[i]
                let node = nodes[j]
                if newNode.name == node.name {
                    newNode.position = node.position
                    newNodes[i] = newNode
                }
            }
        }
        
        nodes = newNodes
    }
}

extension Nodes {
    
    mutating func change(node: Node, location: CGPoint) {
        guard let index = nodes.firstIndex(of: node) else { return }
        
        var newNode = nodes[index]
        newNode.position = location
        
        replaceNodeIn(index: index, with: newNode)
    }
}

extension Nodes {
    mutating func replaceNodeIn(index: Int, with newNode: Node) {
        nodes[index] = newNode
    }
}