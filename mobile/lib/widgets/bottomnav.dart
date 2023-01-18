import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrillBottomNavigatorModel with ChangeNotifier {
  int selectedIndex = 0;

  void setSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}

// This bottom navbar might be inefficient as currently written
// it seems to be hard / not recommended to use just one instance of it across multiple screens
// so the selected index is shared instead
// but it looks nice
// Does not work with the Android device back button
class TrillBottomNavigatorState extends StatelessWidget {
  final GlobalKey key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TrillBottomNavigatorModel>(context);
    return DefaultTabController(
      length: 3,
      initialIndex: model.selectedIndex,
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.black,
          textTheme: Theme.of(context).textTheme.copyWith(
                caption: TextStyle(color: Colors.white),
              ),
        ),
        child: TabBar(
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.blue, width: 2.0),
            ),
          ),
          labelColor: Colors.purple,
          unselectedLabelColor: Colors.white,
          onTap: (index) {
            model.setSelectedIndex(index);
            DefaultTabController.of(context)?.animateTo(index);
            if (index == 0) {
              Navigator.pushNamed(context, '/home');
            }
            if (index == 1) {
              Navigator.pushNamed(context, '/search');
            }
            if (index == 2) {
              Navigator.pushNamed(context, '/profile');
            }
          },
          tabs: [
            Tab(
              icon: Icon(Icons.home),
            ),
            Tab(
              icon: Icon(Icons.search),
            ),
            Tab(
              icon: Icon(Icons.person),
            ),
          ],
        ),
      ),
    );
  }
}
