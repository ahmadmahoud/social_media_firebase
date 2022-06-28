import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_firebase/core/constants.dart';
import 'package:social_firebase/core/cubit/cubit.dart';
import 'package:social_firebase/core/cubit/state.dart';
import 'package:social_firebase/core/models/user_data.dart';
import 'package:social_firebase/features/chat_details_screen/chat_details_screen.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => buildChatItem(context, MainBloc.get(context).users[index]),
            separatorBuilder: (context, index) => Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[200],
            ),
            itemCount: MainBloc.get(context).users.length,
          ),
        );
      },
    );
  }
  Widget buildChatItem(BuildContext context, UserModel userModel) => InkWell(
    onTap: () {
      navigateTo(context, ChatDetailsScreen(userModel: userModel,));
    },
    child: Container(
      padding: const EdgeInsets.all(5.0),
      height: 70.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(
              '${userModel.image}',
            ),
          ),
          const SizedBox(
            width: 15.0,
          ),
          Expanded(
            child: Row(
              children: [
                Text(
                  '${userModel.name}',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: Colors.black87,
                    height: 1.6,
                  ),
                ),
                const SizedBox(
                  width: 5.0,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
