import 'package:flutter/foundation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tsbeh/AppRoutes.dart';

import '../../../helper/incrementally_loading_listview.dart';
import '../../../models/Base/ApiModel.dart';
import '../../../widget/TextSearchWidget.dart';
import '../Controller/listViewController.dart';

class listViewScreen extends StatefulWidget {
  const listViewScreen({Key? key, required this.model}) : super(key: key);

  final ApiModel model;

  @override
  listViewScreenState createState() => listViewScreenState();
}

class listViewScreenState extends State<listViewScreen> {
  late listViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = listViewController(refresh, widget.model);
    _controller.onInit();

    if (!kIsWeb) FirebaseAnalytics.instance.logEvent(
      name: _controller.model.title,
    );
  }

  void refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_controller.model.title),
        ),
        body: RefreshIndicator(
            onRefresh: _controller.pullRefresh,
            child: Directionality(
                textDirection: TextDirection.ltr,
                child: Container(
                    child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                left: 16, right: 16, top: 5, bottom: 5),
                            child: Form(
                              child: TextFormFieldSearch(
                                context,
                                controller: _controller.searchController,
                                onChanged: (value) {
                                  _controller.search(value);
                                },
                              ),
                            ),
                          ),
                          _controller.list.isEmpty
                              ? Expanded(
                                  child: Center(
                                      child: _controller.isLoading
                                          ? CircularProgressIndicator()
                                          : Text("لا توجد نتائج",
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer))))
                              : Expanded(child: _buildListView()),
                          //  Expanded(
                          //     child: SingleChildScrollView(
                          //         physics: ClampingScrollPhysics(),
                          //         // controller: _controller.loadMoreController,
                          //         child: Column(children: <Widget>[
                          //           SizedBox(height: 10),
                          //           _buildListView(),
                          //           _buildProgressIndicator(),
                          //         ])),
                          //   ),
                        ],
                        // ),
                      ),
                    ),
                    // navigationBase(context, widget.model.title),
                  ],
                )))));
  }

  Widget _buildListView() {
    return IncrementallyLoadingListView(
      shrinkWrap: true,
      hasMore: () => _controller.hasMoreItems,
      itemCount: () => _controller.list.length,
      loadMore: () async {
        // can shorten to "loadMore: _loadMoreItems" but this syntax is used to demonstrate that
        // functions with parameters can also be invoked if needed
        await _controller.loadMoreItems();
      },
      onLoadMore: () {
        setState(() {
          _controller.loadingMore = true;
        });
      },
      onLoadMoreFinished: () {
        setState(() {
          _controller.loadingMore = false;
        });
      },
      // separatorBuilder: (_, __) => Divider(),
      // loadMoreOffsetFromBottom: 2,
      itemBuilder: (context, index) {
        return cell(index);
      },
    );

    return FutureBuilder(
      future: _controller.initialLoad,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            return IncrementallyLoadingListView(
              shrinkWrap: true,
              hasMore: () => _controller.hasMoreItems,
              itemCount: () => _controller.list.length,
              loadMore: () async {
                // can shorten to "loadMore: _loadMoreItems" but this syntax is used to demonstrate that
                // functions with parameters can also be invoked if needed
                // await _loadMoreItems();
              },
              onLoadMore: () {
                setState(() {
                  _controller.loadingMore = true;
                });
              },
              onLoadMoreFinished: () {
                setState(() {
                  _controller.loadingMore = false;
                });
              },
              // separatorBuilder: (_, __) => Divider(),
              // loadMoreOffsetFromBottom: 2,
              itemBuilder: (context, index) {
                return cell(index);
              },
            );
          default:
            return Text('Something went wrong');
        }
      },
    );
  }

  Widget _buildListViewOld() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _controller.list.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        // prototypeItem: ListTile(
        //   title: cell(0),
        // ),
        itemBuilder: (context, index) {
          return cell(index);
        });
  }

  Widget cell(int index) {
    return InkWell(
        onTap: () {
          ApiModel obj = _controller.list[index];
          obj.titleParent = widget.model.title;
          AppRoutes.openAction(obj, _controller.list);
        },
        child: Card(
          child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 5),
              height: 80,
              child: ListTile(
                title: Text(_controller.list[index].title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer)),
                subtitle: Text(_controller.list[index].description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer)),
                leading: Icon(Icons.arrow_back_ios),
              )),
        ));
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: _controller.isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }
}
