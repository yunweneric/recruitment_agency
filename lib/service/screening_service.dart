import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:recruitment_agents/service/base_agent_service.dart';
import 'package:recruitment_agents/utils/system_prompts.dart';

class ScreeningService extends BaseAgentService {
  static FunctionDeclaration get _matchUserToJob => FunctionDeclaration(
    'matchUserToJob',
    'Matches a user profile to a job description and returns match insights and scores.',
    parameters: {
      'candidateId': Schema.string(
        description: 'Unique identifier for the candidate/user',
      ),
      'jobId': Schema.string(
        description: 'Unique identifier for the job posting',
      ),
      "data": Schema.object(
        description: 'Match result and insights for a user against a job',
        properties: {
          'matchScore': Schema.number(
            description: 'Overall match score from 0 to 100',
          ),
          'matchedSkills': Schema.array(
            description: 'List of skills that matched the job requirements',
            items: Schema.string(),
          ),
          'missingSkills': Schema.array(
            description: 'List of required skills the candidate does not have',
            items: Schema.string(),
          ),
          'qualificationMatch': Schema.boolean(
            description:
                'Whether the candidate meets the required qualification',
          ),
          'experienceMatch': Schema.boolean(
            description: 'Whether the candidate meets the required experience',
          ),
          'languageMatch': Schema.boolean(
            description: 'Whether the candidate speaks the required languages',
          ),
          'locationMatch': Schema.boolean(
            description: 'Whether the candidate’s location aligns with the job',
          ),
          'roleFitComment': Schema.string(
            description:
                'A human-readable explanation of the candidate’s fitness for the role',
          ),
        },
      ),
    },
  );
  ScreeningService()
    : super(
        markdownPath: SystemPrompts.recommendationSystemPrompt,
        tools: [
          Tool.functionDeclarations([_matchUserToJob]),
        ],
      );

  screenUsers() async {
    String text = "Match this user with the correct profiles";
    final model = await generateModel();

    if (model == null) throw Error();
    final response = model.startChat();
    return response.sendMessageStream(Content.text(text));
  }
}
