// Reminder settings screen: shows all active reminders and allows toggling them.
// Also shows notification permission status and lets user re-grant if denied.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../database/app_database.dart';
import '../../../services/notification_service.dart';

class ReminderSettingsScreen extends ConsumerStatefulWidget {
  const ReminderSettingsScreen({super.key});

  @override
  ConsumerState<ReminderSettingsScreen> createState() =>
      _ReminderSettingsScreenState();
}

class _ReminderSettingsScreenState
    extends ConsumerState<ReminderSettingsScreen> {
  bool _requesting = false;

  Future<void> _requestPermissions() async {
    setState(() => _requesting = true);
    final granted = await NotificationService.requestPermissions();
    if (!mounted) return;
    setState(() => _requesting = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          granted
              ? 'Permessi notifiche concessi!'
              : 'Permessi negati. Abilita le notifiche dalle Impostazioni del dispositivo.',
        ),
        backgroundColor: granted ? Colors.green[700] : Colors.red[700],
      ),
    );
    if (granted) {
      final db = ref.read(appDatabaseProvider);
      await NotificationService.scheduleAllReminders(db);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Impostazioni promemoria')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Permission card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.notifications_active, size: 28, color: Color(0xFF1565C0)),
                      SizedBox(width: 12),
                      Text(
                        'Permessi notifiche',
                        style: TextStyle(
                          fontSize: AppConstants.bodyFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Per ricevere i promemoria è necessario abilitare le notifiche. '
                    'Se non le ricevi, tocca il pulsante qui sotto.',
                    style: TextStyle(
                      fontSize: AppConstants.labelFontSize,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: AppConstants.minButtonHeight,
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: _requesting
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.check_circle_outline),
                      label: Text(
                        _requesting ? 'Richiesta in corso…' : 'Abilita notifiche',
                        style: const TextStyle(fontSize: AppConstants.bodyFontSize),
                      ),
                      onPressed: _requesting ? null : _requestPermissions,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Reschedule card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.refresh, size: 28, color: Color(0xFF1565C0)),
                      SizedBox(width: 12),
                      Text(
                        'Ripristina promemoria',
                        style: TextStyle(
                          fontSize: AppConstants.bodyFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Se i promemoria non arrivano (es. dopo il riavvio del telefono), '
                    'tocca il pulsante per riprogrammarli tutti.',
                    style: TextStyle(
                      fontSize: AppConstants.labelFontSize,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: AppConstants.minButtonHeight,
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.schedule_send_outlined),
                      label: const Text(
                        'Riprogramma tutti',
                        style: TextStyle(fontSize: AppConstants.bodyFontSize),
                      ),
                      onPressed: () async {
                        final db = ref.read(appDatabaseProvider);
                        final messenger = ScaffoldMessenger.of(context);
                        await NotificationService.scheduleAllReminders(db);
                        if (!mounted) return;
                        messenger.showSnackBar(
                          const SnackBar(content: Text('Promemoria riprogrammati!')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Info section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Consiglio per Android',
                  style: TextStyle(
                    fontSize: AppConstants.labelFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Su alcuni telefoni (Xiaomi, Huawei, Samsung) l\'ottimizzazione batteria '
                  'può bloccare le notifiche. Vai in Impostazioni → App → MediRemind → '
                  'Batteria → "Nessuna restrizione" per riceverle sempre.',
                  style: TextStyle(
                    fontSize: AppConstants.labelFontSize,
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
