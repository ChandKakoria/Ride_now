import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_now/providers/user_provider.dart';
import 'package:ride_now/core/api_response.dart';

class StaticContentScreen extends StatefulWidget {
  final String title;
  const StaticContentScreen({super.key, required this.title});

  @override
  State<StaticContentScreen> createState() => _StaticContentScreenState();
}

class _StaticContentScreenState extends State<StaticContentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.title.contains("Privacy")) {
        context.read<UserProvider>().fetchPrivacy();
      } else {
        context.read<UserProvider>().fetchTerms();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF003B4D),
      ),
      body: Consumer<UserProvider>(
        builder: (context, provider, _) {
          final res = widget.title.contains("Privacy")
              ? provider.privacy
              : provider.terms;

          if (res.status == Status.LOADING) {
            return const Center(child: CircularProgressIndicator());
          }

          if (res.status == Status.ERROR) {
            return Center(child: Text(res.message ?? "Error loading content"));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  res.data ?? "No content available",
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
