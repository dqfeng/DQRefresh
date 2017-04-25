# DQRefresh

## DQRefresh是一个轻量并且容易扩展的下拉及上拉刷新组件

## 描述
- DQRefresh是一个抽象类封装了下拉刷新和上拉刷新触发逻辑，并跟踪下拉和上拉距离触发刷新的进度，使用的时候只要继承DQRefresh只考虑自定义UI展示即可。
- demo中已经实现了自定义的下拉刷新组件`DQRefreshHeader.m`/`DQRefreshHeader.h`和上拉加载更多组件`DQRefreshFooter.m`/`DQRefreshFooter.h`。
- 支持自定义触发刷新进度视图。
- 支持自定义刷新中的动画。
- 支持自定义下拉刷新的背景logo。

## 使用

```objc
//导入 #import "UIScrollView+DQRefresh.h"

//添加下拉刷新组件
[self.tableView addDQRefreshHeaderWithTarget:self action:@selector(topRefresh:)];

//添加上拉刷新组件
[self.tableView addDQRefreshFooterWithTarget:self action:@selector(bottomRefresh:)];

//设置不同状态下的文字
 [self.tableView.dqRefreshHeader setTitle:@"下拉刷新" forRefreshState:DQRefreshStateNormal];
 
 //手动触发刷新
 [self.tableView.dqRefreshHeader begainRefreshing];

//结束刷新
 [self.tableView.dqRefreshHeader endRefreshing];
 
 //根据是否有更多数据结束上拉刷新
[self.tableView.dqRefreshFooter endRefreshingWithMoreData:NO];

```
- 详细使用请参看demo

## 支持哪些UI控件
`UITableView`、`UIWebView`、`UIScrollView`、`UICollectionView`

## 安装
将`DQRefresh/DQRefresh/`下的文件拷贝到项目中即可。

## 运行环境

- iOS 7+
- 支持 armv7/armv7s/arm64
