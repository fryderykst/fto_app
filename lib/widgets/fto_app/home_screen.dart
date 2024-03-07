import 'package:flutter/material.dart';
import 'package:fto_app/widgets/issues_list/issues_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  final String title = "Home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    getState();

    super.initState();
  }

  getState() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          // child: GridView()
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              HomeScreenTile(
                title: "ISSUES",
                onTapFunc: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IssuesListScreen(),
                    ),
                  );
                },
              ),
              const Divider(),
              HomeScreenTile(
                title: "SOMETHING #1",
                onTapFunc: () {},
              ),
              const Divider(),
              HomeScreenTile(
                title: "SOMETHING #2",
                onTapFunc: () {},
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: SizedBox(
          height: 50.0,
        ),
      ),
    );
  }
}

class HomeScreenTile extends StatelessWidget {
  const HomeScreenTile({super.key, required this.title, required this.onTapFunc});
  final String title;
  final Function onTapFunc;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListTile(
        shape: const Border(),
        title: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 20,
              fontFamily: 'Roboto',
            ),
          ),
        ),
        // tileColor: Colors.blueGrey.shade900,
        tileColor: Theme.of(context).colorScheme.onInverseSurface,
        onTap: () {
          onTapFunc();
        },
      ),
    );
  }
}
