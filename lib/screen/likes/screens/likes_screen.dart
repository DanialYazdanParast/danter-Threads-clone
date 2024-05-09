import 'package:danter/core/di/di.dart';
import 'package:danter/data/repository/auth_repository.dart';
import 'package:danter/screen/likes/bloc/likes_bloc.dart';
import 'package:danter/core/widgets/user_detail_follow.dart';
import 'package:danter/screen/profile/screens/profile_screen.dart';
import 'package:danter/core/widgets/error.dart';
import 'package:danter/screen/profile_user/screens/profile_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LikesScreen extends StatefulWidget {
  final String idpostEntity;
  const LikesScreen({super.key, required this.idpostEntity});

  @override
  State<LikesScreen> createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen> {
  @override
  void dispose() {
    likesBloc.close();
    super.dispose();
  }

  final likesBloc = LikesBloc(locator.get());
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return BlocProvider.value(
      value: likesBloc..add(LikesStartedEvent(postId: widget.idpostEntity)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Likes',
          ),
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0.0),
              child: Divider(
                  height: 1,
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                  thickness: 0.7)),
        ),
        body: SafeArea(
          child: BlocBuilder<LikesBloc, LikesState>(
            builder: (context, state) {
              if (state is LikesSuccesState) {
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  itemCount: state.user[0].user.length,
                  itemBuilder: (context, index) {
                    return UserDetailFollow(
                      onTabFollow: () {
                        if (!state.user[0].user[index].followers
                            .contains(AuthRepository.readid())) {
                          BlocProvider.of<LikesBloc>(context).add(
                            LikedAddfollowhEvent(
                              userIdProfile: state.user[0].user[index].id,
                              myuserId: AuthRepository.readid(),
                            ),
                          );
                        } else {
                          BlocProvider.of<LikesBloc>(context).add(
                            LikedDelletfollowhEvent(
                              userIdProfile: state.user[0].user[index].id,
                              myuserId: AuthRepository.readid(),
                            ),
                          );
                        }
                      },
                      user: state.user[0].user[index],
                      onTabProfile: () {
                        if (state.user[0].user[index].id ==
                            AuthRepository.readid()) {
                          Navigator.of(
                            context,
                          ).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return const ProfileScreen();
                              },
                            ),
                          );
                        } else {
                          Navigator.of(
                            context,
                          ).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return BlocProvider.value(
                                  value: likesBloc,
                                  child: ProfileUser(
                                    user: state.user[0].user[index],
                                    idpostEntity: widget.idpostEntity,
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                    );
                  },
                );
              } else if (state is LikesLodingState) {
                return Center(
                  child: SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: themeData.colorScheme.secondary,
                      )),
                );
              } else if (state is LikesErrorState) {
                return AppErrorWidget(
                  exception: state.exception,
                  onpressed: () {
                    BlocProvider.of<LikesBloc>(context)
                        .add(LikesStartedEvent(postId: widget.idpostEntity));
                  },
                );
              } else {
                throw Exception('state is not supported ');
              }
            },
          ),
        ),
      ),
    );
  }
}