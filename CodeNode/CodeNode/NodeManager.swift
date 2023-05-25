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
    
    @Published var files: [String]?
    
    /// 对应的文件的名字
    @Published var file: String = "" {
        didSet {
            newFile = file
        }
    }
    
    /// 修改的文件名字
    @Published var newFile: String = ""
    
    /// 选中的 node
    @Published var selectedNodeIndex: Int?
    
    @Published private(set) var graph: NodesGraph = NodesGraph()
    
    var nodes: [Node]? {
        return graph.nodes
    }
    
    var edges: Array<(source: Node, destination: Node)>? {
        return graph.allEdges()
    }
    
    var text: String = "" {
        didSet {
            paser(text)
        }
    }
    
    /// 重新解析文本
    private func paser(_ text: String) {
        let nodes = Paser().parse(text)
        
        graph.update(nodes)
    }
}


/// 处理文件处理相关
extension NodeManager {
    
    /// 读取文件夹中的文件
    func loadFiles() -> [String]? {
        files = FileCenter().readFiles()
        
        return files
    }
    
    /// 从 file 中读取内容
    func loadFile(_ file: String?) {
        guard let file = file else { return }
        
        if file.count == 0 { return }

        do {
            let fileData = try FileCenter().readFile(file)
            
            guard let fileData = fileData else { return }
            
            self.text = fileData.text
            self.graph = NodesGraph(nodes: fileData.nodes)
            
            self.file = file
        } catch {
            print("ERROR: load data from file \(file) failed --- \(error.localizedDescription)")
        }
        
        
    }
    
    /// 保存文件
    func saveFile() {
        let fileData = FileData(text: text, nodes: graph.nodes)
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
            graph.nodes = fileData.nodes
            
        } catch {
            print("ERROR: create new file failed --- \(error.localizedDescription)")
        }
    }
    
    /// 修改文件名
    func renameFile() {
        // 命名长度需要大于 0
        if newFile.count == 0 { return }
        
        do {
            try FileCenter().rename(file, with: newFile)
            
            file = newFile
            files = self.loadFiles()
        } catch {
            print("ERROR: rename file failed --- \(error.localizedDescription)")
        }
    }
    
//    func paser(_ text:)
}


/// 改变 node 位置
extension NodeManager {
    
    func change(node: Node, location: CGPoint) {
        graph.change(node: node, location: location)
    }
    
//    func change(node: Node, frame: CGRect) {
//        print(frame)
//        graph.change(node: node, frame: frame)
//    }
}






/// 一个由 nodeModel 组成的图
struct NodesGraph {
    /// 节点
    var nodes: [Node] = []
    
    /// 图中所有的边， key 为 source， value 为 destination
    func allEdges() -> [(Node, Node)] {
        var edges: [(Node, Node)] = []
        
        for source in nodes {
            guard let destinations = source.edgesTo else { continue }
            for destination in destinations {
                edges.append((source, destination))
            }
        }
        
        return edges
    }
}


extension NodesGraph {
    /// 更新节点
    mutating func update(_ newNodes: [Node]) {
        let oldNodes = nodes
        var newNodes = newNodes
        
        
        for i in 0..<oldNodes.count {
            for j in 0..<newNodes.count {
                var newNode = newNodes[j], oldNode = oldNodes[i]
                
                if newNode.name == oldNode.name || newNode.properties == oldNode.properties {
                    newNode.position = oldNode.position
                    
                    newNodes[j] = newNode
                }
            }
        }
        
        nodes = newNodes
    }
}

extension NodesGraph {
    
    mutating func change(node: Node, location: CGPoint) {
        guard let index = nodes.firstIndex(of: node) else { return }
        
        var newNode = nodes[index]
        newNode.position = location
        
        replaceNodeIn(index, with: newNode)
    }
    
//    mutating func change(node: Node, frame: CGRect) {
//        guard let index = nodes.firstIndex(of: node) else { return }
//
//        var newNode = nodes[index]
//        newNode.frame = frame
//
//        replaceNodeIn(index, with: newNode)
//    }
}

extension NodesGraph {
    mutating func replaceNodeIn(_ index: Int, with newNode: Node) {
        nodes[index] = newNode
    }
}
