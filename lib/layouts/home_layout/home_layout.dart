import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_tile/modules/download/download_page.dart';
import 'package:map_tile/shared/constants/constants.dart';

import '../../cubit/cubit.dart';
import '../../cubit/states.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        // Tap Bar Controller
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              actions: [
                // Logout, Visibility Menu
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem<String>(
                      value: "Visibility",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.visibility, color: Colors.grey),

                          const SizedBox(
                            width: 10,
                          ),
                          const Text("Visibility"),
                          const SizedBox(width: 5,),
                          CircleAvatar(
                            radius: 5,
                            backgroundColor: (cubit.visibility)?Colors.green:Colors.grey,
                          )
                                    ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: "Logout",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.logout_outlined, color: Colors.red),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Logout"),
                        ],
                      ),
                    ),
                  ],
                  // On Click Perform selectedItemAction Function
                  onSelected: (value) =>
                      cubit.selectedItemAction(context, value),
                )
              ],
              title: const Text("Map Tile"),
              bottom: TabBar(tabs: const [
                Text("Map"),
                Text("Report"),
                Text("Chats"),
              ],
              onTap: (value) {
                cubit.changePage(value);
              },
              ),
            ),
            // If Item Downloaded Show Screens, Else Show Download Screen
            body: ConditionalBuilder(
              condition: (unarchived && downloaded),
              fallback: (context) => const DownloadScreen(),
              builder: (context) =>  cubit.screens[cubit.pageIndex],
            ),
          ),
        );
      },
    );
  }
}
