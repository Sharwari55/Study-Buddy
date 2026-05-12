import '../models/models.dart';

class QuizData {
  static const List<QuizQuestion> allQuestions = [
    // === AGE 5-8: General Knowledge (India-focused) ===
    QuizQuestion(
      id: 'q1',
      question: 'What is the national animal of India? 🐅',
      options: ['Lion', 'Tiger', 'Elephant', 'Peacock'],
      correctIndex: 1,
      subject: 'GK',
      ageGroup: '5-8',
      hint: 'It has orange stripes!',
    ),
    QuizQuestion(
      id: 'q2',
      question: 'What is the national bird of India? 🦚',
      options: ['Parrot', 'Eagle', 'Peacock', 'Sparrow'],
      correctIndex: 2,
      subject: 'GK',
      ageGroup: '5-8',
    ),
    QuizQuestion(
      id: 'q3',
      question: 'How many colours are in the Indian flag? 🇮🇳',
      options: ['2', '3', '4', '5'],
      correctIndex: 1,
      subject: 'GK',
      ageGroup: '5-8',
      hint: 'Saffron, White, and Green!',
    ),
    QuizQuestion(
      id: 'q4',
      question: 'Which festival is called the "Festival of Lights"? 🪔',
      options: ['Holi', 'Eid', 'Diwali', 'Christmas'],
      correctIndex: 2,
      subject: 'GK',
      ageGroup: '5-8',
    ),
    QuizQuestion(
      id: 'q5',
      question: 'What is 5 + 7? 🔢',
      options: ['10', '11', '12', '13'],
      correctIndex: 2,
      subject: 'Math',
      ageGroup: '5-8',
    ),
    QuizQuestion(
      id: 'q6',
      question: 'Which planet is closest to the Sun? ☀️',
      options: ['Earth', 'Venus', 'Mercury', 'Mars'],
      correctIndex: 2,
      subject: 'Science',
      ageGroup: '5-8',
    ),
    QuizQuestion(
      id: 'q7',
      question: 'What do plants need to make food? 🌿',
      options: ['Moonlight', 'Sunlight', 'Darkness', 'Wind'],
      correctIndex: 1,
      subject: 'Science',
      ageGroup: '5-8',
      hint: 'Plants use photosynthesis!',
    ),
    QuizQuestion(
      id: 'q8',
      question: 'Which is the longest river in India? 🏞️',
      options: ['Yamuna', 'Ganga', 'Godavari', 'Krishna'],
      correctIndex: 1,
      subject: 'GK',
      ageGroup: '5-8',
    ),

    // === AGE 8-12: Science & History ===
    QuizQuestion(
      id: 'q9',
      question: 'Who built the Taj Mahal? 🕌',
      options: ['Akbar', 'Humayun', 'Shah Jahan', 'Aurangzeb'],
      correctIndex: 2,
      subject: 'History',
      ageGroup: '8-12',
      hint: 'He built it for his wife Mumtaz!',
    ),
    QuizQuestion(
      id: 'q10',
      question: 'What gas do plants release during photosynthesis? 🌱',
      options: ['Carbon Dioxide', 'Nitrogen', 'Oxygen', 'Hydrogen'],
      correctIndex: 2,
      subject: 'Science',
      ageGroup: '8-12',
    ),
    QuizQuestion(
      id: 'q11',
      question: 'India got independence in which year? 🇮🇳',
      options: ['1945', '1946', '1947', '1948'],
      correctIndex: 2,
      subject: 'History',
      ageGroup: '8-12',
    ),
    QuizQuestion(
      id: 'q12',
      question: 'Which Indian scientist discovered the Raman Effect? 🔬',
      options: ['APJ Abdul Kalam', 'CV Raman', 'Homi Bhabha', 'Srinivasa Ramanujan'],
      correctIndex: 1,
      subject: 'Science',
      ageGroup: '8-12',
      hint: 'He won the Nobel Prize in Physics!',
    ),
    QuizQuestion(
      id: 'q13',
      question: 'What is the chemical formula for water? 💧',
      options: ['CO2', 'H2O', 'NaCl', 'O2'],
      correctIndex: 1,
      subject: 'Science',
      ageGroup: '8-12',
    ),
    QuizQuestion(
      id: 'q14',
      question: 'Who is known as the "Father of the Nation" in India? 🇮🇳',
      options: ['Nehru', 'Bose', 'Gandhi', 'Ambedkar'],
      correctIndex: 2,
      subject: 'History',
      ageGroup: '8-12',
    ),
    QuizQuestion(
      id: 'q15',
      question: 'How many states are in India? 🗺️',
      options: ['25', '26', '28', '29'],
      correctIndex: 2,
      subject: 'GK',
      ageGroup: '8-12',
    ),
    QuizQuestion(
      id: 'q16',
      question: 'What is the speed of light? ⚡',
      options: ['3 lakh km/s', '1 lakh km/s', '5 lakh km/s', '2 lakh km/s'],
      correctIndex: 0,
      subject: 'Science',
      ageGroup: '8-12',
    ),

    // === AGE 2-5: Very Simple ===
    QuizQuestion(
      id: 'q17',
      question: 'What sound does a cow make? 🐄',
      options: ['Moo', 'Woof', 'Meow', 'Roar'],
      correctIndex: 0,
      subject: 'Fun',
      ageGroup: '2-5',
    ),
    QuizQuestion(
      id: 'q18',
      question: 'What colour is the sky? ☀️',
      options: ['Red', 'Green', 'Blue', 'Yellow'],
      correctIndex: 2,
      subject: 'Fun',
      ageGroup: '2-5',
    ),
    QuizQuestion(
      id: 'q19',
      question: 'How many legs does a dog have? 🐕',
      options: ['2', '4', '6', '8'],
      correctIndex: 1,
      subject: 'Fun',
      ageGroup: '2-5',
    ),
    QuizQuestion(
      id: 'q20',
      question: 'What do we use to write? ✏️',
      options: ['Spoon', 'Pencil', 'Fork', 'Brush'],
      correctIndex: 1,
      subject: 'Fun',
      ageGroup: '2-5',
    ),
  ];

  static List<QuizQuestion> getForAge(String ageGroup) {
    return allQuestions.where((q) => q.ageGroup == ageGroup).toList()..shuffle();
  }
}

// Mock YouTube Videos (India-appropriate educational content)
class VideoData {
  static const List<VideoItem> videos = [
    // Age 2-5
    VideoItem(
      videoId: 'yCjJyiqpAuU',
      title: 'ABC Song for Kids',
      channelName: 'ChuChu TV Nursery Rhymes',
      thumbnail: 'https://img.youtube.com/vi/yCjJyiqpAuU/hqdefault.jpg',
      ageGroup: '2-5',
      subject: 'Phonics',
    ),
    VideoItem(
      videoId: 'pnMHODPLEcw',
      title: '123 Number Song for Kids',
      channelName: 'ChuChu TV',
      thumbnail: 'https://img.youtube.com/vi/pnMHODPLEcw/hqdefault.jpg',
      ageGroup: '2-5',
      subject: 'Numbers',
    ),
    // Age 5-8
    VideoItem(
      videoId: 'Wx2DnmAhDmM',
      title: 'Science for Kids - The Solar System',
      channelName: 'Kurzgesagt Kids',
      thumbnail: 'https://img.youtube.com/vi/Wx2DnmAhDmM/hqdefault.jpg',
      ageGroup: '5-8',
      subject: 'Science',
    ),
    VideoItem(
      videoId: 'XCVnkZRBFiY',
      title: 'How Plants Make Food - Photosynthesis',
      channelName: 'SciShow Kids',
      thumbnail: 'https://img.youtube.com/vi/XCVnkZRBFiY/hqdefault.jpg',
      ageGroup: '5-8',
      subject: 'Science',
    ),
    VideoItem(
      videoId: 'HlS-TBUvNnY',
      title: 'Indian History for Kids - Mughal Empire',
      channelName: 'History Wallah',
      thumbnail: 'https://img.youtube.com/vi/HlS-TBUvNnY/hqdefault.jpg',
      ageGroup: '8-12',
      subject: 'History',
    ),
    VideoItem(
      videoId: 'rfscVS0vtbw',
      title: 'Learn Python - For Kids',
      channelName: 'freeCodeCamp',
      thumbnail: 'https://img.youtube.com/vi/rfscVS0vtbw/hqdefault.jpg',
      ageGroup: '8-12',
      subject: 'Coding',
    ),
  ];

  static List<VideoItem> getForAge(String ageGroup) {
    return videos.where((v) => v.ageGroup == ageGroup).toList();
  }
}
