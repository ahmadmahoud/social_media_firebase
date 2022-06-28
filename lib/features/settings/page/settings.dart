import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_firebase/core/constants.dart';
import 'package:social_firebase/core/cubit/cubit.dart';
import 'package:social_firebase/core/cubit/state.dart';
import 'package:social_firebase/features/settings/page/editProfile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String url = 'https://firebasestorage.googleapis.com/v0/b/social-media-flutter-df0a9.appspot.com/o/profileImages%2Fqp7RsiacvJYTSGRVYJLjWmS5EWS2?alt=media&token=e3019943-6478-4ee7-9b28-4463fb5b0b9f';
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = MainBloc.get(context).userModel;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 200.0,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Card(
                        elevation: 0.0,
                        margin: const EdgeInsets.symmetric(horizontal: 0.0),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Image(
                          image: NetworkImage(
                            userModel!.cover!.isEmpty ? url : userModel.cover!,
                          ),
                          height: 160.0,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 62.0,
                      backgroundColor:
                      Theme.of(context).scaffoldBackgroundColor,
                      child: CircleAvatar(
                        radius: 60.0,
                        backgroundImage: NetworkImage(
                          '${userModel.image}',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${userModel.name}',
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                '${userModel.bio}',
                style: Theme.of(context).textTheme.caption!.copyWith(
                  fontSize: 14.0,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      child: Column(
                        children: [
                          Text(
                            '100',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Text(
                            'Post',
                            style:
                            Theme.of(context).textTheme.caption!.copyWith(
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {},
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      child: Column(
                        children: [
                          Text(
                            '356',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Text(
                            'Photos',
                            style:
                            Theme.of(context).textTheme.caption!.copyWith(
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {},
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      child: Column(
                        children: [
                          Text(
                            '3k',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Text(
                            'Followers',
                            style:
                            Theme.of(context).textTheme.caption!.copyWith(
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {},
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      child: Column(
                        children: [
                          Text(
                            '128',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Text(
                            'Following',
                            style:
                            Theme.of(context).textTheme.caption!.copyWith(
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {},
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
                    child: OutlinedButton(
                      onPressed: () {},
                      child: Text('Add Photo'),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      navigateTo(context, EditProfile());
                    },
                    child: Icon(
                      Icons.edit_outlined,
                      size: 16.0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              // BuildCondition(
              //   condition: state is LogoutLoadingState,
              //   builder: (context) =>
              //       Center(child: CircularProgressIndicator()),
              //   fallback: (context) => defaultButton(
              //     function: () {
              //       MainBloc.get(context).signOut(context);
              //     },
              //     text: 'logout',
              //     background: Colors.red,
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}
