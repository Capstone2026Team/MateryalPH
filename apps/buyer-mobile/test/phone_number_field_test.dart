import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/widgets/phone_number_field.dart';

void main() {
  testWidgets(
    'country code is separate, normalizes local input and follows pasted numbers',
    (tester) async {
      var value = '';
      final form = GlobalKey<FormState>();
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: Scaffold(
            body: Form(
              key: form,
              child: PhoneNumberField(onChanged: (next) => value = next),
            ),
          ),
        ),
      );
      final input = find.byType(TextFormField);
      expect(
        tester
            .widget<DropdownButtonFormField<String>>(
              find.byType(DropdownButtonFormField<String>),
            )
            .initialValue,
        'PH',
      );
      expect(form.currentState!.validate(), isFalse);
      await tester.enterText(input, '0917 123 4567');
      await tester.pump();
      expect(value, '+639171234567');
      expect(form.currentState!.validate(), isTrue);
      await tester.enterText(input, '+1 (415) 555-0123');
      await tester.pump();
      expect(value, '+14155550123');
      expect(
        tester
            .widget<DropdownButtonFormField<String>>(
              find.byType(DropdownButtonFormField<String>),
            )
            .initialValue,
        'US',
      );
      expect(
        tester.widget<TextFormField>(input).controller!.text,
        '4155550123',
      );
      await tester.enterText(input, '');
      expect(value, '');
      expect(form.currentState!.validate(), isFalse);
    },
  );

  testWidgets(
    'country selection preserves entry; invalid input cannot emit a valid contact',
    (tester) async {
      var value = '';
      final form = GlobalKey<FormState>();
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: Scaffold(
            body: Form(
              key: form,
              child: PhoneNumberField(onChanged: (next) => value = next),
            ),
          ),
        ),
      );
      final input = find.byType(TextFormField);
      await tester.enterText(input, '91234567');
      // Exercise the dropdown callback without scrolling through 245 native menu items.
      tester
          .widget<DropdownButtonFormField<String>>(
            find.byType(DropdownButtonFormField<String>),
          )
          .onChanged!('SG');
      await tester.pump();
      expect(value, '+6591234567');
      for (final raw in [
        '+999123456789',
        '917abc1234567',
        '912345678901234567',
      ]) {
        await tester.enterText(input, raw);
        await tester.pump();
        expect(form.currentState!.validate(), isFalse);
      }
    },
  );
}
