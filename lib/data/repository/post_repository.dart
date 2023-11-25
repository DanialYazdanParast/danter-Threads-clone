import 'package:danter/data/datasource/post_data_source.dart';
import 'package:danter/data/model/post.dart';
import 'package:danter/data/model/replyphoto.dart';

abstract class IPostRepository {
  Future<List<PostEntity>> getPost(String userId);
  Future<List<PostEntity>> getPostProfile(String userId);
  Future<int> getPosttotalLike(String postId);
  Future<int> getPosttotalreplise(String postId);
  Future<List<Replyphoto>> getPosttotalreplisePhoto(String postId);
  Future<void> sendPost(String userId, String text);
}

class PostRepository implements IPostRepository {
  final IPostDataSource dataSource;
  PostRepository(this.dataSource);
  @override
  Future<List<PostEntity>> getPost(String userId) {
    return dataSource.getPost(userId);
  }

  @override
  Future<int> getPosttotalLike(String postId) {
    return dataSource.getPosttotalLike(postId);
  }

  @override
  Future<int> getPosttotalreplise(String postId) {
    return dataSource.getPosttotalreplise(postId);
  }

  @override
  Future<List<Replyphoto>> getPosttotalreplisePhoto(String postId) {
    return dataSource.getPosttotalreplisePhoto(postId);
  }

  @override
  Future<List<PostEntity>> getPostProfile(String userId) {
    return dataSource.getPostProfile(userId);
  }

  @override
  Future<void> sendPost(String userId, String text) {
    return dataSource.sendPost(userId, text);
  }
}
