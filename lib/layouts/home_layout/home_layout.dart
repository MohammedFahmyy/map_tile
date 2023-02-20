import 'package:flutter/material.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: (){}, icon: const Icon(
              Icons.more_vert_rounded
            ))
          ],
          title: const Text("Map Tile"),
          bottom: const TabBar(tabs: [
            Text("Map"),
            Text("Report"),
            Text("Chats"),
          ]),
        ),
        body: SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: FittedBox(
          fit: BoxFit.fill,
          child: Image.asset("assets/map.png"),
        ),
        )
      ),
    );
  }
}