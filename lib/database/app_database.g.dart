// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PrescriptionsTable extends Prescriptions
    with TableInfo<$PrescriptionsTable, Prescription> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrescriptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scanDateMeta = const VerificationMeta(
    'scanDate',
  );
  @override
  late final GeneratedColumn<DateTime> scanDate = GeneratedColumn<DateTime>(
    'scan_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ocrRawTextMeta = const VerificationMeta(
    'ocrRawText',
  );
  @override
  late final GeneratedColumn<String> ocrRawText = GeneratedColumn<String>(
    'ocr_raw_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rawAiOutputMeta = const VerificationMeta(
    'rawAiOutput',
  );
  @override
  late final GeneratedColumn<String> rawAiOutput = GeneratedColumn<String>(
    'raw_ai_output',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _confirmedMeta = const VerificationMeta(
    'confirmed',
  );
  @override
  late final GeneratedColumn<bool> confirmed = GeneratedColumn<bool>(
    'confirmed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("confirmed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    imagePath,
    scanDate,
    ocrRawText,
    rawAiOutput,
    confirmed,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prescriptions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Prescription> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    } else if (isInserting) {
      context.missing(_imagePathMeta);
    }
    if (data.containsKey('scan_date')) {
      context.handle(
        _scanDateMeta,
        scanDate.isAcceptableOrUnknown(data['scan_date']!, _scanDateMeta),
      );
    } else if (isInserting) {
      context.missing(_scanDateMeta);
    }
    if (data.containsKey('ocr_raw_text')) {
      context.handle(
        _ocrRawTextMeta,
        ocrRawText.isAcceptableOrUnknown(
          data['ocr_raw_text']!,
          _ocrRawTextMeta,
        ),
      );
    }
    if (data.containsKey('raw_ai_output')) {
      context.handle(
        _rawAiOutputMeta,
        rawAiOutput.isAcceptableOrUnknown(
          data['raw_ai_output']!,
          _rawAiOutputMeta,
        ),
      );
    }
    if (data.containsKey('confirmed')) {
      context.handle(
        _confirmedMeta,
        confirmed.isAcceptableOrUnknown(data['confirmed']!, _confirmedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Prescription map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Prescription(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      )!,
      scanDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scan_date'],
      )!,
      ocrRawText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ocr_raw_text'],
      ),
      rawAiOutput: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_ai_output'],
      ),
      confirmed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}confirmed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PrescriptionsTable createAlias(String alias) {
    return $PrescriptionsTable(attachedDatabase, alias);
  }
}

class Prescription extends DataClass implements Insertable<Prescription> {
  final int id;
  final String imagePath;
  final DateTime scanDate;
  final String? ocrRawText;
  final String? rawAiOutput;
  final bool confirmed;
  final DateTime createdAt;
  const Prescription({
    required this.id,
    required this.imagePath,
    required this.scanDate,
    this.ocrRawText,
    this.rawAiOutput,
    required this.confirmed,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['image_path'] = Variable<String>(imagePath);
    map['scan_date'] = Variable<DateTime>(scanDate);
    if (!nullToAbsent || ocrRawText != null) {
      map['ocr_raw_text'] = Variable<String>(ocrRawText);
    }
    if (!nullToAbsent || rawAiOutput != null) {
      map['raw_ai_output'] = Variable<String>(rawAiOutput);
    }
    map['confirmed'] = Variable<bool>(confirmed);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PrescriptionsCompanion toCompanion(bool nullToAbsent) {
    return PrescriptionsCompanion(
      id: Value(id),
      imagePath: Value(imagePath),
      scanDate: Value(scanDate),
      ocrRawText: ocrRawText == null && nullToAbsent
          ? const Value.absent()
          : Value(ocrRawText),
      rawAiOutput: rawAiOutput == null && nullToAbsent
          ? const Value.absent()
          : Value(rawAiOutput),
      confirmed: Value(confirmed),
      createdAt: Value(createdAt),
    );
  }

  factory Prescription.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Prescription(
      id: serializer.fromJson<int>(json['id']),
      imagePath: serializer.fromJson<String>(json['imagePath']),
      scanDate: serializer.fromJson<DateTime>(json['scanDate']),
      ocrRawText: serializer.fromJson<String?>(json['ocrRawText']),
      rawAiOutput: serializer.fromJson<String?>(json['rawAiOutput']),
      confirmed: serializer.fromJson<bool>(json['confirmed']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'imagePath': serializer.toJson<String>(imagePath),
      'scanDate': serializer.toJson<DateTime>(scanDate),
      'ocrRawText': serializer.toJson<String?>(ocrRawText),
      'rawAiOutput': serializer.toJson<String?>(rawAiOutput),
      'confirmed': serializer.toJson<bool>(confirmed),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Prescription copyWith({
    int? id,
    String? imagePath,
    DateTime? scanDate,
    Value<String?> ocrRawText = const Value.absent(),
    Value<String?> rawAiOutput = const Value.absent(),
    bool? confirmed,
    DateTime? createdAt,
  }) => Prescription(
    id: id ?? this.id,
    imagePath: imagePath ?? this.imagePath,
    scanDate: scanDate ?? this.scanDate,
    ocrRawText: ocrRawText.present ? ocrRawText.value : this.ocrRawText,
    rawAiOutput: rawAiOutput.present ? rawAiOutput.value : this.rawAiOutput,
    confirmed: confirmed ?? this.confirmed,
    createdAt: createdAt ?? this.createdAt,
  );
  Prescription copyWithCompanion(PrescriptionsCompanion data) {
    return Prescription(
      id: data.id.present ? data.id.value : this.id,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      scanDate: data.scanDate.present ? data.scanDate.value : this.scanDate,
      ocrRawText: data.ocrRawText.present
          ? data.ocrRawText.value
          : this.ocrRawText,
      rawAiOutput: data.rawAiOutput.present
          ? data.rawAiOutput.value
          : this.rawAiOutput,
      confirmed: data.confirmed.present ? data.confirmed.value : this.confirmed,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Prescription(')
          ..write('id: $id, ')
          ..write('imagePath: $imagePath, ')
          ..write('scanDate: $scanDate, ')
          ..write('ocrRawText: $ocrRawText, ')
          ..write('rawAiOutput: $rawAiOutput, ')
          ..write('confirmed: $confirmed, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    imagePath,
    scanDate,
    ocrRawText,
    rawAiOutput,
    confirmed,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Prescription &&
          other.id == this.id &&
          other.imagePath == this.imagePath &&
          other.scanDate == this.scanDate &&
          other.ocrRawText == this.ocrRawText &&
          other.rawAiOutput == this.rawAiOutput &&
          other.confirmed == this.confirmed &&
          other.createdAt == this.createdAt);
}

class PrescriptionsCompanion extends UpdateCompanion<Prescription> {
  final Value<int> id;
  final Value<String> imagePath;
  final Value<DateTime> scanDate;
  final Value<String?> ocrRawText;
  final Value<String?> rawAiOutput;
  final Value<bool> confirmed;
  final Value<DateTime> createdAt;
  const PrescriptionsCompanion({
    this.id = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.scanDate = const Value.absent(),
    this.ocrRawText = const Value.absent(),
    this.rawAiOutput = const Value.absent(),
    this.confirmed = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PrescriptionsCompanion.insert({
    this.id = const Value.absent(),
    required String imagePath,
    required DateTime scanDate,
    this.ocrRawText = const Value.absent(),
    this.rawAiOutput = const Value.absent(),
    this.confirmed = const Value.absent(),
    required DateTime createdAt,
  }) : imagePath = Value(imagePath),
       scanDate = Value(scanDate),
       createdAt = Value(createdAt);
  static Insertable<Prescription> custom({
    Expression<int>? id,
    Expression<String>? imagePath,
    Expression<DateTime>? scanDate,
    Expression<String>? ocrRawText,
    Expression<String>? rawAiOutput,
    Expression<bool>? confirmed,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (imagePath != null) 'image_path': imagePath,
      if (scanDate != null) 'scan_date': scanDate,
      if (ocrRawText != null) 'ocr_raw_text': ocrRawText,
      if (rawAiOutput != null) 'raw_ai_output': rawAiOutput,
      if (confirmed != null) 'confirmed': confirmed,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PrescriptionsCompanion copyWith({
    Value<int>? id,
    Value<String>? imagePath,
    Value<DateTime>? scanDate,
    Value<String?>? ocrRawText,
    Value<String?>? rawAiOutput,
    Value<bool>? confirmed,
    Value<DateTime>? createdAt,
  }) {
    return PrescriptionsCompanion(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      scanDate: scanDate ?? this.scanDate,
      ocrRawText: ocrRawText ?? this.ocrRawText,
      rawAiOutput: rawAiOutput ?? this.rawAiOutput,
      confirmed: confirmed ?? this.confirmed,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (scanDate.present) {
      map['scan_date'] = Variable<DateTime>(scanDate.value);
    }
    if (ocrRawText.present) {
      map['ocr_raw_text'] = Variable<String>(ocrRawText.value);
    }
    if (rawAiOutput.present) {
      map['raw_ai_output'] = Variable<String>(rawAiOutput.value);
    }
    if (confirmed.present) {
      map['confirmed'] = Variable<bool>(confirmed.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrescriptionsCompanion(')
          ..write('id: $id, ')
          ..write('imagePath: $imagePath, ')
          ..write('scanDate: $scanDate, ')
          ..write('ocrRawText: $ocrRawText, ')
          ..write('rawAiOutput: $rawAiOutput, ')
          ..write('confirmed: $confirmed, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MedicationsTable extends Medications
    with TableInfo<$MedicationsTable, Medication> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _prescriptionIdMeta = const VerificationMeta(
    'prescriptionId',
  );
  @override
  late final GeneratedColumn<int> prescriptionId = GeneratedColumn<int>(
    'prescription_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES prescriptions (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activePrincipleMeta = const VerificationMeta(
    'activePrinciple',
  );
  @override
  late final GeneratedColumn<String> activePrinciple = GeneratedColumn<String>(
    'active_principle',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _doseMeta = const VerificationMeta('dose');
  @override
  late final GeneratedColumn<double> dose = GeneratedColumn<double>(
    'dose',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frequencyDescriptionMeta =
      const VerificationMeta('frequencyDescription');
  @override
  late final GeneratedColumn<String> frequencyDescription =
      GeneratedColumn<String>(
        'frequency_description',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _timesPerDayMeta = const VerificationMeta(
    'timesPerDay',
  );
  @override
  late final GeneratedColumn<int> timesPerDay = GeneratedColumn<int>(
    'times_per_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    prescriptionId,
    name,
    activePrinciple,
    dose,
    unit,
    frequencyDescription,
    timesPerDay,
    startDate,
    endDate,
    notes,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medications';
  @override
  VerificationContext validateIntegrity(
    Insertable<Medication> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('prescription_id')) {
      context.handle(
        _prescriptionIdMeta,
        prescriptionId.isAcceptableOrUnknown(
          data['prescription_id']!,
          _prescriptionIdMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('active_principle')) {
      context.handle(
        _activePrincipleMeta,
        activePrinciple.isAcceptableOrUnknown(
          data['active_principle']!,
          _activePrincipleMeta,
        ),
      );
    }
    if (data.containsKey('dose')) {
      context.handle(
        _doseMeta,
        dose.isAcceptableOrUnknown(data['dose']!, _doseMeta),
      );
    } else if (isInserting) {
      context.missing(_doseMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('frequency_description')) {
      context.handle(
        _frequencyDescriptionMeta,
        frequencyDescription.isAcceptableOrUnknown(
          data['frequency_description']!,
          _frequencyDescriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_frequencyDescriptionMeta);
    }
    if (data.containsKey('times_per_day')) {
      context.handle(
        _timesPerDayMeta,
        timesPerDay.isAcceptableOrUnknown(
          data['times_per_day']!,
          _timesPerDayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_timesPerDayMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Medication map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Medication(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      prescriptionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prescription_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      activePrinciple: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}active_principle'],
      ),
      dose: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}dose'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      frequencyDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency_description'],
      )!,
      timesPerDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}times_per_day'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MedicationsTable createAlias(String alias) {
    return $MedicationsTable(attachedDatabase, alias);
  }
}

class Medication extends DataClass implements Insertable<Medication> {
  final int id;
  final int? prescriptionId;
  final String name;
  final String? activePrinciple;
  final double dose;
  final String unit;
  final String frequencyDescription;
  final int timesPerDay;
  final DateTime startDate;
  final DateTime? endDate;
  final String? notes;
  final bool isActive;
  final DateTime createdAt;
  const Medication({
    required this.id,
    this.prescriptionId,
    required this.name,
    this.activePrinciple,
    required this.dose,
    required this.unit,
    required this.frequencyDescription,
    required this.timesPerDay,
    required this.startDate,
    this.endDate,
    this.notes,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || prescriptionId != null) {
      map['prescription_id'] = Variable<int>(prescriptionId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || activePrinciple != null) {
      map['active_principle'] = Variable<String>(activePrinciple);
    }
    map['dose'] = Variable<double>(dose);
    map['unit'] = Variable<String>(unit);
    map['frequency_description'] = Variable<String>(frequencyDescription);
    map['times_per_day'] = Variable<int>(timesPerDay);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MedicationsCompanion toCompanion(bool nullToAbsent) {
    return MedicationsCompanion(
      id: Value(id),
      prescriptionId: prescriptionId == null && nullToAbsent
          ? const Value.absent()
          : Value(prescriptionId),
      name: Value(name),
      activePrinciple: activePrinciple == null && nullToAbsent
          ? const Value.absent()
          : Value(activePrinciple),
      dose: Value(dose),
      unit: Value(unit),
      frequencyDescription: Value(frequencyDescription),
      timesPerDay: Value(timesPerDay),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory Medication.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Medication(
      id: serializer.fromJson<int>(json['id']),
      prescriptionId: serializer.fromJson<int?>(json['prescriptionId']),
      name: serializer.fromJson<String>(json['name']),
      activePrinciple: serializer.fromJson<String?>(json['activePrinciple']),
      dose: serializer.fromJson<double>(json['dose']),
      unit: serializer.fromJson<String>(json['unit']),
      frequencyDescription: serializer.fromJson<String>(
        json['frequencyDescription'],
      ),
      timesPerDay: serializer.fromJson<int>(json['timesPerDay']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'prescriptionId': serializer.toJson<int?>(prescriptionId),
      'name': serializer.toJson<String>(name),
      'activePrinciple': serializer.toJson<String?>(activePrinciple),
      'dose': serializer.toJson<double>(dose),
      'unit': serializer.toJson<String>(unit),
      'frequencyDescription': serializer.toJson<String>(frequencyDescription),
      'timesPerDay': serializer.toJson<int>(timesPerDay),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'notes': serializer.toJson<String?>(notes),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Medication copyWith({
    int? id,
    Value<int?> prescriptionId = const Value.absent(),
    String? name,
    Value<String?> activePrinciple = const Value.absent(),
    double? dose,
    String? unit,
    String? frequencyDescription,
    int? timesPerDay,
    DateTime? startDate,
    Value<DateTime?> endDate = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
  }) => Medication(
    id: id ?? this.id,
    prescriptionId: prescriptionId.present
        ? prescriptionId.value
        : this.prescriptionId,
    name: name ?? this.name,
    activePrinciple: activePrinciple.present
        ? activePrinciple.value
        : this.activePrinciple,
    dose: dose ?? this.dose,
    unit: unit ?? this.unit,
    frequencyDescription: frequencyDescription ?? this.frequencyDescription,
    timesPerDay: timesPerDay ?? this.timesPerDay,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    notes: notes.present ? notes.value : this.notes,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  Medication copyWithCompanion(MedicationsCompanion data) {
    return Medication(
      id: data.id.present ? data.id.value : this.id,
      prescriptionId: data.prescriptionId.present
          ? data.prescriptionId.value
          : this.prescriptionId,
      name: data.name.present ? data.name.value : this.name,
      activePrinciple: data.activePrinciple.present
          ? data.activePrinciple.value
          : this.activePrinciple,
      dose: data.dose.present ? data.dose.value : this.dose,
      unit: data.unit.present ? data.unit.value : this.unit,
      frequencyDescription: data.frequencyDescription.present
          ? data.frequencyDescription.value
          : this.frequencyDescription,
      timesPerDay: data.timesPerDay.present
          ? data.timesPerDay.value
          : this.timesPerDay,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Medication(')
          ..write('id: $id, ')
          ..write('prescriptionId: $prescriptionId, ')
          ..write('name: $name, ')
          ..write('activePrinciple: $activePrinciple, ')
          ..write('dose: $dose, ')
          ..write('unit: $unit, ')
          ..write('frequencyDescription: $frequencyDescription, ')
          ..write('timesPerDay: $timesPerDay, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    prescriptionId,
    name,
    activePrinciple,
    dose,
    unit,
    frequencyDescription,
    timesPerDay,
    startDate,
    endDate,
    notes,
    isActive,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Medication &&
          other.id == this.id &&
          other.prescriptionId == this.prescriptionId &&
          other.name == this.name &&
          other.activePrinciple == this.activePrinciple &&
          other.dose == this.dose &&
          other.unit == this.unit &&
          other.frequencyDescription == this.frequencyDescription &&
          other.timesPerDay == this.timesPerDay &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.notes == this.notes &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class MedicationsCompanion extends UpdateCompanion<Medication> {
  final Value<int> id;
  final Value<int?> prescriptionId;
  final Value<String> name;
  final Value<String?> activePrinciple;
  final Value<double> dose;
  final Value<String> unit;
  final Value<String> frequencyDescription;
  final Value<int> timesPerDay;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<String?> notes;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const MedicationsCompanion({
    this.id = const Value.absent(),
    this.prescriptionId = const Value.absent(),
    this.name = const Value.absent(),
    this.activePrinciple = const Value.absent(),
    this.dose = const Value.absent(),
    this.unit = const Value.absent(),
    this.frequencyDescription = const Value.absent(),
    this.timesPerDay = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MedicationsCompanion.insert({
    this.id = const Value.absent(),
    this.prescriptionId = const Value.absent(),
    required String name,
    this.activePrinciple = const Value.absent(),
    required double dose,
    required String unit,
    required String frequencyDescription,
    required int timesPerDay,
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
  }) : name = Value(name),
       dose = Value(dose),
       unit = Value(unit),
       frequencyDescription = Value(frequencyDescription),
       timesPerDay = Value(timesPerDay),
       startDate = Value(startDate),
       createdAt = Value(createdAt);
  static Insertable<Medication> custom({
    Expression<int>? id,
    Expression<int>? prescriptionId,
    Expression<String>? name,
    Expression<String>? activePrinciple,
    Expression<double>? dose,
    Expression<String>? unit,
    Expression<String>? frequencyDescription,
    Expression<int>? timesPerDay,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? notes,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (prescriptionId != null) 'prescription_id': prescriptionId,
      if (name != null) 'name': name,
      if (activePrinciple != null) 'active_principle': activePrinciple,
      if (dose != null) 'dose': dose,
      if (unit != null) 'unit': unit,
      if (frequencyDescription != null)
        'frequency_description': frequencyDescription,
      if (timesPerDay != null) 'times_per_day': timesPerDay,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (notes != null) 'notes': notes,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MedicationsCompanion copyWith({
    Value<int>? id,
    Value<int?>? prescriptionId,
    Value<String>? name,
    Value<String?>? activePrinciple,
    Value<double>? dose,
    Value<String>? unit,
    Value<String>? frequencyDescription,
    Value<int>? timesPerDay,
    Value<DateTime>? startDate,
    Value<DateTime?>? endDate,
    Value<String?>? notes,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
  }) {
    return MedicationsCompanion(
      id: id ?? this.id,
      prescriptionId: prescriptionId ?? this.prescriptionId,
      name: name ?? this.name,
      activePrinciple: activePrinciple ?? this.activePrinciple,
      dose: dose ?? this.dose,
      unit: unit ?? this.unit,
      frequencyDescription: frequencyDescription ?? this.frequencyDescription,
      timesPerDay: timesPerDay ?? this.timesPerDay,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (prescriptionId.present) {
      map['prescription_id'] = Variable<int>(prescriptionId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (activePrinciple.present) {
      map['active_principle'] = Variable<String>(activePrinciple.value);
    }
    if (dose.present) {
      map['dose'] = Variable<double>(dose.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (frequencyDescription.present) {
      map['frequency_description'] = Variable<String>(
        frequencyDescription.value,
      );
    }
    if (timesPerDay.present) {
      map['times_per_day'] = Variable<int>(timesPerDay.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationsCompanion(')
          ..write('id: $id, ')
          ..write('prescriptionId: $prescriptionId, ')
          ..write('name: $name, ')
          ..write('activePrinciple: $activePrinciple, ')
          ..write('dose: $dose, ')
          ..write('unit: $unit, ')
          ..write('frequencyDescription: $frequencyDescription, ')
          ..write('timesPerDay: $timesPerDay, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _medicationIdMeta = const VerificationMeta(
    'medicationId',
  );
  @override
  late final GeneratedColumn<int> medicationId = GeneratedColumn<int>(
    'medication_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medications (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _hourMeta = const VerificationMeta('hour');
  @override
  late final GeneratedColumn<int> hour = GeneratedColumn<int>(
    'hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minuteMeta = const VerificationMeta('minute');
  @override
  late final GeneratedColumn<int> minute = GeneratedColumn<int>(
    'minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _daysOfWeekMeta = const VerificationMeta(
    'daysOfWeek',
  );
  @override
  late final GeneratedColumn<String> daysOfWeek = GeneratedColumn<String>(
    'days_of_week',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _notificationIdMeta = const VerificationMeta(
    'notificationId',
  );
  @override
  late final GeneratedColumn<int> notificationId = GeneratedColumn<int>(
    'notification_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicationId,
    hour,
    minute,
    daysOfWeek,
    notificationId,
    enabled,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reminder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('medication_id')) {
      context.handle(
        _medicationIdMeta,
        medicationId.isAcceptableOrUnknown(
          data['medication_id']!,
          _medicationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('hour')) {
      context.handle(
        _hourMeta,
        hour.isAcceptableOrUnknown(data['hour']!, _hourMeta),
      );
    } else if (isInserting) {
      context.missing(_hourMeta);
    }
    if (data.containsKey('minute')) {
      context.handle(
        _minuteMeta,
        minute.isAcceptableOrUnknown(data['minute']!, _minuteMeta),
      );
    } else if (isInserting) {
      context.missing(_minuteMeta);
    }
    if (data.containsKey('days_of_week')) {
      context.handle(
        _daysOfWeekMeta,
        daysOfWeek.isAcceptableOrUnknown(
          data['days_of_week']!,
          _daysOfWeekMeta,
        ),
      );
    }
    if (data.containsKey('notification_id')) {
      context.handle(
        _notificationIdMeta,
        notificationId.isAcceptableOrUnknown(
          data['notification_id']!,
          _notificationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_notificationIdMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      medicationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}medication_id'],
      )!,
      hour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hour'],
      )!,
      minute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minute'],
      )!,
      daysOfWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}days_of_week'],
      )!,
      notificationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}notification_id'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final int id;
  final int medicationId;
  final int hour;
  final int minute;
  final String daysOfWeek;
  final int notificationId;
  final bool enabled;
  final DateTime createdAt;
  const Reminder({
    required this.id,
    required this.medicationId,
    required this.hour,
    required this.minute,
    required this.daysOfWeek,
    required this.notificationId,
    required this.enabled,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['medication_id'] = Variable<int>(medicationId);
    map['hour'] = Variable<int>(hour);
    map['minute'] = Variable<int>(minute);
    map['days_of_week'] = Variable<String>(daysOfWeek);
    map['notification_id'] = Variable<int>(notificationId);
    map['enabled'] = Variable<bool>(enabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      medicationId: Value(medicationId),
      hour: Value(hour),
      minute: Value(minute),
      daysOfWeek: Value(daysOfWeek),
      notificationId: Value(notificationId),
      enabled: Value(enabled),
      createdAt: Value(createdAt),
    );
  }

  factory Reminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<int>(json['id']),
      medicationId: serializer.fromJson<int>(json['medicationId']),
      hour: serializer.fromJson<int>(json['hour']),
      minute: serializer.fromJson<int>(json['minute']),
      daysOfWeek: serializer.fromJson<String>(json['daysOfWeek']),
      notificationId: serializer.fromJson<int>(json['notificationId']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'medicationId': serializer.toJson<int>(medicationId),
      'hour': serializer.toJson<int>(hour),
      'minute': serializer.toJson<int>(minute),
      'daysOfWeek': serializer.toJson<String>(daysOfWeek),
      'notificationId': serializer.toJson<int>(notificationId),
      'enabled': serializer.toJson<bool>(enabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Reminder copyWith({
    int? id,
    int? medicationId,
    int? hour,
    int? minute,
    String? daysOfWeek,
    int? notificationId,
    bool? enabled,
    DateTime? createdAt,
  }) => Reminder(
    id: id ?? this.id,
    medicationId: medicationId ?? this.medicationId,
    hour: hour ?? this.hour,
    minute: minute ?? this.minute,
    daysOfWeek: daysOfWeek ?? this.daysOfWeek,
    notificationId: notificationId ?? this.notificationId,
    enabled: enabled ?? this.enabled,
    createdAt: createdAt ?? this.createdAt,
  );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      medicationId: data.medicationId.present
          ? data.medicationId.value
          : this.medicationId,
      hour: data.hour.present ? data.hour.value : this.hour,
      minute: data.minute.present ? data.minute.value : this.minute,
      daysOfWeek: data.daysOfWeek.present
          ? data.daysOfWeek.value
          : this.daysOfWeek,
      notificationId: data.notificationId.present
          ? data.notificationId.value
          : this.notificationId,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute, ')
          ..write('daysOfWeek: $daysOfWeek, ')
          ..write('notificationId: $notificationId, ')
          ..write('enabled: $enabled, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    medicationId,
    hour,
    minute,
    daysOfWeek,
    notificationId,
    enabled,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.medicationId == this.medicationId &&
          other.hour == this.hour &&
          other.minute == this.minute &&
          other.daysOfWeek == this.daysOfWeek &&
          other.notificationId == this.notificationId &&
          other.enabled == this.enabled &&
          other.createdAt == this.createdAt);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<int> id;
  final Value<int> medicationId;
  final Value<int> hour;
  final Value<int> minute;
  final Value<String> daysOfWeek;
  final Value<int> notificationId;
  final Value<bool> enabled;
  final Value<DateTime> createdAt;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.hour = const Value.absent(),
    this.minute = const Value.absent(),
    this.daysOfWeek = const Value.absent(),
    this.notificationId = const Value.absent(),
    this.enabled = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RemindersCompanion.insert({
    this.id = const Value.absent(),
    required int medicationId,
    required int hour,
    required int minute,
    this.daysOfWeek = const Value.absent(),
    required int notificationId,
    this.enabled = const Value.absent(),
    required DateTime createdAt,
  }) : medicationId = Value(medicationId),
       hour = Value(hour),
       minute = Value(minute),
       notificationId = Value(notificationId),
       createdAt = Value(createdAt);
  static Insertable<Reminder> custom({
    Expression<int>? id,
    Expression<int>? medicationId,
    Expression<int>? hour,
    Expression<int>? minute,
    Expression<String>? daysOfWeek,
    Expression<int>? notificationId,
    Expression<bool>? enabled,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicationId != null) 'medication_id': medicationId,
      if (hour != null) 'hour': hour,
      if (minute != null) 'minute': minute,
      if (daysOfWeek != null) 'days_of_week': daysOfWeek,
      if (notificationId != null) 'notification_id': notificationId,
      if (enabled != null) 'enabled': enabled,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RemindersCompanion copyWith({
    Value<int>? id,
    Value<int>? medicationId,
    Value<int>? hour,
    Value<int>? minute,
    Value<String>? daysOfWeek,
    Value<int>? notificationId,
    Value<bool>? enabled,
    Value<DateTime>? createdAt,
  }) {
    return RemindersCompanion(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      notificationId: notificationId ?? this.notificationId,
      enabled: enabled ?? this.enabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<int>(medicationId.value);
    }
    if (hour.present) {
      map['hour'] = Variable<int>(hour.value);
    }
    if (minute.present) {
      map['minute'] = Variable<int>(minute.value);
    }
    if (daysOfWeek.present) {
      map['days_of_week'] = Variable<String>(daysOfWeek.value);
    }
    if (notificationId.present) {
      map['notification_id'] = Variable<int>(notificationId.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute, ')
          ..write('daysOfWeek: $daysOfWeek, ')
          ..write('notificationId: $notificationId, ')
          ..write('enabled: $enabled, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DoseLogsTable extends DoseLogs with TableInfo<$DoseLogsTable, DoseLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DoseLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _reminderIdMeta = const VerificationMeta(
    'reminderId',
  );
  @override
  late final GeneratedColumn<int> reminderId = GeneratedColumn<int>(
    'reminder_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES reminders (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _scheduledAtMeta = const VerificationMeta(
    'scheduledAt',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
    'scheduled_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _takenAtMeta = const VerificationMeta(
    'takenAt',
  );
  @override
  late final GeneratedColumn<DateTime> takenAt = GeneratedColumn<DateTime>(
    'taken_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _skippedMeta = const VerificationMeta(
    'skipped',
  );
  @override
  late final GeneratedColumn<bool> skipped = GeneratedColumn<bool>(
    'skipped',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("skipped" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _skipReasonMeta = const VerificationMeta(
    'skipReason',
  );
  @override
  late final GeneratedColumn<String> skipReason = GeneratedColumn<String>(
    'skip_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    reminderId,
    scheduledAt,
    takenAt,
    skipped,
    skipReason,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dose_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<DoseLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('reminder_id')) {
      context.handle(
        _reminderIdMeta,
        reminderId.isAcceptableOrUnknown(data['reminder_id']!, _reminderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_reminderIdMeta);
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
        _scheduledAtMeta,
        scheduledAt.isAcceptableOrUnknown(
          data['scheduled_at']!,
          _scheduledAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('taken_at')) {
      context.handle(
        _takenAtMeta,
        takenAt.isAcceptableOrUnknown(data['taken_at']!, _takenAtMeta),
      );
    }
    if (data.containsKey('skipped')) {
      context.handle(
        _skippedMeta,
        skipped.isAcceptableOrUnknown(data['skipped']!, _skippedMeta),
      );
    }
    if (data.containsKey('skip_reason')) {
      context.handle(
        _skipReasonMeta,
        skipReason.isAcceptableOrUnknown(data['skip_reason']!, _skipReasonMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DoseLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DoseLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      reminderId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_id'],
      )!,
      scheduledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_at'],
      )!,
      takenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}taken_at'],
      ),
      skipped: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}skipped'],
      )!,
      skipReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}skip_reason'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $DoseLogsTable createAlias(String alias) {
    return $DoseLogsTable(attachedDatabase, alias);
  }
}

class DoseLog extends DataClass implements Insertable<DoseLog> {
  final int id;
  final int reminderId;
  final DateTime scheduledAt;
  final DateTime? takenAt;
  final bool skipped;
  final String? skipReason;
  final String? notes;
  const DoseLog({
    required this.id,
    required this.reminderId,
    required this.scheduledAt,
    this.takenAt,
    required this.skipped,
    this.skipReason,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['reminder_id'] = Variable<int>(reminderId);
    map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    if (!nullToAbsent || takenAt != null) {
      map['taken_at'] = Variable<DateTime>(takenAt);
    }
    map['skipped'] = Variable<bool>(skipped);
    if (!nullToAbsent || skipReason != null) {
      map['skip_reason'] = Variable<String>(skipReason);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  DoseLogsCompanion toCompanion(bool nullToAbsent) {
    return DoseLogsCompanion(
      id: Value(id),
      reminderId: Value(reminderId),
      scheduledAt: Value(scheduledAt),
      takenAt: takenAt == null && nullToAbsent
          ? const Value.absent()
          : Value(takenAt),
      skipped: Value(skipped),
      skipReason: skipReason == null && nullToAbsent
          ? const Value.absent()
          : Value(skipReason),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory DoseLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DoseLog(
      id: serializer.fromJson<int>(json['id']),
      reminderId: serializer.fromJson<int>(json['reminderId']),
      scheduledAt: serializer.fromJson<DateTime>(json['scheduledAt']),
      takenAt: serializer.fromJson<DateTime?>(json['takenAt']),
      skipped: serializer.fromJson<bool>(json['skipped']),
      skipReason: serializer.fromJson<String?>(json['skipReason']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'reminderId': serializer.toJson<int>(reminderId),
      'scheduledAt': serializer.toJson<DateTime>(scheduledAt),
      'takenAt': serializer.toJson<DateTime?>(takenAt),
      'skipped': serializer.toJson<bool>(skipped),
      'skipReason': serializer.toJson<String?>(skipReason),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  DoseLog copyWith({
    int? id,
    int? reminderId,
    DateTime? scheduledAt,
    Value<DateTime?> takenAt = const Value.absent(),
    bool? skipped,
    Value<String?> skipReason = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => DoseLog(
    id: id ?? this.id,
    reminderId: reminderId ?? this.reminderId,
    scheduledAt: scheduledAt ?? this.scheduledAt,
    takenAt: takenAt.present ? takenAt.value : this.takenAt,
    skipped: skipped ?? this.skipped,
    skipReason: skipReason.present ? skipReason.value : this.skipReason,
    notes: notes.present ? notes.value : this.notes,
  );
  DoseLog copyWithCompanion(DoseLogsCompanion data) {
    return DoseLog(
      id: data.id.present ? data.id.value : this.id,
      reminderId: data.reminderId.present
          ? data.reminderId.value
          : this.reminderId,
      scheduledAt: data.scheduledAt.present
          ? data.scheduledAt.value
          : this.scheduledAt,
      takenAt: data.takenAt.present ? data.takenAt.value : this.takenAt,
      skipped: data.skipped.present ? data.skipped.value : this.skipped,
      skipReason: data.skipReason.present
          ? data.skipReason.value
          : this.skipReason,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DoseLog(')
          ..write('id: $id, ')
          ..write('reminderId: $reminderId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('takenAt: $takenAt, ')
          ..write('skipped: $skipped, ')
          ..write('skipReason: $skipReason, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    reminderId,
    scheduledAt,
    takenAt,
    skipped,
    skipReason,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DoseLog &&
          other.id == this.id &&
          other.reminderId == this.reminderId &&
          other.scheduledAt == this.scheduledAt &&
          other.takenAt == this.takenAt &&
          other.skipped == this.skipped &&
          other.skipReason == this.skipReason &&
          other.notes == this.notes);
}

class DoseLogsCompanion extends UpdateCompanion<DoseLog> {
  final Value<int> id;
  final Value<int> reminderId;
  final Value<DateTime> scheduledAt;
  final Value<DateTime?> takenAt;
  final Value<bool> skipped;
  final Value<String?> skipReason;
  final Value<String?> notes;
  const DoseLogsCompanion({
    this.id = const Value.absent(),
    this.reminderId = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.takenAt = const Value.absent(),
    this.skipped = const Value.absent(),
    this.skipReason = const Value.absent(),
    this.notes = const Value.absent(),
  });
  DoseLogsCompanion.insert({
    this.id = const Value.absent(),
    required int reminderId,
    required DateTime scheduledAt,
    this.takenAt = const Value.absent(),
    this.skipped = const Value.absent(),
    this.skipReason = const Value.absent(),
    this.notes = const Value.absent(),
  }) : reminderId = Value(reminderId),
       scheduledAt = Value(scheduledAt);
  static Insertable<DoseLog> custom({
    Expression<int>? id,
    Expression<int>? reminderId,
    Expression<DateTime>? scheduledAt,
    Expression<DateTime>? takenAt,
    Expression<bool>? skipped,
    Expression<String>? skipReason,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (reminderId != null) 'reminder_id': reminderId,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (takenAt != null) 'taken_at': takenAt,
      if (skipped != null) 'skipped': skipped,
      if (skipReason != null) 'skip_reason': skipReason,
      if (notes != null) 'notes': notes,
    });
  }

  DoseLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? reminderId,
    Value<DateTime>? scheduledAt,
    Value<DateTime?>? takenAt,
    Value<bool>? skipped,
    Value<String?>? skipReason,
    Value<String?>? notes,
  }) {
    return DoseLogsCompanion(
      id: id ?? this.id,
      reminderId: reminderId ?? this.reminderId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      takenAt: takenAt ?? this.takenAt,
      skipped: skipped ?? this.skipped,
      skipReason: skipReason ?? this.skipReason,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (reminderId.present) {
      map['reminder_id'] = Variable<int>(reminderId.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (takenAt.present) {
      map['taken_at'] = Variable<DateTime>(takenAt.value);
    }
    if (skipped.present) {
      map['skipped'] = Variable<bool>(skipped.value);
    }
    if (skipReason.present) {
      map['skip_reason'] = Variable<String>(skipReason.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DoseLogsCompanion(')
          ..write('id: $id, ')
          ..write('reminderId: $reminderId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('takenAt: $takenAt, ')
          ..write('skipped: $skipped, ')
          ..write('skipReason: $skipReason, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $InteractionWarningsTable extends InteractionWarnings
    with TableInfo<$InteractionWarningsTable, InteractionWarning> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InteractionWarningsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _medAIdMeta = const VerificationMeta('medAId');
  @override
  late final GeneratedColumn<int> medAId = GeneratedColumn<int>(
    'med_a_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medications (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _medBIdMeta = const VerificationMeta('medBId');
  @override
  late final GeneratedColumn<int> medBId = GeneratedColumn<int>(
    'med_b_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medications (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _severityMeta = const VerificationMeta(
    'severity',
  );
  @override
  late final GeneratedColumn<String> severity = GeneratedColumn<String>(
    'severity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('local_db'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medAId,
    medBId,
    severity,
    description,
    source,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'interaction_warnings';
  @override
  VerificationContext validateIntegrity(
    Insertable<InteractionWarning> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('med_a_id')) {
      context.handle(
        _medAIdMeta,
        medAId.isAcceptableOrUnknown(data['med_a_id']!, _medAIdMeta),
      );
    } else if (isInserting) {
      context.missing(_medAIdMeta);
    }
    if (data.containsKey('med_b_id')) {
      context.handle(
        _medBIdMeta,
        medBId.isAcceptableOrUnknown(data['med_b_id']!, _medBIdMeta),
      );
    } else if (isInserting) {
      context.missing(_medBIdMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(
        _severityMeta,
        severity.isAcceptableOrUnknown(data['severity']!, _severityMeta),
      );
    } else if (isInserting) {
      context.missing(_severityMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InteractionWarning map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InteractionWarning(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      medAId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}med_a_id'],
      )!,
      medBId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}med_b_id'],
      )!,
      severity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}severity'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $InteractionWarningsTable createAlias(String alias) {
    return $InteractionWarningsTable(attachedDatabase, alias);
  }
}

class InteractionWarning extends DataClass
    implements Insertable<InteractionWarning> {
  final int id;
  final int medAId;
  final int medBId;
  final String severity;
  final String description;
  final String source;
  final DateTime createdAt;
  const InteractionWarning({
    required this.id,
    required this.medAId,
    required this.medBId,
    required this.severity,
    required this.description,
    required this.source,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['med_a_id'] = Variable<int>(medAId);
    map['med_b_id'] = Variable<int>(medBId);
    map['severity'] = Variable<String>(severity);
    map['description'] = Variable<String>(description);
    map['source'] = Variable<String>(source);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  InteractionWarningsCompanion toCompanion(bool nullToAbsent) {
    return InteractionWarningsCompanion(
      id: Value(id),
      medAId: Value(medAId),
      medBId: Value(medBId),
      severity: Value(severity),
      description: Value(description),
      source: Value(source),
      createdAt: Value(createdAt),
    );
  }

  factory InteractionWarning.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InteractionWarning(
      id: serializer.fromJson<int>(json['id']),
      medAId: serializer.fromJson<int>(json['medAId']),
      medBId: serializer.fromJson<int>(json['medBId']),
      severity: serializer.fromJson<String>(json['severity']),
      description: serializer.fromJson<String>(json['description']),
      source: serializer.fromJson<String>(json['source']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'medAId': serializer.toJson<int>(medAId),
      'medBId': serializer.toJson<int>(medBId),
      'severity': serializer.toJson<String>(severity),
      'description': serializer.toJson<String>(description),
      'source': serializer.toJson<String>(source),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  InteractionWarning copyWith({
    int? id,
    int? medAId,
    int? medBId,
    String? severity,
    String? description,
    String? source,
    DateTime? createdAt,
  }) => InteractionWarning(
    id: id ?? this.id,
    medAId: medAId ?? this.medAId,
    medBId: medBId ?? this.medBId,
    severity: severity ?? this.severity,
    description: description ?? this.description,
    source: source ?? this.source,
    createdAt: createdAt ?? this.createdAt,
  );
  InteractionWarning copyWithCompanion(InteractionWarningsCompanion data) {
    return InteractionWarning(
      id: data.id.present ? data.id.value : this.id,
      medAId: data.medAId.present ? data.medAId.value : this.medAId,
      medBId: data.medBId.present ? data.medBId.value : this.medBId,
      severity: data.severity.present ? data.severity.value : this.severity,
      description: data.description.present
          ? data.description.value
          : this.description,
      source: data.source.present ? data.source.value : this.source,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InteractionWarning(')
          ..write('id: $id, ')
          ..write('medAId: $medAId, ')
          ..write('medBId: $medBId, ')
          ..write('severity: $severity, ')
          ..write('description: $description, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, medAId, medBId, severity, description, source, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InteractionWarning &&
          other.id == this.id &&
          other.medAId == this.medAId &&
          other.medBId == this.medBId &&
          other.severity == this.severity &&
          other.description == this.description &&
          other.source == this.source &&
          other.createdAt == this.createdAt);
}

class InteractionWarningsCompanion extends UpdateCompanion<InteractionWarning> {
  final Value<int> id;
  final Value<int> medAId;
  final Value<int> medBId;
  final Value<String> severity;
  final Value<String> description;
  final Value<String> source;
  final Value<DateTime> createdAt;
  const InteractionWarningsCompanion({
    this.id = const Value.absent(),
    this.medAId = const Value.absent(),
    this.medBId = const Value.absent(),
    this.severity = const Value.absent(),
    this.description = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  InteractionWarningsCompanion.insert({
    this.id = const Value.absent(),
    required int medAId,
    required int medBId,
    required String severity,
    required String description,
    this.source = const Value.absent(),
    required DateTime createdAt,
  }) : medAId = Value(medAId),
       medBId = Value(medBId),
       severity = Value(severity),
       description = Value(description),
       createdAt = Value(createdAt);
  static Insertable<InteractionWarning> custom({
    Expression<int>? id,
    Expression<int>? medAId,
    Expression<int>? medBId,
    Expression<String>? severity,
    Expression<String>? description,
    Expression<String>? source,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medAId != null) 'med_a_id': medAId,
      if (medBId != null) 'med_b_id': medBId,
      if (severity != null) 'severity': severity,
      if (description != null) 'description': description,
      if (source != null) 'source': source,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  InteractionWarningsCompanion copyWith({
    Value<int>? id,
    Value<int>? medAId,
    Value<int>? medBId,
    Value<String>? severity,
    Value<String>? description,
    Value<String>? source,
    Value<DateTime>? createdAt,
  }) {
    return InteractionWarningsCompanion(
      id: id ?? this.id,
      medAId: medAId ?? this.medAId,
      medBId: medBId ?? this.medBId,
      severity: severity ?? this.severity,
      description: description ?? this.description,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (medAId.present) {
      map['med_a_id'] = Variable<int>(medAId.value);
    }
    if (medBId.present) {
      map['med_b_id'] = Variable<int>(medBId.value);
    }
    if (severity.present) {
      map['severity'] = Variable<String>(severity.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InteractionWarningsCompanion(')
          ..write('id: $id, ')
          ..write('medAId: $medAId, ')
          ..write('medBId: $medBId, ')
          ..write('severity: $severity, ')
          ..write('description: $description, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) =>
      AppSetting(key: key ?? this.key, value: value ?? this.value);
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PrescriptionsTable prescriptions = $PrescriptionsTable(this);
  late final $MedicationsTable medications = $MedicationsTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $DoseLogsTable doseLogs = $DoseLogsTable(this);
  late final $InteractionWarningsTable interactionWarnings =
      $InteractionWarningsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final MedicationsDao medicationsDao = MedicationsDao(
    this as AppDatabase,
  );
  late final RemindersDao remindersDao = RemindersDao(this as AppDatabase);
  late final DoseLogsDao doseLogsDao = DoseLogsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    prescriptions,
    medications,
    reminders,
    doseLogs,
    interactionWarnings,
    appSettings,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'medications',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reminders', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'reminders',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('dose_logs', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'medications',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('interaction_warnings', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'medications',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('interaction_warnings', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$PrescriptionsTableCreateCompanionBuilder =
    PrescriptionsCompanion Function({
      Value<int> id,
      required String imagePath,
      required DateTime scanDate,
      Value<String?> ocrRawText,
      Value<String?> rawAiOutput,
      Value<bool> confirmed,
      required DateTime createdAt,
    });
typedef $$PrescriptionsTableUpdateCompanionBuilder =
    PrescriptionsCompanion Function({
      Value<int> id,
      Value<String> imagePath,
      Value<DateTime> scanDate,
      Value<String?> ocrRawText,
      Value<String?> rawAiOutput,
      Value<bool> confirmed,
      Value<DateTime> createdAt,
    });

final class $$PrescriptionsTableReferences
    extends BaseReferences<_$AppDatabase, $PrescriptionsTable, Prescription> {
  $$PrescriptionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$MedicationsTable, List<Medication>>
  _medicationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.medications,
    aliasName: $_aliasNameGenerator(
      db.prescriptions.id,
      db.medications.prescriptionId,
    ),
  );

  $$MedicationsTableProcessedTableManager get medicationsRefs {
    final manager = $$MedicationsTableTableManager(
      $_db,
      $_db.medications,
    ).filter((f) => f.prescriptionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_medicationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PrescriptionsTableFilterComposer
    extends Composer<_$AppDatabase, $PrescriptionsTable> {
  $$PrescriptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scanDate => $composableBuilder(
    column: $table.scanDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ocrRawText => $composableBuilder(
    column: $table.ocrRawText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawAiOutput => $composableBuilder(
    column: $table.rawAiOutput,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get confirmed => $composableBuilder(
    column: $table.confirmed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> medicationsRefs(
    Expression<bool> Function($$MedicationsTableFilterComposer f) f,
  ) {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.prescriptionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableFilterComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PrescriptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PrescriptionsTable> {
  $$PrescriptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scanDate => $composableBuilder(
    column: $table.scanDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ocrRawText => $composableBuilder(
    column: $table.ocrRawText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawAiOutput => $composableBuilder(
    column: $table.rawAiOutput,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get confirmed => $composableBuilder(
    column: $table.confirmed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PrescriptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrescriptionsTable> {
  $$PrescriptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<DateTime> get scanDate =>
      $composableBuilder(column: $table.scanDate, builder: (column) => column);

  GeneratedColumn<String> get ocrRawText => $composableBuilder(
    column: $table.ocrRawText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rawAiOutput => $composableBuilder(
    column: $table.rawAiOutput,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get confirmed =>
      $composableBuilder(column: $table.confirmed, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> medicationsRefs<T extends Object>(
    Expression<T> Function($$MedicationsTableAnnotationComposer a) f,
  ) {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.prescriptionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableAnnotationComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PrescriptionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PrescriptionsTable,
          Prescription,
          $$PrescriptionsTableFilterComposer,
          $$PrescriptionsTableOrderingComposer,
          $$PrescriptionsTableAnnotationComposer,
          $$PrescriptionsTableCreateCompanionBuilder,
          $$PrescriptionsTableUpdateCompanionBuilder,
          (Prescription, $$PrescriptionsTableReferences),
          Prescription,
          PrefetchHooks Function({bool medicationsRefs})
        > {
  $$PrescriptionsTableTableManager(_$AppDatabase db, $PrescriptionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrescriptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrescriptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrescriptionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> imagePath = const Value.absent(),
                Value<DateTime> scanDate = const Value.absent(),
                Value<String?> ocrRawText = const Value.absent(),
                Value<String?> rawAiOutput = const Value.absent(),
                Value<bool> confirmed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PrescriptionsCompanion(
                id: id,
                imagePath: imagePath,
                scanDate: scanDate,
                ocrRawText: ocrRawText,
                rawAiOutput: rawAiOutput,
                confirmed: confirmed,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String imagePath,
                required DateTime scanDate,
                Value<String?> ocrRawText = const Value.absent(),
                Value<String?> rawAiOutput = const Value.absent(),
                Value<bool> confirmed = const Value.absent(),
                required DateTime createdAt,
              }) => PrescriptionsCompanion.insert(
                id: id,
                imagePath: imagePath,
                scanDate: scanDate,
                ocrRawText: ocrRawText,
                rawAiOutput: rawAiOutput,
                confirmed: confirmed,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PrescriptionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicationsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (medicationsRefs) db.medications],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (medicationsRefs)
                    await $_getPrefetchedData<
                      Prescription,
                      $PrescriptionsTable,
                      Medication
                    >(
                      currentTable: table,
                      referencedTable: $$PrescriptionsTableReferences
                          ._medicationsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PrescriptionsTableReferences(
                            db,
                            table,
                            p0,
                          ).medicationsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.prescriptionId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PrescriptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PrescriptionsTable,
      Prescription,
      $$PrescriptionsTableFilterComposer,
      $$PrescriptionsTableOrderingComposer,
      $$PrescriptionsTableAnnotationComposer,
      $$PrescriptionsTableCreateCompanionBuilder,
      $$PrescriptionsTableUpdateCompanionBuilder,
      (Prescription, $$PrescriptionsTableReferences),
      Prescription,
      PrefetchHooks Function({bool medicationsRefs})
    >;
typedef $$MedicationsTableCreateCompanionBuilder =
    MedicationsCompanion Function({
      Value<int> id,
      Value<int?> prescriptionId,
      required String name,
      Value<String?> activePrinciple,
      required double dose,
      required String unit,
      required String frequencyDescription,
      required int timesPerDay,
      required DateTime startDate,
      Value<DateTime?> endDate,
      Value<String?> notes,
      Value<bool> isActive,
      required DateTime createdAt,
    });
typedef $$MedicationsTableUpdateCompanionBuilder =
    MedicationsCompanion Function({
      Value<int> id,
      Value<int?> prescriptionId,
      Value<String> name,
      Value<String?> activePrinciple,
      Value<double> dose,
      Value<String> unit,
      Value<String> frequencyDescription,
      Value<int> timesPerDay,
      Value<DateTime> startDate,
      Value<DateTime?> endDate,
      Value<String?> notes,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });

final class $$MedicationsTableReferences
    extends BaseReferences<_$AppDatabase, $MedicationsTable, Medication> {
  $$MedicationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PrescriptionsTable _prescriptionIdTable(_$AppDatabase db) =>
      db.prescriptions.createAlias(
        $_aliasNameGenerator(
          db.medications.prescriptionId,
          db.prescriptions.id,
        ),
      );

  $$PrescriptionsTableProcessedTableManager? get prescriptionId {
    final $_column = $_itemColumn<int>('prescription_id');
    if ($_column == null) return null;
    final manager = $$PrescriptionsTableTableManager(
      $_db,
      $_db.prescriptions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_prescriptionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$RemindersTable, List<Reminder>>
  _remindersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reminders,
    aliasName: $_aliasNameGenerator(
      db.medications.id,
      db.reminders.medicationId,
    ),
  );

  $$RemindersTableProcessedTableManager get remindersRefs {
    final manager = $$RemindersTableTableManager(
      $_db,
      $_db.reminders,
    ).filter((f) => f.medicationId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_remindersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MedicationsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activePrinciple => $composableBuilder(
    column: $table.activePrinciple,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get dose => $composableBuilder(
    column: $table.dose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequencyDescription => $composableBuilder(
    column: $table.frequencyDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timesPerDay => $composableBuilder(
    column: $table.timesPerDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PrescriptionsTableFilterComposer get prescriptionId {
    final $$PrescriptionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.prescriptionId,
      referencedTable: $db.prescriptions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrescriptionsTableFilterComposer(
            $db: $db,
            $table: $db.prescriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> remindersRefs(
    Expression<bool> Function($$RemindersTableFilterComposer f) f,
  ) {
    final $$RemindersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.medicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableFilterComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicationsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activePrinciple => $composableBuilder(
    column: $table.activePrinciple,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get dose => $composableBuilder(
    column: $table.dose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequencyDescription => $composableBuilder(
    column: $table.frequencyDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timesPerDay => $composableBuilder(
    column: $table.timesPerDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PrescriptionsTableOrderingComposer get prescriptionId {
    final $$PrescriptionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.prescriptionId,
      referencedTable: $db.prescriptions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrescriptionsTableOrderingComposer(
            $db: $db,
            $table: $db.prescriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get activePrinciple => $composableBuilder(
    column: $table.activePrinciple,
    builder: (column) => column,
  );

  GeneratedColumn<double> get dose =>
      $composableBuilder(column: $table.dose, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get frequencyDescription => $composableBuilder(
    column: $table.frequencyDescription,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timesPerDay => $composableBuilder(
    column: $table.timesPerDay,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$PrescriptionsTableAnnotationComposer get prescriptionId {
    final $$PrescriptionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.prescriptionId,
      referencedTable: $db.prescriptions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrescriptionsTableAnnotationComposer(
            $db: $db,
            $table: $db.prescriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> remindersRefs<T extends Object>(
    Expression<T> Function($$RemindersTableAnnotationComposer a) f,
  ) {
    final $$RemindersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.medicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableAnnotationComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicationsTable,
          Medication,
          $$MedicationsTableFilterComposer,
          $$MedicationsTableOrderingComposer,
          $$MedicationsTableAnnotationComposer,
          $$MedicationsTableCreateCompanionBuilder,
          $$MedicationsTableUpdateCompanionBuilder,
          (Medication, $$MedicationsTableReferences),
          Medication,
          PrefetchHooks Function({bool prescriptionId, bool remindersRefs})
        > {
  $$MedicationsTableTableManager(_$AppDatabase db, $MedicationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> prescriptionId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> activePrinciple = const Value.absent(),
                Value<double> dose = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String> frequencyDescription = const Value.absent(),
                Value<int> timesPerDay = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MedicationsCompanion(
                id: id,
                prescriptionId: prescriptionId,
                name: name,
                activePrinciple: activePrinciple,
                dose: dose,
                unit: unit,
                frequencyDescription: frequencyDescription,
                timesPerDay: timesPerDay,
                startDate: startDate,
                endDate: endDate,
                notes: notes,
                isActive: isActive,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> prescriptionId = const Value.absent(),
                required String name,
                Value<String?> activePrinciple = const Value.absent(),
                required double dose,
                required String unit,
                required String frequencyDescription,
                required int timesPerDay,
                required DateTime startDate,
                Value<DateTime?> endDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required DateTime createdAt,
              }) => MedicationsCompanion.insert(
                id: id,
                prescriptionId: prescriptionId,
                name: name,
                activePrinciple: activePrinciple,
                dose: dose,
                unit: unit,
                frequencyDescription: frequencyDescription,
                timesPerDay: timesPerDay,
                startDate: startDate,
                endDate: endDate,
                notes: notes,
                isActive: isActive,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MedicationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({prescriptionId = false, remindersRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (remindersRefs) db.reminders],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (prescriptionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.prescriptionId,
                                    referencedTable:
                                        $$MedicationsTableReferences
                                            ._prescriptionIdTable(db),
                                    referencedColumn:
                                        $$MedicationsTableReferences
                                            ._prescriptionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (remindersRefs)
                        await $_getPrefetchedData<
                          Medication,
                          $MedicationsTable,
                          Reminder
                        >(
                          currentTable: table,
                          referencedTable: $$MedicationsTableReferences
                              ._remindersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicationsTableReferences(
                                db,
                                table,
                                p0,
                              ).remindersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.medicationId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MedicationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicationsTable,
      Medication,
      $$MedicationsTableFilterComposer,
      $$MedicationsTableOrderingComposer,
      $$MedicationsTableAnnotationComposer,
      $$MedicationsTableCreateCompanionBuilder,
      $$MedicationsTableUpdateCompanionBuilder,
      (Medication, $$MedicationsTableReferences),
      Medication,
      PrefetchHooks Function({bool prescriptionId, bool remindersRefs})
    >;
typedef $$RemindersTableCreateCompanionBuilder =
    RemindersCompanion Function({
      Value<int> id,
      required int medicationId,
      required int hour,
      required int minute,
      Value<String> daysOfWeek,
      required int notificationId,
      Value<bool> enabled,
      required DateTime createdAt,
    });
typedef $$RemindersTableUpdateCompanionBuilder =
    RemindersCompanion Function({
      Value<int> id,
      Value<int> medicationId,
      Value<int> hour,
      Value<int> minute,
      Value<String> daysOfWeek,
      Value<int> notificationId,
      Value<bool> enabled,
      Value<DateTime> createdAt,
    });

final class $$RemindersTableReferences
    extends BaseReferences<_$AppDatabase, $RemindersTable, Reminder> {
  $$RemindersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MedicationsTable _medicationIdTable(_$AppDatabase db) =>
      db.medications.createAlias(
        $_aliasNameGenerator(db.reminders.medicationId, db.medications.id),
      );

  $$MedicationsTableProcessedTableManager get medicationId {
    final $_column = $_itemColumn<int>('medication_id')!;

    final manager = $$MedicationsTableTableManager(
      $_db,
      $_db.medications,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$DoseLogsTable, List<DoseLog>> _doseLogsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.doseLogs,
    aliasName: $_aliasNameGenerator(db.reminders.id, db.doseLogs.reminderId),
  );

  $$DoseLogsTableProcessedTableManager get doseLogsRefs {
    final manager = $$DoseLogsTableTableManager(
      $_db,
      $_db.doseLogs,
    ).filter((f) => f.reminderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_doseLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hour => $composableBuilder(
    column: $table.hour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minute => $composableBuilder(
    column: $table.minute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get daysOfWeek => $composableBuilder(
    column: $table.daysOfWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicationsTableFilterComposer get medicationId {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableFilterComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> doseLogsRefs(
    Expression<bool> Function($$DoseLogsTableFilterComposer f) f,
  ) {
    final $$DoseLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.doseLogs,
      getReferencedColumn: (t) => t.reminderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DoseLogsTableFilterComposer(
            $db: $db,
            $table: $db.doseLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hour => $composableBuilder(
    column: $table.hour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minute => $composableBuilder(
    column: $table.minute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get daysOfWeek => $composableBuilder(
    column: $table.daysOfWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicationsTableOrderingComposer get medicationId {
    final $$MedicationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableOrderingComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get hour =>
      $composableBuilder(column: $table.hour, builder: (column) => column);

  GeneratedColumn<int> get minute =>
      $composableBuilder(column: $table.minute, builder: (column) => column);

  GeneratedColumn<String> get daysOfWeek => $composableBuilder(
    column: $table.daysOfWeek,
    builder: (column) => column,
  );

  GeneratedColumn<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MedicationsTableAnnotationComposer get medicationId {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableAnnotationComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> doseLogsRefs<T extends Object>(
    Expression<T> Function($$DoseLogsTableAnnotationComposer a) f,
  ) {
    final $$DoseLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.doseLogs,
      getReferencedColumn: (t) => t.reminderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DoseLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.doseLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTable,
          Reminder,
          $$RemindersTableFilterComposer,
          $$RemindersTableOrderingComposer,
          $$RemindersTableAnnotationComposer,
          $$RemindersTableCreateCompanionBuilder,
          $$RemindersTableUpdateCompanionBuilder,
          (Reminder, $$RemindersTableReferences),
          Reminder,
          PrefetchHooks Function({bool medicationId, bool doseLogsRefs})
        > {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> medicationId = const Value.absent(),
                Value<int> hour = const Value.absent(),
                Value<int> minute = const Value.absent(),
                Value<String> daysOfWeek = const Value.absent(),
                Value<int> notificationId = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RemindersCompanion(
                id: id,
                medicationId: medicationId,
                hour: hour,
                minute: minute,
                daysOfWeek: daysOfWeek,
                notificationId: notificationId,
                enabled: enabled,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int medicationId,
                required int hour,
                required int minute,
                Value<String> daysOfWeek = const Value.absent(),
                required int notificationId,
                Value<bool> enabled = const Value.absent(),
                required DateTime createdAt,
              }) => RemindersCompanion.insert(
                id: id,
                medicationId: medicationId,
                hour: hour,
                minute: minute,
                daysOfWeek: daysOfWeek,
                notificationId: notificationId,
                enabled: enabled,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RemindersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({medicationId = false, doseLogsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (doseLogsRefs) db.doseLogs],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (medicationId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.medicationId,
                                    referencedTable: $$RemindersTableReferences
                                        ._medicationIdTable(db),
                                    referencedColumn: $$RemindersTableReferences
                                        ._medicationIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (doseLogsRefs)
                        await $_getPrefetchedData<
                          Reminder,
                          $RemindersTable,
                          DoseLog
                        >(
                          currentTable: table,
                          referencedTable: $$RemindersTableReferences
                              ._doseLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RemindersTableReferences(
                                db,
                                table,
                                p0,
                              ).doseLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.reminderId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTable,
      Reminder,
      $$RemindersTableFilterComposer,
      $$RemindersTableOrderingComposer,
      $$RemindersTableAnnotationComposer,
      $$RemindersTableCreateCompanionBuilder,
      $$RemindersTableUpdateCompanionBuilder,
      (Reminder, $$RemindersTableReferences),
      Reminder,
      PrefetchHooks Function({bool medicationId, bool doseLogsRefs})
    >;
typedef $$DoseLogsTableCreateCompanionBuilder =
    DoseLogsCompanion Function({
      Value<int> id,
      required int reminderId,
      required DateTime scheduledAt,
      Value<DateTime?> takenAt,
      Value<bool> skipped,
      Value<String?> skipReason,
      Value<String?> notes,
    });
typedef $$DoseLogsTableUpdateCompanionBuilder =
    DoseLogsCompanion Function({
      Value<int> id,
      Value<int> reminderId,
      Value<DateTime> scheduledAt,
      Value<DateTime?> takenAt,
      Value<bool> skipped,
      Value<String?> skipReason,
      Value<String?> notes,
    });

final class $$DoseLogsTableReferences
    extends BaseReferences<_$AppDatabase, $DoseLogsTable, DoseLog> {
  $$DoseLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RemindersTable _reminderIdTable(_$AppDatabase db) =>
      db.reminders.createAlias(
        $_aliasNameGenerator(db.doseLogs.reminderId, db.reminders.id),
      );

  $$RemindersTableProcessedTableManager get reminderId {
    final $_column = $_itemColumn<int>('reminder_id')!;

    final manager = $$RemindersTableTableManager(
      $_db,
      $_db.reminders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_reminderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DoseLogsTableFilterComposer
    extends Composer<_$AppDatabase, $DoseLogsTable> {
  $$DoseLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get skipped => $composableBuilder(
    column: $table.skipped,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get skipReason => $composableBuilder(
    column: $table.skipReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$RemindersTableFilterComposer get reminderId {
    final $$RemindersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reminderId,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableFilterComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DoseLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $DoseLogsTable> {
  $$DoseLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get skipped => $composableBuilder(
    column: $table.skipped,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get skipReason => $composableBuilder(
    column: $table.skipReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$RemindersTableOrderingComposer get reminderId {
    final $$RemindersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reminderId,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableOrderingComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DoseLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DoseLogsTable> {
  $$DoseLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get takenAt =>
      $composableBuilder(column: $table.takenAt, builder: (column) => column);

  GeneratedColumn<bool> get skipped =>
      $composableBuilder(column: $table.skipped, builder: (column) => column);

  GeneratedColumn<String> get skipReason => $composableBuilder(
    column: $table.skipReason,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$RemindersTableAnnotationComposer get reminderId {
    final $$RemindersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reminderId,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableAnnotationComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DoseLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DoseLogsTable,
          DoseLog,
          $$DoseLogsTableFilterComposer,
          $$DoseLogsTableOrderingComposer,
          $$DoseLogsTableAnnotationComposer,
          $$DoseLogsTableCreateCompanionBuilder,
          $$DoseLogsTableUpdateCompanionBuilder,
          (DoseLog, $$DoseLogsTableReferences),
          DoseLog,
          PrefetchHooks Function({bool reminderId})
        > {
  $$DoseLogsTableTableManager(_$AppDatabase db, $DoseLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DoseLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DoseLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DoseLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> reminderId = const Value.absent(),
                Value<DateTime> scheduledAt = const Value.absent(),
                Value<DateTime?> takenAt = const Value.absent(),
                Value<bool> skipped = const Value.absent(),
                Value<String?> skipReason = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => DoseLogsCompanion(
                id: id,
                reminderId: reminderId,
                scheduledAt: scheduledAt,
                takenAt: takenAt,
                skipped: skipped,
                skipReason: skipReason,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int reminderId,
                required DateTime scheduledAt,
                Value<DateTime?> takenAt = const Value.absent(),
                Value<bool> skipped = const Value.absent(),
                Value<String?> skipReason = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => DoseLogsCompanion.insert(
                id: id,
                reminderId: reminderId,
                scheduledAt: scheduledAt,
                takenAt: takenAt,
                skipped: skipped,
                skipReason: skipReason,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DoseLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({reminderId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (reminderId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.reminderId,
                                referencedTable: $$DoseLogsTableReferences
                                    ._reminderIdTable(db),
                                referencedColumn: $$DoseLogsTableReferences
                                    ._reminderIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DoseLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DoseLogsTable,
      DoseLog,
      $$DoseLogsTableFilterComposer,
      $$DoseLogsTableOrderingComposer,
      $$DoseLogsTableAnnotationComposer,
      $$DoseLogsTableCreateCompanionBuilder,
      $$DoseLogsTableUpdateCompanionBuilder,
      (DoseLog, $$DoseLogsTableReferences),
      DoseLog,
      PrefetchHooks Function({bool reminderId})
    >;
typedef $$InteractionWarningsTableCreateCompanionBuilder =
    InteractionWarningsCompanion Function({
      Value<int> id,
      required int medAId,
      required int medBId,
      required String severity,
      required String description,
      Value<String> source,
      required DateTime createdAt,
    });
typedef $$InteractionWarningsTableUpdateCompanionBuilder =
    InteractionWarningsCompanion Function({
      Value<int> id,
      Value<int> medAId,
      Value<int> medBId,
      Value<String> severity,
      Value<String> description,
      Value<String> source,
      Value<DateTime> createdAt,
    });

final class $$InteractionWarningsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $InteractionWarningsTable,
          InteractionWarning
        > {
  $$InteractionWarningsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MedicationsTable _medAIdTable(_$AppDatabase db) =>
      db.medications.createAlias(
        $_aliasNameGenerator(db.interactionWarnings.medAId, db.medications.id),
      );

  $$MedicationsTableProcessedTableManager get medAId {
    final $_column = $_itemColumn<int>('med_a_id')!;

    final manager = $$MedicationsTableTableManager(
      $_db,
      $_db.medications,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medAIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MedicationsTable _medBIdTable(_$AppDatabase db) =>
      db.medications.createAlias(
        $_aliasNameGenerator(db.interactionWarnings.medBId, db.medications.id),
      );

  $$MedicationsTableProcessedTableManager get medBId {
    final $_column = $_itemColumn<int>('med_b_id')!;

    final manager = $$MedicationsTableTableManager(
      $_db,
      $_db.medications,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medBIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$InteractionWarningsTableFilterComposer
    extends Composer<_$AppDatabase, $InteractionWarningsTable> {
  $$InteractionWarningsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicationsTableFilterComposer get medAId {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medAId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableFilterComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MedicationsTableFilterComposer get medBId {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medBId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableFilterComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InteractionWarningsTableOrderingComposer
    extends Composer<_$AppDatabase, $InteractionWarningsTable> {
  $$InteractionWarningsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicationsTableOrderingComposer get medAId {
    final $$MedicationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medAId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableOrderingComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MedicationsTableOrderingComposer get medBId {
    final $$MedicationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medBId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableOrderingComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InteractionWarningsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InteractionWarningsTable> {
  $$InteractionWarningsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MedicationsTableAnnotationComposer get medAId {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medAId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableAnnotationComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MedicationsTableAnnotationComposer get medBId {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medBId,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableAnnotationComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InteractionWarningsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InteractionWarningsTable,
          InteractionWarning,
          $$InteractionWarningsTableFilterComposer,
          $$InteractionWarningsTableOrderingComposer,
          $$InteractionWarningsTableAnnotationComposer,
          $$InteractionWarningsTableCreateCompanionBuilder,
          $$InteractionWarningsTableUpdateCompanionBuilder,
          (InteractionWarning, $$InteractionWarningsTableReferences),
          InteractionWarning,
          PrefetchHooks Function({bool medAId, bool medBId})
        > {
  $$InteractionWarningsTableTableManager(
    _$AppDatabase db,
    $InteractionWarningsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InteractionWarningsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InteractionWarningsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$InteractionWarningsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> medAId = const Value.absent(),
                Value<int> medBId = const Value.absent(),
                Value<String> severity = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => InteractionWarningsCompanion(
                id: id,
                medAId: medAId,
                medBId: medBId,
                severity: severity,
                description: description,
                source: source,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int medAId,
                required int medBId,
                required String severity,
                required String description,
                Value<String> source = const Value.absent(),
                required DateTime createdAt,
              }) => InteractionWarningsCompanion.insert(
                id: id,
                medAId: medAId,
                medBId: medBId,
                severity: severity,
                description: description,
                source: source,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InteractionWarningsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medAId = false, medBId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (medAId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.medAId,
                                referencedTable:
                                    $$InteractionWarningsTableReferences
                                        ._medAIdTable(db),
                                referencedColumn:
                                    $$InteractionWarningsTableReferences
                                        ._medAIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (medBId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.medBId,
                                referencedTable:
                                    $$InteractionWarningsTableReferences
                                        ._medBIdTable(db),
                                referencedColumn:
                                    $$InteractionWarningsTableReferences
                                        ._medBIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$InteractionWarningsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InteractionWarningsTable,
      InteractionWarning,
      $$InteractionWarningsTableFilterComposer,
      $$InteractionWarningsTableOrderingComposer,
      $$InteractionWarningsTableAnnotationComposer,
      $$InteractionWarningsTableCreateCompanionBuilder,
      $$InteractionWarningsTableUpdateCompanionBuilder,
      (InteractionWarning, $$InteractionWarningsTableReferences),
      InteractionWarning,
      PrefetchHooks Function({bool medAId, bool medBId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PrescriptionsTableTableManager get prescriptions =>
      $$PrescriptionsTableTableManager(_db, _db.prescriptions);
  $$MedicationsTableTableManager get medications =>
      $$MedicationsTableTableManager(_db, _db.medications);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$DoseLogsTableTableManager get doseLogs =>
      $$DoseLogsTableTableManager(_db, _db.doseLogs);
  $$InteractionWarningsTableTableManager get interactionWarnings =>
      $$InteractionWarningsTableTableManager(_db, _db.interactionWarnings);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
