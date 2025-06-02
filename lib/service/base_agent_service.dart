import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/services.dart';
import 'package:recruitment_agents/enums/models.dart';
import 'package:recruitment_agents/errors/exception.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:recruitment_agents/utils/logger.dart';

abstract class BaseAgentInterface {
  Future<GenerativeModel?> generateModel();
}

class BaseAgentService extends BaseAgentInterface {
  final String? modelName;
  final String? instructions;
  final String? markdownPath;
  final List<Tool>? tools;

  BaseAgentService({
    this.modelName,
    this.instructions,
    this.tools,
    this.markdownPath,
  });

  Future<String> _loadInstruction() async {
    return rootBundle.loadString(markdownPath!);
  }

  @override
  Future<GenerativeModel?> generateModel() async {
    try {
      // **Check if the user still has credits to perform orientations
      //* If not, throw and error here

      final newInst = await _loadInstruction();
      var vertexInstance = FirebaseAI.vertexAI();
      final modelInstance = vertexInstance.generativeModel(
        model: modelName ?? Models.gemini25pro.value,
        systemInstruction: Content.system(instructions ?? newInst),
        tools: tools,
        safetySettings: [
          SafetySetting(
            HarmCategory.harassment,
            HarmBlockThreshold.high,
            HarmBlockMethod.severity,
          ),
        ],
      );

      return modelInstance;
    } catch (e) {
      AppLogger.e(e);
      throw AppException(error: e);
    }
  }
}
