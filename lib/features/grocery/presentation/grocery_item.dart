import 'package:attendance_practice/core/components/background_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:attendance_practice/core/constants/color.dart';
import 'package:attendance_practice/core/enum/state_status.enum.dart';
import 'package:attendance_practice/core/global_widgets/snackbar.widget.dart';
import 'package:attendance_practice/core/utils/guard.dart';
import 'package:attendance_practice/features/grocery/domain/grocery_bloc/grocery_bloc.dart';
import 'package:attendance_practice/features/grocery/domain/grocery_title.models/grocery_title.model.dart';
import 'package:attendance_practice/features/grocery/domain/models/add_grocery.model.dart';
import 'package:attendance_practice/features/grocery/domain/models/delete_grocery.model.dart';
import 'package:attendance_practice/features/grocery/domain/title_grocery_bloc/title_grocery_bloc.dart';
import 'package:attendance_practice/features/grocery/presentation/update_itemgrocery.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.groceryTitleModel});
  final GroceryTitleModel groceryTitleModel;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late GroceryItemBloc _groceryBloc;

  late TitleGroceryBloc _titleGroceryBloc;

  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();

  final TextEditingController _yrLvl = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _course = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  late String groceryId;
  late String title;

  @override
  void initState() {
    super.initState();
    //get ID from groceryTitleModel
    groceryId = widget.groceryTitleModel.id;

    _titleGroceryBloc = BlocProvider.of<TitleGroceryBloc>(context);
    _titleGroceryBloc.add(GetTitleGroceryEvent(userId: groceryId));

    //kani gi gamit para sa title kay di makita ang value sa id ingani-on kani pasabot sa ubos
    title = widget.groceryTitleModel.title;

    _groceryBloc = BlocProvider.of<GroceryItemBloc>(context);
    _groceryBloc.add(GetGroceryEvent(titleID: groceryId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TitleGroceryBloc, TitleGroceryState>(
      bloc: _titleGroceryBloc,
      listener: _titleGroceryListener,
      builder: (context, state) {
        //kani pasabot sa babaw
        // final title =
        //     state.titleGroceryList.where((e) => e.id == groceryId).first.title;
        if (state.stateStatus == StateStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.isUpdated) {
          Navigator.pop(context);
          SnackBarUtils.defualtSnackBar(
              'Student successfully updated!', context);
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
            title: Text('$title Students'),
          ),
          body: BackgroundHome(
            child: BlocConsumer<GroceryItemBloc, GroceryItemState>(
              listener: _groceryListener,
              builder: (context, groceryState) {
                if (groceryState.stateStatus == StateStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (groceryState.isEmpty) {
                  return SizedBox(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Image.asset(
                          "assets/images/emptyOrange.png",
                        ),
                      ),
                    ),
                  );
                }
                if (groceryState.isDeleted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Student deleted'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
                  itemCount: groceryState.groceryList.length,
                  itemBuilder: (context, index) {
                    final groceryList = groceryState.groceryList[index];
                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) {
                        return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirm Delete'),
                              content: Text(
                                  'Are you sure you want to delete ${groceryList.lastName}?'),
                              actions: <Widget>[
                                ElevatedButton(
                                    onPressed: () {
                                      _deleteItem(context, groceryList.id);
                                    },
                                    child: const Text('Delete')),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'))
                              ],
                            );
                          },
                        );
                      },
                      background: Container(
                        color: Colors.red,
                        child: const Padding(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [Icon(Icons.delete), Text('Delete')],
                          ),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: _groceryBloc,
                                child: UpdateGroceryItemPage(
                                  groceryItemModel: groceryList,
                                ),
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Card(
                            child: ListTile(
                              title: Text(
                                '${groceryList.firstName} ${groceryList.lastName}',
                                style: const TextStyle(fontSize: 17),
                              ),
                              subtitle: Text(
                                groceryList.year_level,
                                style: const TextStyle(fontSize: 15),
                              ),
                              // trailing: Text(
                              //   '₱ ${groceryList.price}',
                              //   style: const TextStyle(fontSize: 15),
                              // ),
                              // trailing: Checkbox(
                              //     value: groceryList.isChecked,
                              //     onChanged: (bool? newIsChecked) {
                              //       _checkListener(
                              //           context, item.id, newIsChecked ?? false);
                              //     }),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: primaryColor,
            onPressed: () {
              _displayAddDialog(context);
            },
            child: const Icon(Icons.add, color: Colors.white,),
          ),
        );
      },
    );
  }

  void _groceryListener(
      BuildContext context, GroceryItemState titleGroceryState) {
    if (titleGroceryState.stateStatus == StateStatus.error) {
      const Center(child: CircularProgressIndicator());
      SnackBarUtils.defualtSnackBar(titleGroceryState.errorMessage, context);
    }
  }

  void _titleGroceryListener(
      BuildContext context, TitleGroceryState titleGroceryState) {
    if (titleGroceryState.stateStatus == StateStatus.error) {
      const Center(child: CircularProgressIndicator());
      SnackBarUtils.defualtSnackBar(titleGroceryState.errorMessage, context);
    }
  }

  Future _displayAddDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: AlertDialog(
            scrollable: true,
            title: const Text('Add Attendance'),
            content: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (val) {
                      return Guard.againstEmptyString(val, 'First Name');
                    },
                    controller: _firstName,
                    autofocus: true,
                    decoration: const InputDecoration(
                      
                        labelText: 'First Name'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (val) {
                      return Guard.againstEmptyString(val, 'Last Name');
                    },
                    controller: _lastName,
                    autofocus: true,
                    decoration: const InputDecoration(
                        
                        labelText: 'Last Name'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (val) {
                      return Guard.againstEmptyString(val, 'Course');
                    },
                    controller: _course,
                    autofocus: true,
                    decoration: const InputDecoration(
                       
                        labelText: 'Course'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (val) {
                      return Guard.againstEmptyString(val, 'Year Level');
                    },
                    controller: _yrLvl,
                    autofocus: true,
                    decoration: const InputDecoration(
                       
                        labelText: 'Year Level'),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: textColor,
                ),
                child: const Text('ADD'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addGroceries(context);
                    Navigator.of(context).pop();
                    _firstName.clear();
                    _lastName.clear();
                    _gender.clear();
                    _yrLvl.clear();
                    _course.clear();
                  }
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: textColor,
                ),
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      },
    );
  }

  void _addGroceries(BuildContext context) {
    _groceryBloc.add(AddGroceryEvent(
        addGroceryModel: AddGroceryModel(
            firstName: _firstName.text,
            lastName: _lastName.text,
            gender: _gender.text,
            course: _course.text,
            year_level: _yrLvl.text)));
  }

  void _deleteItem(BuildContext context, String id) {
    _groceryBloc.add(
        DeleteGroceryEvent(deleteGroceryModel: DeleteGroceryModel(id: id)));
    Navigator.of(context).pop();
  }
}
