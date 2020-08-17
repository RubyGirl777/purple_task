import 'package:ant_icons/ant_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:to_do/ui/strings/strings.dart';
import 'package:to_do/models/new_category.dart';

class CategoryTasks extends StatelessWidget {
  final Function onFinishPressed;
  final Function onSubmitted;

  const CategoryTasks({
    Key key,
    @required this.onFinishPressed,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Strings s = Provider.of<Strings>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32.0, 24.0, 32.0, 0.0),
          child: Consumer<NewCategory>(
            builder: (_, value, __) => Text(
              value.name,
              style: TextStyle(fontSize: 24.0),
            ),
          ),
        ),
        SizedBox(height: 8.0),
        Padding(
          padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 0.0),
          child: TextField(
            decoration: InputDecoration(
              suffix: IconButton(
                color: Colors.blue,
                icon: Icon(
                  AntIcons.check_circle,
                ),
                onPressed: () {
                  onSubmitted();
                },
              ),
            ),
            autofocus: true,
            textInputAction: TextInputAction.done,
            onSubmitted: onSubmitted,
            style: TextStyle(fontSize: 18.0),
            onChanged: (text) =>
                Provider.of<NewCategory>(context, listen: false).taskName =
                    text,
          ),
        ),
        Text(
          s.task,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        Expanded(
          child: Consumer<NewCategory>(
            builder: (_, value, __) => ListView.builder(
              itemCount: value.tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 32.0),
                  title: Text(value.tasks[index].name),
                );
              },
            ),
          ),
        ),
        Row(
          children: [
            SizedBox(width: 16.0),
            FlatButton(
              color: Colors.grey[400],
              child: Text(s.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Spacer(),
            FlatButton(
              autofocus: true,
              color: Colors.green,
              child: Text(s.finish),
              onPressed: onFinishPressed,
            ),
            SizedBox(width: 16.0),
          ],
        )
      ],
    );
  }
}
