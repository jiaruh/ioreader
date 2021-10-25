import 'package:cached_network_image/cached_network_image.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ioreader/network/image_model.dart';
import 'package:ioreader/network/image_request.dart';

class PhotoPage extends StatelessWidget {
  const PhotoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.red[50],
        padding: const EdgeInsets.all(15),
        child: FutureBuilder<Response<APIImageQuery>>(
          future: ImageService.create().queryImages('Girl', 'Girl', 1, 10),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.3,
                  ),
                );
              }

              final imageQuery = snapshot.data?.body;
              return _buildSimpleList(context, imageQuery);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

Widget _buildSimpleList(BuildContext context, APIImageQuery? query) {
  if (query == null) {
    return Center(child: Text("empty rersponse 🥲"));
  } else {
    final images = query.images;
    return ListView.builder(
      itemCount: images.length,
      itemBuilder: (ctx, idx) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) {
                return const FullSpecWidget();
              },
            ),
          );
        },
        child: Card(
          borderOnForeground: true,
          elevation: 10,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(2.0),
                child: TopBarWidget(
                  callback: () {
                    Fluttertoast.showToast(msg: "😊 YOU CLICK $idx!");
                  },
                ),
              ),
              CachedNetworkImage(
                imageUrl: images[idx].url,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopBarWidget extends StatelessWidget {
  VoidCallback? callback;
  TopBarWidget({
    this.callback,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(image: AssetImage('images/Avatar.png')),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                "Huang Jiaru",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "Just now",
                style: TextStyle(fontSize: 10),
              )
            ],
          ),
          Spacer(),
          IconButton(onPressed: callback, icon: Icon(Icons.more_vert)),
        ],
      ),
    );
  }
}

// TODO: 完善详情页
class FullSpecWidget extends StatelessWidget {
  const FullSpecWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(image: AssetImage('images/Img.png')),
          Text(
            '//TODO: - 完善详情页 😉',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox.fromSize(size: Size(0, 20)),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          )
        ],
      ),
    ));
  }
}