title: JavaScript-Ztree节点操作
date: 2016-01-02 22:09:28
tags:
    - JavaScript
    - ztree
categories: JavaScript
---
下面 是一些Ztree节点相关的常用操作

1、根据id获取树的某个节点：
```javascript
 var zTree = $.fn.zTree.getZTreeObj("mytree");

 var node = zTree.getNodeByParam("id",1);
```
2、设置node节点选中状态：
```javascript
zTree.selectNode(node);
```
3、设置node节点checked选中,有两种方法实现

```javascript
（1）、zTree.checkNode(node, true, true);

（2）、node.checked = true;

// 注：设置checked属性之后，一定要更新该节点，否则会出现只有鼠标滑过的时候节点才被选中的情况
    zTree.updateNode(node);
```
4、获取树的根节点：
```javascript
var nodes = zTree.getNodes();
//注：只有当树的根节点只有一个时，才可以这样取，否则会获取到多个节点
var pnode = nodes[0];
```
5、ztree获取选中节点的子节点的方法：

```javascript
    // 该方法参考自：http://my.oschina.net/webas/blog/110295 ，本人还未测试。。
    var nodes = zTree.getSelectedNodes();

    var treeNode = nodes[0];

    var treeNodeP = treeNode.parentTId ? treeNode.getParentNode():null;

    for(var i=0;i<treeNode.children.length;i++) {

    var childNode = treeNode.children[i];

    alert('childNode.name: '+childNode.name);

    }
```

```javascript
function selected(){
                var s="";
                var zTree = $.fn.zTree.getZTreeObj("problemtree");
                var selected = zTree.getCheckedNodes();
                for(i=0;i<selected.length;i++){
                    s += selected[i].id+",";
                }
                if(s.substring(s.length-1,s.length) ==','){
                    s = s.substring(0,s.length-1);
                }
                $("input[name='problem']").val(s);
            }
```