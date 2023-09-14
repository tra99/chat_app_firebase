
import 'package:chat_app_new_version/chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constant.dart';
import '../providers/models_provider.dart';

class ModelsDropdownWidget extends StatefulWidget {
  const ModelsDropdownWidget({super.key});

  @override
  State<ModelsDropdownWidget> createState() => _ModelsDropdownWidgetState();
}

class _ModelsDropdownWidgetState extends State<ModelsDropdownWidget> {
  String? currentModel;
  @override
  Widget build(BuildContext context) {
    final modelsProvider=Provider.of<ModelsProvider>(context,listen: false);
    currentModel=modelsProvider.getCurrentModel;
    return FutureBuilder(
      future: modelsProvider.getAllModels(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: TextWidget(label: snapshot.error.toString()),
          );
        }
        return snapshot.data == null || snapshot.data!.isEmpty
            ? const SizedBox.shrink()
            : FittedBox(
              child: DropdownButton(
                  dropdownColor: scaffoldBackgroundColor,
                  iconEnabledColor: Colors.white,
                  items: List<DropdownMenuItem<String>>.generate(
                      snapshot.data!.length,
                      (index) => DropdownMenuItem(
                        value: snapshot.data![index].id,
                              child: TextWidget(
                                fontSize: 16,
                            label: snapshot.data![index].id,
                          ))),
                  value: currentModel,
                  onChanged: (value) {
                    setState(() {
                      currentModel = value.toString();
                    });
                    modelsProvider.setCurrentModel(value.toString());
                  },
                ),
            );
      },
    );
  }
}
