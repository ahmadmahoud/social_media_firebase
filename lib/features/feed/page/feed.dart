import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_firebase/core/cubit/cubit.dart';
import 'package:social_firebase/core/cubit/cubit.dart';
import 'package:social_firebase/core/cubit/state.dart';
import 'package:social_firebase/core/models/postModel.dart';
import 'package:social_firebase/core/widget/loading.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: BuildCondition(
              fallback: (_) => const LoadingPage(),
              condition: MainBloc.get(context).userModel != null,
              builder: (_) => Column(
                children: [
                  const Card(
                    elevation: 5.0,
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image(
                      image: NetworkImage(
                        'https://img.freepik.com/free-vector/beautiful-cappadocia-scene_1308-25471.jpg?t=st=1656323514~exp=1656324114~hmac=9cbfd9bf42554ee6c43ecd847209e34b85b5257f78fe86ceab08b95da2576bdf&w=1380',
                      ),
                      height: 220.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => buildPostItem(
                        context, index, MainBloc.get(context).posts[index]),
                    itemCount: MainBloc.get(context).posts.length,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildPostItem(context, int index, PostModel post) => Card(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25.0,
                    backgroundImage: NetworkImage(
                      post.image!,
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
                              post.name!,
                              style: Theme.of(context)
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
                          post.dateTime!,
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(height: 1.0),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_horiz,
                      size: 16.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                post.text!,
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: Colors.black,
                      height: 1.4,
                      fontSize: 16.0,
                    ),
              ),
              if (post.postImage != null && post.postImage != '')
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Card(
                    elevation: 0.0,
                    margin: EdgeInsets.zero,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image(
                      image: NetworkImage(
                        post.postImage!,
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
                          onTap: () {
                            MainBloc.get(context)
                                .likePost(MainBloc.get(context).postsId[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.favorite_outline,
                                  size: 16.0,
                                  color: Colors.redAccent,
                                ),
                                const SizedBox(
                                  width: 4.0,
                                ),
                                Text(
                                  '${MainBloc.get(context).likes[index]} likes',
                                  style: Theme.of(context).textTheme.caption,
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
                            const Icon(
                              Icons.comment_outlined,
                              size: 16.0,
                              color: Colors.blueAccent,
                            ),
                            const SizedBox(
                              width: 4.0,
                            ),
                            Text(
                              '120 comment',
                              style: Theme.of(context).textTheme.caption,
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
                              MainBloc.get(context).userModel!.image!,
                            ),
                          ),
                          const SizedBox(
                            width: 15.0,
                          ),
                          Text(
                            'write a comment...',
                            style:
                                Theme.of(context).textTheme.caption!.copyWith(
                                      height: 1.6,
                                      fontSize: 14.0,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      MainBloc.get(context)
                          .likePost(MainBloc.get(context).postsId[index]);
                    },
                    icon: const Icon(
                      Icons.favorite_outline,
                      size: 22.0,
                      color: Colors.redAccent,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
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
