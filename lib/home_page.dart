import 'package:flutter/material.dart';
import 'package:sqlproj/services/database_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final DatabaseService _databaseService = DatabaseService.instance;

  @override
  Widget build(Object context) {
    return Scaffold();
  }
}