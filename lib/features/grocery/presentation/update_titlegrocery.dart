import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:attendance_practice/core/constants/color.dart';
import 'package:attendance_practice/core/enum/state_status.enum.dart';
import 'package:attendance_practice/core/global_widgets/snackbar.widget.dart';
import 'package:attendance_practice/core/utils/guard.dart';
import 'package:attendance_practice/features/grocery/domain/grocery_title.models/grocery_title.model.dart';
import 'package:attendance_practice/features/grocery/domain/grocery_title.models/update_title.model.dart';
import 'package:attendance_practice/features/grocery/domain/title_grocery_bloc/title_grocery_bloc.dart';

class UpdateGroceryTitlePage extends StatefulWidget {
  const UpdateGroceryTitlePage({super.key, required this.groceryTitleModel});
  final GroceryTitleModel groceryTitleModel;

  @override
  State<UpdateGroceryTitlePage> createState() => _UpdateGroceryTitlePageState();
}

class _UpdateGroceryTitlePageState extends State<UpdateGroceryTitlePage> {
  late TitleGroceryBloc _titleGroceryBloc;

  late TextEditingController _titleGrocery ;
    late TextEditingController _subjectCode ;

  late String _titleIDController;
  late String _updatedAt;

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _titleGroceryBloc = BlocProvider.of<TitleGroceryBloc>(context);
        _subjectCode = TextEditingController(text: widget.groceryTitleModel.subjectCode);

      _titleGrocery = TextEditingController(text: widget.groceryTitleModel.title);
    _titleIDController = widget.groceryTitleModel.id;
    _updatedAt = widget.groceryTitleModel.createdAt!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TitleGroceryBloc, TitleGroceryState>(
      bloc: _titleGroceryBloc,
      listener: _updateListener,
      builder: (context, state) {
        if (state.stateStatus == StateStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            titleSpacing: 00.0,
            centerTitle: true,
            toolbarHeight: 60.2,
            toolbarOpacity: 0.8,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25)),
            ),
            elevation: 0.00,
            titleTextStyle: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
            leading: const SizedBox(
                height: 10,
                width: 10,
                child: Icon(Icons.edit_calendar_outlined)),
            title: const Text('Update Subject'),
          ),
          body: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      right: 15, top: 90, left: 15, bottom: 10),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (val) {
                      return Guard.againstEmptyString(val, 'Subject');
                    },
                    controller: _titleGrocery,
                    autofocus: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal()),
                        labelText: 'Subject name'),
                  ),
                ),
                 Padding(
                  padding: const EdgeInsets.only(
                      right: 15, top: 10, left: 15, bottom: 10),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (val) {
                      return Guard.againstEmptyString(val, 'Subject Code');
                    },
                    controller: _subjectCode,
                    autofocus: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal()),
                        labelText: 'Subject Code'),
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 16),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: textColor,
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _updateTitleGorcery(context);
                              }
                            },
                            child: const Text('Update')),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 16),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: textColor,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel')),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _updateListener(BuildContext context, TitleGroceryState state) {
    if (state.stateStatus == StateStatus.error) {
      SnackBarUtils.defualtSnackBar(state.errorMessage, context);
      return;
    }

    if (state.isUpdated) {
      Navigator.pop(context);
      SnackBarUtils.defualtSnackBar(' Successfully updated!', context);
      return;
    }
  }

//update is working but when Navigator.pop(context) is compiled
//it gets an error, *Unexpected Null value*
//without telling what file is getting null value
  void _updateTitleGorcery(BuildContext context) {
    _titleGroceryBloc.add(
      UpdateTitleGroceryEvent(
        updateTitleGroceryModel: UpdateTitleGroceryModel(
            id: _titleIDController,
            title: _titleGrocery.text,
            updatedAt: _updatedAt, 
            subjectCode:_subjectCode.text),
      ),
    );
  }
}
