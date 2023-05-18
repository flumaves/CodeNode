//
//  FileCenter.swift
//  CodeNode
//
//  Created by xiong_jia on 2023/5/11.
//

import Foundation
import UniformTypeIdentifiers
import SwiftUI


/// 数据在文件中存储的格式
struct FileData: Codable {
    var text: String = ""
    var nodes: [Node] = []
}

/// 管理文件的存储
class FileCenter {
    
    let folderURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first?.appendingPathComponent("CodeNodeFolder")
    
    /// 在桌面中创建文件夹
    func createFolderOnDesktop() {
        do {
            try FileManager.default.createDirectory(at: self.folderURL!, withIntermediateDirectories: true)
        } catch {
            print("ERROR: create folder failed \(error.localizedDescription)")
        }
    }
    
    
    /// 保存文件
    func save(_ data: FileData, to file: String) throws {
        let fileURL = folderURL?.appendingPathComponent(file)
        
        guard let fileURL = fileURL else { return }
        
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(data)
        
        try jsonData.write(to: fileURL)
    }

    
    /// 读取文件夹中所有的文件
    func readFiles() -> [String]? {
        do {
            let files = try FileManager.default.contentsOfDirectory(at: self.folderURL!, includingPropertiesForKeys: nil)
            let fileNames = files.map { $0.lastPathComponent }
            
            return fileNames
        } catch {
            print("ERROR: read files failed --- \(error.localizedDescription)")
        }
        
        return nil
    }
    
    
    /// 读取指定路径的文件
    func readFile(_ file: String) throws -> FileData? {
        let fileURL = folderURL?.appendingPathComponent(file)
        
        guard let fileURL = fileURL else { return nil }
        
        let jsonData = try Data(contentsOf: fileURL)
        
        let decoder = JSONDecoder()
        return try decoder.decode(FileData.self, from: jsonData)
    }
}
