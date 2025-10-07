class ApiConfig {
  // IMPORTANT: Replace 'YOUR_OPENAI_API_KEY_HERE' with your actual OpenAI API key
  // You can get your API key from: https://platform.openai.com/api-keys
  // NEVER commit your actual API key to version control!
  static const String openaiApiKey = 'YOUR_OPENAI_API_KEY_HERE';
  
  // OpenAI API Configuration
  static const String openaiBaseUrl = 'https://api.openai.com/v1';
  static const String openaiModel = 'gpt-3.5-turbo';
  
  // Rate limiting and safety
  static const int maxTokens = 300;
  static const double temperature = 0.7;
  
  // System prompt for the AI Coach
  static const String systemPrompt = '''You are an AI Sports Coach specializing in fitness assessment and athletic performance. 
You help athletes improve their performance through personalized advice, training recommendations, and motivation. 
You analyze fitness test results and provide actionable insights. 
Keep responses concise, encouraging, and focused on sports performance improvement.
Always maintain a positive and motivational tone while providing practical advice.''';
}
