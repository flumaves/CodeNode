//
//  NodeView.swift
//  CodeNode
//
//  Created by xiong_jia on 2023/5/5.
//
import SwiftUI


struct NodeView: View {
    
    @State var node: Node
    
    @ObservedObject var selection: SelectionHandler
    
    var isSelected: Bool {
        return selection.isNodeSelected(node)
    }
    
    var nodeColor: Color {
        return isSelected ? .yellow : .blue
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let name = node.name {
                Text(name)
                    .font(.system(.title2))
                    .padding(5)
            }
            
            if let properties = node.properties, properties.count >= 1 {
                VStack (alignment: .leading){
                    ForEach(properties, id: \.self) { property in
                        HStack (spacing: 4) {
                            Circle()
                                .fill(nodeColor)
                                .frame(width: 6, height: 6)
                            Text(property)
                                .font(.system(.title3))
                                .foregroundColor(.black)
                        }
                        
                    }
                }
                .padding(5)
                .background(.white)
                .cornerRadius(3)
                .padding(.init(top: 0, leading: 2, bottom: 2, trailing: 2))
            }
        }
        .background(nodeColor)
        .cornerRadius(5)
    }
}

struct NodeView_Previews: PreviewProvider {
    static var previews: some View {
        let selection1 = SelectionHandler()
        let node1 = Node(name: "node 1", properties: ["func A", "func B"])
        
        let selection2 = SelectionHandler()
        let node2 = Node(name: "node 2", properties: ["func A", "func B"])
        selection2.selectNode(node2)
        
        return VStack {
            NodeView(node: node1, selection: selection1)
            NodeView(node: node2, selection: selection2)
        }
    }
}
