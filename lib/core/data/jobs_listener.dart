import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:job_match/core/domain/models/job_model.dart';
import 'package:job_match/presentation/widgets/simulation/notification_overlay.dart';

class JobsRealtimeListener {
  final SupabaseClient _supabase = Supabase.instance.client;
  RealtimeChannel? _channel;
  bool _isInitializing = false;
  bool _reconnecting = false;

  // Keep track of recently notified job IDs to prevent duplicate notifications
  final Map<String, DateTime> _recentJobNotifications = {};

  // Keep track of multiple changes within a time window
  final Map<String, List<String>> _pendingJobChanges = {};
  final Map<String, Timer?> _jobUpdateTimers = {};

  // Callback functions
  Function(Job)? onJobCreated;
  Function(Job, Job?)? onJobUpdated;
  Function(Job)? onJobDeleted;
  Function(Job)? onJobDeadlineReached;
  Function(Job, String)? onJobStatusChanged;
  Function(Job, Job?)? onJobSalaryChanged;

  // Singleton pattern with private constructor
  static final JobsRealtimeListener _instance =
      JobsRealtimeListener._internal();
  factory JobsRealtimeListener() => _instance;
  JobsRealtimeListener._internal();

  Future<void> startListening({
    Function(Job)? onJobCreated,
    Function(Job, Job?)? onJobUpdated,
    Function(Job)? onJobDeleted,
    Function(Job)? onJobDeadlineReached,
    Function(Job, String)? onJobStatusChanged,
    Function(Job, Job?)? onJobSalaryChanged,
  }) async {
    // Prevent multiple simultaneous initializations
    if (_isInitializing) return;
    _isInitializing = true;

    try {
      // First stop any existing listeners to prevent duplicates
      await stopListening();

      // Update callbacks
      this.onJobCreated = onJobCreated;
      this.onJobUpdated = onJobUpdated;
      this.onJobDeleted = onJobDeleted;
      this.onJobDeadlineReached = onJobDeadlineReached;
      this.onJobStatusChanged = onJobStatusChanged;
      this.onJobSalaryChanged = onJobSalaryChanged;

      // Get the session to ensure we're authenticated
      _supabase.auth.currentSession;

      // Create a unique channel name to prevent conflicts
      final channelName =
          'jobs_updates_${DateTime.now().millisecondsSinceEpoch}';

      _channel =
          _supabase
              .channel('realtime:public:jobs')
              .onPostgresChanges(
                event: PostgresChangeEvent.insert,
                schema: 'public',
                table: 'jobs',
                callback: (payload) {
                  final newJob = Job.fromMap(payload.newRecord);
                  onJobCreated?.call(newJob);
                },
              )
              // …otros .onPostgresChanges para UPDATE/DELETE…
              .subscribe();

      // Create channel with unique name
      _channel = _supabase.channel(channelName);

      // Set up PostgreSQL change listeners
      _channel = _channel!
          .onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: 'jobs',
            callback: (payload) {
              try {
                final newJob = Job.fromMap(payload.newRecord);
                print('🆕 Nuevo job creado: ${newJob.title}');
                onJobCreated?.call(newJob);
              } catch (e) {
                print('Error processing job creation: $e');
              }
            },
          )
          .onPostgresChanges(
            event: PostgresChangeEvent.update,
            schema: 'public',
            table: 'jobs',
            callback: (payload) {
              try {
                final newJob = Job.fromMap(payload.newRecord);
                final oldJob =
                    payload.oldRecord != null
                        ? Job.fromMap(payload.oldRecord)
                        : null;

                print('🔄 Job actualizado: ${newJob.title}');

                // Check for specific important changes
                _handleJobChanges(newJob, oldJob);

                onJobUpdated?.call(newJob, oldJob);
              } catch (e) {
                print('Error processing job update: $e');
              }
            },
          )
          .onPostgresChanges(
            event: PostgresChangeEvent.delete,
            schema: 'public',
            table: 'jobs',
            callback: (payload) {
              try {
                final deletedJob = Job.fromMap(payload.oldRecord);
                print('🗑️ Job eliminado: ${deletedJob.title}');
                onJobDeleted?.call(deletedJob);
              } catch (e) {
                print('Error processing job deletion: $e');
              }
            },
          );

      // Handle connection errors
      _channel!.socket.onError((error) {
        print('⚠️ Socket error in jobs listener: $error');
        if (!_reconnecting) _scheduleReconnect();
      });

      // Handle socket closing
      _channel!.socket.onClose((_) {
        print('⚠️ Socket closed in jobs listener - will try to reconnect');
        if (!_reconnecting) _scheduleReconnect();
      });

      // Make sure the socket is connected
      _channel!.socket.connect();

      // Subscribe to the channel
      _channel!.subscribe((status, [_]) {
        print('! Jobs listener subscription status: $status');
        if (status == 'SUBSCRIBED') {
          print('✅ Jobs realtime listener iniciado con confirmación');

          // Start sending periodic pings to keep connection alive
          _startKeepAlive();
        } else if (status == 'TIMED_OUT' || status == 'CLOSED') {
          print('⚠️ Subscription failed with status: $status');
          if (!_reconnecting) _scheduleReconnect();
        }
      });
    } catch (e) {
      print('⚠️ Error starting jobs listener: $e');
    } finally {
      _isInitializing = false;
    }
  }

  // Schedule a reconnect attempt with exponential backoff
  int _reconnectAttempts = 0;
  void _scheduleReconnect() {
    if (_reconnecting) return;
    _reconnecting = true;

    // Calculate delay with exponential backoff (1s, 2s, 4s, 8s, etc.) with a max of 30s
    final delay = Duration(
      seconds:
          _reconnectAttempts > 0 ? (1 << _reconnectAttempts).clamp(1, 30) : 1,
    );

    print(
      '🔄 Will attempt to reconnect in ${delay.inSeconds} seconds (attempt ${_reconnectAttempts + 1})',
    );

    Future.delayed(delay, () async {
      try {
        _reconnectAttempts++;
        print('🔄 Reconnection attempt $_reconnectAttempts');
        await startListening(
          onJobCreated: onJobCreated,
          onJobUpdated: onJobUpdated,
          onJobDeleted: onJobDeleted,
          onJobDeadlineReached: onJobDeadlineReached,
          onJobStatusChanged: onJobStatusChanged,
          onJobSalaryChanged: onJobSalaryChanged,
        );
        _reconnecting = false;
        _reconnectAttempts = 0; // Reset after successful connection
        print('✅ Reconnected successfully after $_reconnectAttempts attempts');
      } catch (e) {
        print('⚠️ Reconnection attempt failed: $e');
        _reconnecting = false;
        _scheduleReconnect(); // Try again
      }
    });
  }

  // Send periodic pings to keep connection alive
  void _startKeepAlive() {
    Future.doWhile(() async {
      if (_channel == null) return false;

      try {
        await Future.delayed(const Duration(seconds: 15));
        if (_channel == null) return false;

        // Instead of using send directly, use socket.connect to refresh the connection
        print('📍 Refreshing realtime connection');
        _channel!.socket.connect();

        return true; // Continue the loop
      } catch (e) {
        print('⚠️ Error refreshing connection: $e');
        return _channel != null; // Continue if channel exists
      }
    });
  }

  void _handleJobChanges(Job newJob, Job? oldJob) {
    if (oldJob == null) return;

    List<String> detectedChanges = [];

    // Check status change
    if (newJob.status != oldJob.status) {
      print(
        '🔄 Estado cambió para ${newJob.title}: ${oldJob.status} → ${newJob.status}',
      );
      detectedChanges.add('status');
    }

    // Check salary change
    if (newJob.salaryMin != oldJob.salaryMin ||
        newJob.salaryMax != oldJob.salaryMax) {
      print('💰 Salario cambió para ${newJob.title}:');
      print('   Anterior: ${oldJob.salaryMin}-${oldJob.salaryMax}');
      print('   Nuevo: ${newJob.salaryMin}-${newJob.salaryMax}');
      detectedChanges.add('salary');
    }

    // Check modality change
    if (newJob.modality != oldJob.modality) {
      print(
        '🏢 Modalidad cambió para ${newJob.title}: ${oldJob.modality} → ${newJob.modality}',
      );
      detectedChanges.add('modality');
    }

    // Check job type change
    if (newJob.type != oldJob.type) {
      print(
        '💼 Tipo de trabajo cambió para ${newJob.title}: ${oldJob.type} → ${newJob.type}',
      );
      detectedChanges.add('type');
    }

    // Check location change
    if (newJob.location != oldJob.location) {
      print(
        '📍 Ubicación cambió para ${newJob.title}: ${oldJob.location} → ${newJob.location}',
      );
      detectedChanges.add('location');
    }

    // Check required skills change
    if (!_areSkillListsEqual(newJob.requiredSkills, oldJob.requiredSkills)) {
      final newSkills = newJob.requiredSkills ?? [];
      final oldSkills = oldJob.requiredSkills ?? [];

      print('🎯 Habilidades requeridas cambiaron para ${newJob.title}:');
      print('   Anterior: ${oldSkills.join(", ")}');
      print('   Nuevo: ${newSkills.join(", ")}');
      detectedChanges.add('skills');
    }

    // Check max applications change
    if (newJob.maxApplications != oldJob.maxApplications) {
      print(
        '👥 Máximo de aplicaciones cambió para ${newJob.title}: ${oldJob.maxApplications} → ${newJob.maxApplications}',
      );
      detectedChanges.add('maxApplications');
    }

    // Check views count change (might be useful for employers)
    if (newJob.viewsCount != oldJob.viewsCount) {
      print(
        '👀 Vistas cambió para ${newJob.title}: ${oldJob.viewsCount} → ${newJob.viewsCount}',
      );

      // Notify on significant milestones (every 10 views)
      if (newJob.viewsCount != null && oldJob.viewsCount != null) {
        final newViews = newJob.viewsCount!;
        final oldViews = oldJob.viewsCount!;

        if ((newViews ~/ 10) > (oldViews ~/ 10)) {
          detectedChanges.add('views_milestone');
        }
      }
    }

    // Check description change
    if (newJob.description != oldJob.description) {
      print('📝 Descripción cambió para ${newJob.title}');
      detectedChanges.add('description');
    }

    // Check title change
    if (newJob.title != oldJob.title) {
      print('📝 Título cambió: ${oldJob.title} → ${newJob.title}');
      detectedChanges.add('title');
    }

    // Check company name change
    if (newJob.companyName != oldJob.companyName) {
      print(
        '🏢 Nombre de empresa cambió para ${newJob.title}: ${oldJob.companyName} → ${newJob.companyName}',
      );
      detectedChanges.add('companyName');
    }

    // Check company_id change
    if (newJob.companyId != oldJob.companyId) {
      print(
        '🏢 ID de empresa cambió para ${newJob.title}: ${oldJob.companyId} → ${newJob.companyId}',
      );
      detectedChanges.add('companyId');
    }

    // Check application deadline change
    if (_areDatesEqual(
          newJob.applicationDeadline,
          oldJob.applicationDeadline,
        ) ==
        false) {
      print('📅 Deadline cambió para ${newJob.title}:');
      print('   Anterior: ${oldJob.applicationDeadline}');
      print('   Nuevo: ${newJob.applicationDeadline}');
      detectedChanges.add('deadline_change');
    }

    // Check if deadline reached
    if (newJob.applicationDeadline != null) {
      final now = DateTime.now();
      DateTime? deadline;
      try {
        deadline = newJob.applicationDeadline;
      } catch (e) {
        print('Error parsing deadline: ${newJob.applicationDeadline}');
      }

      if (deadline != null && deadline.isBefore(now)) {
        bool wasDeadlineValid = true;
        if (oldJob.applicationDeadline != null) {
          try {
            wasDeadlineValid = oldJob.applicationDeadline!.isAfter(now);
          } catch (e) {
            // Error parsing old deadline, assume it was valid
          }
        }

        if (wasDeadlineValid) {
          print('⏰ Deadline alcanzado para ${newJob.title}');
          detectedChanges.add('deadline_reached');
        }
      }
    }

    // Check created_at change
    if (_areDatesEqual(newJob.createdAt, oldJob.createdAt) == false) {
      print(
        '📅 Fecha de creación cambió para ${newJob.title}: ${oldJob.createdAt} → ${newJob.createdAt}',
      );
      detectedChanges.add('created_at');
    }

    // Handle multiple changes with batching
    if (detectedChanges.isNotEmpty) {
      _handleBatchedChanges(newJob, detectedChanges);
    }
  }

  // Handle multiple changes within a time window
  void _handleBatchedChanges(Job job, List<String> newChanges) {
    final jobId = job.id;

    // Cancel existing timer if any
    _jobUpdateTimers[jobId]?.cancel();

    // Add new changes to pending list
    _pendingJobChanges[jobId] =
        (_pendingJobChanges[jobId] ?? [])..addAll(newChanges);

    // Set a timer to process batched changes after a short delay
    _jobUpdateTimers[jobId] = Timer(const Duration(milliseconds: 2000), () {
      _processBatchedChanges(job, _pendingJobChanges[jobId] ?? []);

      // Clean up
      _pendingJobChanges.remove(jobId);
      _jobUpdateTimers.remove(jobId);
    });
  }

  // Process batched changes and show appropriate notifications
  void _processBatchedChanges(Job job, List<String> changes) {
    if (changes.isEmpty) return;

    // Remove duplicates
    final uniqueChanges = changes.toSet().toList();
    final changeCount = uniqueChanges.length;

    // Handle special cases first
    if (uniqueChanges.contains('deadline_reached')) {
      if (_shouldShowNotification(job.id, 'deadline_reached')) {
        onJobDeadlineReached?.call(job);
      }
      uniqueChanges.remove('deadline_reached');
    }

    if (uniqueChanges.contains('status')) {
      if (_shouldShowNotification(job.id, 'status')) {
        onJobStatusChanged?.call(job, job.status);
      }
      uniqueChanges.remove('status');
    }

    if (uniqueChanges.contains('salary')) {
      if (_shouldShowNotification(job.id, 'salary')) {
        // We don't have oldJob here, so we'll create a generic notification
        _showGenericJobChangeNotification(
          job,
          'Salario actualizado para ${job.title}',
          Colors.blue,
        );
      }
      uniqueChanges.remove('salary');
    }

    // Handle remaining changes
    if (uniqueChanges.isNotEmpty) {
      final remainingCount = uniqueChanges.length;

      if (_shouldShowNotification(job.id, 'multiple_updates')) {
        String message;

        if (remainingCount == 1) {
          // Single remaining change - show specific message
          message = _getSingleChangeMessage(job, uniqueChanges.first);
        } else {
          // Multiple changes - show generic message
          message =
              'El trabajo "${job.title}" se ha actualizado ($remainingCount cambios)';
        }

        _showGenericJobChangeNotification(job, message, Colors.orange);
      }
    }

    // Call the general onJobUpdated callback
    onJobUpdated?.call(job, null);
  }

  // Get specific message for a single change type
  String _getSingleChangeMessage(Job job, String changeType) {
    switch (changeType) {
      case 'modality':
        return 'Modalidad actualizada para "${job.title}": ${job.modality}';
      case 'type':
        return 'Tipo de trabajo actualizado para "${job.title}": ${job.type}';
      case 'location':
        return 'Ubicación actualizada para "${job.title}": ${job.location}';
      case 'skills':
        return 'Habilidades requeridas actualizadas para "${job.title}"';
      case 'maxApplications':
        return 'Límite de aplicaciones actualizado para "${job.title}": ${job.maxApplications}';
      case 'description':
        return 'Descripción actualizada para "${job.title}"';
      case 'title':
        return 'Título actualizado a: "${job.title}"';
      case 'companyName':
        return 'Empresa actualizada para "${job.title}": ${job.companyName}';
      case 'deadline_change':
        String deadlineText =
            job.applicationDeadline != null
                ? _formatDate(job.applicationDeadline!)
                : 'Sin fecha límite';
        return 'Fecha límite actualizada para "${job.title}": $deadlineText';
      case 'views_milestone':
        return 'El trabajo "${job.title}" alcanzó ${job.viewsCount} visualizaciones';
      default:
        return 'El trabajo "${job.title}" se ha actualizado';
    }
  }

  // Check if notification for this job was recently shown
  bool _shouldShowNotification(String jobId, String notificationType) {
    final now = DateTime.now();
    final key = '$jobId-$notificationType';

    // Check if we've notified about this job+type recently (within 10 seconds)
    if (_recentJobNotifications.containsKey(key)) {
      final lastNotified = _recentJobNotifications[key]!;
      if (now.difference(lastNotified).inSeconds < 10) {
        return false; // Too recent, don't show again
      }
    }

    // Update the notification timestamp
    _recentJobNotifications[key] = now;

    // Clean up old entries from the map to prevent memory leaks
    _recentJobNotifications.removeWhere(
      (k, v) => now.difference(v).inSeconds > 60,
    );

    return true; // OK to show notification
  }

  // Helper method to compare skill lists
  bool _areSkillListsEqual(List<String>? list1, List<String>? list2) {
    if (list1 == null && list2 == null) return true;
    if (list1 == null || list2 == null) return false;
    if (list1.length != list2.length) return false;

    // Sort both lists and compare
    final sorted1 = List<String>.from(list1)..sort();
    final sorted2 = List<String>.from(list2)..sort();

    for (int i = 0; i < sorted1.length; i++) {
      if (sorted1[i] != sorted2[i]) return false;
    }
    return true;
  }

  // Helper method to compare dates
  bool? _areDatesEqual(DateTime? date1, DateTime? date2) {
    if (date1 == null && date2 == null) return true;
    if (date1 == null || date2 == null) return false;
    return date1.isAtSameMomentAs(date2);
  }

  // Helper method to format dates
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Helper method to show generic job change notifications
  void _showGenericJobChangeNotification(Job job, String message, Color color) {
    // This method can be called by the mixin or handled by callbacks
    // For now, we'll use the existing onJobUpdated callback to handle it
    print('🔔 Notificación: $message para ${job.title}');
  }

  Future<void> stopListening() async {
    if (_channel != null) {
      try {
        await _channel!.unsubscribe();
        _channel = null;
        print('🛑 Jobs realtime listener detenido');
      } catch (e) {
        print('⚠️ Error stopping jobs listener: $e');
        // Force cleanup even if error occurs
        _channel = null;
      }
    }
  }

  bool get isListening => _channel != null;

  void dispose() {
    // Cancel all pending timers
    for (final timer in _jobUpdateTimers.values) {
      timer?.cancel();
    }
    _jobUpdateTimers.clear();
    _pendingJobChanges.clear();

    stopListening();
  }
}

// Provider for the singleton instance
final jobsRealtimeListenerProvider = Provider<JobsRealtimeListener>((ref) {
  return JobsRealtimeListener();
});

// Provider for jobs state management with realtime updates
final realtimeJobsProvider =
    StateNotifierProvider<RealtimeJobsNotifier, List<Job>>((ref) {
      return RealtimeJobsNotifier(ref);
    });

class RealtimeJobsNotifier extends StateNotifier<List<Job>> {
  final Ref ref;
  JobsRealtimeListener? _listener;

  RealtimeJobsNotifier(this.ref) : super([]) {
    _initializeRealtimeListener();
  }

  void _initializeRealtimeListener() {
    _listener = ref.read(jobsRealtimeListenerProvider);
    _listener!.startListening(
      onJobCreated: (newJob) {
        state = [newJob, ...state];
      },
      onJobUpdated: (newJob, oldJob) {
        state = state.map((job) => job.id == newJob.id ? newJob : job).toList();
      },
      onJobDeleted: (deletedJob) {
        state = state.where((job) => job.id != deletedJob.id).toList();
      },
    );
  }

  void setJobs(List<Job> jobs) {
    state = jobs;
  }

  void addJob(Job job) {
    state = [job, ...state];
  }

  void updateJob(Job updatedJob) {
    state =
        state.map((job) => job.id == updatedJob.id ? updatedJob : job).toList();
  }

  void removeJob(String jobId) {
    state = state.where((job) => job.id != jobId).toList();
  }

  @override
  void dispose() {
    _listener?.dispose();
    super.dispose();
  }
}

// Utility functions for job status and deadline checking
class JobUtils {
  static bool isJobApplicationAvailable(Job job) {
    if (job.status.toLowerCase() != 'open') return false;

    if (job.applicationDeadline != null) {
      try {
        final deadline = DateTime.parse(job.applicationDeadline.toString());
        return deadline.isAfter(DateTime.now());
      } catch (e) {
        print('Error parsing deadline: ${job.applicationDeadline}');
        return false;
      }
    }

    return true;
  }

  static bool isJobExpired(Job job) {
    if (job.applicationDeadline != null) {
      try {
        final deadline = DateTime.parse(job.applicationDeadline.toString());
        return deadline.isBefore(DateTime.now());
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  static String getJobUnavailabilityReason(Job job) {
    if (job.status.toLowerCase() == 'closed') {
      return 'Esta oferta de trabajo ha sido cerrada';
    }

    if (job.status.toLowerCase() == 'paused') {
      return 'Esta oferta de trabajo está pausada temporalmente';
    }

    if (job.applicationDeadline != null) {
      final deadline = DateTime.parse(job.applicationDeadline.toString());
      if (deadline.isBefore(DateTime.now())) {
        return 'La fecha límite de aplicación ha vencido (${_formatDate(deadline)})';
      }
    }

    return 'Esta oferta no está disponible para aplicar';
  }

  static String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.green;
      case 'closed':
        return Colors.red;
      case 'paused':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  static IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Icons.check_circle;
      case 'closed':
        return Icons.cancel;
      case 'paused':
        return Icons.pause_circle;
      default:
        return Icons.help;
    }
  }
}

// Prevent showing too many notifications for the same job
String _getDisplayStatus(String status) {
  switch (status.toLowerCase()) {
    case 'open':
      return 'Abierto';
    case 'closed':
      return 'Cerrado';
    case 'paused':
      return 'Pausado';
    default:
      return status; // Return original if unknown
  }
}

// Mixin for widgets that need job realtime updates
mixin JobRealtimeUpdatesMixin<T extends StatefulWidget> on State<T> {
  JobsRealtimeListener? _jobsListener;
  bool _isInitializing = false;
  List<Job> _jobs = [];

  // Keep track of shown notifications to prevent duplicates
  final Map<String, DateTime> _shownNotifications = {};

  void initializeJobsListener({
    Function(Job)? onJobCreated,
    Function(Job, Job?)? onJobUpdated,
    Function(Job)? onJobDeleted,
    Function(Job)? onJobDeadlineReached,
    Function(Job, String)? onJobStatusChanged,
  }) {
    // Prevent multiple initializations
    if (_isInitializing || _jobsListener != null) return;
    _isInitializing = true;

    _jobsListener = JobsRealtimeListener();
    _jobsListener!.startListening(
      onJobCreated: (newJob) {
        if (mounted) {
          setState(() {
            _jobs = [newJob, ..._jobs];
          });
          onJobCreated?.call(newJob);
          _showNotificationOverlay(
            'Nuevo trabajo disponible: ${newJob.title}',
            Colors.green,
          );
        }
      },
      onJobUpdated: (newJob, oldJob) {
        if (mounted) {
          setState(() {
            final index = _jobs.indexWhere((job) => job.id == newJob.id);
            if (index != -1) {
              _jobs[index] = newJob;
            }
          });
          onJobUpdated?.call(newJob, oldJob);
        }
      },
      onJobDeleted: (deletedJob) {
        if (mounted) {
          setState(() {
            _jobs.removeWhere((job) => job.id == deletedJob.id);
          });
          onJobDeleted?.call(deletedJob);
          _showNotificationOverlay(
            'Trabajo eliminado: ${deletedJob.title}',
            Colors.red,
          );
        }
      },
      onJobDeadlineReached: (job) {
        if (mounted) {
          onJobDeadlineReached?.call(job);
          // Show a notification only if we haven't recently shown one for this job
          if (_canShowNotification(job.id, 'deadline')) {
            _showNotificationOverlay(
              'Fecha límite vencida para: ${job.title}',
              Colors.orange,
            );
          }
        }
      },
      onJobStatusChanged: (job, newStatus) {
        if (mounted) {
          onJobStatusChanged?.call(job, newStatus);
          // Show a notification only if we haven't recently shown one for this job
          if (_canShowNotification(job.id, 'status')) {
            _showNotificationOverlay(
              '${job.title} cambió a: ${_getDisplayStatus(newStatus)}',
              JobUtils.getStatusColor(newStatus),
            );
          }
        }
      },
      onJobSalaryChanged: (job, oldJob) {
        if (mounted && _canShowNotification(job.id, 'salary')) {
          final oldRange =
              '${oldJob?.salaryMin ?? "N/A"} - ${oldJob?.salaryMax ?? "N/A"}';
          final newRange = '${job.salaryMin} - ${job.salaryMax}';
          _showNotificationOverlay(
            'Salario actualizado para ${job.title}: $oldRange → $newRange',
            Colors.blue,
          );
        }
      },
    );
    _isInitializing = false;
  }

  // Prevent showing too many notifications for the same job
  bool _canShowNotification(String jobId, String type) {
    final now = DateTime.now();
    final key = "$jobId-$type";

    if (_shownNotifications.containsKey(key)) {
      final lastShown = _shownNotifications[key]!;
      if (now.difference(lastShown).inSeconds < 5) {
        return false; // Don't show notifications more than once every 5 seconds
      }
    }

    _shownNotifications[key] = now;

    // Clean up old notifications (older than 1 minute)
    _shownNotifications.removeWhere((k, v) => now.difference(v).inMinutes > 1);

    return true;
  }

  // New method to show notification overlays instead of snackbars
  void _showNotificationOverlay(
    String message,
    Color color, {
    int? fitPercentage,
  }) {
    if (!mounted) return;

    // Find the overlay
    final overlay = Overlay.of(context);

    // Create a unique key for this notification
    final key = GlobalKey<NotificationOverlayState>();

    // Declare entry variable first
    late OverlayEntry entry;

    // Create an overlay entry
    entry = OverlayEntry(
      builder:
          (context) => NotificationOverlay(
            key: key,
            message: message,
            fitPercentage: fitPercentage,
            onDismiss: () {
              // Remove entry from overlay on dismiss
              entry.remove();
            },
          ),
    );

    // Insert the overlay entry
    overlay.insert(entry);

    // Auto-dismiss after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (entry.mounted) {
        entry.remove();
      }
    });
  }

  void setJobsList(List<Job> jobs) {
    setState(() {
      _jobs = jobs;
    });
  }

  List<Job> get jobs => _jobs;

  void disposeJobsListener() {
    _jobsListener?.dispose();
  }

  @override
  void dispose() {
    disposeJobsListener();
    super.dispose();
  }
}

// Add a provider to control animation skipping
