import 'dart:convert';

class DataStructuresAndAlgorithmsQuestions {
  int index = 0;

  List questions = [
    json.decode('{"title":"Stack Usage in Programming","question":"What is the primary use of a stack in computer programming?","possible_answers":{"A":"To manage function calls","B":"To store application settings","C":"To manage memory allocation","D":"To increase processing speed"},"answer_percentages":{"A":80.0,"B":5.0,"C":10.0,"D":5.0},"right_answer":"A","topic_name":"Stacks","description_and_explanation":"A stack is a data structure used to store a collection of objects. It operates on a last in, first out (LIFO) principle, making it particularly useful for managing function calls in programming languages. This allows programs to keep track of function invocations and return addresses.","difficulty_level":"Easy","pro_tip":"Always check for stack overflow conditions in recursive function implementations.","fun_fact":"The concept of a stack was formalized in computer science by Alan Turing in 1946."}'),
    json.decode('{"title":"Implementing Priority Queues","question":"Which data structure is best suited for implementing a priority queue?","possible_answers":{"A":"Array","B":"Linked List","C":"Heap","D":"Binary Search Tree"},"answer_percentages":{"A":5.0,"B":10.0,"C":70.0,"D":15.0},"right_answer":"C","topic_name":"Heaps","description_and_explanation":"A heap is a specialized tree-based data structure that satisfies the heap property. It is particularly effective for implementing priority queues where the highest (or lowest) priority element needs to be accessed quickly. Heaps are crucial in algorithms like Heapsort and in systems requiring quick access to the most urgent element.","difficulty_level":"Medium","pro_tip":"Consider using a binary heap for easier implementation and efficient performance.","fun_fact":"Heaps are particularly popular in network traffic management and operating system scheduling."}'),
    json.decode('{"title":"Efficient Searching in Sorted Arrays","question":"What algorithm is most efficient for searching for an item in a sorted array?","possible_answers":{"A":"Linear Search","B":"Binary Search","C":"Depth-First Search","D":"Breadth-First Search"},"answer_percentages":{"A":10.0,"B":70.0,"C":10.0,"D":10.0},"right_answer":"B","topic_name":"Search Algorithms","description_and_explanation":"Binary search is an efficient algorithm for finding an item from a sorted array by repeatedly dividing the search interval in half. This method significantly reduces the time complexity to O(log n) as compared to linear search, making it ideal for large datasets.","difficulty_level":"Easy","pro_tip":"Always ensure that the array is sorted before applying binary search to avoid incorrect results.","fun_fact":"The idea of binary search dates back to the invention of the binary numeral system by Pingala around 200 BC."}'),
    json.decode('{"title":"Sorting with Binary Search Trees","question":"Which data structure efficiently supports the unique sorting of elements?","possible_answers":{"A":"Linked List","B":"Hash Table","C":"Queue","D":"Binary Search Tree"},"answer_percentages":{"A":5.0,"B":15.0,"C":5.0,"D":75.0},"right_answer":"D","topic_name":"Sorting and Trees","description_and_explanation":"A Binary Search Tree (BST) is a node-based binary tree data structure which has the following properties: the left subtree of a node contains only nodes with keys lesser than the node’s key, and the right subtree of a node contains only nodes with keys greater than the node’s key. This allows BSTs to maintain a dynamically changing dataset in sorted order, which makes it perfect for search, insert, delete, and retrieve operations in an ordered manner.","difficulty_level":"Medium","pro_tip":"Balancing the BST is key to maintaining optimal performance for all operations.","fun_fact":"The concept of binary trees dates back to the 17th century with their mathematical description by Leibniz."}'),
    json.decode('{"title":"Shortest Path in Weighted Graphs","question":"What is the best algorithm to find the shortest path in a weighted graph?","possible_answers":{"A":"Dijkstra\'s Algorithm","B":"A* Search","C":"Bellman-Ford Algorithm","D":"Floyd-Warshall Algorithm"},"answer_percentages":{"A":50.0,"B":20.0,"C":20.0,"D":10.0},"right_answer":"A","topic_name":"Graph Algorithms","description_and_explanation":"Dijkstra\'s Algorithm is renowned for its efficiency in finding the shortest path from a single source to all other nodes in a weighted graph without negative weights. It utilizes a greedy approach, continuously selecting the vertex with the minimum distance and updating the path lengths accordingly.","difficulty_level":"Hard","pro_tip":"Using priority queues can significantly speed up Dijkstra\'s algorithm.","fun_fact":"Edsger W. Dijkstra conceived the algorithm in 1956 when pondering the shortest route from Rotterdam to Groningen."}'),
    json.decode('{"title":"Cycle Detection in Directed Graphs","question":"Which algorithm is used to detect cycles in a directed graph?","possible_answers":{"A":"Kruskal\'s Algorithm","B":"Depth-First Search","C":"Prim\'s Algorithm","D":"Topological Sort"},"answer_percentages":{"A":5.0,"B":80.0,"C":5.0,"D":10.0},"right_answer":"B","topic_name":"Graph Theory","description_and_explanation":"Depth-First Search (DFS) is a fundamental algorithm in graph theory used for traversing or searching tree or graph data structures. It can be employed to detect cycles in a graph by tracking the vertices visited and checking for revisitation, indicating a cycle.","difficulty_level":"Medium","pro_tip":"Keep track of visited nodes and recursion stack to effectively detect cycles using DFS.","fun_fact":"DFS was first discussed in the context of maze solving by Charles Pierre Tremaux in the 19th century."}'),
    json.decode('{"title":"Undo Functionality with Stacks","question":"What data structure is primarily used to implement the undo functionality in software applications?","possible_answers":{"A":"Queue","B":"Stack","C":"Array","D":"Linked List"},"answer_percentages":{"A":5.0,"B":85.0,"C":5.0,"D":5.0},"right_answer":"B","topic_name":"Application of Data Structures","description_and_explanation":"Stacks are ideally suited for scenarios where you need to reverse actions. The LIFO (Last In, First Out) principle they operate on allows applications to store actions in a stack, enabling users to undo their most recent actions sequentially.","difficulty_level":"Easy","pro_tip":"Utilize stacks to handle any feature that requires reverse operations efficiently.","fun_fact":"The widespread use of stacks for undo functionality in text editors began in the early 1970s."}'),
    json.decode('{"title":"Hash Table Efficiency","question":"What is a fundamental characteristic of a hash table?","possible_answers":{"A":"The order of elements is preserved","B":"Elements are accessed sequentially","C":"Average-case constant time complexity for lookups","D":"Elements are prioritized based on their values"},"answer_percentages":{"A":5.0,"B":5.0,"C":85.0,"D":5.0},"right_answer":"C","topic_name":"Hash Tables","description_and_explanation":"Hash tables offer an average-case time complexity of O(1) for search, insert, and delete operations. This efficiency is achieved by using a hash function to compute an index into an array of buckets from which the desired value can be found.","difficulty_level":"Medium","pro_tip":"Choosing a good hash function is crucial to reduce collisions and maintain the performance of hash tables.","fun_fact":"Hash tables have been a fundamental part of programming languages like Lisp since its inception."}'),
    json.decode('{"title":"Exponential Time Complexity","question":"What describes an algorithm\'s runtime complexity that doubles with each addition to the input size?","possible_answers":{"A":"O(n)","B":"O(log n)","C":"O(n log n)","D":"O(2^n)"},"answer_percentages":{"A":5.0,"B":5.0,"C":10.0,"D":80.0},"right_answer":"D","topic_name":"Complexity Theory","description_and_explanation":"Algorithms with O(2^n) runtime complexity are often referred to as exponential time algorithms. They are characterized by a runtime that grows exponentially with each additional element in the input set, which makes them impractical for large datasets.","difficulty_level":"Hard","pro_tip":"Avoid exponential time algorithms for large datasets to ensure that your program runs efficiently.","fun_fact":"The number of possible solutions to the Traveling Salesman Problem increases exponentially with the number of cities, making it a classic example of an exponential time problem."}'),
    json.decode('{"title":"Quick Sort Efficiency","question":"Which sorting algorithm is considered the fastest in practice, despite having a worse-case runtime of O(n^2)?","possible_answers":{"A":"Merge Sort","B":"Quick Sort","C":"Bubble Sort","D":"Insertion Sort"},"answer_percentages":{"A":10.0,"B":70.0,"C":10.0,"D":10.0},"right_answer":"B","topic_name":"Sorting Algorithms","description_and_explanation":"Quick Sort is widely recognized for its efficiency in the average case, even though it can degenerate to O(n^2) complexity in the worst case (typically when the smallest or largest element is always picked as the pivot). However, its partitioning approach, which divides the array into smaller parts before sorting them independently, makes it generally faster than other O(n log n) algorithms in practice.","difficulty_level":"Medium","pro_tip":"Choosing a random pivot for Quick Sort can help avoid worst-case performance on sorted inputs.","fun_fact":"Quick Sort was developed by Tony Hoare in 1960, during his visit to the Soviet Union as a guest of the Russian Academy of Sciences."}'),
    json.decode('{"title":"Organizational Chart Structures","question":"Which data structure would be most appropriate for storing the hierarchical structure of a new organizational chart?","possible_answers":{"A":"Graph","B":"Tree","C":"Array","D":"Stack"},"answer_percentages":{"A":10.0,"B":80.0,"C":5.0,"D":5.0},"right_answer":"B","topic_name":"Trees","description_and_explanation":"A tree is a non-linear data structure that simulates a hierarchical tree structure with a set of linked nodes. It is perfect for representing structures like organizational charts, where each employee (node) may have one superior (parent) and can have multiple subordinates (children).","difficulty_level":"Easy","pro_tip":"Utilize tree traversal algorithms to efficiently manage and update the organizational chart.","fun_fact":"The concept of tree structures in computing was popularized by the use of binary trees in the 1960s."}'),
    json.decode('{"title":"Memoization in Recursive Algorithms","question":"What is the key advantage of using memoization in recursive algorithms?","possible_answers":{"A":"Reducing the number of recursive calls","B":"Decreasing the memory usage","C":"Simplifying the algorithm\'s logic","D":"Increasing the recursion depth"},"answer_percentages":{"A":75.0,"B":5.0,"C":10.0,"D":10.0},"right_answer":"A","topic_name":"Dynamic Programming","description_and_explanation":"Memoization is an optimization technique used primarily to speed up computer programs by storing the results of expensive function calls and reusing them when the same inputs occur again, thus reducing the number of calls made. It is especially useful in recursive algorithms to avoid computing the same results multiple times, which can dramatically decrease runtime.","difficulty_level":"Medium","pro_tip":"Implement memoization in top-down dynamic programming solutions to optimize performance.","fun_fact":"The term \'memoization\' was coined by Donald Michie in 1968 and is derived from the Latin word \'memorandum\' meaning \'to be remembered\', rather than the similar word \'memory\'."}'),
    json.decode('{"title":"Implementing Priority Queues","question":"Which data structure is best suited for implementing a priority queue?\\n\\n```dart\\nclass PriorityQueue {\\n  void insert(int item) {\\n    // implementation here\\n  }\\n}\\n```","possible_answers":{"A":"Array","B":"Linked List","C":"Heap","D":"Binary Search Tree"},"answer_percentages":{"A":5.0,"B":10.0,"C":70.0,"D":15.0},"right_answer":"C","topic_name":"Heaps","description_and_explanation":"A heap is a specialized tree-based data structure that satisfies the heap property. It is particularly effective for implementing priority queues where the highest (or lowest) priority element needs to be accessed quickly. Heaps are crucial in algorithms like Heapsort and in systems requiring quick access to the most urgent element.","difficulty_level":"Medium","pro_tip":"Consider using a binary heap for easier implementation and efficient performance.","fun_fact":"Heaps are particularly popular in network traffic management and operating system scheduling."}')
  ];

  DataStructuresAndAlgorithmsQuestions._privateConstructor();
  static final DataStructuresAndAlgorithmsQuestions _instance = DataStructuresAndAlgorithmsQuestions._privateConstructor();

  factory DataStructuresAndAlgorithmsQuestions() {
    return _instance;
  }

  getNextQuestion() {
    index = (index == questions.length - 1) ? 0 : index + 1;
    return questions[index];
  }

  getNextQuestionsList(int count) {
    index = (index == questions.length - 1) ? 0 : index + 1;
    var questionsList = [];
    for(int i = index; i < count; i ++) {
      questionsList.add(questions[index]);
      index = (index == questions.length - 1) ? 0 : index + 1;
    }
    return questionsList;
  }
}