import 'package:danter/data/model/follow.dart';
import 'package:danter/data/model/like.dart';
import 'package:danter/data/model/post.dart';
import 'package:danter/data/model/replyphoto.dart';
import 'package:danter/data/model/user.dart';
import 'package:danter/util/response_validator.dart';
import 'package:dio/dio.dart';
import 'package:pocketbase/pocketbase.dart';

abstract class IPostDataSource {
  Future<List<PostEntity>> getPost(String userId);
  Future<List<PostEntity>> getPostProfile(String userId);
  Future<int> getPosttotalLike(String postId);
  Future<List<Replyphoto>> getPosttotalreplisePhoto(String postId);
  Future<int> getPosttotalreplise(String postId);
  Future<void> sendPost(String userId, String text, image);
  Future<int> getLikeuser(String postId, String userId);
  Future<void> addLike(String userId, String postid);
  Future<void> deleteLike(String likeid);
  Future<List<LikeId>> getLikeid(String postId, String userId);
  Future<int> getTotalfollowers(String userId);
  Future<int> getTruefollowing(String myuserId, String userIdProfile);
  Future<void> addfollow(String myuserId, String userIdProfile);
  Future<List<FollowId>> getFollowid(String myuserId, String userIdProfile);
  Future<void> deleteFollow(String followid);
  Future<List<LikeUser>> getAllLikePost(String postId);
  Future<List<Followers>> geAllfollowers(String userId);
  Future<List<Following>> geAllfollowing(String userId);
  Future<void> deletePost(String postid);
  Future<User> sendNameAndBio(String userid, String name, String bio);
  Future<User> sendImagePorofile(String userid, image);
}

class PostRemoteDataSource with HttpResponseValidat implements IPostDataSource {
  final Dio _dio;
  final pb = PocketBase('https://dan.chbk.run');
  // final String userId = AuthRepository.readid();
  PostRemoteDataSource(this._dio);
  @override
  Future<List<PostEntity>> getPost(String userId) async {
    Map<String, dynamic> qParams = {
      'filter': 'user !="$userId" && postid= "" ',
      'expand': 'user',
      'sort': '-created',
    };
    var response = await _dio.get(
      'collections/post/records',
      queryParameters: qParams,
    );
    validatResponse(response);

    return response.data['items']
        .map<PostEntity>((jsonObject) => PostEntity.fromJson(jsonObject))
        .toList();
  }

  @override
  Future<int> getPosttotalLike(String postId) async {
    Map<String, dynamic> qParams = {
      'filter': 'post="$postId"',
    };
    var response = await _dio.get(
      'collections/like/records',
      queryParameters: qParams,
    );
    validatResponse(response);

    return response.data['totalItems'];
  }

  @override
  Future<List<Replyphoto>> getPosttotalreplisePhoto(String postId) async {
    Map<String, dynamic> qParams = {
      'filter': 'postid="$postId"',
      'expand': 'user',
    };
    var response = await _dio.get(
      'collections/post/records',
      queryParameters: qParams,
    );
    validatResponse(response);

    return response.data['items']
        .map<Replyphoto>((jsonObject) => Replyphoto.fromJson(jsonObject))
        .toList();
  }

  @override
  Future<int> getPosttotalreplise(String postId) async {
    Map<String, dynamic> qParams = {
      'filter': 'postid="$postId"',
    };
    var response = await _dio.get(
      'collections/post/records',
      queryParameters: qParams,
    );
    validatResponse(response);

    return response.data['totalItems'];
  }

  @override
  Future<List<PostEntity>> getPostProfile(String userId) async {
    Map<String, dynamic> qParams = {
      'filter': 'user ="$userId"&& postid= ""',
      'expand': 'user',
      'sort': '-created'
    };
    var response = await _dio.get(
      'collections/post/records',
      queryParameters: qParams,
    );
    validatResponse(response);

    return response.data['items']
        .map<PostEntity>((jsonObject) => PostEntity.fromJson(jsonObject))
        .toList();
  }

  @override
  Future<void> sendPost(String userId, String text, image) async {
    // String filename = image.path.split('/').last;

    //  List uploadList = [];
    //   for (File file in image) {
    //      await MultipartFile.fromFile(
    //       uploadList.add(file.path)
    //     );

    //   }

    //    for (File item in image)
    //  formData.files.addAll([
    //    MapEntry("image", await MultipartFile.fromFile(item.path)),
    //  ]);

    FormData formData = FormData.fromMap({
      "user": userId,
      "text": text,
      "image": image
          .map((item) => MultipartFile.fromFileSync(item.path,
              filename: item.path.split('/').last))
          .toList()
    });

    final response =
        await _dio.post('collections/post/records', data: formData);
    validatResponse(response);
  }

  @override
  Future<int> getLikeuser(String postId, String userId) async {
    Map<String, dynamic> qParams = {
      'filter': 'user="$userId"&&post="$postId"',
    };
    var response = await _dio.get(
      'collections/like/records',
      queryParameters: qParams,
    );
    validatResponse(response);

    return response.data['totalItems'];
  }

  @override
  Future<void> addLike(String userId, String postid) async {
    final response = await _dio.post('collections/like/records',
        data: {"user": userId, "post": postid});
    validatResponse(response);
  }

  @override
  Future<void> deleteLike(String likeid) async {
    await pb.collection('like').delete(likeid);
  }

  @override
  Future<List<LikeId>> getLikeid(String postId, String userId) async {
    Map<String, dynamic> qParams = {
      'filter': 'user="$userId"&&post="$postId"',
    };
    var response = await _dio.get(
      'collections/like/records',
      queryParameters: qParams,
    );
    validatResponse(response);

    return response.data['items']
        .map<LikeId>((jsonObject) => LikeId.fromJson(jsonObject))
        .toList();
  }

  @override
  Future<int> getTotalfollowers(String userId) async {
    Map<String, dynamic> qParams = {
      'filter': 'fielduserfollower="$userId"',
    };
    var response = await _dio.get(
      'collections/follow/records',
      queryParameters: qParams,
    );
    validatResponse(response);

    return response.data['totalItems'];
  }

  @override
  Future<int> getTruefollowing(String myuserId, String userIdProfile) async {
    Map<String, dynamic> qParams = {
      'filter': 'userfollowing="$myuserId"&&fielduserfollower="$userIdProfile"',
    };
    var response = await _dio.get(
      'collections/follow/records',
      queryParameters: qParams,
    );
    validatResponse(response);

    return response.data['totalItems'];
  }

  @override
  Future<void> addfollow(String myuserId, String userIdProfile) async {
    final response = await _dio.post('collections/follow/records',
        data: {"userfollowing": myuserId, "fielduserfollower": userIdProfile});
    validatResponse(response);
  }

  @override
  Future<List<FollowId>> getFollowid(
      String myuserId, String userIdProfile) async {
    Map<String, dynamic> qParams = {
      'filter': 'userfollowing="$myuserId"&&fielduserfollower="$userIdProfile"',
    };
    var response = await _dio.get(
      'collections/follow/records',
      queryParameters: qParams,
    );
    validatResponse(response);

    return response.data['items']
        .map<FollowId>((jsonObject) => FollowId.fromJson(jsonObject))
        .toList();
  }

  @override
  Future<void> deleteFollow(String followid) async {
    await pb.collection('follow').delete(followid);
  }

  @override
  Future<List<LikeUser>> getAllLikePost(String postId) async {
    Map<String, dynamic> qParams = {
      'filter': 'post="$postId"',
      'expand': 'user',
    };
    var response = await _dio.get(
      'collections/like/records',
      queryParameters: qParams,
    );
    validatResponse(response);

    return response.data['items']
        .map<LikeUser>((jsonObject) => LikeUser.fromJson(jsonObject))
        .toList();
  }

  @override
  Future<List<Followers>> geAllfollowers(String userId) async {
    Map<String, dynamic> qParams = {
      'filter': 'fielduserfollower="$userId"',
      'expand': 'userfollowing',
      'sort': '-created'
    };
    var response = await _dio.get(
      'collections/follow/records',
      queryParameters: qParams,
    );
    validatResponse(response);

    return response.data['items']
        .map<Followers>((jsonObject) => Followers.fromJson(jsonObject))
        .toList();
  }

  @override
  Future<List<Following>> geAllfollowing(String userId) async {
    Map<String, dynamic> qParams = {
      'filter': 'userfollowing="$userId"',
      'expand': 'fielduserfollower',
      'sort': '-created'
    };
    var response = await _dio.get(
      'collections/follow/records',
      queryParameters: qParams,
    );
    validatResponse(response);

    return response.data['items']
        .map<Following>((jsonObject) => Following.fromJson(jsonObject))
        .toList();
  }

  @override
  Future<void> deletePost(String postid) async {
    await pb.collection('post').delete(postid);
  }

  @override
  Future<User> sendNameAndBio(String userid, String name, String bio) async {
    final body = <String, dynamic>{"name": name, "bio": bio,};
    // final response =  await pb.collection('users').update(userid, body: body);

    var response = await _dio.patch(
      'collections/users/records/$userid',
      data: body,
    );

    return User.fromJson(response.data);
  }

  @override
  Future<User> sendImagePorofile(String userid, image) async {
    FormData formData = FormData.fromMap({
      "avatar": image == null ? null : await MultipartFile.fromFile(image.path),
    });

    var response = await _dio.patch(
      'collections/users/records/$userid',
      data: formData,
    );

    return User.fromJson(response.data);
  }
}
