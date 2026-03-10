import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/widgets.dart';

class SelectDropDon<T> extends StatefulWidget {
  final String name;
  final String label;
  final bool required;
  final bool clearListOnFocus;
  final dynamic value;
  final IconData? icon;
  final Color? color;
  final bool isFill;
  final String? hintText;
  final Future<List<T>?> Function() onTap;
  final Function(dynamic)? onSelected;
  final Function()? onClear;
  final bool enabled;
  final bool isSearch;
  final GlobalKey<FormBuilderState>? keyForm;
  final DropdownMenuEntry<dynamic> Function(T item) cardInfo;

  const SelectDropDon({
    super.key,
    required this.name,
    required this.label,
    this.keyForm,
    this.icon,
    this.onSelected,
    this.onClear,
    required this.onTap,
    this.value,
    this.isSearch = false,
    required this.cardInfo,
    this.hintText,
    this.required = false,
    this.color,
    this.isFill = true,
    this.enabled = true,
    this.clearListOnFocus = false,
  });

  @override
  State<SelectDropDon> createState() => _SelectDropDonState<T>();
}

class _SelectDropDonState<T> extends State<SelectDropDon<T>> {
  TextEditingController controlText2 = TextEditingController();
  bool showLoader = false;
  List<DropdownMenuEntry<dynamic>> item = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    handelData();
  }

  handelData() async {
    if (widget.value != null) {
      setState(() {
        showLoader = true;
      });

      // Fetch data and map it to DropdownMenuEntry
      var fetchedItems = await widget.onTap();
      if (fetchedItems != null) {
        setState(() {
          item = fetchedItems.map<DropdownMenuEntry<dynamic>>((T itemData) {
            // Here, we pass itemData to cardInfo without casting, as T can be dynamic
            return widget.cardInfo(itemData);
          }).toList();
        });
      }

      var matchingItems = item.where((e) => e.value == widget.value);
      if (matchingItems.isNotEmpty) {
        controlText2.text = matchingItems.first.label;
      }

      setState(() {
        showLoader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Focus(
            onFocusChange: (hasFocus) async {
              if (widget.clearListOnFocus) {
                item.clear();
              }
              if (hasFocus && item.isEmpty) {
                setState(() {
                  showLoader = true;
                });

                // Fetch data and map it to DropdownMenuEntry
                var fetchedItems = await widget.onTap();
                if (fetchedItems != null) {
                  setState(() {
                    item = fetchedItems.map<DropdownMenuEntry<dynamic>>((
                      T itemData,
                    ) {
                      // Here, we pass itemData to cardInfo without casting, as T can be dynamic
                      return widget.cardInfo(itemData);
                    }).toList();
                  });
                }

                setState(() {
                  showLoader = false;
                });
              }
            },
            child: FormBuilderField(
              enabled: widget.enabled,
              name: widget.name,
              initialValue: widget.value,
              validator: FormBuilderValidators.compose([
                if (widget.required)
                  FormBuilderValidators.required(errorText: 'هذ الحقل مطلوب'),
              ]),

              builder: (FormFieldState<dynamic> field) {
                return DropdownMenu(
                  helperText: field.errorText,
                  label: _buildLabel(),
                  controller: controlText2,
                  leadingIcon: field.value == null
                      ? null
                      : IconButton(
                          onPressed: () {
                            field.reset();
                            widget.keyForm?.currentState?.reset();
                            controlText2.clear();
                            if (widget.onClear != null) {
                              widget.onClear!();
                            }
                          },
                          icon: Icon(Icons.close),
                        ),
                  selectedTrailingIcon: Icon(
                    Icons.arrow_drop_down_circle_outlined,
                  ),
                  requestFocusOnTap: widget.isSearch,
                  closeBehavior: DropdownMenuCloseBehavior.all,
                  enableFilter: widget.isSearch,
                  enableSearch: false,

                  onSelected: (value) {
                    field.didChange(value);
                    if (widget.onSelected != null) {
                      widget.onSelected!(value);
                    }
                  },

                  inputDecorationTheme: _inputDecorationTheme(),
                  hintText: widget.hintText ?? '',
                  menuStyle: _menuStyle(),
                  menuHeight: 300,
                  width: constraints.maxWidth,
                  enabled: widget.enabled,
                  initialSelection: widget.value,
                  alignmentOffset: Offset(0, 5),
                  dropdownMenuEntries: _buildDropdownMenuEntries(),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // Label style
  Widget _buildLabel() {
    return Text(
      widget.label,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.grey[600],
      ),
    );
  }

  // Input decoration theme
  InputDecorationTheme _inputDecorationTheme() {
    return InputDecorationTheme(
      filled: widget.isFill,
      fillColor: widget.color,
      helperStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.red,
      ),
      hintStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.grey[600],
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Color.fromARGB(255, 174, 174, 174)),
      ),
    );
  }

  // Menu style
  MenuStyle _menuStyle() {
    return MenuStyle(
      side: WidgetStateProperty.all(
        BorderSide(color: Colors.grey.withOpacity(0.5)),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

  // Dropdown entries (including loader)
  List<DropdownMenuEntry<dynamic>> _buildDropdownMenuEntries() {
    List<DropdownMenuEntry<dynamic>> entries = [];

    // Add loader entry if necessary
    if (showLoader) {
      entries.add(
        DropdownMenuEntry(
          value: 'loading',
          label: ' ',
          labelWidget: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
          ),
          style: ButtonStyle(),
        ),
      );
    }

    // Add the data items to the dropdown
    entries.addAll(item);
    return entries;
  }
}
