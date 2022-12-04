import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_db/bloc/bloc.dart';
import 'package:test_db/bloc/events.dart';
import 'package:test_db/bloc/states.dart';
import 'package:test_db/model/user.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  final List<User> userList = [];

  @override
  Widget build(BuildContext context) {
    // BlocBuilder, BlocConsumer
    return BlocListener<UsersBloc, UsersState>(
      listener: (BuildContext context, state) {
        if (state is UsersLoadedState) {
          setState(() {
            if (state.users.length - userList.length > 1) {
              userList.clear();
              userList.addAll(state.users);
            } else if (state.users.length - userList.length != 0){
              userList.add(state.users.last);
            }
          });
        }
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: nameController,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  hintText: "User name",
                  contentPadding: EdgeInsets.only(left: 30),
                  fillColor: Color.fromARGB(84, 100, 117, 135),
                  filled: true,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: ageController,
                obscureText: false,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  hintText: "User age",
                  contentPadding: EdgeInsets.only(left: 30),
                  fillColor: Color.fromARGB(84, 100, 117, 135),
                  filled: true,
                ),
              ),
            ),
            ButtonBar(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _addUserValues,
                  child: const Text('Add users'),
                ),
                ElevatedButton(
                  onPressed: _printAllUsers,
                  child: const Text('Print users in UI'),
                ),
              ],
            ),
            Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: userList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          height: 50,
                          margin: EdgeInsets.all(2),
                          color: Color.fromARGB(84, 100, 117, 135),
                          child: Center(
                              child: Text(
                            'User ${userList[index].name}, ${userList[index].age} years',
                            style: TextStyle(fontSize: 18),
                          )));
                    })),
            const SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }

  void _addUserValues() {
    final bloc = BlocProvider.of<UsersBloc>(context);
    bloc.add(
      AddUserEvent(
        User(
          name: nameController.text,
          age: int.parse(ageController.text),
        ),
      ),
    );
  }

  void _printAllUsers() {
    final bloc = BlocProvider.of<UsersBloc>(context);
    bloc.add(LoadUsersEvent());
  }
}