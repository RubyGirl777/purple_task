import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../helpers.dart';
import '../../../globals/globals.dart';
import '../../../db_models/db_models.dart';
import '../../ui.dart';

enum TaskState {
  Normal,
  EditName,
  Expanded,
}

class TaskItem extends StatefulWidget {
  final Task task;

  const TaskItem({
    Key key,
    this.task,
  }) : super(key: key);

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  TaskState _taskState = TaskState.Normal;
  final _textController = TextEditingController();
  bool _hasText = false;

  setTaskNormal() {
    setState(() {
      _taskState = TaskState.Normal;
    });
  }

  setTaskExpanded() {
    setState(() {
      _taskState = TaskState.Expanded;
    });
  }

  setTaskEditName() {
    setState(() {
      _textController.text = widget.task.name;
      _taskState = TaskState.EditName;
    });
  }

  _updateTextField() {
    setState(() {
      _hasText = _textController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    _textController.addListener(_updateTextField);
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _settings = Provider.of<SettingsViewModel>(context, listen: false);
    final _taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
    bool _displayDoneTaskTime = _settings.getDisplayTaskDOneTimePref();
    String _timeFormat = _settings.getTimeFormat();
    String _dateFormat = _settings.getDateFormat();
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: _taskState == TaskState.Normal
                ? Colors.transparent
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 4.0),
                  Checkbox(
                    activeColor: Colors.grey,
                    value: widget.task.isDone,
                    onChanged: (value) {
                      widget.task.isDone = value;
                      if (widget.task.isDone) {
                        widget.task.doneTime = _taskViewModel.setTaskDoneTime();
                      }
                      _taskViewModel.updateTask(widget.task.key, widget.task);
                    },
                  ),
                  const SizedBox(width: 4.0),
                  Expanded(
                    child: _taskState == TaskState.EditName
                        ? CupertinoTextField(
                            controller: _textController,
                            autofocus: true,
                            style: Theme.of(context).textTheme.subtitle1,
                            onSubmitted: _hasText
                                ? (v) {
                                    widget.task.name = _textController.text;
                                    _taskViewModel.updateTask(
                                        widget.task.key, widget.task);
                                    setTaskNormal();
                                  }
                                : null,
                          )
                        : InkWell(
                            onTap: _taskState == TaskState.Normal ||
                                    _taskState == TaskState.Expanded
                                ? setTaskEditName
                                : null,
                            child: Text(
                              widget.task.name,
                              style: widget.task.isDone
                                  ? Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                      )
                                  : Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                  ),
                  const SizedBox(width: 8.0),
                  if (widget.task.dueDate != null)
                    Text(_taskViewModel.displayDueDate(
                        widget.task.dueDate, _dateFormat)),
                  if (_taskState == TaskState.Normal ||
                      _taskState == TaskState.EditName)
                    CustomIconButton(
                      icon: const Icon(
                        Icons.arrow_drop_down,
                      ),
                      color: Colors.transparent,
                      onPressed: setTaskExpanded,
                      tooltip: SHOW_OPTIONS,
                    ),
                  if (_taskState == TaskState.Expanded)
                    CustomIconButton(
                      icon: const Icon(
                        Icons.arrow_drop_up,
                      ),
                      color: Colors.transparent,
                      onPressed: setTaskNormal,
                      tooltip: HIDE_OPTIONS,
                    ),
                ],
              ),
              if (_displayDoneTaskTime &&
                  widget.task.isDone &&
                  widget.task.doneTime != null)
                Row(
                  children: [
                    SizedBox(width: 10.0),
                    Text(
                      '$COMPLETED: ${TimeConversion().millisToDateAndTime(
                        widget.task.doneTime,
                        dateFormat: _dateFormat,
                        timeFormat: _timeFormat,
                      )}',
                    ),
                  ],
                ),
              AnimatedContainer(
                height: _taskState == TaskState.Expanded ? 140 : 0,
                duration: Duration(milliseconds: 120),
                child: _taskState == TaskState.Expanded
                    ? TaskOptions(
                        task: widget.task,
                        onCategorySelected: () => setTaskNormal(),
                        onDateSelected: () => setTaskNormal(),
                        onDeletePressed: () {
                          _taskViewModel.deleteTask(widget.task.key);
                          setTaskNormal();
                        },
                      )
                    : null,
              ),
              AnimatedContainer(
                height: _taskState == TaskState.EditName ? 56 : 0,
                duration: Duration(milliseconds: 90),
                child: (_taskState == TaskState.EditName)
                    ? Row(
                        children: [
                          const SizedBox(width: 10),
                          SimpleButton(
                            onPressed: setTaskNormal,
                            text: CANCEL,
                          ),
                          Spacer(),
                          SimpleButton(
                            text: SAVE,
                            color: Colors.green,
                            onPressed: _hasText
                                ? () {
                                    widget.task.name = _textController.text;
                                    _taskViewModel.updateTask(
                                        widget.task.key, widget.task);
                                    setTaskNormal();
                                  }
                                : null,
                          ),
                          const SizedBox(width: 10),
                        ],
                      )
                    : null,
              ),
            ],
          ),
        ),
        Divider(height: 6.0),
      ],
    );
  }
}

class TaskOptions extends StatelessWidget {
  final Task task;
  final VoidCallback onDeletePressed;
  final VoidCallback onCategorySelected;
  final VoidCallback onDateSelected;

  const TaskOptions({
    Key key,
    @required this.task,
    @required this.onDeletePressed,
    @required this.onCategorySelected,
    @required this.onDateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Row(
              children: [
                const SizedBox(width: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(CATEGORY),
                    ),
                    CategorySelector(
                      task: task,
                      onCategorySelected: onCategorySelected,
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(DUE_DATE),
                    ),
                    DueDateSelector(
                      task: task,
                      onDateSelected: onDateSelected,
                    ),
                  ],
                ),
                const SizedBox(width: 6),
              ],
            ),
            const SizedBox(height: 16.0),
            SimpleButton(
              text: DELETE,
              color: Colors.red,
              onPressed: onDeletePressed,
            ),
          ],
        ),
      ),
    );
  }
}
