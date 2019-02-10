import 'package:flutter/material.dart';
import 'package:simple_exercise_calendar/helpers/common_functions.dart';
import 'package:simple_exercise_calendar/helpers/exercise_plan_data.dart';
import 'package:simple_exercise_calendar/helpers/mainInherited_widget.dart';
import 'package:simple_exercise_calendar/helpers/progress_widget.dart';
import 'package:simple_exercise_calendar/ui/calendar/calendar.dart';
import 'package:simple_exercise_calendar/ui/exercises/exercicises.dart';
import 'package:simple_exercise_calendar/ui/exercises/exercises_detail.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> {
  final PageController _pageController = PageController();
  List<Widget> _pages = [];
  int _index = 0;
  String _title = "";

  @override
  void initState() {
    super.initState();

    _pages = [CalendarMain(), ExercisesMain()];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          onTap: (int index) {
            setState(() {
              _setTitle(index);
              _pageController.jumpToPage(index);
              _index = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              title: Text("Calendar"),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.people), title: Text("Exercises"))
          ],
        ),
        floatingActionButton: _index == 1
            ? FloatingActionButton(
                onPressed: () async {
                  String title = await showEditDialog(
                      context, "Create Plan", "Plan name", "");

                  if (title != null && title.isNotEmpty) {
                    ExercisePlanData plan = ExercisePlanData(title: title);

                    int result = await plan.save();
                    if (result != 0) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => ExercisesDetail(
                                plan: plan,
                              )));
                    }
                  }
                },
                child: Icon(Icons.add),
              )
            : null,
        body: ProgressWidget(
            showStream: MainInherited.of(context).loaderProgressStream,
            child: PageView.builder(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 2,
                itemBuilder: (BuildContext context, int page) {
                  return _pages[page];
                })));
  }

  void _setTitle(int page) {
    if (page == 0) _title = "Calendar";
    if (page == 1) _title = "Execise plans";
  }
}
