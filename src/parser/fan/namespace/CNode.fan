//
// Copyright (c) 2006, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   15 Sep 05  Brian Frank  Creation
//    3 Jun 06  Brian Frank  Ported from Java to Fantom - Megan's b-day!
//

**
** Node is the base class of all classes which represent a node
** in the abstract syntax tree generated by the parser.
**
mixin CNode
{

//////////////////////////////////////////////////////////////////////////
// Debug
//////////////////////////////////////////////////////////////////////////

  **
  ** Print to std out
  **
  Void dump()
  {
    print(AstWriter.make)
  }

  **
  ** Pretty print this node and it's descendants.
  **
  abstract Void print(AstWriter out)
  
//////////////////////////////////////////////////////////////////////////
// Tree
//////////////////////////////////////////////////////////////////////////

  virtual Void getChildren(CNode[] list, [Str:Obj]? options) {}
  
  **
  ** find node of tree by loction
  **
  CNode findAt(Loc loc, CNode[]? path := null) {
    list := CNode[,]
    getChildren(list, null)
    if (path != null) path.add(this)
    for (i:=0; i<list.size; ++i) {
      node := list[i]
      if (node.loc.contains(loc)) {
        return node.findAt(loc, path)
      }
    }
    return this
  }
  
  Void printTree(Int deep := 0) {
    deep.times { Env.cur.out.print("  ") }
    Env.cur.out.print(this.typeof.toStr + "\t" + this + "\t" + loc.offset + "," + loc.end+ "\n")
    list := CNode[,]
    getChildren(list, null)
    for (i:=0; i<list.size; ++i) {
      node := list[i]
      node.printTree(deep+1)
    }
  }

//////////////////////////////////////////////////////////////////////////
// Fields
//////////////////////////////////////////////////////////////////////////

  abstract Loc loc()

}

**
** Node is the base class of all classes which represent a node
** in the abstract syntax tree generated by the parser.
**
abstract class Node : CNode
{

//////////////////////////////////////////////////////////////////////////
// Construction
//////////////////////////////////////////////////////////////////////////

  **
  ** All Node's must have a valid location in a source file.
  **
  new make(Loc loc)
  {
    this.loc = loc
  }

//////////////////////////////////////////////////////////////////////////
// Debug
//////////////////////////////////////////////////////////////////////////

  **
  ** Pretty print this node and it's descendants.
  **
  abstract override Void print(AstWriter out)

//////////////////////////////////////////////////////////////////////////
// Fields
//////////////////////////////////////////////////////////////////////////

  override Loc loc
}