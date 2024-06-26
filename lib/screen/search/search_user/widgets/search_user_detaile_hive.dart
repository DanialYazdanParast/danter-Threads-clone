import 'package:danter/data/model/user.dart';

import 'package:danter/core/widgets/image_user_post.dart';
import 'package:danter/screen/root/screens/root.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class SearchUserDetailHive extends StatelessWidget {
  final User user;
  final GestureTapCallback onTabProfile;
  final GestureTapCallback onTabDelete;
  const SearchUserDetailHive(
      {super.key,
      required this.user,
      required this.onTabProfile,
      required this.onTabDelete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTabProfile,
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
                  ImageUserPost(user: user, onTabNameUser: onTabProfile),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: !RootScreen.isMobile(context) ? 180 : null,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 2),
                            SizedBox(
                              child: Text(
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                softWrap: true,
                                user.username,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            Visibility(
                              visible: user.tik,
                              child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: Image.asset('assets/images/tik.png')),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: !RootScreen.isMobile(context) ? 200 : null,
                        child: Text(
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false,
                          user.name == '' ? user.username : user.name!,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      )
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: onTabDelete,
                    child: Icon(
                      CupertinoIcons.multiply,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 20,
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
