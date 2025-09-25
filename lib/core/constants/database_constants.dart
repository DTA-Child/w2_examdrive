class DatabaseConstants {
  // Database Info
  static const String databaseName = 'driving_test.db';
  static const int databaseVersion = 1;

  // Table Names
  static const String tableTopics = 'topics';
  static const String tableQuestions = 'questions';
  static const String tableTestResults = 'test_results';
  static const String tableAnswerDetails = 'answer_details';
  static const String tableUsers = 'users';

// User Table Columns
  static const String userId = 'id';
  static const String userUsername = 'username';
  static const String userPassword = 'password';
  static const String userFullname = 'fullname';
  static const String userEmail = 'email';
  static const String userPhone = 'phone';
  static const String userGender = 'gender';
  static const String userBirthday = 'birthday';
  static const String userStatus = 'status';
  static const String userCreatedAt = 'created_at';
  static const String userUpdatedAt = 'updated_at';

  // Topics Table Columns
  static const String topicId = 'id';
  static const String topicTitle = 'title';
  static const String topicDescription = 'description';
  static const String topicIconPath = 'icon_path';
  static const String topicQuestionCount = 'question_count';

  // Questions Table Columns
  static const String questionId = 'id';
  static const String questionTitle = 'title';
  static const String questionContent = 'content';
  static const String questionAudio = 'audio';
  static const String questionMediaType = 'media_type';
  static const String questionAnsA = 'ansa';
  static const String questionAnsB = 'ansb';
  static const String questionAnsC = 'ansc';
  static const String questionAnsD = 'ansd';
  static const String questionAnsRight = 'ansright';
  static const String questionAnsHint = 'anshint';
  static const String questionTopicId = 'topic_id';
  static const String questionMandatory = 'mandatory';
  static const String questionDifficulty = 'difficulty';

  // Test Results Table Columns
  static const String resultId = 'id';
  static const String resultStartTime = 'start_time';
  static const String resultEndTime = 'end_time';
  static const String resultTotalQuestions = 'total_questions';
  static const String resultCorrectAnswers = 'correct_answers';
  static const String resultScore = 'score';
  static const String resultIsPassed = 'is_passed';
  static const String resultTestType = 'test_type';

  // Answer Details Table Columns
  static const String detailId = 'id';
  static const String detailResultId = 'result_id';
  static const String detailQuestionId = 'question_id';
  static const String detailUserAnswer = 'user_answer';
  static const String detailIsCorrect = 'is_correct';
  static const String detailTimeSpent = 'time_spent';

  // SQL Queries
  static const String createTopicsTable = '''
    CREATE TABLE $tableTopics (
      $topicId INTEGER PRIMARY KEY,
      $topicTitle TEXT NOT NULL,
      $topicDescription TEXT,
      $topicIconPath TEXT,
      $topicQuestionCount INTEGER DEFAULT 0
    )
  ''';
  // Create Users Table Query
  static const String createUsersTable = '''
  CREATE TABLE $tableUsers (
    $userId INTEGER PRIMARY KEY AUTOINCREMENT,
    $userUsername TEXT NOT NULL UNIQUE,
    $userPassword TEXT NOT NULL,
    $userFullname TEXT,
    $userEmail TEXT UNIQUE,
    $userPhone TEXT,
    $userGender TEXT CHECK ($userGender IN ('M', 'F')),
    $userBirthday TEXT,
    $userStatus INTEGER DEFAULT 1 CHECK ($userStatus IN (0,1,2)),
    $userCreatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
    $userUpdatedAt TEXT DEFAULT CURRENT_TIMESTAMP
  )
''';

  static const String createQuestionsTable = '''
    CREATE TABLE $tableQuestions (
      $questionId INTEGER PRIMARY KEY,
      $questionTitle TEXT,
      $questionContent TEXT NOT NULL,
      $questionAudio TEXT,
      $questionMediaType TEXT DEFAULT 'none',
      $questionAnsA TEXT,
      $questionAnsB TEXT,
      $questionAnsC TEXT,
      $questionAnsD TEXT,
      $questionAnsRight TEXT NOT NULL,
      $questionAnsHint TEXT,
      $questionTopicId INTEGER,
      $questionMandatory INTEGER DEFAULT 0,
      $questionDifficulty INTEGER DEFAULT 1,
      FOREIGN KEY ($questionTopicId) REFERENCES $tableTopics($topicId)
    )
  ''';

  static const String createTestResultsTable = '''
    CREATE TABLE $tableTestResults (
      $resultId INTEGER PRIMARY KEY,
      $resultStartTime TEXT,
      $resultEndTime TEXT,
      $resultTotalQuestions INTEGER,
      $resultCorrectAnswers INTEGER,
      $resultScore REAL,
      $resultIsPassed INTEGER,
      $resultTestType TEXT DEFAULT 'practice'
    )
  ''';

  static const String createAnswerDetailsTable = '''
    CREATE TABLE $tableAnswerDetails (
      $detailId INTEGER PRIMARY KEY,
      $detailResultId INTEGER,
      $detailQuestionId INTEGER,
      $detailUserAnswer TEXT,
      $detailIsCorrect INTEGER,
      $detailTimeSpent INTEGER,
      FOREIGN KEY ($detailResultId) REFERENCES $tableTestResults($resultId),
      FOREIGN KEY ($detailQuestionId) REFERENCES $tableQuestions($questionId)
    )
  ''';

  // Indexes
  static const String indexQuestionsTopicId = 'CREATE INDEX idx_questions_topic ON $tableQuestions($questionTopicId)';
  static const String indexQuestionsMandatory = 'CREATE INDEX idx_questions_mandatory ON $tableQuestions($questionMandatory)';
  static const String indexAnswerDetailsResult = 'CREATE INDEX idx_answer_details_result ON $tableAnswerDetails($detailResultId)';

  static const List<String> createIndexes = [
    indexQuestionsTopicId,
    indexQuestionsMandatory,
    indexAnswerDetailsResult,
  ];
}