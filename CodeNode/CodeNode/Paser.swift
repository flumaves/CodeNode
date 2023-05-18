//
//  Paser.swift
//  CodeNode
//
//  Created by xiong_jia on 2023/5/5.
//

import Cocoa

// 语法实例：
/**
    class className {
        NSUInteger *age;
        NSString *name;
    }
 
    DiagramNodeType name {
        properties
    }
 */


/// 解释器，对 NSString 进行分析生成 nodeModels
/// 目前只支持正确格式的解析
class Paser: NSObject {
    
    /// 解析文本
    /// - Returns: NodeModel 数组，可能为空
    func parse(_ source: String) -> [Node] {
        var nodes: [Node] = []
        
        let pattern = #"node\s*\((.*?)\)\s*\{(.*?)\}(?:\s*\.(.*?))?"#
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators]) else {
            return nodes
        }
            
        let range = NSRange(source.startIndex..<source.endIndex, in: source)
        let matchs = regex.matches(in: source, range: range)

        for match in matchs {
            let nodeTypeRange = match.range(at: 1)
            let propertiesRange = match.range(at: 2)
            let optionsRange = match.range(at: 3)
            
            guard let nodeTypeRange = Range(nodeTypeRange, in: source),
                  let propertiesRange = Range(propertiesRange, in: source) else {
                return nodes
            }
            
            let nodeType = String(source[nodeTypeRange])
//            let properties = String(source[propertiesRange])
//                                .components(separatedBy: ",\n")
//                                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
//                                .filter { !$0.isEmpty }
            let properties = parseProperties(String(source[propertiesRange]))
            
//            var options: [String: String] = [:]
//            
//            if let optionsRange = Range(optionsRange, in: source) {
//                let optionsText = String(source[optionsRange])
//                options = parseOptions(optionsText)
//            }
            
            let node = Node(name: nodeType, properties: properties)
            
            nodes.append(node)
        }
        
        return nodes
    }
        
//        private func parseOptions(_ text: String) -> [String: String] {
//            var options: [String: String] = [:]
//            let pattern = #"\.(.*?)\(\)"#
//            let regex = try! NSRegularExpression(pattern: pattern, options: [])
//
//            regex.enumerateMatches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) { (match, _, _) in
//                guard let match = match else { return }
//
//                let optionText = text[Range(match.range(at: 1), in: text)!]
//                options[optionText] = ""
//            }
//
//            return options
//        }
    
    private func parseProperties(_ text: String) -> [String] {
        var parsedProperties: [String] = []
        
        let propertyLines = text.components(separatedBy: CharacterSet.newlines)
        
        for line in propertyLines {
            let property = line.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !property.isEmpty else {
                continue
            }
            
            parsedProperties.append(property)
        }
        
        return parsedProperties
    }
}

