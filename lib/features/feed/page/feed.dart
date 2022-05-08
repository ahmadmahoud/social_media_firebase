import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const Card(
              elevation: 5.0,
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image(
                image: NetworkImage(
                  'https://image.freepik.com/free-photo/woman-covering-her-eye-looking-away_23-2148255271.jpg',
                ),
                height: 200.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => buildPostItem(context),
              itemCount: 10,
            ),
            const SizedBox(
              height: 8.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPostItem(context) =>
      Card(
        elevation: 5.0,
        margin: const EdgeInsetsDirectional.only(
          start: 8.0,
          end: 8.0,
          top: 8.0,
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 25.0,
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1651439896595-cd4754150d27?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
                    ),
                  ),
                  const SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'New Post',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            const Icon(
                              Icons.check_circle,
                              size: 14.0,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        Text(
                          'January 21,2021 at 11.00 pm',
                          style: Theme
                              .of(context)
                              .textTheme
                              .caption!
                              .copyWith(height: 1.0),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_horiz,
                      size: 16.0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'the first post in the design ... gee coders is here ',
                textAlign: TextAlign.end,
                style: Theme
                    .of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(
                  height: 1.4,
                  fontSize: 16.0,
                ),
              ),
              // Container(
              //   padding: const EdgeInsetsDirectional.only(bottom: 5.0),
              //   width: double.infinity,
              //   child: Wrap(
              //     crossAxisAlignment: WrapCrossAlignment.start,
              //     children: [
              //       Container(
              //         padding: const EdgeInsetsDirectional.only(end: 2.0),
              //         height: 20.0,
              //         child: MaterialButton(
              //           minWidth: 0.0,
              //           padding: EdgeInsetsDirectional.zero,
              //           onPressed: () {},
              //           height: 20.0,
              //           child: Text(
              //             '#mobile_app_dev',
              //             style: Theme.of(context).textTheme.caption!.copyWith(
              //                   height: 1.4,
              //                   fontSize: 15.0,
              //                   color: Colors.blue,
              //                 ),
              //           ),
              //         ),
              //       ),
              //       Container(
              //         padding: const EdgeInsetsDirectional.only(end: 2.0),
              //         height: 20.0,
              //         child: MaterialButton(
              //           padding: EdgeInsets.zero,
              //           onPressed: () {},
              //           height: 20.0,
              //           minWidth: 0.0,
              //           child: Text(
              //             '#flutter',
              //             style: Theme.of(context).textTheme.caption!.copyWith(
              //                 height: 1.4, fontSize: 15.0, color: Colors.blue),
              //           ),
              //         ),
              //       ),
              //       Container(
              //         padding: const EdgeInsetsDirectional.only(end: 2.0),
              //         height: 20.0,
              //         child: MaterialButton(
              //           padding: EdgeInsets.zero,
              //           onPressed: () {},
              //           height: 20.0,
              //           minWidth: 0.0,
              //           child: Text(
              //             '#software',
              //             style: Theme.of(context).textTheme.caption!.copyWith(
              //                 height: 1.4, fontSize: 15.0, color: Colors.blue),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // if (postModel.postImage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Card(
                    elevation: 0.0,
                    margin: EdgeInsets.zero,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1651886842288-8c3779eeb2c0?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1632&q=80',
                      ),
                      height: 150.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite_outline,
                              size: 16.0,
                              color: Colors.redAccent,
                            ),
                            SizedBox(
                              width: 4.0,
                            ),
                            Text(
                              '120',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .caption,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.comment_outlined,
                              size: 16.0,
                              color: Colors.blueAccent,
                            ),
                            SizedBox(
                              width: 4.0,
                            ),
                            Text(
                              '120 comment',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .caption,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 15.0,
                            backgroundImage: NetworkImage(
                              'https://images.unsplash.com/photo-1651439896595-cd4754150d27?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
                            ),
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          Text(
                            'write a comment...',
                            style:
                            Theme
                                .of(context)
                                .textTheme
                                .caption!
                                .copyWith(
                              height: 1.6,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.favorite_outline,
                      size: 22.0,
                      color: Colors.redAccent,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.ios_share,
                      size: 22.0,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}