import 'package:flutter/material.dart';
import 'package:simple_exercise_calendar/helpers/exercise_plan_data.dart';
import 'package:simple_exercise_calendar/ui/calendar/calendar.dart';
import 'package:simple_exercise_calendar/ui/exercises/exercicises.dart';
import 'package:simple_exercise_calendar/ui/exercises/exercise_edit_dialog.dart';
import 'package:simple_exercise_calendar/ui/exercises/exercises_create.dart';

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
      appBar: AppBar(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (int index) {
          setState(() {
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
                String title = await _showCreatePlan();

                if (title != null && title.isNotEmpty) {
                  ExercisePlanData plan = ExercisePlanData(
                    title: title
                  );
                  
                  int result = await plan.save();
                  if (result != 0) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => ExercisesCreate(
                        plan: plan,
                      )));
                  }
                }
              },
              child: Icon(Icons.add),
            )
          : null,
      body: PageView.builder(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 2,
          itemBuilder: (BuildContext context, int page) {
            return _pages[page];
          }),
    );
  }

  Future<String> _showCreatePlan() async {
    return showDialog<String>(
        context: context,
        builder: (BuildContext dialogContext) => ExerciseEditDialog(
          title: "Create Plan",
          lable: "Plan name",
        ));
  }
}
