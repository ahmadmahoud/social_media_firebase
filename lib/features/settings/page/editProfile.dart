import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_firebase/core/constants.dart';
import 'package:social_firebase/core/cubit/cubit.dart';
import 'package:social_firebase/core/cubit/state.dart';
import 'package:social_firebase/features/home/widget/iconBroken.dart';

class EditProfile extends StatelessWidget {
  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = MainBloc.get(context);
        var profileImage = cubit.profileImage;
        var coverImage = cubit.coverImage;
        var userModel = cubit.userModel;
        nameController.text = userModel!.name!;
        bioController.text = userModel.bio!;
        phoneController.text = userModel.phone!;

        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Edit Profile',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            leading: IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(
              IconBroken.Arrow___Left_Square,
              size: 32,
              color: Colors.black54,
            )),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                if (state is UploadUserDataLoadingState)
                  LinearProgressIndicator(),
                if (state is UploadUserDataLoadingState)
                  SizedBox(
                    height: 5.0,
                  ),
                Container(
                  height: 200.0,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          if (coverImage == null)
                            Align(
                              alignment: AlignmentDirectional.topCenter,
                              child: Card(
                                elevation: 0.0,
                                margin: EdgeInsets.symmetric(horizontal: 0.0),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Image(
                                  image: NetworkImage(
                                    '${userModel.cover}',
                                  ),
                                  height: 160.0,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          if (coverImage != null)
                            Align(
                              alignment: AlignmentDirectional.topCenter,
                              child: Card(
                                elevation: 0.0,
                                margin: EdgeInsets.symmetric(horizontal: 0.0),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Image(
                                  image: FileImage(
                                    File(coverImage.path),
                                  ),
                                  height: 160.0,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 20.0,
                              backgroundColor: Colors.lightBlue,
                              child: IconButton(
                                onPressed: () {
                                  cubit.pickCoverImage();
                                },
                                icon: Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          if (profileImage == null)
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
                          if (profileImage != null)
                            CircleAvatar(
                              radius: 62.0,
                              backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 60.0,
                                backgroundImage: FileImage(
                                  File(profileImage.path),
                                ),
                              ),
                            ),
                          CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.lightBlue,
                            child: IconButton(
                              onPressed: () {
                                cubit.pickProfileImage();
                              },
                              icon: Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                defaultFormField(
                  controller: nameController,
                  label: 'Name',
                  prefix: Icons.person_outline,
                  type: TextInputType.name,
                  validate: (String? value) {
                    if (value!.isEmpty)
                      return 'Name must not be empty';
                    else
                      return null;
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                defaultFormField(
                  controller: phoneController,
                  label: 'Phone',
                  prefix: Icons.phone_outlined,
                  type: TextInputType.phone,
                  validate: (String? value) {
                    if (value!.isEmpty)
                      return 'Phone must not be empty';
                    else
                      return null;
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                defaultFormField(
                  controller: bioController,
                  label: 'Bio',
                  prefix: Icons.info_outline,
                  type: TextInputType.text,
                  validate: (String? value) {
                    if (value!.isEmpty)
                      return 'Bio must not be empty';
                    else
                      return null;
                  },
                ),
                Spacer(),
                MaterialButton(onPressed: (){
                  cubit.updateUserDate(
                    name: nameController.text,
                    phone: phoneController.text,
                    bio: bioController.text,
                  );

                },
                  height: 50,
                  shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0) ),
                  minWidth: double.infinity,
                  color: Colors.deepPurpleAccent,
                  child: Text('Update Data',style: TextStyle(color: Colors.white),),

                )
              ],
            ),
          ),
        );
      },
    );
  }
}