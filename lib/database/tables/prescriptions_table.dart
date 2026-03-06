// Prescriptions: stores scanned prescription metadata and AI output

import 'package:drift/drift.dart';

class Prescriptions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get imagePath => text()();
  DateTimeColumn get scanDate => dateTime()();
  // Raw OCR text extracted by ML Kit
  TextColumn get ocrRawText => text().nullable()();
  // Raw JSON output from the LLM
  TextColumn get rawAiOutput => text().nullable()();
  // Whether the user has confirmed the extracted medications
  BoolColumn get confirmed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
}
