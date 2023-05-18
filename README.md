# CodeNode
Automatically generate mind map by parsing text according to the prescribed syntax

# syntax rules
## node (...) {}
1. Use node as the begining
2. content between the "()" would be parse as the node Name
3. content between the "{}" would be parse as properties,separate by newline

## eg.
node (Class Person) {       
    var name: String        
    var age: Int         
}

will parse like
____________________
| Person           |
|------------------|
| var name: String |
| var age: Int     |
|__________________|



# Upcoming features
## relationship between nodes
## show/hide nodes or relationship
