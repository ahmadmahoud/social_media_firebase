import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_firebase/core/constants.dart';
import 'package:social_firebase/core/cubit/state.dart';
import 'package:social_firebase/core/di/injection.dart';
import 'package:social_firebase/core/models/messageModel.dart';
import 'package:social_firebase/core/models/postModel.dart';
import 'package:social_firebase/core/models/user_data.dart';
import 'package:social_firebase/core/network/local/cache_helper.dart';
import 'package:social_firebase/core/network/repository.dart';
import 'package:social_firebase/features/chat/page/chat.dart';
import 'package:social_firebase/features/feed/page/feed.dart';
import 'package:social_firebase/features/home/widget/iconBroken.dart';
import 'package:social_firebase/features/new_post/new_post.dart';
import 'package:social_firebase/features/settings/page/settings.dart';
import 'package:social_firebase/features/users/page/users.dart';

class MainBloc extends Cubit<MainState> {
  final Repository _repository;

  MainBloc({
    required Repository repository,
  })
      : _repository = repository,
        super(Empty());

  static MainBloc get(context) => BlocProvider.of(context);

  /// variables bool
  bool isRtl = false;
  bool isDark = false;

  /// dark colors
  String scaffoldBackground = '11202a';
  String mainColorDark = 'ffffff';
  String mainColorVariantDark = '8a8a89';

  /// dark colors
  String secondaryDark = 'ffffff';
  String secondaryVariantDark = '8a8a89';

  late ThemeData lightTheme;
  late ThemeData darkTheme;

  bool noInternetConnection = false;

  /// ChangePage --------------------------------- start ||
  int currentIndex = 0;

  List<Widget> screens = [
    const FeedPage(),
    const ChatsPage(),
    const NewPostPage(),
    const UsersPage(),
    const SettingsPage(),
  ];


  List<String> titles = [
    'Home',
    'Chats',
    'Post',
    'Users',
    'Settings',
  ];


  List<BottomNavigationBarItem> bottomItems = [
    const BottomNavigationBarItem(
      icon: Icon(IconBroken.Home),
      label: "Home",
    ),
    const BottomNavigationBarItem(
        icon: Icon(IconBroken.Chat),
        label: "Chats"),
    const BottomNavigationBarItem(
      icon: Icon(IconBroken.Paper_Upload),
      label: "Post",
    ),
    const BottomNavigationBarItem(
      icon: Icon(IconBroken.User),
      label: "Users",
    ),
    const BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.settings), label: "Settings"),
  ];

  // navigator to new post page without appbar .
  void changeBottomNav(int index) {
    if (index == 2)
      emit(SocialNewPostState());
    else {
      currentIndex = index;
      emit(SocialBottomNavigateState());
    }
  }

  /// ChangePage --------------------------------- end ||
  /// firebase --------------------------------- start
  String? name;
  String? email;
  String? phone;
  File? imageFile;
  String? imageUrl;
  String? uId;

  void userRegister({
    required String email,
    required String password,
    required String name,
    required String phone,
    required File imageFile,
  }) async {
    this.email = email;
    this.name = name;
    this.phone = phone;
    this.imageFile = imageFile;

    emit(RegisterLoadingState());
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
        email: email,
        password: password)
        .then((value) {
      uId = value.user!.uid;
      _uploadImage();
    }).catchError((error) {
      emit(Error(error.toString()));
    });
  }

  void _uploadImage() async {
    print('_uploadImage -----------------');
    try {
      await FirebaseStorage.instance
          .ref('profileImages/$uId')
          .putFile(imageFile!);

      _getImageUrl();
    } on FirebaseException catch (e) {
      emit(Error(e.toString()));
    }
  }

  void _getImageUrl() async {
    print('_getImageUrl -----------------');
    imageUrl = await FirebaseStorage.instance
        .ref('profileImages/$uId')
        .getDownloadURL();
    userCreate();
  }

  void userCreate() async {
    UserModel userModel = UserModel(
      email: email,
      name: name,
      phone: phone,
      uId: uId,
      image: imageUrl,
      cover: imageUrl
    );
    print('userCreate -----------------');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(userModel.toMap())
        .then((value) {
      sl<CacheHelper>().put('uid', uIdUser);
      getUserDate();
      emit(CreateUserSuccessState());
    }).catchError((error) {
      emit(Error(error.toString()));
    });
  }

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(LoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: email,
        password: password)
        .then((value) {
      print('----- yes');
      print(value.user!.email);
      sl<CacheHelper>().put('uid', FirebaseAuth.instance.currentUser!.uid);
      // print(value.user!.uid);
      // uId = value.user!.uid;
      emit(LoginSuccessState());
      getUserDate();
    }).catchError((error) {
      print('----- no');
      emit(Error(error.toString()));
    });
  }

  UserModel? userModel;

  void getUserDate() {
    emit(HomeGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').
    doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
      userModel = UserModel.fromMap(value.data()!);
      print(FirebaseAuth.instance.currentUser!.emailVerified);
      emit(HomeGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(Error(error));
    });
  }

  ///---------------------- add image and update data ---------------------- start
  // Pick Profile && Cover Image
  var picker = ImagePicker();

  // Pick Profile Image
  File? profileImage;

  // get image from gallery and save path in profileImage
  Future<void> pickProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    profileImage = File(pickedFile!.path);
    emit(PickProfileImageState());
  }

  // Pick Cover Image
  File? coverImage;

  //get image from gallery and save path in coverImage
  Future<void> pickCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    coverImage = File(pickedFile!.path);
    emit(PickCoverImageState());
  }

  // Firebase Storage, Upload Profile Image
  String? uploadedProfileImageUrl;

  // update data without images .
  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(UploadUserDataLoadingState());
    FirebaseStorage.instance
        .ref()
    // go to users collection and get end path from image .
    // ex : camera/dims/image_picker4924737622256940789.jpg get ( ' image_picker4924737622256940789.jpg ' )
        .child('users/${Uri
        .file(profileImage!.path)
        .pathSegments
        .last}')
    // upload profileImage
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        // get link of image in uploadedProfileImageUrl
        uploadedProfileImageUrl = value;
        updateUser(
          bio: bio,
          name: name,
          phone: phone,
          // send uploadedProfileImageUrl to firebase .
          profile: uploadedProfileImageUrl,
        );
        emit(UploadProfileImageSuccessState());
      }).catchError((error) {
        emit(UploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(UploadProfileImageErrorState());
    });
  }

  // Firebase Storage, Upload Cover Image
  String? uploadedCoverImageUrl;

  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(UploadUserDataLoadingState());
    FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file(coverImage!.path)
        .pathSegments
        .last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        uploadedCoverImageUrl = value;
        updateUser(
          bio: bio,
          name: name,
          phone: phone,
          cover: uploadedCoverImageUrl,
        );
        emit(UploadCoverImageSuccessState());
      }).catchError((error) {
        emit(UploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(UploadCoverImageErrorState());
    });
  }

  //  ---------------- Update User ----------------------- //
  // send name + phone + bio required | profile  || cover == null ? get default images from model
  void updateUser({
    required String name,
    required String phone,
    required String bio,
    String? profile,
    String? cover,
  }) {
    UserModel model = UserModel(
      email: userModel!.email,
      name: name,
      phone: phone,
      image: profile ?? userModel!.image,
      cover: cover ?? userModel!.cover,
      uId: userModel!.uId,
      bio: bio,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      getUserDate();
    }).catchError((error) {
      emit(UpdateUserErrorState());
    });
  }

  //  Firebase Storage, Update user date
  void updateUserDate({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(UploadUserDataLoadingState());
    if (profileImage != null) {
      uploadProfileImage(
        name: name,
        phone: phone,
        bio: bio,
      );
    }
    if (coverImage != null) {
      uploadCoverImage(
        name: name,
        phone: phone,
        bio: bio,
      );
    }
    if (coverImage == null && profileImage == null) {
      updateUser(
        bio: bio,
        name: name,
        phone: phone,
      );
    }
  }

  //  upload image and update data ----------------------------------------------- END
  /// New Post and get ------------------------------------------------------------- Start
  File? postImage;

  // convert image to link and save link in postImage.
  Future<void> pickPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    postImage = File(pickedFile!.path);
    emit(PicPostImageState());
  }

  // remove image after click delete
  void removePostImage() {
    postImage = null;
    emit(RemovePostImageState());
  }

  // upload that image and get it path to create post with image
  void createImagedPost({
    required String dataTime,
    required String text,
    required BuildContext context,
  }) {
    emit(CreatePostLoadingState());
    FirebaseStorage.instance
        .ref()
        .child('posts/${Uri
        .file(postImage!.path)
        .pathSegments
        .last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        // upload post with image
        createPost(
          context: context,
          text: text,
          dataTime: dataTime,
          postImage: value,
        );
      }).catchError((error) {
        emit(CreatePostErrorState());
      });
    }).catchError((error) {
      emit(CreatePostErrorState());
    });
  }

  //  3- upload post if no image
  void createPost({
    required String dataTime,
    required String text,
    required BuildContext context,
    String? postImage,
  }) {
    // create post without image.
    PostModel postModel = PostModel(
      name: userModel!.name,
      image: userModel!.image,
      uId: userModel!.uId,
      text: text,
      dateTime: dataTime,
      postImage: postImage ?? null,
    );
    // here use add replace set ( add generate random id and save direct after collection )
    emit(CreatePostLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .add(postModel.toMap())
        .then((value) {
      Navigator.pop(context);
      getPosts();
    }).catchError((error) {
      print(error.toString());
      emit(CreatePostErrorState());
    });
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];


  // get all docs from posts collection and adding one by one to that list (posts) using forEach
  void getPosts() {
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      // get all data to value
      // loop all value.docs (count of post)
      value.docs.forEach((element) {
        // get data from element.data (عرض البيانات الخاصه بالعنصر الواحد بشكل كامل)
        element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);
          // add all id's posts to list.
          postsId.add(element.id);
          // add data post to list.
          posts.add(PostModel.fromMap(element.data()));
        });
      });
      emit(HomeGetPostsSuccessState());
    }).catchError((error) {
      emit(HomeGetPostsErrorInitialState(error.toString()));
    });
  }

  // New Post and get ------------------------------------------------------------- END

  ///  ---------------- likes ----------------------- start

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId!)
        .set({
      'like': true,
    }).then((value) {
      emit(SocialLikePostSuccessState());
    }).catchError((error) {
      emit(SocialLikePostErrorState(error.toString()));
    });
  }

  //  likes ------------------------------------------------------------- END

  ///  ---------------- get AllUsers ----------------------- start

  List<UserModel> users = [];

  void getUsers() {
    FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach((element) {
        // if id is not equal to current user id add to list
        if (element.data()['uId'] != userModel!.uId) {
          users.add(UserModel.fromMap(element.data()));
        }
      });
      emit(SocialGetAllUsersSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetAllUsersErrorState(error.toString()));
    });
  }


  //  get AllUsers ------------------------------------------------------------- END

  ///  ---------------- Chat ----------------------- start

  List<MessageModel> messages = [];

  void sendMessage({
    required String receiverId,
    required String text,
    required String dateTime,
  }) {
    MessageModel model = MessageModel(
      text: text,
      senderId: userModel!.uId!,
      receiverId: receiverId,
      dateTime: dateTime,
    );

    // set my chats (set data in my user id)
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });

    // set receiver chats (set data in receiver id)=> delete message from user (delete me) show message for receiver
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
  }


void getMessages({
  required String receiverId,
}) {
  FirebaseFirestore.instance
      .collection('users')
      .doc(userModel!.uId!)
      .collection('chats')
      .doc(receiverId)
      .collection('messages')
      .orderBy('dateTime')
      .snapshots()
      .listen((event) {
        // delete data evey one and get
        messages = [];

    event.docs.forEach((element) {
      messages.add(MessageModel.fromMap(element.data()));
    });

    emit(SocialGetMessagesSuccessState());
  });
}

//  Chat ------------------------------------------------------------- END


/// firebase --------------------------------- end

void checkConnectivity() {
  Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    debugPrint('Internet Connection ------------------------');
    debugPrint('${result.index}');
    debugPrint(result.toString());
    if (result.index == 0 || result.index == 1) {
      noInternetConnection = false;
    } else if (result.index == 2) {
      noInternetConnection = true;
    }
    emit(InternetState());
  });
}

void checkInternet() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    noInternetConnection = false;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    noInternetConnection = false;
  } else {
    noInternetConnection = true;
  }
  emit(InternetState());
}

void changeDarkMode() {
  isDark = !isDark;
  sl<CacheHelper>().put('isDark', isDark);
  setThemes(change: isDark);
  emit(ChangeDarkMode());
}

void setThemes({required bool change}) {
  isDark = change;
  isDarkMode = isDark;
  changeTheme();
  emit(ThemeLoaded());
}

void rebuildAllChildren(BuildContext context) {
  void rebuild(Element el) {
    el.markNeedsBuild();
    el.visitChildren(rebuild);
  }

  (context as Element).visitChildren(rebuild);
}

void changeTheme() {
  lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: Platform.isIOS
          ? null
          : const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      titleSpacing: 0.0,
      iconTheme: const IconThemeData(
        color: Colors.white,
        size: 20.0,
      ),
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      elevation: 50.0,
      selectedItemColor: HexColor(textColorD),
      unselectedItemColor: HexColor(grey),
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: const TextStyle(
        height: 1.5,
      ),
    ),
    primarySwatch: MaterialColor(int.parse('0xff$secondaryColorD'), color),
    textTheme: TextTheme(
      headline6: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: isDark ? HexColor(textColorD) : HexColor(TextMainColor),
        height: 1.3,
      ),
      bodyText1: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: isDark ? HexColor(textColorD) : HexColor(TextMainColor),
        height: 1.4,
      ),
      bodyText2: TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.w700,
        color: isDark ? HexColor(secondaryDark) : HexColor(TextMainColor),
        height: 1.4,
      ),
      subtitle1: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w700,
        color: isDark ? HexColor(textColorD) : HexColor(TextMainColor),
        height: 1.4,
      ),
      subtitle2: TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.w400,
        color: isDark ? HexColor(textColorD) : HexColor(TextMainColor),
        height: 1.4,
      ),
      caption: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w400,
        color: Colors.black54,
        height: 1.4,
      ),
      button: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        height: 1.4,
      ),
    ),
  );

  darkTheme = ThemeData(
    primaryColor: Colors.yellow,
    primaryColorLight: Colors.yellow,
    primaryColorDark: Colors.yellow,
    // background
    scaffoldBackgroundColor: Colors.black38,
    // canvasColor: Colors.transparent,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: Platform.isIOS
          ? null
          : const SystemUiOverlayStyle(
        statusBarColor: Color(0x00060a0c),
        statusBarIconBrightness: Brightness.light,
      ),
      backgroundColor: darkGreyClr,
      elevation: 0.0,
      titleSpacing: 0.0,
      iconTheme: IconThemeData(
        size: 20.0,
        color: HexColor(mainColorDark),
      ),
      titleTextStyle: TextStyle(
        color: HexColor(grey),
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: HexColor(scaffoldBackground),
      elevation: 50.0,
      selectedItemColor: HexColor(mainColor),
      unselectedItemColor: HexColor(grey),
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: const TextStyle(
        height: 1.5,
      ),
    ),
    // any selected item .
    primarySwatch: MaterialColor(int.parse('0xff$mainColorD'), color),
    textTheme: TextTheme(
      headline6: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        color: HexColor(surface),
        height: 1.3,
      ),
      bodyText1: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        color: HexColor(surface),
        height: 1.4,
      ),
      bodyText2: TextStyle(
        fontSize: 25.0,
        fontWeight: FontWeight.w700,
        color: HexColor(surface),
        height: 1.4,
      ),
      subtitle1: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w700,
        color: HexColor(surface),
        height: 1.4,
      ),
      subtitle2: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        color: HexColor(surface),
        height: 1.4,
      ),
      caption: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w400,
        color: HexColor(surface),
        height: 1.4,
      ),
      button: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        height: 1.4,
      ),
    ),
  );
}

void changeMode({required bool value}) {
  isDark = value;
  sl<CacheHelper>().put('isDark', isDark);
  emit(ChangeModeState());
}}
