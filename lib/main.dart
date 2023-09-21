import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:register/src/database/database.dart';
import 'package:register/src/models/member.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Register(),
    ),
  );
}

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(context) {
    return _RegisterWidget();
  }
}

class _RegisterWidget extends StatefulWidget {
  @override
  State createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<_RegisterWidget> {
  late TextEditingController _nameController,
      _idNumberController,
      _telephoneNumberController;

  late Future<List<Map<String, dynamic>>> data;

  bool register = false, isRegistering = false;
  late Timer? timer;

  int deleted = 0;

  bool implyDelete = false;

  List<Member> selection = [];

  List<Member> members = [];

  @override
  void initState() {
    _nameController = TextEditingController();
    _idNumberController = TextEditingController();
    _telephoneNumberController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  bool anySelected(Member member) {
    return selection.any(
      (Member m) => m.idNumber == member.idNumber,
    );
  }

  void _deleteSelected() async {
    if (selection.isEmpty) return;

    Widget builder(context) => Dialog(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              height: 200,
              width: 300,
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('delete the selected members?'.toUpperCase()),
                  Text('This action cannot be undone!'.toUpperCase()),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(border: Border.all()),
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('cancel'.toUpperCase()),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(border: Border.all()),
                        child: TextButton(
                          onPressed: () async {
                            int count = 0;
                            for (Member member in selection) {
                              int delete = await RegisterDatabase()
                                  .batchDeleteByIdNumber(member.idNumber);
                              setState(() {
                                count += delete;
                              });
                            }

                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor:
                                    const Color.fromARGB(255, 86, 43, 94),
                                width: 300,
                                behavior: SnackBarBehavior.floating,
                                content: Center(
                                  child: Text(
                                    'deleted $count members'.toUpperCase(),
                                  ),
                                ),
                              ),
                            );

                            selection.clear();
                          },
                          child: const Text('OK'),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );

    showDialog(context: context, builder: builder);
  }

  @override
  Widget build(BuildContext context) {
    if (DateTime.now().isAfter(
      DateTime(2023, 10, 15),
    )) {
      return const Scaffold(
        body: Center(
          child: Text('UNAUTHORIZED ACCESS!\n KEY REQUIRES RENEWAL'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        flexibleSpace: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            child: selection.isEmpty
                ? null
                : Text(
                    'selected: ${selection.length}',
                    style: const TextStyle(color: Colors.black),
                  ),
          ),
        ),
        actions: [
          ScaffoldMessenger(
            child: SizedBox(
              child: selection.isEmpty
                  ? null
                  : IconButton.outlined(
                      onPressed: _deleteSelected,
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.black,
                      ),
                    ),
            ),
          ),
          IconButton(
            onPressed: () {
              Widget builder(ctx) {
                return Dialog(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    color: Colors.white,
                    height: 250,
                    width: 200,
                    child: const Column(
                      children: [
                        Flexible(
                          child: Text(
                            'Created by George Muigai Njau at'
                            ' BKICT as a fun project',
                            style: TextStyle(
                              height: 1.8,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(top: 18.0),
                            child: Text('Copyright 2023'),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(top: 18.0),
                            child: CloseButton(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              showDialog(context: context, builder: builder);
            },
            icon: const Icon(
              Icons.thunderstorm,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, BoxConstraints boxConstraints) {
          return Padding(
            padding: EdgeInsets.only(
              top: (boxConstraints.maxWidth / 10),
              left: (boxConstraints.maxWidth / 30),
              right: (boxConstraints.maxWidth / 30),
              bottom: (boxConstraints.maxWidth / 20),
            ),
            child: SizedBox(
              width: boxConstraints.maxWidth,
              height: boxConstraints.maxHeight,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: register
                                ? Border.all(style: BorderStyle.solid)
                                : null,
                          ),
                          child: register
                              ? Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    TextField(
                                      controller: _nameController,
                                      keyboardType: TextInputType.name,
                                      decoration: const InputDecoration(
                                        hintText: 'enter member name',
                                      ),
                                    ),
                                    TextField(
                                      controller: _idNumberController,
                                      keyboardType: TextInputType.number,
                                      maxLength: 8,
                                      decoration: const InputDecoration(
                                        hintText: 'enter ID number',
                                      ),
                                    ),
                                    TextField(
                                      controller: _telephoneNumberController,
                                      keyboardType: TextInputType.phone,
                                      maxLength: 10,
                                      decoration: const InputDecoration(
                                        hintText: 'Enter telephone number',
                                      ),
                                    ),
                                    Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          IconButton(
                                            onPressed: () async {
                                              var existingMembers =
                                                  await RegisterDatabase()
                                                      .getAllMembers();
                                              for (var json
                                                  in existingMembers) {
                                                for (var i = 0;
                                                    i < existingMembers.length;
                                                    i++) {
                                                  if (Member.fromJson(json)
                                                          .idNumber ==
                                                      Member.fromJson(
                                                              existingMembers[
                                                                  i])
                                                          .idNumber) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        backgroundColor:
                                                            Color.fromARGB(255,
                                                                128, 84, 134),
                                                        width: 200,
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        content: Center(
                                                          child: Text(
                                                              'member with the given ID number already exist, try a diffrent one'),
                                                        ),
                                                      ),
                                                    );
                                                    return;
                                                  }
                                                }
                                              }

                                              if (_nameController
                                                      .text.isEmpty ||
                                                  _idNumberController
                                                      .text.isEmpty ||
                                                  _telephoneNumberController
                                                      .text.isEmpty) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 128, 84, 134),
                                                    width: 200,
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    content: Center(
                                                      child: Text(
                                                        'please enter all details to proceed',
                                                      ),
                                                    ),
                                                  ),
                                                );

                                                return;
                                              }
                                              int saved =
                                                  await RegisterDatabase()
                                                      .addUser(
                                                Member(
                                                  name: _nameController.text
                                                      .trim(),
                                                  idNumber: _idNumberController
                                                      .text
                                                      .trim(),
                                                  telephoneNumber:
                                                      _telephoneNumberController
                                                          .text
                                                          .trim(),
                                                ),
                                              );

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 128, 84, 134),
                                                  width: 200,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  content: Center(
                                                    child: Text(
                                                      saved > 0
                                                          ? 'saved'
                                                          : 'error saving user',
                                                    ),
                                                  ),
                                                ),
                                              );

                                              setState(() {
                                                register = false;
                                                _nameController.clear();
                                                _idNumberController.clear();
                                                _telephoneNumberController
                                                    .clear();
                                              });
                                            },
                                            icon: const Icon(Icons.save_alt),
                                          ),
                                          IconButton(
                                            onPressed: () => setState(() {
                                              register = false;
                                            }),
                                            icon: const Icon(Icons.close),
                                          ),
                                        ])
                                  ]
                                      .map(
                                        (child) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: child),
                                      )
                                      .toList(),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextButton(
                                        child: Text(
                                          'register a new member'.toUpperCase(),
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 72, 82, 102),
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(
                                            () {
                                              register = register != true
                                                  ? true
                                                  : register;
                                            },
                                          );

                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        SizedBox(
                          child: selection.isEmpty
                              ? null
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        child: isRegistering
                                            ? const CircularProgressIndicator()
                                            : TextButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    isRegistering = true;
                                                  });

                                                  var list =
                                                      await DateRegisterDatabase()
                                                          .getAllMembers();

                                                  for (var json in list) {
                                                    var mmbrFromDb =
                                                        Member.fromJson(json);
                                                    for (var member
                                                        in selection) {
                                                      if (mmbrFromDb.idNumber ==
                                                          member.idNumber) {
                                                        selection.removeWhere(
                                                            (m) =>
                                                                m.idNumber ==
                                                                mmbrFromDb
                                                                    .idNumber);
                                                      }
                                                    }
                                                  }

                                                  int markedPresent = 0;

                                                  for (Member member
                                                      in selection) {
                                                    await DateRegisterDatabase()
                                                        .dbFallBackHandle();

                                                    int present =
                                                        await DateRegisterDatabase()
                                                            .addUser(
                                                      member: member,
                                                      registrationDate:
                                                          DateFormat(DateFormat
                                                                  .YEAR_ABBR_MONTH_WEEKDAY_DAY)
                                                              .format(
                                                        DateTime.now(),
                                                      ),
                                                    );
                                                    markedPresent += present;
                                                  }

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      width: 300,
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      content: Text(
                                                        'marked $markedPresent members present',
                                                      ),
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255, 86, 43, 94),
                                                    ),
                                                  );

                                                  selection.clear();

                                                  setState(() {
                                                    isRegistering = false;
                                                  });
                                                },
                                                child: const Text(
                                                  'MARK SELECTED MEMBERS PRESENT TODAY',
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 72, 82, 102),
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        const Flexible(
                          child: Text(
                            'MEMBERS PRESENT TODAY',
                            style: TextStyle(fontSize: 32),
                          ),
                        ),
                        Flexible(
                          child: FutureBuilder(
                            future: DateRegisterDatabase().getAllMembers(),
                            builder: (context, snapshot) {
                              return snapshot.connectionState ==
                                          ConnectionState.done &&
                                      snapshot.hasData
                                  ? SizedBox(
                                      height: 400,
                                      child: ListView(
                                        children: snapshot.data!.map((json) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              " ${json['name']}, id: ${json['idNumber']}",
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    )
                                  : const Text('no members found');
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  const Flexible(
                    child: VerticalDivider(color: Colors.black),
                  ),
                  Flexible(
                    flex: 3,
                    child: FutureBuilder(
                      future: RegisterDatabase().getAllMembers(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          debugPrint(snapshot.data.toString());
                          return ListView(
                            padding: const EdgeInsets.only(left: 100.0),
                            children:
                                snapshot.data!.map((Map<String, dynamic> json) {
                              Member member = Member.fromJson(json);

                              return SizedBox(
                                height: 60,
                                child: Column(
                                  children: [
                                    ScaffoldMessenger(
                                      child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Checkbox(
                                              value: anySelected(member),
                                              onChanged: (value) {
                                                if (selection.any((Member m) =>
                                                    m.idNumber ==
                                                    member.idNumber)) {
                                                  setState(() {
                                                    selection.removeWhere(
                                                      (Member member) =>
                                                          member.idNumber ==
                                                          Member.fromJson(json)
                                                              .idNumber,
                                                    );

                                                    value =
                                                        member.selected = false;
                                                  });
                                                } else {
                                                  setState(() {
                                                    selection.add(
                                                      Member.fromJson(json),
                                                    );

                                                    value =
                                                        member.selected = true;
                                                  });
                                                }
                                              },
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                  Member.fromJson(json).name),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(Member.fromJson(json)
                                                  .idNumber),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(Member.fromJson(json)
                                                  .telephoneNumber),
                                            ),
                                            IconButton(
                                              onPressed: () async {
                                                var date = await showDatePicker(
                                                  context: context,
                                                  onDatePickerModeChange:
                                                      (value) {
                                                    debugPrint(
                                                        value.toString());
                                                  },
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(
                                                    2022,
                                                    1,
                                                  ),
                                                  lastDate: DateTime.now(),
                                                );
                                                if (date == null) return;

                                                var resultsForDate =
                                                    DateRegisterDatabase()
                                                        .getWithDate(
                                                  registrationDate: DateFormat(
                                                          DateFormat
                                                              .YEAR_ABBR_MONTH_WEEKDAY_DAY)
                                                      .format(date)
                                                      .toString(),
                                                );

                                                bool found =
                                                    (await resultsForDate).any(
                                                        (Map json) =>
                                                            json['idNumber'] ==
                                                            member.idNumber);

                                                SnackBar snackBar = SnackBar(
                                                  width: 500,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  content: Text(
                                                    found
                                                        ? 'member was present on ${DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY).format(date)}'
                                                        : 'member was not present',
                                                  ),
                                                );

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              },
                                              icon: Transform.rotate(
                                                angle: -55,
                                                child: const Icon(Icons
                                                    .arrow_forward_ios_sharp),
                                              ),
                                            ),
                                          ]),
                                    ),
                                    const Flexible(
                                      child: Divider(
                                        color:
                                            Color.fromARGB(255, 202, 122, 255),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        }
                        return const Text('no members found');
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
