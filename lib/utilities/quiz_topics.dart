import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../quiz/quiz_question/questions/aws.dart';
import '../quiz/quiz_question/questions/dsa.dart';
import '../quiz/quiz_question/questions/java.dart';
import '../quiz/quiz_question/questions/kafka.dart';
import '../quiz/quiz_question/questions/kubernetes.dart';
import '../quiz/quiz_question/questions/python.dart';
import '../quiz/quiz_question/questions/system_design.dart';

class Topics {

  static var subtopics = json.decode('{"System Design":{"Scalability":"Techniques and strategies to handle growing amounts of work and users efficiently.","Load Balancing":"Distributing incoming network traffic across multiple servers to ensure reliability and performance.","Caching":"Storing frequently accessed data in a temporary storage to improve retrieval speed.","Database Sharding":"Splitting a large database into smaller, more manageable pieces called shards.","Microservices":"Architectural style that structures an application as a collection of loosely coupled services.","High Availability":"Ensuring a system operates continuously without downtime.","Fault Tolerance":"Ability of a system to continue operating properly in the event of a failure.","Consistency Models":"Ensuring that a system\'s data remains consistent across different nodes and operations."},"Data Structures and Algorithms":{"Arrays":"A collection of elements identified by index or key.","Linked Lists":"A linear data structure where each element points to the next.","Stacks":"A linear data structure that follows the Last In, First Out (LIFO) principle.","Queues":"A linear data structure that follows the First In, First Out (FIFO) principle.","Trees":"A hierarchical data structure with a root value and subtrees of children, represented as a set of linked nodes.","Graphs":"A collection of nodes connected by edges.","Sorting Algorithms":"Techniques to arrange elements in a certain order.","Searching Algorithms":"Techniques to find an element within a data structure.","Dynamic Programming":"A method for solving complex problems by breaking them down into simpler subproblems.","Greedy Algorithms":"Algorithms that make the locally optimal choice at each stage."},"Kubernetes":{"Pods":"The smallest deployable units in Kubernetes that can contain one or more containers.","Services":"An abstract way to expose an application running on a set of Pods as a network service.","Deployments":"Provide declarative updates to applications.","Namespaces":"Provide a way to divide cluster resources between multiple users.","ConfigMaps":"Used to decouple configuration artifacts from image content to keep containerized applications portable.","Secrets":"Used to manage sensitive information like passwords, OAuth tokens, and ssh keys.","Ingress":"Manage external access to the services in a cluster, typically HTTP.","Persistent Volumes":"A piece of storage in the cluster that has been provisioned by an administrator or dynamically provisioned using Storage Classes."},"AWS":{"EC2":"Scalable virtual servers in the cloud.","S3":"Object storage built to store and retrieve any amount of data from anywhere.","RDS":"Managed relational database service.","Lambda":"Run code without provisioning or managing servers.","VPC":"Virtual network dedicated to your AWS account.","CloudFormation":"Infrastructure as code for AWS resources.","IAM":"Manage access to AWS services and resources securely.","DynamoDB":"NoSQL database service for any scale."},"Apache Kafka":{"Producers":"Entities that publish data to Kafka topics.","Consumers":"Entities that subscribe to topics and process the feed of published messages.","Topics":"Categories to which records are sent by producers.","Partitions":"Horizontal scalability and fault tolerance unit within topics.","Brokers":"Kafka servers that store data and serve clients.","Zookeeper":"Manages and coordinates Kafka brokers.","Streams API":"Allows the processing of data in Kafka with stream processing applications.","Connect API":"Integrates Kafka with other systems."},"Python":{"Data Types":"Built-in types for different kinds of data such as integers, floats, strings, and lists.","Control Structures":"Conditional statements, loops, and control flow mechanisms.","Functions":"Blocks of reusable code that perform specific tasks.","Modules and Packages":"Organizing Python code into reusable components.","File I/O":"Reading from and writing to files.","Exception Handling":"Managing errors and exceptions that occur during program execution.","Object-Oriented Programming":"Creating classes and objects to model real-world entities.","Libraries and Frameworks":"Popular Python libraries and frameworks such as NumPy, Pandas, Flask, and Django."},"Java":{"Syntax and Semantics":"Basic syntax and semantic rules of Java.","Object-Oriented Programming":"Core principles like inheritance, polymorphism, encapsulation, and abstraction.","Data Types and Variables":"Primitive data types and variable declarations.","Control Flow":"Conditional statements, loops, and branching.","Collections Framework":"Data structures like List, Set, Map, and their implementations.","Exception Handling":"Handling runtime errors using try, catch, and finally blocks.","Multithreading":"Creating and managing multiple threads in a program.","Java Standard Library":"Core libraries like java.lang, java.util, java.io, and java.net."}}');

  static final List<String> options = [
    'System Design',
    'Data Structures and Algorithms',
    'Kubernetes',
    'AWS',
    'Apache Kafka',
    'Python',
    'Java',
  ];

  static getQuizType(String topicName) {
    print(topicName);
    switch(topicName) {
      case 'System Design':
        return SystemDesignQuestions();
      case 'Data Structures and Algorithms':
        return DataStructuresAndAlgorithmsQuestions();
      case 'Kubernetes':
        return KubernetesQuestions();
      case 'AWS':
        return AWSQuestions();
      case 'Apache Kafka':
        return ApacheKafkaQuestions();
      case 'Python':
        return PythonQuestions();
      case 'Java':
        return JavaQuestions();
      default:
        throw new Exception('Invalid Topic Selection !!!');
    }
  }

  static IconData getIconForTopics(String type) {
    switch (type) {
      case 'Data Structures and Algorithms':
        return Icons.graphic_eq;
      case 'System Design':
        return Icons.architecture;
      case 'Python':
        return FontAwesomeIcons.python;
      case 'Java':
        return FontAwesomeIcons.java;
      case 'AWS':
        return FontAwesomeIcons.aws;
      case 'Kubernetes':
        return FontAwesomeIcons.kickstarter;
      case 'Kafka':
        return FontAwesomeIcons.kaggle;
      default:
        return Icons.help;
    }
  }

  static getSubtopics(String topic) {
    return subtopics[topic];
  }
}
