import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  List<Task> _tasks = [];

  void _showAddTaskDialog() {
    String taskName = '';
    TimeOfDay? taskTime;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  taskName = value;
                },
                decoration: InputDecoration(hintText: 'Enter task name'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      taskTime = pickedTime;
                    });
                  }
                },
                child: Text('Select Time'),
              ),
              SizedBox(height: 10.0),
              if (taskTime != null)
                Text(
                  'Selected Time: ${taskTime?. format(context)}',
                  style: TextStyle(fontSize: 16.0),
                ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (taskTime != null) {
                  setState(() {
                    _tasks.add(Task(
                      name: taskName,
                      date: _selectedDate!,
                      time: taskTime!,
                    ));
                  });
                  Navigator.of(context).pop();
                } else {
                  // Handle case where time is not selected
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Select Time'),
                        content: Text('Please select a time for the task.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(231, 249, 218, 1),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddTaskDialog();
          },
          child: Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        color: Colors.blueAccent,
                        height: 200,
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              DateTime? datepick = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate ?? DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(DateTime.now().year + 1),
                              );
                              if (datepick != null) {
                                setState(() {
                                  _selectedDate = datepick;
                                });
                              }
                            },
                            child: Text('Select Date'),
                          ),
                        ),
                      ),
                      if (_selectedDate != null)
                        ListTile(
                          title: Text(
                            'Tasks for ${DateFormat('dd-MM-yyyy').format(_selectedDate!)}',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _tasks.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.white,
                              child: ListTile(
                                title: Text("Task:${_tasks[index].name}"),
                                subtitle: _tasks[index].time != null
                                    ? Text('Time: ${_tasks[index].time!.format(context)}')
                                    : null,
                                trailing: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _tasks.removeAt(index);
                                    });
                                  },
                                  icon: Icon(Icons.delete_outline),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Task {
  final String name;
  final DateTime date;
  final TimeOfDay? time;

  Task({
    required this.name,
    required this.date,
    this.time,
  });
}
