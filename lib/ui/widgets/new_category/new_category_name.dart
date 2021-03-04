import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../../../globals/globals.dart';
import '../../ui.dart';

class CategoryName extends StatelessWidget {
  final Function onSubmitted;

  const CategoryName({
    Key key,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 0.0),
          child: CupertinoTextField(
            autofocus: true,
            textInputAction: TextInputAction.done,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            onSubmitted: onSubmitted,
            style: Theme.of(context).textTheme.headline4,
            decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(color: Colors.grey[300], offset: Offset(0.0, -2.0)),
                  BoxShadow(color: Colors.white, offset: Offset(0.0, 1.0)),
                ]),
            onChanged: (text) =>
                Provider.of<NewCategoryViewModel>(context, listen: false).name =
                    text,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          CATEGORY_NAME,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        Spacer(),
      ],
    );
  }
}
