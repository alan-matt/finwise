import 'package:finwise/widget/field_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

dropDownButton(
  BuildContext context, {
  required List<String> dropDownList,
  String? labelText,
  required TextEditingController selectedValue,
  bool enableBorder = false,
  String? hintText,
  required String? Function(String?)? validator,
}) {
  return TextFieldComponent(
    textStyle: TextStyle(color: Colors.white),
    controller: selectedValue,
    readOnly: true,
    validator: validator,
    onTap: () {
      showDialog(
        context: context,
        builder:
            (context) => Dialog(
              child: dropDownDialog(
                context,
                dropDownList: dropDownList,
                onSelect: (p0) {
                  selectedValue.text = p0 ?? '';
                },
                hintText: hintText,
                enableBorder: enableBorder,
              ),
            ),
      );
    },
    hintText: hintText,
  );
}

Widget dropDownDialog(
  BuildContext context, {
  required List<String> dropDownList,
  String? labelText,
  required Function(String?) onSelect,
  bool enableBorder = false,
  String? hintText,
}) {
  final searchController = TextEditingController();
  final filteredList = ValueNotifier<List<String>>(dropDownList);

  return Container(
    height: 300.0,
    padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 17),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: Colors.amber,
    ),
    child: ValueListenableBuilder<List<String>>(
      valueListenable: filteredList,
      builder: (context, items, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: TextStyle(color: Colors.white),
              controller: searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Search here",
                prefixIcon: const Icon(CupertinoIcons.search, size: 16),
                helperStyle: TextStyle(fontSize: 10),
                border: Theme.of(context).inputDecorationTheme.border,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 30,
                  maxWidth: 40,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
              ),
              onChanged: (query) {
                filteredList.value =
                    dropDownList
                        .where(
                          (item) =>
                              item.toLowerCase().contains(query.toLowerCase()),
                        )
                        .toList();
              },
            ),
            SizedBox(height: 13),
            Flexible(
              child: ListView.separated(
                separatorBuilder:
                    (context, index) => const SizedBox(height: 10),
                itemCount: filteredList.value.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      onSelect(filteredList.value[index]);
                      Navigator.pop(context);
                    },
                    child: Text(
                      filteredList.value[index],
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    ),
  );
}
