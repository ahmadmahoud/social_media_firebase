import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_firebase/core/cubit/cubit.dart';
import 'package:social_firebase/core/models/messageModel.dart';
import 'package:social_firebase/core/models/user_data.dart';
import 'package:social_firebase/features/home/widget/iconBroken.dart';

import '../../core/cubit/state.dart';

class ChatDetailsScreen extends StatelessWidget {
  UserModel userModel;
  ChatDetailsScreen({Key? key,required this.userModel}) : super(key: key);


  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        MainBloc.get(context).getMessages(
          receiverId: userModel.uId!,
        );

        return BlocConsumer<MainBloc, MainState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                backgroundColor: Colors.grey[400]!,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(
                        userModel.image!,
                      ),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      userModel.name!,
                    ),
                  ],
                ),
              ),
              body: BuildCondition(
                condition: MainBloc.get(context).messages.isNotEmpty,
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index)
                          {
                            var message = MainBloc.get(context).messages[index];

                            if(MainBloc.get(context).userModel!.uId! == message.senderId) {
                              return buildMyMessage(message);
                            }
                            return buildMessage(message);
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 15.0,
                          ),
                          itemCount: MainBloc.get(context).messages.length,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(
                            15.0,
                          ),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                ),
                                child: TextFormField(
                                  controller: messageController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'type your message here ...',
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 50.0,
                              color: Colors.blue,
                              child: MaterialButton(
                                onPressed: () {
                                  MainBloc.get(context).sendMessage(
                                    receiverId: userModel.uId!,
                                    dateTime: DateTime.now().toString(),
                                    text: messageController.text,
                                  );
                                  messageController.clear();
                                },
                                minWidth: 1.0,
                                child: const Icon(
                                  IconBroken.Send,
                                  size: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                fallback: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMessage(MessageModel model) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: const BorderRadiusDirectional.only(
          bottomEnd: Radius.circular(
            10.0,
          ),
          topStart: Radius.circular(
            10.0,
          ),
          topEnd: Radius.circular(
            10.0,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 10.0,
      ),
      child: Text(
        model.text!,
      ),
    ),
  );

  Widget buildMyMessage(MessageModel model) => Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(
          .2,
        ),
        borderRadius:  const BorderRadiusDirectional.only(
          bottomStart:  Radius.circular(
            10.0,
          ),
          topStart:  Radius.circular(
            10.0,
          ),
          topEnd: Radius.circular(
            10.0,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 10.0,
      ),
      child: Text(
        model.text!,
      ),
    ),
  );
}
