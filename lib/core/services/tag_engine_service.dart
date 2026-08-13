class TagEngineService {

  static Future<List<String>>
      generateTags(
    String text,
  ) async {

    final lowerText =
        text.toLowerCase();

    final Set<String> tags = {};

    final keywordMap = {

      'technology': [
        'technology',
        'tech',
        'software',
        'computer',
        'programming',
        'coding',
      ],

      'ai': [
        'ai',
        'artificial intelligence',
        'machine learning',
      ],

      'business': [
        'business',
        'entrepreneurship',
        'startup',
        'marketing',
        'sales',
      ],

      'finance': [
        'finance',
        'money',
        'banking',
        'investment',
      ],

      'agriculture': [
        'farming',
        'agriculture',
        'farm',
        'crops',
      ],

      'water': [
        'water',
        'borehole',
        'irrigation',
      ],

      'education': [
        'education',
        'school',
        'teaching',
      ],

      'health': [
        'health',
        'medical',
        'hospital',
      ],

      'transport': [
        'transport',
        'roads',
        'traffic',
      ],

      'construction': [
        'construction',
        'building',
        'housing',
      ],

      'energy': [
        'electricity',
        'solar',
        'energy',
        'power',
      ],

      'jobs': [
        'jobs',
        'employment',
        'career',
      ],

      'youth': [
        'youth',
        'young people',
      ],
    };

    keywordMap.forEach(

      (mainTag, keywords) {

        for (final keyword
            in keywords) {

          if (lowerText
              .contains(keyword)) {

            tags.add(mainTag);
          }
        }
      },
    );

    return tags.toList();
  }
}