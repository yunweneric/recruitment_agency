import 'dart:io';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:recruitment_agents/errors/exception.dart';
import 'package:recruitment_agents/extensions/file_extension.dart';
import 'package:recruitment_agents/service/base_agent_service.dart';
import 'package:recruitment_agents/utils/system_prompts.dart';
import 'package:recruitment_agents/utils/util_helper.dart';

class ExtractionService extends BaseAgentService {
  static FunctionDeclaration get _matchProfileFromDb => FunctionDeclaration(
    'matchProfileFromDb',
    'Save the candidate resume information to the database.',
    parameters: {
      'fullName': Schema.string(description: 'The full name of the candidate'),
      'email': Schema.string(description: 'The email address of the candidate'),
      'phoneNumber': Schema.string(
        description: 'The phone number of the candidate',
      ),
      'location': Schema.string(
        description: 'The current location of the candidate',
      ),
      'linkedIn': Schema.string(
        description: 'The LinkedIn profile URL of the candidate',
      ),
      'currentJobTitle': Schema.string(
        description: 'The current job title of the candidate',
      ),
      'yearsOfExperience': Schema.number(
        description: 'Total number of years of professional experience',
      ),
      'highestQualification': Schema.string(
        description: 'The highest educational qualification obtained',
      ),
      'skills': Schema.array(
        description: 'A list of professional skills the candidate possesses',
        items: Schema.string(),
      ),
      'languages': Schema.array(
        description: 'Languages spoken or written by the candidate',
        items: Schema.string(),
      ),
      'experience': Schema.array(
        description: 'Professional work experience details',
        items: Schema.object(
          properties: {
            'jobTitle': Schema.string(
              description: 'Job title held during this experience',
            ),
            'company': Schema.string(
              description: 'Company or organization name',
            ),
            'startDate': Schema.string(description: 'Start date of the job'),
            'endDate': Schema.string(description: 'End date of the job'),
            'duration': Schema.string(
              description: 'Total duration in this role',
            ),
            'description': Schema.string(
              description: 'Description of responsibilities and achievements',
            ),
          },
        ),
      ),
      'education': Schema.array(
        description: 'Educational background and academic history',
        items: Schema.object(
          properties: {
            'degree': Schema.string(
              description: 'Degree earned (e.g., BSc, MSc)',
            ),
            'institution': Schema.string(
              description: 'Name of the academic institution',
            ),
            'startYear': Schema.integer(description: 'Year studies began'),
            'endYear': Schema.integer(description: 'Year studies completed'),
            'fieldOfStudy': Schema.string(
              description: 'Field of study (e.g., Computer Science)',
            ),
          },
        ),
      ),
      'certifications': Schema.array(
        description: 'Certifications or licenses held by the candidate',
        items: Schema.object(
          properties: {
            'name': Schema.string(description: 'Name of the certification'),
            'issuer': Schema.string(
              description: 'Organization that issued the certification',
            ),
            'year': Schema.integer(
              description: 'Year the certification was earned',
            ),
          },
        ),
      ),
    },
  );
  ExtractionService()
    : super(
        markdownPath: SystemPrompts.extractionSystemPrompt,
        tools: [
          Tool.functionDeclarations([_matchProfileFromDb]),
        ],
      );

  Future<Stream<GenerateContentResponse>> extract(File file) async {
    try {
      final prompt = TextPart("Extract the information from this resume");

      final doc = await file.readAsBytes();
      final mimeType = UtilHelper.getMimeType(file.ext);
      final docPart = InlineDataPart(mimeType, doc);

      final model = await generateModel();
      if (model == null) throw AppException(error: {});

      final response = model.startChat();
      return response.sendMessageStream(Content.multi([prompt, docPart]));
    } catch (e) {
      throw AppException(error: e);
    }
  }

  Future<Stream<GenerateContentResponse>> followUpExtraction({
    File? file,
    required String? newPrompt,
    List<Content>? history,
  }) async {
    try {
      Content? content;
      const prompt = "Extract the information from this resume";
      final promptStr = newPrompt ?? prompt;

      if (file != null) {
        final doc = await file.readAsBytes();
        final mimeType = UtilHelper.getMimeType(file.ext);

        final docPart = InlineDataPart(mimeType, doc);
        content = Content.multi([TextPart(promptStr), docPart]);
      } else {
        content = Content.text(promptStr);
      }

      final model = await generateModel();
      if (model == null) throw AppException(error: {});

      final response = model.startChat(history: history);
      return response.sendMessageStream(content);
    } catch (e) {
      throw AppException(error: e);
    }
  }
}
