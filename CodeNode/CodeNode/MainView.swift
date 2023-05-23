//
//  MainView.swift
//  CodeNode
//
//  Created by xiong_jia on 2023/5/5.
//

import Foundation
import SwiftUI

struct MainView: View {
    
    var body: some View {
        
        NavigationView {
            SideBarView()
            DetailView()
        }
    }
}

struct SideBarView: View {
    
    var body: some View {
        List {
            if let files = FileCenter().readFiles() {
                ForEach(files, id: \.self) { fileName in
                    NavigationLink {
                        DetailView(fileName)
                    } label: {
                        Label(fileName, systemImage: "doc.text")
                    }

                }
            }
        }
        .listStyle(.sidebar)
        .frame(minWidth: 148, idealWidth: 160, maxWidth: 192, maxHeight: .infinity)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    toggleSidebar()
                } label: {
                    Image(systemName: "sidebar.left")
                }
            }
        }
    }
    
    func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}


struct DetailView: View {
    
    @ObservedObject var nodeManager =  NodeManager()
    @ObservedObject var selection = SelectionHandler()
    
    @State private var isRightViewVisable = true
    @State private var isEditing = false
    
    var fileName: String
    
    var body: some View {
        HStack(spacing: 0) {

            GraphView(nodeManager: nodeManager, selection: selection)
                .background(Color.primary)

            if isRightViewVisable {
                TextEditor(text: $nodeManager.text)
                    .font(.system(size: 20))
                    .transition(.asymmetric(insertion: .move(edge: .trailing),
                                            removal: .move(edge: .trailing)
                            ))
            }
        }
        .onAppear {
            self.nodeManager.loadFile(fileName)
        }
        .onDisappear {
            self.nodeManager.saveFile()
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button  {
                    nodeManager.createNewFile()
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }
            
            ToolbarItem {
                Button {
                    withAnimation {
                        isRightViewVisable.toggle()
                    }
                    
                } label: {
                    Image(systemName: "sidebar.right")
                }
            }
            
//            ToolbarItem(placement: .navigation) {
//                if isEditing {
//                    TextField("", text: $nodeManager.newFile)
//                        .textFieldStyle(.roundedBorder)
//                        .onSubmit {
//                            isEditing = false
//                            nodeManager.renameFile()
//                        }
//                        .font(.title2)
//                } else {
//                    Text(nodeManager.file)
//                        .font(.title2)
//
//                        .onTapGesture {
//                            isEditing = true
//                        }
//                }
//            }
        }
    }
    
    init(_ fileName: String = "") {
        self.fileName = fileName
    }
}

