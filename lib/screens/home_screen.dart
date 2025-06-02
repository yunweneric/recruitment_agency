import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:recruitment_agents/enums/stage.dart';
import 'package:recruitment_agents/errors/exception.dart';
import 'package:recruitment_agents/service/extraction_service.dart';
import 'package:recruitment_agents/service/screening_service.dart';
import 'package:recruitment_agents/utils/app_button.dart';
import 'package:recruitment_agents/utils/colors.dart';
import 'package:recruitment_agents/utils/logger.dart';
import 'package:recruitment_agents/utils/sizing.dart';
import 'package:recruitment_agents/utils/util_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PlatformFile? file;
  bool loading = false;
  bool error = false;
  Stage stage = Stage.init;

  var data = {};

  void processResume() async {
    try {
      setState(() {
        loading = true;
        error = false;
      });
      AppLogger.i("Loading ...");

      ExtractionService es = ExtractionService();
      final streamRes = await es.extract(File(file!.path!));
      await for (final response in streamRes) {
        AppLogger.i(response.text);
        for (var function in response.functionCalls) {
          AppLogger.i(function.args);
          AppLogger.i(function.args);

          setState(() {
            data = function.args;
          });

          switch (function.name) {
            case "matchProfileFromDb":
              matchProfiles(function.args);
              break;
            default:
          }
        }
      }
      setState(() {
        stage = Stage.screening;
        loading = false;
        error = false;
      });
      AppLogger.i("Loaded ...");
    } catch (e) {
      final message = AppException.getMessage(e);
      AppLogger.e(message);
      setState(() {
        loading = false;
        error = true;
      });
    }
  }

  void matchProfiles(Map<String, dynamic> data) async {
    processResume();

    ScreeningService _screeningService = ScreeningService();

    final streamRes = await _screeningService.screenUsers();

    await for (final response in streamRes) {
      AppLogger.i(response.text);
      for (var function in response.functionCalls) {
        AppLogger.i(function.args);
        AppLogger.i(function.args);

        setState(() {
          data = function.args;
        });

        switch (function.name) {
          case "matchUserToJob":
            matchProfiles(function.args);
            break;
          default:
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: AppSizing.kMainPadding(context),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final files = await UtilHelper.pickFile();
                      AppLogger.i(files.length);
                      if (files.isNotEmpty) {
                        setState(() {
                          file = files.first;
                        });
                      }
                    },
                    child: Container(
                      width: AppSizing.width(context),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 40,
                        horizontal: 100,
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.file_present_rounded, size: 40),
                          AppSizing.kh10Spacer(),
                          Text("Pick file"),
                        ],
                      ),
                    ),
                  ),
                  if (file != null) ...[
                    AppSizing.kh10Spacer(),
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      tileColor: AppColors.BGGRAY2,
                      leading: Icon(Icons.file_copy),
                      title: Text(file!.name, style: TextStyle(fontSize: 12)),
                      subtitle: Text(
                        "${(file!.size / 1024).toStringAsFixed(2)}KB",
                      ),
                      trailing: InkWell(
                        onTap: () {
                          setState(() => file = null);
                        },
                        child: CircleAvatar(child: Icon(Icons.delete)),
                      ),
                    ),
                    AppSizing.kh20Spacer(),
                    AppButton(title: "Process", onPressed: processResume),
                    AppSizing.kh20Spacer(),

                    Divider(color: Colors.purple, thickness: 6),
                    Text("Data"),
                    Text(jsonEncode(data)),
                  ],
                ],
              ),
            ),
          ),

          if (loading)
            Container(
              height: AppSizing.height(context),
              width: AppSizing.width(context),
              color: Colors.black.withValues(alpha: 0.5),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
