import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sout_el_qaa/core/di/injection.dart';
import 'package:sout_el_qaa/core/storage/local_cache_service.dart';
import 'package:sout_el_qaa/features/complaints/presentation/widgets/complaint_list_card.dart';
import 'package:sout_el_qaa/main.dart';

/// Drives the app on a real simulator/device end-to-end using [WidgetTester], instead of OS-level
/// input injection (which needs a macOS Accessibility grant this sandbox can't obtain). Each stop
/// prints a unique `SCREEN:<name>` marker to stdout and then holds for a few seconds so an external
/// `xcrun simctl io screenshot` (run from the driving shell, watching for that marker) can capture the
/// real rendered frame — this is the Figma-Sync-pass runtime verification walkthrough, not a pass/fail
/// test suite, so it has no expect()s beyond "the app didn't crash".
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('full app walkthrough for visual verification', (tester) async {
    await LocalCacheService.init();
    configureDependencies();

    await tester.pumpWidget(const SoutElQaaApp());
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await _hold(tester, 'home');

    // Home -> Complaint Details (tap first trending card).
    await tester.tap(find.byType(ComplaintListCard).first);
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await _hold(tester, 'complaint_details');

    // Back to Home.
    await _goBack(tester);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Home -> Notifications (bell icon).
    await tester.tap(find.byIcon(Icons.notifications_outlined).first);
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await _hold(tester, 'notifications');
    await _goBack(tester);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Bottom nav -> Complaints List.
    await tester.tap(find.text('شكاوي').first);
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await _hold(tester, 'complaints_list');

    // Bottom nav -> Map.
    await tester.tap(find.text('الخريطة').first);
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await _hold(tester, 'map');

    // Bottom nav -> Create Complaint (center action button, step 1).
    await tester.tap(find.text('إضافة').first);
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await _hold(tester, 'create_complaint_step1');
    await _goBack(tester);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Bottom nav -> Profile.
    await tester.tap(find.text('الملف الشخصي').first);
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await _hold(tester, 'profile');

    // Back to Home for a clean final frame.
    await tester.tap(find.text('الرئيسية').first);
    await tester.pumpAndSettle(const Duration(seconds: 1));
  });
}

Future<void> _hold(WidgetTester tester, String name) async {
  await tester.pump();
  debugPrint('SCREEN:$name');
  // An external `xcrun simctl io screenshot`, driven by a human/agent watching this process's stdout
  // for the marker line above, needs a real wall-clock window to react and shoot.
  await Future<void>.delayed(const Duration(seconds: 8));
}

/// Pops the current route imperatively instead of tapping a back button — some pushed pages
/// (e.g. Create Complaint's entry form step) intentionally render with no back arrow at all per
/// Figma, relying only on the OS edge-swipe gesture, which a [WidgetTester] can't easily replicate.
Future<void> _goBack(WidgetTester tester) async {
  Navigator.of(tester.element(find.byType(Scaffold).last)).pop();
  await tester.pumpAndSettle(const Duration(seconds: 1));
}
