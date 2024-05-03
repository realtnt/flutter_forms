import 'package:flutter/material.dart';
import 'package:flutter_forms/models/todo.dart';
import 'package:flutter_forms/todo_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formGlobalKey = GlobalKey<FormState>();
  Priority _selectedPriority = Priority.low;
  String _title = '';
  String _description = '';

  final List<Todo> todos = [
    const Todo(
        title: 'Buy milk',
        description: 'There is no milk left in the fridge!',
        priority: Priority.high),
    const Todo(
        title: 'Make the bed',
        description: 'Keep things tidy please..',
        priority: Priority.low),
    const Todo(
        title: 'Pay bills',
        description: 'The gas bill needs paying ASAP.',
        priority: Priority.urgent),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        centerTitle: true,
        backgroundColor: Colors.grey[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(child: TodoList(todos: todos)),
            // form stuff below here
            Form(
              key: _formGlobalKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // todo title
                  TextFormField(
                    maxLength: 20,
                    decoration: const InputDecoration(
                      label: Text('Todo title'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Title cannot be empty';
                      }
                      return null;
                    },
                    onSaved: (newValue) => _title = newValue!,
                  ),

                  // todo description
                  TextFormField(
                    maxLength: 40,
                    decoration: const InputDecoration(
                      label: Text('Todo description'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 5) {
                        return 'Description needs to be at least 5 characters long.';
                      }
                      return null;
                    },
                    onSaved: (newValue) => _description = newValue!,
                  ),

                  // priority
                  DropdownButtonFormField(
                    value: _selectedPriority,
                    decoration: const InputDecoration(
                      label: Text('Priority'),
                    ),
                    onChanged: (value) {
                      _selectedPriority = value!;
                    },
                    items: Priority.values
                        .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e.title)))
                        .toList(),
                  ),

                  // submit button
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () {
                      if (_formGlobalKey.currentState!.validate()) {
                        _formGlobalKey.currentState!.save();
                        setState(() {
                          todos.add(Todo(
                              title: _title,
                              description: _description,
                              priority: _selectedPriority));
                          _formGlobalKey.currentState!.reset();
                        });
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text('Add'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
