part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class PostSuccesState extends PostState {
  final int totallike;
 final List<Replyphoto> totareplisePhoto;
  final int totareplise;

  const PostSuccesState(this.totallike, this.totareplise, this.totareplisePhoto,);

  @override
  List<Object> get props => [totallike, totareplise];
}

class PostErrorState extends PostState {
  final AppException exception;

  const PostErrorState({required this.exception});

  @override
  List<Object> get props => [exception];
}
