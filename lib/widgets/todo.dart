import 'package:flutter/material.dart';
import 'package:unicode_todo_app/models/todo.dart';

class ToDoItemWidget extends StatefulWidget {
  final ToDoModel todo;
  final VoidCallback onToggleCompletion;

  const ToDoItemWidget({
    Key? key,
    required this.todo,
    required this.onToggleCompletion,
  }) : super(key: key);

  @override
  _ToDoItemWidgetState createState() => _ToDoItemWidgetState();
}

class _ToDoItemWidgetState extends State<ToDoItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      value: 0.5,
      duration: const Duration(milliseconds: 300),
    );

    if (!widget.todo.isCompleted) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            key: Key(widget.todo.title),
            opacity: Tween<double>(begin: 0.5, end: 1.0)
                .animate(_animationController),
            child: Material(
              elevation: 2.0, // Adds a slight shadow to give a card-like effect
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white, // Ensures visibility against any background
              child: ListTile(
                leading: Checkbox(
                  key: const Key("todo_checkbox"),
                  value: widget.todo.isCompleted,
                  onChanged: (value) {
                    setState(() {
                      widget.onToggleCompletion();
                      if (widget.todo.isCompleted) {
                        _animationController.forward();
                      } else {
                        _animationController.reverse();
                      }
                    });
                  },
                ),
                title: Text(
                  widget.todo.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    decoration: widget.todo.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
