import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_firebase/core/constants.dart';
import 'package:social_firebase/core/cubit/cubit.dart';
import 'package:social_firebase/core/cubit/state.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({Key? key}) : super(key: key);

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  var postController = TextEditingController();
  var now = DateTime.now();


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = MainBloc.get(context);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'New Post',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            actions: [
              defaultTextButton(
                onPressed: () {
                  if (cubit.postImage == null) {
                    cubit.createPost(
                      dataTime: now.toString(),
                      text: postController.text,
                      context: context,
                    );
                  } else {
                    cubit.createImagedPost(
                      context: context,
                      dataTime: now.toString(),
                      text: postController.text,
                    );
                  }
                },
                text: 'Post',
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if (state is CreatePostLoadingState)
                  Column(
                    children: [
                      LinearProgressIndicator(),
                      SizedBox(
                        height: 5.0,
                      ),
                    ],
                  ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25.0,
                      backgroundImage: NetworkImage(
                        '${cubit.userModel!.image}',
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${cubit.userModel!.name}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                  height: 1.6,
                                ),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Icon(
                                Icons.check_circle,
                                size: 14.0,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    child: TextFormField(
                      controller: postController,
                      decoration: InputDecoration(
                        hintText: 'What is on your mind ...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                if (cubit.postImage != null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Card(
                        elevation: 0.0,
                        margin: EdgeInsets.symmetric(horizontal: 0.0),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Image(
                          image: FileImage(
                            File(cubit.postImage!.path),
                          ),
                          height: 160.0,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Colors.lightBlue,
                          child: IconButton(
                            onPressed: () {
                              cubit.removePostImage();
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          cubit.pickPostImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 18.0,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              'Add photo',
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: Text('# tags'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}