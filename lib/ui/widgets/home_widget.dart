import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:saviour/data/issue.dart';

class HomeWidget extends StatelessWidget {
  List<Issue> nearByIssueList;
  HomeWidget({@required this.nearByIssueList});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: nearByIssueList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                border: Border.all(
                  color: Colors.grey,
                )),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: CachedNetworkImage(
                          imageUrl: nearByIssueList[index].imageUrl,
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                          placeholder: (context, url) =>
                              Container(color: Colors.blue),
                          errorWidget: (context, url, error) =>
                              Container(color: Colors.blue),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(nearByIssueList[index].title),
                            Text(nearByIssueList[index].description),
                            Text(nearByIssueList[index].createdBy),
                          ],
                        ),
                      )
                    ],
                  ),
                  Text("3 more facing this issue"),
                  Text("You too facing issue, click 2 know more."),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
