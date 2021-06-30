### 3.关联数据的分析

<img src="./相关分析1.png" alt="1" width="900" height = "600" />

​	在进行关联数据分析时，我们首先找出了atom中commits数量排名前5的开发者。其中排名第一的开发者kevinsawicki共进行了8655次commit。排名第二的benogle共进行了2071次commit。排名前5位的开发者的commits数量基本都超过或接近1000次。



![2](./相关分析2.png)

​	在找出了atom的5名主要贡献者后，我们统计了他们主要参与的项目。

​	这些项目很多都与atom相关联。例如上图中排名第一的 "atom/find-and-replace"。这个项目的贡献者里包含了前面提到的5位中的3位atom开发者。这个项目主要用于实现atom编辑器中查找和替换文本的功能。还有例如"atom/autocomplete-plus“这个项目，主要用于实现atom编辑器中自动补全的功能。

​	此外，值得一提的是"electron/electron"这个项目。electron是一个跨平台的、基于web前端技术的桌面GUI应用程序开发框架。它最初是用来服务Github的开发工具atom的，当时的名称为atom shell，后来才改名为electron。在atom中commits数量排名第一的开发者"kevinsawicki"在electron中的commits数量位列第二(2138 commits)。