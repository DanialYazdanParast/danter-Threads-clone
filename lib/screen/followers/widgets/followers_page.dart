import 'package:danter/data/model/user.dart';
import 'package:danter/data/repository/auth_repository.dart';
import 'package:danter/core/widgets/image_user_post.dart';
import 'package:flutter/material.dart';

class FollowersPage extends StatelessWidget {
  final String userid;
  final User userFollowers;
  final GestureTapCallback onTabProfileUser;
  final GestureTapCallback onTabfolow;
  const FollowersPage({
    super.key,
    required this.userFollowers,
    required this.userid,
    required this.onTabProfileUser,
    required this.onTabfolow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTabProfileUser,
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImageUserPost(
                      user: userFollowers, onTabNameUser: onTabProfileUser),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            userFollowers.username,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(width: 2),
                          Visibility(
                            visible: userFollowers.tik,
                            child: SizedBox(
                                width: 16,
                                height: 16,
                                child: Image.asset('assets/images/tik.png')),
                          ),
                        ],
                      ),
                      Text(
                        userFollowers.name == ''
                            ? userFollowers.username
                            : userFollowers.name!,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Visibility(
                    visible: userFollowers.id != AuthRepository.readid(),
                    child: SizedBox(
                      height: 35,
                      width: 130,
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              //  minimumSize: const Size(120, 35),
                              shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                          onPressed: onTabfolow,
                          child: Text(
                              userid == AuthRepository.readid()
                                  ? 'Remove'
                                  : userFollowers.followers
                                          .contains(AuthRepository.readid())
                                      ? 'Following'
                                      : 'Follow',
                              style: userid == AuthRepository.readid()
                                  ? Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(fontWeight: FontWeight.w400)
                                  : userFollowers.followers
                                          .contains(AuthRepository.readid())
                                      ? Theme.of(context).textTheme.titleSmall
                                      : Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.w400))),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 67),
              child: Divider(
                  height: 20,
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                  thickness: 0.7),
            ),
          ],
        ),
      ),
    );
  }
}
