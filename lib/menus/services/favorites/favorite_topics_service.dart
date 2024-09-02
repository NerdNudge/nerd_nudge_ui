import 'dart:convert';

import '../../../user_profile/dto/user_profile_entity.dart';
import '../../../utilities/api_end_points.dart';
import '../../../utilities/api_service.dart';

class FavoriteTopicsService {
  final Map<String, dynamic> favSDESubTopics = json.decode('{"scalability":"Strategies for scaling systems.","load_balancing":"Distributing workloads across multiple servers.","caching":"Techniques to cache data for faster access.","database_replication":"Replicating databases for redundancy and availability.","data_partitioning":"Partitioning data to manage large datasets.","microservices":"Designing and managing microservices architecture."}');
  final Map<String, dynamic> favDSASubTopics = json.decode('{"arrays":"Introduction to arrays and their uses.","linked_lists":"Understanding linked lists and their operations.","stacks":"Stack data structure and its applications.","queues":"Queue data structure and its operations.","trees":"Introduction to tree data structures.","graphs":"Understanding graph theory and its algorithms."}');
  final Map<String, dynamic> favPythonSubTopics = json.decode('{"basics":"Introduction to Python programming.","data_structures":"Python\'s built-in data structures.","functions":"Defining and using functions in Python.","modules":"Working with modules and packages.","file_io":"File input/output operations.","error_handling":"Exception handling in Python."}');
  final Map<String, dynamic> favJavaSubTopics = json.decode('{"basics":"Introduction to Java programming.","oop_concepts":"Object-Oriented Programming concepts.","collections":"Java Collections Framework.","streams":"Working with Java Streams API.","concurrency":"Concurrency and multithreading in Java.","jvm":"Java Virtual Machine and memory management."}');
  final Map<String, dynamic> favAWSSubTopics = json.decode('{"ec2":"Amazon EC2 instances and their management.","s3":"Amazon S3 for object storage.","rds":"Amazon RDS for relational databases.","lambda":"AWS Lambda for serverless computing.","cloudformation":"Infrastructure as code with AWS CloudFormation.","vpc":"Amazon VPC for network isolation."}');
  final Map<String, dynamic> favK8sSubTopics = json.decode('{"kubernetes_overview":"Introduction to Kubernetes.","architecture":"Kubernetes architecture and components.","pods":"Understanding Kubernetes Pods.","services":"Kubernetes Services for networking.","deployments":"Managing applications with Kubernetes Deployments.","config_maps":"Using ConfigMaps for configuration."}');
  final Map<String, dynamic> favKafkaSubTopics = json.decode('{"introduction":"Overview of Apache Kafka.","architecture":"Kafka architecture and components.","producers":"Understanding Kafka producers.","consumers":"Kafka consumers and consumer groups.","topics":"Managing Kafka topics and partitions.","streams":"Stream processing with Kafka Streams."}');

  FavoriteTopicsService._privateConstructor();

  static final FavoriteTopicsService _instance = FavoriteTopicsService._privateConstructor();

  factory FavoriteTopicsService() {
    return _instance;
  }

  List<Map<String, String>> getSubtopicList(String topic) {
    Map<String, dynamic> subtopicsMap;
    switch(topic) {
      case 'Data Structures and Algorithms':
        subtopicsMap = favDSASubTopics;
        break;
      case 'System Design':
        subtopicsMap = favSDESubTopics;
        break;
      case 'Python':
        subtopicsMap = favPythonSubTopics;
        break;
      case 'Java':
        subtopicsMap = favJavaSubTopics;
        break;
      case 'AWS':
        subtopicsMap = favAWSSubTopics;
        break;
      case 'Kubernetes':
        subtopicsMap = favK8sSubTopics;
        break;
      case 'Kafka':
      default:
        subtopicsMap = favKafkaSubTopics;
        break;
    }
    return subtopicsMap.entries.map((entry) => {'id': entry.key, 'description': entry.value.toString()}).toList();
  }


  Future<List<Map<String, dynamic>>> getFavoritesTopics() async {
    print('getting Quizflex data now..');
    final ApiService apiService = ApiService();
    dynamic result;
    try {
      final String url = APIEndpoints.USER_INSIGHTS_BASE_URL + APIEndpoints.FAVORITE_TOPICS + "/" + UserProfileEntity().getUserEmail();
      print('Sending GET request to: $url');
      result = await apiService.getRequest(APIEndpoints.USER_INSIGHTS_BASE_URL, APIEndpoints.FAVORITE_TOPICS + "/" + UserProfileEntity().getUserEmail());
      print('API Result: $result');

      if (result is Map<String, dynamic>) {
        return List<Map<String, dynamic>>.from(result['data']);
      } else if (result is String) {
        Map<String, dynamic> decodedResult = json.decode(result);
        return List<Map<String, dynamic>>.from(decodedResult['data']);
      } else {
        throw const FormatException("Unexpected response format");
      }
    } catch (e) {
      print('Error during getRecentFavorites: $e');
      throw e;
    }
  }
}