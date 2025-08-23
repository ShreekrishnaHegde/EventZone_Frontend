import 'package:flutter/material.dart';
import '../../models/event_model.dart';
import '../../service/auth_service/auth_service.dart';
import '../../service/event_service/event_service.dart';

class AttendeeHomeView extends StatefulWidget {
  const AttendeeHomeView({super.key});

  @override
  State<AttendeeHomeView> createState() => _AttendeeHomeViewState();
}

class _AttendeeHomeViewState extends State<AttendeeHomeView> {
  final _authService = AuthService();
  final EventService _eventService = EventService();
  int _selectedIndex = 0;
  late Future<List<Event>> _eventsFuture;
  void _logout(BuildContext context) async {
    _authService.logout();
  }
  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  void _loadEvents() {
    setState(() {
      _eventsFuture = _eventService.fetchAllEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EventZone Participant"),
        backgroundColor: Colors.indigo.shade700,
        centerTitle: true,
        elevation: 2,
      ),
      body: FutureBuilder<List<Event>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return _buildError(snapshot.error.toString());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmpty();
          }
          final events = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async => _loadEvents(),
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Event Image
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: event.eventImageUrl != null
                            ? Image.network(
                          event.eventImageUrl!,
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                        )
                            : Container(
                          height: 180,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.event, size: 60, color: Colors.grey),
                        ),
                      ),
                      // Event Details
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              event.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(event.date.toString().split(" ").first),
                                const SizedBox(width: 16),
                                if (event.location != null) ...[
                                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      event.location!,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text("Something went wrong", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(error, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadEvents,
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildEmpty() {
    return const Center(
      child: Text(
        "No Events Found",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}


