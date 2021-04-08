import 'package:coolapp/models/todo.dart';
import 'package:coolapp/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:injector/injector.dart';
import 'package:supabase/supabase.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> todos = [];
  RealtimeSubscription todosSubscription;
  TextEditingController newTaskName;

  @override
  void initState() {
    super.initState();

    newTaskName = TextEditingController();
    setupTodosSubscription();

    Future.microtask(() async {
      final _todos = await getInitialTodos();
      setState(() {
        todos = _todos;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final todoWidgets = todos
        .map((todo) => ListTile(
              leading: Checkbox(
                  value: todo.isComplete,
                  onChanged: (isComplete) async {
                    await updateTodo(todo, isComplete);
                  }),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => deleteTodo(todo.id),
              ),
              title: Text(todo.task),
            ))
        .toList();
    final currentUser = Injector.appInstance.get<SupabaseClient>().auth.user();
    return Scaffold(
        appBar: AppBar(
          title: Text(currentUser.email),
          actions: [
            ElevatedButton(
                onPressed: () async {
                  await Injector.appInstance
                      .get<SupabaseClient>()
                      .auth
                      .signOut();

                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => SplashPage()),
                      (route) => false);
                },
                child: Text('Sign Out'))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 500,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: newTaskName,
                        onEditingComplete: addTask,
                        decoration: InputDecoration(
                            helperText: 'Enter task',
                            suffixIcon: IconButton(
                              icon: Icon(Icons.add),
                              onPressed: addTask,
                            )),
                      ),
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    ...todoWidgets
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Future deleteTodo(int todoId) async {
    await Injector.appInstance
        .get<SupabaseClient>()
        .from('todos')
        .delete()
        .eq('id', todoId)
        .execute();
  }

  Future updateTodo(Todo updatedTodo, bool isComplete) async {
    await Injector.appInstance
        .get<SupabaseClient>()
        .from('todos')
        .update({'is_complete': isComplete})
        .eq('id', updatedTodo.id)
        .execute();
    setState(() {
      updatedTodo.isComplete = isComplete;
    });
  }

  Future<List<Todo>> getInitialTodos() async {
    final response = await Injector.appInstance
        .get<SupabaseClient>()
        .from('todos')
        .select()
        .order('inserted_at', ascending: false)
        .execute();

    final dataList = response.data as List;
    return dataList.map((map) => Todo.fromJson(map)).toList();
  }

  void setupTodosSubscription() {
    todosSubscription = Injector.appInstance
        .get<SupabaseClient>()
        .from('todos')
        .on(SupabaseEventTypes.delete, (payload) {
      final deleteId = payload.oldRecord['id'];
      setState(() {
        todos = todos.where((t) => t.id != deleteId).toList();
      });
    }).on(SupabaseEventTypes.update, (payload) {
      final updatedTodo = Todo.fromJson(payload.newRecord);
      final todo =
          todos.firstWhere((t) => t.id == updatedTodo.id, orElse: () => null);
      if (todo == null) {
        setState(() {
          todos = [todo, ...todos];
        });
      } else {
        todo.isComplete = updatedTodo.isComplete;
      }
    }).on(SupabaseEventTypes.insert, (payload) {
      final todo = Todo.fromJson(payload.newRecord);
      setState(() {
        todos = [todo, ...todos];
      });
    }).subscribe();
  }

  Future addTask() async {
    final client = Injector.appInstance.get<SupabaseClient>();
    final currentUser = client.auth.user();

    final newTodo =
        Todo(task: newTaskName.text, userId: currentUser.id, isComplete: false);

    Injector.appInstance
        .get<SupabaseClient>()
        .from('todos')
        .insert(newTodo.toJson())
        .execute();
    setState(() {
      newTaskName.text = '';
    });
  }
}
