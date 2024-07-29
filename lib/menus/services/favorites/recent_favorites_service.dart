import 'dart:convert';

class RecentFavoritesService {
  var recent = json.decode('{"status":"SUCCESS","recent":[{"id":"DSA_1ys3","topic":"DSA","sub-topic":"Stacks","title":"Stack Usage in Programming","difficulty_level":"Easy","question":"What is the primary use of a stack in computer programming?","description_and_explanation":"A stack is a data structure used to store a collection of objects. It operates on a last in, first out (LIFO) principle, making it particularly useful for managing function calls in programming languages. This allows programs to keep track of function invocations and return addresses.","pro_tip":"Always check for stack overflow conditions in recursive function implementations.","fun_fact":"The concept of a stack was formalized in computer science by Alan Turing in 1946."},{"id":"DSA_Y6&h","topic":"DSA","sub-topic":"Heaps","title":"Implementing Priority Queues","difficulty_level":"Medium","question":"What is the primary use of a stack in computer programming?","description_and_explanation":"A heap is a specialized tree-based data structure that satisfies the heap property. It is particularly effective for implementing priority queues where the highest (or lowest) priority element needs to be accessed quickly. Heaps are crucial in algorithms like Heapsort and in systems requiring quick access to the most urgent element.","pro_tip":"Consider using a binary heap for easier implementation and efficient performance.","fun_fact":"Heaps are particularly popular in network traffic management and operating system scheduling."},{"id":"SDE_NAH7u","topic":"SDE","sub-topic":"Database Types","title":"Best Database for Hierarchical Data","difficulty_level":"Medium","question":"Which database type is best suited for handling hierarchical data, such as organizational structures?","description_and_explanation":"Graph databases are designed to store and navigate relationships in a natural and efficient way, making them ideal for hierarchical data structures.","pro_tip":"When dealing with complex, interconnected data, graph databases can significantly simplify your queries.","fun_fact":"Graph databases are used by social networks to map users connections efficiently."}]}');

  RecentFavoritesService._privateConstructor();

  static final RecentFavoritesService _instance = RecentFavoritesService._privateConstructor();

  factory RecentFavoritesService() {
    return _instance;
  }

  List<Map<String, dynamic>> getRecentFavorites() {
    return List<Map<String, dynamic>>.from(recent['recent']);
  }

  List<Map<String, dynamic>> getFavoritesBySubTopics(String topic, String subtopic) {
    return List<Map<String, dynamic>>.from(recent['recent']);
  }
}