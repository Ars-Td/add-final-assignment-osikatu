// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $OshisTable extends Oshis with TableInfo<$OshisTable, Oshi> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OshisTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconPathMeta = const VerificationMeta(
    'iconPath',
  );
  @override
  late final GeneratedColumn<String> iconPath = GeneratedColumn<String>(
    'icon_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coverColorMeta = const VerificationMeta(
    'coverColor',
  );
  @override
  late final GeneratedColumn<int> coverColor = GeneratedColumn<int>(
    'cover_color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _birthdayMeta = const VerificationMeta(
    'birthday',
  );
  @override
  late final GeneratedColumn<String> birthday = GeneratedColumn<String>(
    'birthday',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
    'memo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isGroupMeta = const VerificationMeta(
    'isGroup',
  );
  @override
  late final GeneratedColumn<bool> isGroup = GeneratedColumn<bool>(
    'is_group',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_group" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastViewedAtMeta = const VerificationMeta(
    'lastViewedAt',
  );
  @override
  late final GeneratedColumn<String> lastViewedAt = GeneratedColumn<String>(
    'last_viewed_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    iconPath,
    coverColor,
    birthday,
    category,
    memo,
    isGroup,
    createdAt,
    lastViewedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'oshis';
  @override
  VerificationContext validateIntegrity(
    Insertable<Oshi> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon_path')) {
      context.handle(
        _iconPathMeta,
        iconPath.isAcceptableOrUnknown(data['icon_path']!, _iconPathMeta),
      );
    }
    if (data.containsKey('cover_color')) {
      context.handle(
        _coverColorMeta,
        coverColor.isAcceptableOrUnknown(data['cover_color']!, _coverColorMeta),
      );
    } else if (isInserting) {
      context.missing(_coverColorMeta);
    }
    if (data.containsKey('birthday')) {
      context.handle(
        _birthdayMeta,
        birthday.isAcceptableOrUnknown(data['birthday']!, _birthdayMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('memo')) {
      context.handle(
        _memoMeta,
        memo.isAcceptableOrUnknown(data['memo']!, _memoMeta),
      );
    }
    if (data.containsKey('is_group')) {
      context.handle(
        _isGroupMeta,
        isGroup.isAcceptableOrUnknown(data['is_group']!, _isGroupMeta),
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
    if (data.containsKey('last_viewed_at')) {
      context.handle(
        _lastViewedAtMeta,
        lastViewedAt.isAcceptableOrUnknown(
          data['last_viewed_at']!,
          _lastViewedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Oshi map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Oshi(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      iconPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_path'],
      ),
      coverColor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cover_color'],
      )!,
      birthday: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}birthday'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      memo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memo'],
      ),
      isGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_group'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      lastViewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_viewed_at'],
      ),
    );
  }

  @override
  $OshisTable createAlias(String alias) {
    return $OshisTable(attachedDatabase, alias);
  }
}

class Oshi extends DataClass implements Insertable<Oshi> {
  final int id;
  final String name;
  final String? iconPath;
  final int coverColor;
  final String? birthday;
  final String category;
  final String? memo;
  final bool isGroup;
  final String createdAt;
  final String? lastViewedAt;
  const Oshi({
    required this.id,
    required this.name,
    this.iconPath,
    required this.coverColor,
    this.birthday,
    required this.category,
    this.memo,
    required this.isGroup,
    required this.createdAt,
    this.lastViewedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || iconPath != null) {
      map['icon_path'] = Variable<String>(iconPath);
    }
    map['cover_color'] = Variable<int>(coverColor);
    if (!nullToAbsent || birthday != null) {
      map['birthday'] = Variable<String>(birthday);
    }
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    map['is_group'] = Variable<bool>(isGroup);
    map['created_at'] = Variable<String>(createdAt);
    if (!nullToAbsent || lastViewedAt != null) {
      map['last_viewed_at'] = Variable<String>(lastViewedAt);
    }
    return map;
  }

  OshisCompanion toCompanion(bool nullToAbsent) {
    return OshisCompanion(
      id: Value(id),
      name: Value(name),
      iconPath: iconPath == null && nullToAbsent
          ? const Value.absent()
          : Value(iconPath),
      coverColor: Value(coverColor),
      birthday: birthday == null && nullToAbsent
          ? const Value.absent()
          : Value(birthday),
      category: Value(category),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
      isGroup: Value(isGroup),
      createdAt: Value(createdAt),
      lastViewedAt: lastViewedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastViewedAt),
    );
  }

  factory Oshi.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Oshi(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      iconPath: serializer.fromJson<String?>(json['iconPath']),
      coverColor: serializer.fromJson<int>(json['coverColor']),
      birthday: serializer.fromJson<String?>(json['birthday']),
      category: serializer.fromJson<String>(json['category']),
      memo: serializer.fromJson<String?>(json['memo']),
      isGroup: serializer.fromJson<bool>(json['isGroup']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      lastViewedAt: serializer.fromJson<String?>(json['lastViewedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'iconPath': serializer.toJson<String?>(iconPath),
      'coverColor': serializer.toJson<int>(coverColor),
      'birthday': serializer.toJson<String?>(birthday),
      'category': serializer.toJson<String>(category),
      'memo': serializer.toJson<String?>(memo),
      'isGroup': serializer.toJson<bool>(isGroup),
      'createdAt': serializer.toJson<String>(createdAt),
      'lastViewedAt': serializer.toJson<String?>(lastViewedAt),
    };
  }

  Oshi copyWith({
    int? id,
    String? name,
    Value<String?> iconPath = const Value.absent(),
    int? coverColor,
    Value<String?> birthday = const Value.absent(),
    String? category,
    Value<String?> memo = const Value.absent(),
    bool? isGroup,
    String? createdAt,
    Value<String?> lastViewedAt = const Value.absent(),
  }) => Oshi(
    id: id ?? this.id,
    name: name ?? this.name,
    iconPath: iconPath.present ? iconPath.value : this.iconPath,
    coverColor: coverColor ?? this.coverColor,
    birthday: birthday.present ? birthday.value : this.birthday,
    category: category ?? this.category,
    memo: memo.present ? memo.value : this.memo,
    isGroup: isGroup ?? this.isGroup,
    createdAt: createdAt ?? this.createdAt,
    lastViewedAt: lastViewedAt.present ? lastViewedAt.value : this.lastViewedAt,
  );
  Oshi copyWithCompanion(OshisCompanion data) {
    return Oshi(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      iconPath: data.iconPath.present ? data.iconPath.value : this.iconPath,
      coverColor: data.coverColor.present
          ? data.coverColor.value
          : this.coverColor,
      birthday: data.birthday.present ? data.birthday.value : this.birthday,
      category: data.category.present ? data.category.value : this.category,
      memo: data.memo.present ? data.memo.value : this.memo,
      isGroup: data.isGroup.present ? data.isGroup.value : this.isGroup,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastViewedAt: data.lastViewedAt.present
          ? data.lastViewedAt.value
          : this.lastViewedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Oshi(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconPath: $iconPath, ')
          ..write('coverColor: $coverColor, ')
          ..write('birthday: $birthday, ')
          ..write('category: $category, ')
          ..write('memo: $memo, ')
          ..write('isGroup: $isGroup, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastViewedAt: $lastViewedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    iconPath,
    coverColor,
    birthday,
    category,
    memo,
    isGroup,
    createdAt,
    lastViewedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Oshi &&
          other.id == this.id &&
          other.name == this.name &&
          other.iconPath == this.iconPath &&
          other.coverColor == this.coverColor &&
          other.birthday == this.birthday &&
          other.category == this.category &&
          other.memo == this.memo &&
          other.isGroup == this.isGroup &&
          other.createdAt == this.createdAt &&
          other.lastViewedAt == this.lastViewedAt);
}

class OshisCompanion extends UpdateCompanion<Oshi> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> iconPath;
  final Value<int> coverColor;
  final Value<String?> birthday;
  final Value<String> category;
  final Value<String?> memo;
  final Value<bool> isGroup;
  final Value<String> createdAt;
  final Value<String?> lastViewedAt;
  const OshisCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.iconPath = const Value.absent(),
    this.coverColor = const Value.absent(),
    this.birthday = const Value.absent(),
    this.category = const Value.absent(),
    this.memo = const Value.absent(),
    this.isGroup = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastViewedAt = const Value.absent(),
  });
  OshisCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.iconPath = const Value.absent(),
    required int coverColor,
    this.birthday = const Value.absent(),
    required String category,
    this.memo = const Value.absent(),
    this.isGroup = const Value.absent(),
    required String createdAt,
    this.lastViewedAt = const Value.absent(),
  }) : name = Value(name),
       coverColor = Value(coverColor),
       category = Value(category),
       createdAt = Value(createdAt);
  static Insertable<Oshi> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? iconPath,
    Expression<int>? coverColor,
    Expression<String>? birthday,
    Expression<String>? category,
    Expression<String>? memo,
    Expression<bool>? isGroup,
    Expression<String>? createdAt,
    Expression<String>? lastViewedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (iconPath != null) 'icon_path': iconPath,
      if (coverColor != null) 'cover_color': coverColor,
      if (birthday != null) 'birthday': birthday,
      if (category != null) 'category': category,
      if (memo != null) 'memo': memo,
      if (isGroup != null) 'is_group': isGroup,
      if (createdAt != null) 'created_at': createdAt,
      if (lastViewedAt != null) 'last_viewed_at': lastViewedAt,
    });
  }

  OshisCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? iconPath,
    Value<int>? coverColor,
    Value<String?>? birthday,
    Value<String>? category,
    Value<String?>? memo,
    Value<bool>? isGroup,
    Value<String>? createdAt,
    Value<String?>? lastViewedAt,
  }) {
    return OshisCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      iconPath: iconPath ?? this.iconPath,
      coverColor: coverColor ?? this.coverColor,
      birthday: birthday ?? this.birthday,
      category: category ?? this.category,
      memo: memo ?? this.memo,
      isGroup: isGroup ?? this.isGroup,
      createdAt: createdAt ?? this.createdAt,
      lastViewedAt: lastViewedAt ?? this.lastViewedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (iconPath.present) {
      map['icon_path'] = Variable<String>(iconPath.value);
    }
    if (coverColor.present) {
      map['cover_color'] = Variable<int>(coverColor.value);
    }
    if (birthday.present) {
      map['birthday'] = Variable<String>(birthday.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (isGroup.present) {
      map['is_group'] = Variable<bool>(isGroup.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (lastViewedAt.present) {
      map['last_viewed_at'] = Variable<String>(lastViewedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OshisCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconPath: $iconPath, ')
          ..write('coverColor: $coverColor, ')
          ..write('birthday: $birthday, ')
          ..write('category: $category, ')
          ..write('memo: $memo, ')
          ..write('isGroup: $isGroup, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastViewedAt: $lastViewedAt')
          ..write(')'))
        .toString();
  }
}

class $EventsTable extends Events with TableInfo<$EventsTable, Event> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _oshiIdMeta = const VerificationMeta('oshiId');
  @override
  late final GeneratedColumn<int> oshiId = GeneratedColumn<int>(
    'oshi_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES oshis (id)',
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
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _venueMeta = const VerificationMeta('venue');
  @override
  late final GeneratedColumn<String> venue = GeneratedColumn<String>(
    'venue',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<int> totalAmount = GeneratedColumn<int>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
    'memo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathsMeta = const VerificationMeta(
    'photoPaths',
  );
  @override
  late final GeneratedColumn<String> photoPaths = GeneratedColumn<String>(
    'photo_paths',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    oshiId,
    name,
    date,
    venue,
    category,
    totalAmount,
    memo,
    photoPaths,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'events';
  @override
  VerificationContext validateIntegrity(
    Insertable<Event> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('oshi_id')) {
      context.handle(
        _oshiIdMeta,
        oshiId.isAcceptableOrUnknown(data['oshi_id']!, _oshiIdMeta),
      );
    } else if (isInserting) {
      context.missing(_oshiIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('venue')) {
      context.handle(
        _venueMeta,
        venue.isAcceptableOrUnknown(data['venue']!, _venueMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    }
    if (data.containsKey('memo')) {
      context.handle(
        _memoMeta,
        memo.isAcceptableOrUnknown(data['memo']!, _memoMeta),
      );
    }
    if (data.containsKey('photo_paths')) {
      context.handle(
        _photoPathsMeta,
        photoPaths.isAcceptableOrUnknown(data['photo_paths']!, _photoPathsMeta),
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
  Event map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Event(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      oshiId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}oshi_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      venue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}venue'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_amount'],
      )!,
      memo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memo'],
      ),
      photoPaths: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_paths'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(attachedDatabase, alias);
  }
}

class Event extends DataClass implements Insertable<Event> {
  final int id;
  final int oshiId;
  final String name;
  final String date;
  final String? venue;
  final String category;
  final int totalAmount;
  final String? memo;

  /// 写真パスの JSON 配列（例: '["path1","path2"]'）。null = 写真なし
  final String? photoPaths;
  final String createdAt;
  const Event({
    required this.id,
    required this.oshiId,
    required this.name,
    required this.date,
    this.venue,
    required this.category,
    required this.totalAmount,
    this.memo,
    this.photoPaths,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['oshi_id'] = Variable<int>(oshiId);
    map['name'] = Variable<String>(name);
    map['date'] = Variable<String>(date);
    if (!nullToAbsent || venue != null) {
      map['venue'] = Variable<String>(venue);
    }
    map['category'] = Variable<String>(category);
    map['total_amount'] = Variable<int>(totalAmount);
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    if (!nullToAbsent || photoPaths != null) {
      map['photo_paths'] = Variable<String>(photoPaths);
    }
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: Value(id),
      oshiId: Value(oshiId),
      name: Value(name),
      date: Value(date),
      venue: venue == null && nullToAbsent
          ? const Value.absent()
          : Value(venue),
      category: Value(category),
      totalAmount: Value(totalAmount),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
      photoPaths: photoPaths == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPaths),
      createdAt: Value(createdAt),
    );
  }

  factory Event.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Event(
      id: serializer.fromJson<int>(json['id']),
      oshiId: serializer.fromJson<int>(json['oshiId']),
      name: serializer.fromJson<String>(json['name']),
      date: serializer.fromJson<String>(json['date']),
      venue: serializer.fromJson<String?>(json['venue']),
      category: serializer.fromJson<String>(json['category']),
      totalAmount: serializer.fromJson<int>(json['totalAmount']),
      memo: serializer.fromJson<String?>(json['memo']),
      photoPaths: serializer.fromJson<String?>(json['photoPaths']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'oshiId': serializer.toJson<int>(oshiId),
      'name': serializer.toJson<String>(name),
      'date': serializer.toJson<String>(date),
      'venue': serializer.toJson<String?>(venue),
      'category': serializer.toJson<String>(category),
      'totalAmount': serializer.toJson<int>(totalAmount),
      'memo': serializer.toJson<String?>(memo),
      'photoPaths': serializer.toJson<String?>(photoPaths),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  Event copyWith({
    int? id,
    int? oshiId,
    String? name,
    String? date,
    Value<String?> venue = const Value.absent(),
    String? category,
    int? totalAmount,
    Value<String?> memo = const Value.absent(),
    Value<String?> photoPaths = const Value.absent(),
    String? createdAt,
  }) => Event(
    id: id ?? this.id,
    oshiId: oshiId ?? this.oshiId,
    name: name ?? this.name,
    date: date ?? this.date,
    venue: venue.present ? venue.value : this.venue,
    category: category ?? this.category,
    totalAmount: totalAmount ?? this.totalAmount,
    memo: memo.present ? memo.value : this.memo,
    photoPaths: photoPaths.present ? photoPaths.value : this.photoPaths,
    createdAt: createdAt ?? this.createdAt,
  );
  Event copyWithCompanion(EventsCompanion data) {
    return Event(
      id: data.id.present ? data.id.value : this.id,
      oshiId: data.oshiId.present ? data.oshiId.value : this.oshiId,
      name: data.name.present ? data.name.value : this.name,
      date: data.date.present ? data.date.value : this.date,
      venue: data.venue.present ? data.venue.value : this.venue,
      category: data.category.present ? data.category.value : this.category,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      memo: data.memo.present ? data.memo.value : this.memo,
      photoPaths: data.photoPaths.present
          ? data.photoPaths.value
          : this.photoPaths,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Event(')
          ..write('id: $id, ')
          ..write('oshiId: $oshiId, ')
          ..write('name: $name, ')
          ..write('date: $date, ')
          ..write('venue: $venue, ')
          ..write('category: $category, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('memo: $memo, ')
          ..write('photoPaths: $photoPaths, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    oshiId,
    name,
    date,
    venue,
    category,
    totalAmount,
    memo,
    photoPaths,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Event &&
          other.id == this.id &&
          other.oshiId == this.oshiId &&
          other.name == this.name &&
          other.date == this.date &&
          other.venue == this.venue &&
          other.category == this.category &&
          other.totalAmount == this.totalAmount &&
          other.memo == this.memo &&
          other.photoPaths == this.photoPaths &&
          other.createdAt == this.createdAt);
}

class EventsCompanion extends UpdateCompanion<Event> {
  final Value<int> id;
  final Value<int> oshiId;
  final Value<String> name;
  final Value<String> date;
  final Value<String?> venue;
  final Value<String> category;
  final Value<int> totalAmount;
  final Value<String?> memo;
  final Value<String?> photoPaths;
  final Value<String> createdAt;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.oshiId = const Value.absent(),
    this.name = const Value.absent(),
    this.date = const Value.absent(),
    this.venue = const Value.absent(),
    this.category = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.memo = const Value.absent(),
    this.photoPaths = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  EventsCompanion.insert({
    this.id = const Value.absent(),
    required int oshiId,
    required String name,
    required String date,
    this.venue = const Value.absent(),
    required String category,
    this.totalAmount = const Value.absent(),
    this.memo = const Value.absent(),
    this.photoPaths = const Value.absent(),
    required String createdAt,
  }) : oshiId = Value(oshiId),
       name = Value(name),
       date = Value(date),
       category = Value(category),
       createdAt = Value(createdAt);
  static Insertable<Event> custom({
    Expression<int>? id,
    Expression<int>? oshiId,
    Expression<String>? name,
    Expression<String>? date,
    Expression<String>? venue,
    Expression<String>? category,
    Expression<int>? totalAmount,
    Expression<String>? memo,
    Expression<String>? photoPaths,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (oshiId != null) 'oshi_id': oshiId,
      if (name != null) 'name': name,
      if (date != null) 'date': date,
      if (venue != null) 'venue': venue,
      if (category != null) 'category': category,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (memo != null) 'memo': memo,
      if (photoPaths != null) 'photo_paths': photoPaths,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  EventsCompanion copyWith({
    Value<int>? id,
    Value<int>? oshiId,
    Value<String>? name,
    Value<String>? date,
    Value<String?>? venue,
    Value<String>? category,
    Value<int>? totalAmount,
    Value<String?>? memo,
    Value<String?>? photoPaths,
    Value<String>? createdAt,
  }) {
    return EventsCompanion(
      id: id ?? this.id,
      oshiId: oshiId ?? this.oshiId,
      name: name ?? this.name,
      date: date ?? this.date,
      venue: venue ?? this.venue,
      category: category ?? this.category,
      totalAmount: totalAmount ?? this.totalAmount,
      memo: memo ?? this.memo,
      photoPaths: photoPaths ?? this.photoPaths,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (oshiId.present) {
      map['oshi_id'] = Variable<int>(oshiId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (venue.present) {
      map['venue'] = Variable<String>(venue.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<int>(totalAmount.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (photoPaths.present) {
      map['photo_paths'] = Variable<String>(photoPaths.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('oshiId: $oshiId, ')
          ..write('name: $name, ')
          ..write('date: $date, ')
          ..write('venue: $venue, ')
          ..write('category: $category, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('memo: $memo, ')
          ..write('photoPaths: $photoPaths, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $EventExpensesTable extends EventExpenses
    with TableInfo<$EventExpensesTable, EventExpense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventExpensesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<int> eventId = GeneratedColumn<int>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES events (id)',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, eventId, label, amount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'event_expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<EventExpense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventExpense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventExpense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}event_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
    );
  }

  @override
  $EventExpensesTable createAlias(String alias) {
    return $EventExpensesTable(attachedDatabase, alias);
  }
}

class EventExpense extends DataClass implements Insertable<EventExpense> {
  final int id;
  final int eventId;
  final String label;
  final int amount;
  const EventExpense({
    required this.id,
    required this.eventId,
    required this.label,
    required this.amount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['event_id'] = Variable<int>(eventId);
    map['label'] = Variable<String>(label);
    map['amount'] = Variable<int>(amount);
    return map;
  }

  EventExpensesCompanion toCompanion(bool nullToAbsent) {
    return EventExpensesCompanion(
      id: Value(id),
      eventId: Value(eventId),
      label: Value(label),
      amount: Value(amount),
    );
  }

  factory EventExpense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventExpense(
      id: serializer.fromJson<int>(json['id']),
      eventId: serializer.fromJson<int>(json['eventId']),
      label: serializer.fromJson<String>(json['label']),
      amount: serializer.fromJson<int>(json['amount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'eventId': serializer.toJson<int>(eventId),
      'label': serializer.toJson<String>(label),
      'amount': serializer.toJson<int>(amount),
    };
  }

  EventExpense copyWith({int? id, int? eventId, String? label, int? amount}) =>
      EventExpense(
        id: id ?? this.id,
        eventId: eventId ?? this.eventId,
        label: label ?? this.label,
        amount: amount ?? this.amount,
      );
  EventExpense copyWithCompanion(EventExpensesCompanion data) {
    return EventExpense(
      id: data.id.present ? data.id.value : this.id,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      label: data.label.present ? data.label.value : this.label,
      amount: data.amount.present ? data.amount.value : this.amount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventExpense(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('label: $label, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, eventId, label, amount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventExpense &&
          other.id == this.id &&
          other.eventId == this.eventId &&
          other.label == this.label &&
          other.amount == this.amount);
}

class EventExpensesCompanion extends UpdateCompanion<EventExpense> {
  final Value<int> id;
  final Value<int> eventId;
  final Value<String> label;
  final Value<int> amount;
  const EventExpensesCompanion({
    this.id = const Value.absent(),
    this.eventId = const Value.absent(),
    this.label = const Value.absent(),
    this.amount = const Value.absent(),
  });
  EventExpensesCompanion.insert({
    this.id = const Value.absent(),
    required int eventId,
    required String label,
    required int amount,
  }) : eventId = Value(eventId),
       label = Value(label),
       amount = Value(amount);
  static Insertable<EventExpense> custom({
    Expression<int>? id,
    Expression<int>? eventId,
    Expression<String>? label,
    Expression<int>? amount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventId != null) 'event_id': eventId,
      if (label != null) 'label': label,
      if (amount != null) 'amount': amount,
    });
  }

  EventExpensesCompanion copyWith({
    Value<int>? id,
    Value<int>? eventId,
    Value<String>? label,
    Value<int>? amount,
  }) {
    return EventExpensesCompanion(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      label: label ?? this.label,
      amount: amount ?? this.amount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<int>(eventId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventExpensesCompanion(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('label: $label, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }
}

class $GoodsTable extends Goods with TableInfo<$GoodsTable, Good> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoodsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _oshiIdMeta = const VerificationMeta('oshiId');
  @override
  late final GeneratedColumn<int> oshiId = GeneratedColumn<int>(
    'oshi_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES oshis (id)',
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
  static const VerificationMeta _purchaseDateMeta = const VerificationMeta(
    'purchaseDate',
  );
  @override
  late final GeneratedColumn<String> purchaseDate = GeneratedColumn<String>(
    'purchase_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shopMeta = const VerificationMeta('shop');
  @override
  late final GeneratedColumn<String> shop = GeneratedColumn<String>(
    'shop',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
    'memo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    oshiId,
    name,
    purchaseDate,
    category,
    amount,
    shop,
    quantity,
    imagePath,
    memo,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goods';
  @override
  VerificationContext validateIntegrity(
    Insertable<Good> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('oshi_id')) {
      context.handle(
        _oshiIdMeta,
        oshiId.isAcceptableOrUnknown(data['oshi_id']!, _oshiIdMeta),
      );
    } else if (isInserting) {
      context.missing(_oshiIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
        _purchaseDateMeta,
        purchaseDate.isAcceptableOrUnknown(
          data['purchase_date']!,
          _purchaseDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchaseDateMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('shop')) {
      context.handle(
        _shopMeta,
        shop.isAcceptableOrUnknown(data['shop']!, _shopMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('memo')) {
      context.handle(
        _memoMeta,
        memo.isAcceptableOrUnknown(data['memo']!, _memoMeta),
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
  Good map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Good(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      oshiId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}oshi_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      purchaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purchase_date'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      shop: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shop'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      memo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memo'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $GoodsTable createAlias(String alias) {
    return $GoodsTable(attachedDatabase, alias);
  }
}

class Good extends DataClass implements Insertable<Good> {
  final int id;
  final int oshiId;
  final String name;
  final String purchaseDate;
  final String category;
  final int amount;
  final String? shop;
  final int quantity;
  final String? imagePath;
  final String? memo;
  final String createdAt;
  const Good({
    required this.id,
    required this.oshiId,
    required this.name,
    required this.purchaseDate,
    required this.category,
    required this.amount,
    this.shop,
    required this.quantity,
    this.imagePath,
    this.memo,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['oshi_id'] = Variable<int>(oshiId);
    map['name'] = Variable<String>(name);
    map['purchase_date'] = Variable<String>(purchaseDate);
    map['category'] = Variable<String>(category);
    map['amount'] = Variable<int>(amount);
    if (!nullToAbsent || shop != null) {
      map['shop'] = Variable<String>(shop);
    }
    map['quantity'] = Variable<int>(quantity);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  GoodsCompanion toCompanion(bool nullToAbsent) {
    return GoodsCompanion(
      id: Value(id),
      oshiId: Value(oshiId),
      name: Value(name),
      purchaseDate: Value(purchaseDate),
      category: Value(category),
      amount: Value(amount),
      shop: shop == null && nullToAbsent ? const Value.absent() : Value(shop),
      quantity: Value(quantity),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
      createdAt: Value(createdAt),
    );
  }

  factory Good.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Good(
      id: serializer.fromJson<int>(json['id']),
      oshiId: serializer.fromJson<int>(json['oshiId']),
      name: serializer.fromJson<String>(json['name']),
      purchaseDate: serializer.fromJson<String>(json['purchaseDate']),
      category: serializer.fromJson<String>(json['category']),
      amount: serializer.fromJson<int>(json['amount']),
      shop: serializer.fromJson<String?>(json['shop']),
      quantity: serializer.fromJson<int>(json['quantity']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      memo: serializer.fromJson<String?>(json['memo']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'oshiId': serializer.toJson<int>(oshiId),
      'name': serializer.toJson<String>(name),
      'purchaseDate': serializer.toJson<String>(purchaseDate),
      'category': serializer.toJson<String>(category),
      'amount': serializer.toJson<int>(amount),
      'shop': serializer.toJson<String?>(shop),
      'quantity': serializer.toJson<int>(quantity),
      'imagePath': serializer.toJson<String?>(imagePath),
      'memo': serializer.toJson<String?>(memo),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  Good copyWith({
    int? id,
    int? oshiId,
    String? name,
    String? purchaseDate,
    String? category,
    int? amount,
    Value<String?> shop = const Value.absent(),
    int? quantity,
    Value<String?> imagePath = const Value.absent(),
    Value<String?> memo = const Value.absent(),
    String? createdAt,
  }) => Good(
    id: id ?? this.id,
    oshiId: oshiId ?? this.oshiId,
    name: name ?? this.name,
    purchaseDate: purchaseDate ?? this.purchaseDate,
    category: category ?? this.category,
    amount: amount ?? this.amount,
    shop: shop.present ? shop.value : this.shop,
    quantity: quantity ?? this.quantity,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    memo: memo.present ? memo.value : this.memo,
    createdAt: createdAt ?? this.createdAt,
  );
  Good copyWithCompanion(GoodsCompanion data) {
    return Good(
      id: data.id.present ? data.id.value : this.id,
      oshiId: data.oshiId.present ? data.oshiId.value : this.oshiId,
      name: data.name.present ? data.name.value : this.name,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      category: data.category.present ? data.category.value : this.category,
      amount: data.amount.present ? data.amount.value : this.amount,
      shop: data.shop.present ? data.shop.value : this.shop,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      memo: data.memo.present ? data.memo.value : this.memo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Good(')
          ..write('id: $id, ')
          ..write('oshiId: $oshiId, ')
          ..write('name: $name, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('shop: $shop, ')
          ..write('quantity: $quantity, ')
          ..write('imagePath: $imagePath, ')
          ..write('memo: $memo, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    oshiId,
    name,
    purchaseDate,
    category,
    amount,
    shop,
    quantity,
    imagePath,
    memo,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Good &&
          other.id == this.id &&
          other.oshiId == this.oshiId &&
          other.name == this.name &&
          other.purchaseDate == this.purchaseDate &&
          other.category == this.category &&
          other.amount == this.amount &&
          other.shop == this.shop &&
          other.quantity == this.quantity &&
          other.imagePath == this.imagePath &&
          other.memo == this.memo &&
          other.createdAt == this.createdAt);
}

class GoodsCompanion extends UpdateCompanion<Good> {
  final Value<int> id;
  final Value<int> oshiId;
  final Value<String> name;
  final Value<String> purchaseDate;
  final Value<String> category;
  final Value<int> amount;
  final Value<String?> shop;
  final Value<int> quantity;
  final Value<String?> imagePath;
  final Value<String?> memo;
  final Value<String> createdAt;
  const GoodsCompanion({
    this.id = const Value.absent(),
    this.oshiId = const Value.absent(),
    this.name = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.category = const Value.absent(),
    this.amount = const Value.absent(),
    this.shop = const Value.absent(),
    this.quantity = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.memo = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  GoodsCompanion.insert({
    this.id = const Value.absent(),
    required int oshiId,
    required String name,
    required String purchaseDate,
    required String category,
    required int amount,
    this.shop = const Value.absent(),
    this.quantity = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.memo = const Value.absent(),
    required String createdAt,
  }) : oshiId = Value(oshiId),
       name = Value(name),
       purchaseDate = Value(purchaseDate),
       category = Value(category),
       amount = Value(amount),
       createdAt = Value(createdAt);
  static Insertable<Good> custom({
    Expression<int>? id,
    Expression<int>? oshiId,
    Expression<String>? name,
    Expression<String>? purchaseDate,
    Expression<String>? category,
    Expression<int>? amount,
    Expression<String>? shop,
    Expression<int>? quantity,
    Expression<String>? imagePath,
    Expression<String>? memo,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (oshiId != null) 'oshi_id': oshiId,
      if (name != null) 'name': name,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (category != null) 'category': category,
      if (amount != null) 'amount': amount,
      if (shop != null) 'shop': shop,
      if (quantity != null) 'quantity': quantity,
      if (imagePath != null) 'image_path': imagePath,
      if (memo != null) 'memo': memo,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  GoodsCompanion copyWith({
    Value<int>? id,
    Value<int>? oshiId,
    Value<String>? name,
    Value<String>? purchaseDate,
    Value<String>? category,
    Value<int>? amount,
    Value<String?>? shop,
    Value<int>? quantity,
    Value<String?>? imagePath,
    Value<String?>? memo,
    Value<String>? createdAt,
  }) {
    return GoodsCompanion(
      id: id ?? this.id,
      oshiId: oshiId ?? this.oshiId,
      name: name ?? this.name,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      shop: shop ?? this.shop,
      quantity: quantity ?? this.quantity,
      imagePath: imagePath ?? this.imagePath,
      memo: memo ?? this.memo,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (oshiId.present) {
      map['oshi_id'] = Variable<int>(oshiId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<String>(purchaseDate.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (shop.present) {
      map['shop'] = Variable<String>(shop.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoodsCompanion(')
          ..write('id: $id, ')
          ..write('oshiId: $oshiId, ')
          ..write('name: $name, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('shop: $shop, ')
          ..write('quantity: $quantity, ')
          ..write('imagePath: $imagePath, ')
          ..write('memo: $memo, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SavingPlansTable extends SavingPlans
    with TableInfo<$SavingPlansTable, SavingPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingPlansTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _oshiIdMeta = const VerificationMeta('oshiId');
  @override
  late final GeneratedColumn<int> oshiId = GeneratedColumn<int>(
    'oshi_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES oshis (id)',
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
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalDateMeta = const VerificationMeta(
    'goalDate',
  );
  @override
  late final GeneratedColumn<String> goalDate = GeneratedColumn<String>(
    'goal_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _goalAmountMeta = const VerificationMeta(
    'goalAmount',
  );
  @override
  late final GeneratedColumn<int> goalAmount = GeneratedColumn<int>(
    'goal_amount',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dailyAmountMeta = const VerificationMeta(
    'dailyAmount',
  );
  @override
  late final GeneratedColumn<int> dailyAmount = GeneratedColumn<int>(
    'daily_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    oshiId,
    name,
    startDate,
    goalDate,
    goalAmount,
    dailyAmount,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saving_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavingPlan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('oshi_id')) {
      context.handle(
        _oshiIdMeta,
        oshiId.isAcceptableOrUnknown(data['oshi_id']!, _oshiIdMeta),
      );
    } else if (isInserting) {
      context.missing(_oshiIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('goal_date')) {
      context.handle(
        _goalDateMeta,
        goalDate.isAcceptableOrUnknown(data['goal_date']!, _goalDateMeta),
      );
    }
    if (data.containsKey('goal_amount')) {
      context.handle(
        _goalAmountMeta,
        goalAmount.isAcceptableOrUnknown(data['goal_amount']!, _goalAmountMeta),
      );
    }
    if (data.containsKey('daily_amount')) {
      context.handle(
        _dailyAmountMeta,
        dailyAmount.isAcceptableOrUnknown(
          data['daily_amount']!,
          _dailyAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dailyAmountMeta);
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
  SavingPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingPlan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      oshiId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}oshi_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_date'],
      )!,
      goalDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_date'],
      ),
      goalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}goal_amount'],
      ),
      dailyAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_amount'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SavingPlansTable createAlias(String alias) {
    return $SavingPlansTable(attachedDatabase, alias);
  }
}

class SavingPlan extends DataClass implements Insertable<SavingPlan> {
  final int id;
  final int oshiId;
  final String name;
  final String startDate;
  final String? goalDate;
  final int? goalAmount;
  final int dailyAmount;
  final String createdAt;
  const SavingPlan({
    required this.id,
    required this.oshiId,
    required this.name,
    required this.startDate,
    this.goalDate,
    this.goalAmount,
    required this.dailyAmount,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['oshi_id'] = Variable<int>(oshiId);
    map['name'] = Variable<String>(name);
    map['start_date'] = Variable<String>(startDate);
    if (!nullToAbsent || goalDate != null) {
      map['goal_date'] = Variable<String>(goalDate);
    }
    if (!nullToAbsent || goalAmount != null) {
      map['goal_amount'] = Variable<int>(goalAmount);
    }
    map['daily_amount'] = Variable<int>(dailyAmount);
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  SavingPlansCompanion toCompanion(bool nullToAbsent) {
    return SavingPlansCompanion(
      id: Value(id),
      oshiId: Value(oshiId),
      name: Value(name),
      startDate: Value(startDate),
      goalDate: goalDate == null && nullToAbsent
          ? const Value.absent()
          : Value(goalDate),
      goalAmount: goalAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(goalAmount),
      dailyAmount: Value(dailyAmount),
      createdAt: Value(createdAt),
    );
  }

  factory SavingPlan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingPlan(
      id: serializer.fromJson<int>(json['id']),
      oshiId: serializer.fromJson<int>(json['oshiId']),
      name: serializer.fromJson<String>(json['name']),
      startDate: serializer.fromJson<String>(json['startDate']),
      goalDate: serializer.fromJson<String?>(json['goalDate']),
      goalAmount: serializer.fromJson<int?>(json['goalAmount']),
      dailyAmount: serializer.fromJson<int>(json['dailyAmount']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'oshiId': serializer.toJson<int>(oshiId),
      'name': serializer.toJson<String>(name),
      'startDate': serializer.toJson<String>(startDate),
      'goalDate': serializer.toJson<String?>(goalDate),
      'goalAmount': serializer.toJson<int?>(goalAmount),
      'dailyAmount': serializer.toJson<int>(dailyAmount),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  SavingPlan copyWith({
    int? id,
    int? oshiId,
    String? name,
    String? startDate,
    Value<String?> goalDate = const Value.absent(),
    Value<int?> goalAmount = const Value.absent(),
    int? dailyAmount,
    String? createdAt,
  }) => SavingPlan(
    id: id ?? this.id,
    oshiId: oshiId ?? this.oshiId,
    name: name ?? this.name,
    startDate: startDate ?? this.startDate,
    goalDate: goalDate.present ? goalDate.value : this.goalDate,
    goalAmount: goalAmount.present ? goalAmount.value : this.goalAmount,
    dailyAmount: dailyAmount ?? this.dailyAmount,
    createdAt: createdAt ?? this.createdAt,
  );
  SavingPlan copyWithCompanion(SavingPlansCompanion data) {
    return SavingPlan(
      id: data.id.present ? data.id.value : this.id,
      oshiId: data.oshiId.present ? data.oshiId.value : this.oshiId,
      name: data.name.present ? data.name.value : this.name,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      goalDate: data.goalDate.present ? data.goalDate.value : this.goalDate,
      goalAmount: data.goalAmount.present
          ? data.goalAmount.value
          : this.goalAmount,
      dailyAmount: data.dailyAmount.present
          ? data.dailyAmount.value
          : this.dailyAmount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavingPlan(')
          ..write('id: $id, ')
          ..write('oshiId: $oshiId, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('goalDate: $goalDate, ')
          ..write('goalAmount: $goalAmount, ')
          ..write('dailyAmount: $dailyAmount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    oshiId,
    name,
    startDate,
    goalDate,
    goalAmount,
    dailyAmount,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingPlan &&
          other.id == this.id &&
          other.oshiId == this.oshiId &&
          other.name == this.name &&
          other.startDate == this.startDate &&
          other.goalDate == this.goalDate &&
          other.goalAmount == this.goalAmount &&
          other.dailyAmount == this.dailyAmount &&
          other.createdAt == this.createdAt);
}

class SavingPlansCompanion extends UpdateCompanion<SavingPlan> {
  final Value<int> id;
  final Value<int> oshiId;
  final Value<String> name;
  final Value<String> startDate;
  final Value<String?> goalDate;
  final Value<int?> goalAmount;
  final Value<int> dailyAmount;
  final Value<String> createdAt;
  const SavingPlansCompanion({
    this.id = const Value.absent(),
    this.oshiId = const Value.absent(),
    this.name = const Value.absent(),
    this.startDate = const Value.absent(),
    this.goalDate = const Value.absent(),
    this.goalAmount = const Value.absent(),
    this.dailyAmount = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SavingPlansCompanion.insert({
    this.id = const Value.absent(),
    required int oshiId,
    required String name,
    required String startDate,
    this.goalDate = const Value.absent(),
    this.goalAmount = const Value.absent(),
    required int dailyAmount,
    required String createdAt,
  }) : oshiId = Value(oshiId),
       name = Value(name),
       startDate = Value(startDate),
       dailyAmount = Value(dailyAmount),
       createdAt = Value(createdAt);
  static Insertable<SavingPlan> custom({
    Expression<int>? id,
    Expression<int>? oshiId,
    Expression<String>? name,
    Expression<String>? startDate,
    Expression<String>? goalDate,
    Expression<int>? goalAmount,
    Expression<int>? dailyAmount,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (oshiId != null) 'oshi_id': oshiId,
      if (name != null) 'name': name,
      if (startDate != null) 'start_date': startDate,
      if (goalDate != null) 'goal_date': goalDate,
      if (goalAmount != null) 'goal_amount': goalAmount,
      if (dailyAmount != null) 'daily_amount': dailyAmount,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SavingPlansCompanion copyWith({
    Value<int>? id,
    Value<int>? oshiId,
    Value<String>? name,
    Value<String>? startDate,
    Value<String?>? goalDate,
    Value<int?>? goalAmount,
    Value<int>? dailyAmount,
    Value<String>? createdAt,
  }) {
    return SavingPlansCompanion(
      id: id ?? this.id,
      oshiId: oshiId ?? this.oshiId,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      goalDate: goalDate ?? this.goalDate,
      goalAmount: goalAmount ?? this.goalAmount,
      dailyAmount: dailyAmount ?? this.dailyAmount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (oshiId.present) {
      map['oshi_id'] = Variable<int>(oshiId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (goalDate.present) {
      map['goal_date'] = Variable<String>(goalDate.value);
    }
    if (goalAmount.present) {
      map['goal_amount'] = Variable<int>(goalAmount.value);
    }
    if (dailyAmount.present) {
      map['daily_amount'] = Variable<int>(dailyAmount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingPlansCompanion(')
          ..write('id: $id, ')
          ..write('oshiId: $oshiId, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('goalDate: $goalDate, ')
          ..write('goalAmount: $goalAmount, ')
          ..write('dailyAmount: $dailyAmount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SavingRecordsTable extends SavingRecords
    with TableInfo<$SavingRecordsTable, SavingRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingRecordsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<int> planId = GeneratedColumn<int>(
    'plan_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES saving_plans (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, planId, date, amount, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saving_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavingRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
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
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {planId, date},
  ];
  @override
  SavingRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plan_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SavingRecordsTable createAlias(String alias) {
    return $SavingRecordsTable(attachedDatabase, alias);
  }
}

class SavingRecord extends DataClass implements Insertable<SavingRecord> {
  final int id;
  final int planId;
  final String date;
  final int amount;
  final String createdAt;
  const SavingRecord({
    required this.id,
    required this.planId,
    required this.date,
    required this.amount,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plan_id'] = Variable<int>(planId);
    map['date'] = Variable<String>(date);
    map['amount'] = Variable<int>(amount);
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  SavingRecordsCompanion toCompanion(bool nullToAbsent) {
    return SavingRecordsCompanion(
      id: Value(id),
      planId: Value(planId),
      date: Value(date),
      amount: Value(amount),
      createdAt: Value(createdAt),
    );
  }

  factory SavingRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingRecord(
      id: serializer.fromJson<int>(json['id']),
      planId: serializer.fromJson<int>(json['planId']),
      date: serializer.fromJson<String>(json['date']),
      amount: serializer.fromJson<int>(json['amount']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'planId': serializer.toJson<int>(planId),
      'date': serializer.toJson<String>(date),
      'amount': serializer.toJson<int>(amount),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  SavingRecord copyWith({
    int? id,
    int? planId,
    String? date,
    int? amount,
    String? createdAt,
  }) => SavingRecord(
    id: id ?? this.id,
    planId: planId ?? this.planId,
    date: date ?? this.date,
    amount: amount ?? this.amount,
    createdAt: createdAt ?? this.createdAt,
  );
  SavingRecord copyWithCompanion(SavingRecordsCompanion data) {
    return SavingRecord(
      id: data.id.present ? data.id.value : this.id,
      planId: data.planId.present ? data.planId.value : this.planId,
      date: data.date.present ? data.date.value : this.date,
      amount: data.amount.present ? data.amount.value : this.amount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavingRecord(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, planId, date, amount, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingRecord &&
          other.id == this.id &&
          other.planId == this.planId &&
          other.date == this.date &&
          other.amount == this.amount &&
          other.createdAt == this.createdAt);
}

class SavingRecordsCompanion extends UpdateCompanion<SavingRecord> {
  final Value<int> id;
  final Value<int> planId;
  final Value<String> date;
  final Value<int> amount;
  final Value<String> createdAt;
  const SavingRecordsCompanion({
    this.id = const Value.absent(),
    this.planId = const Value.absent(),
    this.date = const Value.absent(),
    this.amount = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SavingRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int planId,
    required String date,
    required int amount,
    required String createdAt,
  }) : planId = Value(planId),
       date = Value(date),
       amount = Value(amount),
       createdAt = Value(createdAt);
  static Insertable<SavingRecord> custom({
    Expression<int>? id,
    Expression<int>? planId,
    Expression<String>? date,
    Expression<int>? amount,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planId != null) 'plan_id': planId,
      if (date != null) 'date': date,
      if (amount != null) 'amount': amount,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SavingRecordsCompanion copyWith({
    Value<int>? id,
    Value<int>? planId,
    Value<String>? date,
    Value<int>? amount,
    Value<String>? createdAt,
  }) {
    return SavingRecordsCompanion(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<int>(planId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingRecordsCompanion(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $OshisTable oshis = $OshisTable(this);
  late final $EventsTable events = $EventsTable(this);
  late final $EventExpensesTable eventExpenses = $EventExpensesTable(this);
  late final $GoodsTable goods = $GoodsTable(this);
  late final $SavingPlansTable savingPlans = $SavingPlansTable(this);
  late final $SavingRecordsTable savingRecords = $SavingRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    oshis,
    events,
    eventExpenses,
    goods,
    savingPlans,
    savingRecords,
  ];
}

typedef $$OshisTableCreateCompanionBuilder =
    OshisCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> iconPath,
      required int coverColor,
      Value<String?> birthday,
      required String category,
      Value<String?> memo,
      Value<bool> isGroup,
      required String createdAt,
      Value<String?> lastViewedAt,
    });
typedef $$OshisTableUpdateCompanionBuilder =
    OshisCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> iconPath,
      Value<int> coverColor,
      Value<String?> birthday,
      Value<String> category,
      Value<String?> memo,
      Value<bool> isGroup,
      Value<String> createdAt,
      Value<String?> lastViewedAt,
    });

final class $$OshisTableReferences
    extends BaseReferences<_$AppDatabase, $OshisTable, Oshi> {
  $$OshisTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EventsTable, List<Event>> _eventsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.events,
    aliasName: 'oshis__id__events__oshi_id',
  );

  $$EventsTableProcessedTableManager get eventsRefs {
    final manager = $$EventsTableTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.oshiId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_eventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GoodsTable, List<Good>> _goodsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.goods,
    aliasName: 'oshis__id__goods__oshi_id',
  );

  $$GoodsTableProcessedTableManager get goodsRefs {
    final manager = $$GoodsTableTableManager(
      $_db,
      $_db.goods,
    ).filter((f) => f.oshiId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_goodsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SavingPlansTable, List<SavingPlan>>
  _savingPlansRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.savingPlans,
    aliasName: 'oshis__id__saving_plans__oshi_id',
  );

  $$SavingPlansTableProcessedTableManager get savingPlansRefs {
    final manager = $$SavingPlansTableTableManager(
      $_db,
      $_db.savingPlans,
    ).filter((f) => f.oshiId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_savingPlansRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OshisTableFilterComposer extends Composer<_$AppDatabase, $OshisTable> {
  $$OshisTableFilterComposer({
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

  ColumnFilters<String> get iconPath => $composableBuilder(
    column: $table.iconPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get coverColor => $composableBuilder(
    column: $table.coverColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get birthday => $composableBuilder(
    column: $table.birthday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isGroup => $composableBuilder(
    column: $table.isGroup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastViewedAt => $composableBuilder(
    column: $table.lastViewedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> eventsRefs(
    Expression<bool> Function($$EventsTableFilterComposer f) f,
  ) {
    final $$EventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.oshiId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> goodsRefs(
    Expression<bool> Function($$GoodsTableFilterComposer f) f,
  ) {
    final $$GoodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goods,
      getReferencedColumn: (t) => t.oshiId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoodsTableFilterComposer(
            $db: $db,
            $table: $db.goods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> savingPlansRefs(
    Expression<bool> Function($$SavingPlansTableFilterComposer f) f,
  ) {
    final $$SavingPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.savingPlans,
      getReferencedColumn: (t) => t.oshiId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavingPlansTableFilterComposer(
            $db: $db,
            $table: $db.savingPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OshisTableOrderingComposer
    extends Composer<_$AppDatabase, $OshisTable> {
  $$OshisTableOrderingComposer({
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

  ColumnOrderings<String> get iconPath => $composableBuilder(
    column: $table.iconPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get coverColor => $composableBuilder(
    column: $table.coverColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get birthday => $composableBuilder(
    column: $table.birthday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isGroup => $composableBuilder(
    column: $table.isGroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastViewedAt => $composableBuilder(
    column: $table.lastViewedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OshisTableAnnotationComposer
    extends Composer<_$AppDatabase, $OshisTable> {
  $$OshisTableAnnotationComposer({
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

  GeneratedColumn<String> get iconPath =>
      $composableBuilder(column: $table.iconPath, builder: (column) => column);

  GeneratedColumn<int> get coverColor => $composableBuilder(
    column: $table.coverColor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get birthday =>
      $composableBuilder(column: $table.birthday, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  GeneratedColumn<bool> get isGroup =>
      $composableBuilder(column: $table.isGroup, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get lastViewedAt => $composableBuilder(
    column: $table.lastViewedAt,
    builder: (column) => column,
  );

  Expression<T> eventsRefs<T extends Object>(
    Expression<T> Function($$EventsTableAnnotationComposer a) f,
  ) {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.oshiId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> goodsRefs<T extends Object>(
    Expression<T> Function($$GoodsTableAnnotationComposer a) f,
  ) {
    final $$GoodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goods,
      getReferencedColumn: (t) => t.oshiId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoodsTableAnnotationComposer(
            $db: $db,
            $table: $db.goods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> savingPlansRefs<T extends Object>(
    Expression<T> Function($$SavingPlansTableAnnotationComposer a) f,
  ) {
    final $$SavingPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.savingPlans,
      getReferencedColumn: (t) => t.oshiId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavingPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.savingPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OshisTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OshisTable,
          Oshi,
          $$OshisTableFilterComposer,
          $$OshisTableOrderingComposer,
          $$OshisTableAnnotationComposer,
          $$OshisTableCreateCompanionBuilder,
          $$OshisTableUpdateCompanionBuilder,
          (Oshi, $$OshisTableReferences),
          Oshi,
          PrefetchHooks Function({
            bool eventsRefs,
            bool goodsRefs,
            bool savingPlansRefs,
          })
        > {
  $$OshisTableTableManager(_$AppDatabase db, $OshisTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OshisTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OshisTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OshisTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> iconPath = const Value.absent(),
                Value<int> coverColor = const Value.absent(),
                Value<String?> birthday = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<bool> isGroup = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String?> lastViewedAt = const Value.absent(),
              }) => OshisCompanion(
                id: id,
                name: name,
                iconPath: iconPath,
                coverColor: coverColor,
                birthday: birthday,
                category: category,
                memo: memo,
                isGroup: isGroup,
                createdAt: createdAt,
                lastViewedAt: lastViewedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> iconPath = const Value.absent(),
                required int coverColor,
                Value<String?> birthday = const Value.absent(),
                required String category,
                Value<String?> memo = const Value.absent(),
                Value<bool> isGroup = const Value.absent(),
                required String createdAt,
                Value<String?> lastViewedAt = const Value.absent(),
              }) => OshisCompanion.insert(
                id: id,
                name: name,
                iconPath: iconPath,
                coverColor: coverColor,
                birthday: birthday,
                category: category,
                memo: memo,
                isGroup: isGroup,
                createdAt: createdAt,
                lastViewedAt: lastViewedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$OshisTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                eventsRefs = false,
                goodsRefs = false,
                savingPlansRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (eventsRefs) db.events,
                    if (goodsRefs) db.goods,
                    if (savingPlansRefs) db.savingPlans,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (eventsRefs)
                        await $_getPrefetchedData<Oshi, $OshisTable, Event>(
                          currentTable: table,
                          referencedTable: $$OshisTableReferences
                              ._eventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OshisTableReferences(db, table, p0).eventsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.oshiId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (goodsRefs)
                        await $_getPrefetchedData<Oshi, $OshisTable, Good>(
                          currentTable: table,
                          referencedTable: $$OshisTableReferences
                              ._goodsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OshisTableReferences(db, table, p0).goodsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.oshiId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (savingPlansRefs)
                        await $_getPrefetchedData<
                          Oshi,
                          $OshisTable,
                          SavingPlan
                        >(
                          currentTable: table,
                          referencedTable: $$OshisTableReferences
                              ._savingPlansRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OshisTableReferences(
                                db,
                                table,
                                p0,
                              ).savingPlansRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.oshiId == item.id,
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

typedef $$OshisTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OshisTable,
      Oshi,
      $$OshisTableFilterComposer,
      $$OshisTableOrderingComposer,
      $$OshisTableAnnotationComposer,
      $$OshisTableCreateCompanionBuilder,
      $$OshisTableUpdateCompanionBuilder,
      (Oshi, $$OshisTableReferences),
      Oshi,
      PrefetchHooks Function({
        bool eventsRefs,
        bool goodsRefs,
        bool savingPlansRefs,
      })
    >;
typedef $$EventsTableCreateCompanionBuilder =
    EventsCompanion Function({
      Value<int> id,
      required int oshiId,
      required String name,
      required String date,
      Value<String?> venue,
      required String category,
      Value<int> totalAmount,
      Value<String?> memo,
      Value<String?> photoPaths,
      required String createdAt,
    });
typedef $$EventsTableUpdateCompanionBuilder =
    EventsCompanion Function({
      Value<int> id,
      Value<int> oshiId,
      Value<String> name,
      Value<String> date,
      Value<String?> venue,
      Value<String> category,
      Value<int> totalAmount,
      Value<String?> memo,
      Value<String?> photoPaths,
      Value<String> createdAt,
    });

final class $$EventsTableReferences
    extends BaseReferences<_$AppDatabase, $EventsTable, Event> {
  $$EventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OshisTable _oshiIdTable(_$AppDatabase db) =>
      db.oshis.createAlias('events__oshi_id__oshis__id');

  $$OshisTableProcessedTableManager get oshiId {
    final $_column = $_itemColumn<int>('oshi_id')!;

    final manager = $$OshisTableTableManager(
      $_db,
      $_db.oshis,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_oshiIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$EventExpensesTable, List<EventExpense>>
  _eventExpensesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.eventExpenses,
    aliasName: 'events__id__event_expenses__event_id',
  );

  $$EventExpensesTableProcessedTableManager get eventExpensesRefs {
    final manager = $$EventExpensesTableTableManager(
      $_db,
      $_db.eventExpenses,
    ).filter((f) => f.eventId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_eventExpensesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EventsTableFilterComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableFilterComposer({
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

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get venue => $composableBuilder(
    column: $table.venue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPaths => $composableBuilder(
    column: $table.photoPaths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$OshisTableFilterComposer get oshiId {
    final $$OshisTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.oshiId,
      referencedTable: $db.oshis,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OshisTableFilterComposer(
            $db: $db,
            $table: $db.oshis,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> eventExpensesRefs(
    Expression<bool> Function($$EventExpensesTableFilterComposer f) f,
  ) {
    final $$EventExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.eventExpenses,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventExpensesTableFilterComposer(
            $db: $db,
            $table: $db.eventExpenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EventsTableOrderingComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableOrderingComposer({
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

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get venue => $composableBuilder(
    column: $table.venue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPaths => $composableBuilder(
    column: $table.photoPaths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$OshisTableOrderingComposer get oshiId {
    final $$OshisTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.oshiId,
      referencedTable: $db.oshis,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OshisTableOrderingComposer(
            $db: $db,
            $table: $db.oshis,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableAnnotationComposer({
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

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get venue =>
      $composableBuilder(column: $table.venue, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  GeneratedColumn<String> get photoPaths => $composableBuilder(
    column: $table.photoPaths,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$OshisTableAnnotationComposer get oshiId {
    final $$OshisTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.oshiId,
      referencedTable: $db.oshis,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OshisTableAnnotationComposer(
            $db: $db,
            $table: $db.oshis,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> eventExpensesRefs<T extends Object>(
    Expression<T> Function($$EventExpensesTableAnnotationComposer a) f,
  ) {
    final $$EventExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.eventExpenses,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.eventExpenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EventsTable,
          Event,
          $$EventsTableFilterComposer,
          $$EventsTableOrderingComposer,
          $$EventsTableAnnotationComposer,
          $$EventsTableCreateCompanionBuilder,
          $$EventsTableUpdateCompanionBuilder,
          (Event, $$EventsTableReferences),
          Event,
          PrefetchHooks Function({bool oshiId, bool eventExpensesRefs})
        > {
  $$EventsTableTableManager(_$AppDatabase db, $EventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> oshiId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String?> venue = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> totalAmount = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<String?> photoPaths = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
              }) => EventsCompanion(
                id: id,
                oshiId: oshiId,
                name: name,
                date: date,
                venue: venue,
                category: category,
                totalAmount: totalAmount,
                memo: memo,
                photoPaths: photoPaths,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int oshiId,
                required String name,
                required String date,
                Value<String?> venue = const Value.absent(),
                required String category,
                Value<int> totalAmount = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<String?> photoPaths = const Value.absent(),
                required String createdAt,
              }) => EventsCompanion.insert(
                id: id,
                oshiId: oshiId,
                name: name,
                date: date,
                venue: venue,
                category: category,
                totalAmount: totalAmount,
                memo: memo,
                photoPaths: photoPaths,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$EventsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({oshiId = false, eventExpensesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (eventExpensesRefs) db.eventExpenses,
              ],
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
                    if (oshiId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.oshiId,
                                referencedTable: $$EventsTableReferences
                                    ._oshiIdTable(db),
                                referencedColumn: $$EventsTableReferences
                                    ._oshiIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (eventExpensesRefs)
                    await $_getPrefetchedData<
                      Event,
                      $EventsTable,
                      EventExpense
                    >(
                      currentTable: table,
                      referencedTable: $$EventsTableReferences
                          ._eventExpensesRefsTable(db),
                      managerFromTypedResult: (p0) => $$EventsTableReferences(
                        db,
                        table,
                        p0,
                      ).eventExpensesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.eventId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$EventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EventsTable,
      Event,
      $$EventsTableFilterComposer,
      $$EventsTableOrderingComposer,
      $$EventsTableAnnotationComposer,
      $$EventsTableCreateCompanionBuilder,
      $$EventsTableUpdateCompanionBuilder,
      (Event, $$EventsTableReferences),
      Event,
      PrefetchHooks Function({bool oshiId, bool eventExpensesRefs})
    >;
typedef $$EventExpensesTableCreateCompanionBuilder =
    EventExpensesCompanion Function({
      Value<int> id,
      required int eventId,
      required String label,
      required int amount,
    });
typedef $$EventExpensesTableUpdateCompanionBuilder =
    EventExpensesCompanion Function({
      Value<int> id,
      Value<int> eventId,
      Value<String> label,
      Value<int> amount,
    });

final class $$EventExpensesTableReferences
    extends BaseReferences<_$AppDatabase, $EventExpensesTable, EventExpense> {
  $$EventExpensesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EventsTable _eventIdTable(_$AppDatabase db) =>
      db.events.createAlias('event_expenses__event_id__events__id');

  $$EventsTableProcessedTableManager get eventId {
    final $_column = $_itemColumn<int>('event_id')!;

    final manager = $$EventsTableTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EventExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $EventExpensesTable> {
  $$EventExpensesTableFilterComposer({
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

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  $$EventsTableFilterComposer get eventId {
    final $$EventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $EventExpensesTable> {
  $$EventExpensesTableOrderingComposer({
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

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  $$EventsTableOrderingComposer get eventId {
    final $$EventsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableOrderingComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventExpensesTable> {
  $$EventExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  $$EventsTableAnnotationComposer get eventId {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EventExpensesTable,
          EventExpense,
          $$EventExpensesTableFilterComposer,
          $$EventExpensesTableOrderingComposer,
          $$EventExpensesTableAnnotationComposer,
          $$EventExpensesTableCreateCompanionBuilder,
          $$EventExpensesTableUpdateCompanionBuilder,
          (EventExpense, $$EventExpensesTableReferences),
          EventExpense,
          PrefetchHooks Function({bool eventId})
        > {
  $$EventExpensesTableTableManager(_$AppDatabase db, $EventExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> eventId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<int> amount = const Value.absent(),
              }) => EventExpensesCompanion(
                id: id,
                eventId: eventId,
                label: label,
                amount: amount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int eventId,
                required String label,
                required int amount,
              }) => EventExpensesCompanion.insert(
                id: id,
                eventId: eventId,
                label: label,
                amount: amount,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EventExpensesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({eventId = false}) {
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
                    if (eventId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.eventId,
                                referencedTable: $$EventExpensesTableReferences
                                    ._eventIdTable(db),
                                referencedColumn: $$EventExpensesTableReferences
                                    ._eventIdTable(db)
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

typedef $$EventExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EventExpensesTable,
      EventExpense,
      $$EventExpensesTableFilterComposer,
      $$EventExpensesTableOrderingComposer,
      $$EventExpensesTableAnnotationComposer,
      $$EventExpensesTableCreateCompanionBuilder,
      $$EventExpensesTableUpdateCompanionBuilder,
      (EventExpense, $$EventExpensesTableReferences),
      EventExpense,
      PrefetchHooks Function({bool eventId})
    >;
typedef $$GoodsTableCreateCompanionBuilder =
    GoodsCompanion Function({
      Value<int> id,
      required int oshiId,
      required String name,
      required String purchaseDate,
      required String category,
      required int amount,
      Value<String?> shop,
      Value<int> quantity,
      Value<String?> imagePath,
      Value<String?> memo,
      required String createdAt,
    });
typedef $$GoodsTableUpdateCompanionBuilder =
    GoodsCompanion Function({
      Value<int> id,
      Value<int> oshiId,
      Value<String> name,
      Value<String> purchaseDate,
      Value<String> category,
      Value<int> amount,
      Value<String?> shop,
      Value<int> quantity,
      Value<String?> imagePath,
      Value<String?> memo,
      Value<String> createdAt,
    });

final class $$GoodsTableReferences
    extends BaseReferences<_$AppDatabase, $GoodsTable, Good> {
  $$GoodsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OshisTable _oshiIdTable(_$AppDatabase db) =>
      db.oshis.createAlias('goods__oshi_id__oshis__id');

  $$OshisTableProcessedTableManager get oshiId {
    final $_column = $_itemColumn<int>('oshi_id')!;

    final manager = $$OshisTableTableManager(
      $_db,
      $_db.oshis,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_oshiIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GoodsTableFilterComposer extends Composer<_$AppDatabase, $GoodsTable> {
  $$GoodsTableFilterComposer({
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

  ColumnFilters<String> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shop => $composableBuilder(
    column: $table.shop,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$OshisTableFilterComposer get oshiId {
    final $$OshisTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.oshiId,
      referencedTable: $db.oshis,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OshisTableFilterComposer(
            $db: $db,
            $table: $db.oshis,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoodsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoodsTable> {
  $$GoodsTableOrderingComposer({
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

  ColumnOrderings<String> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shop => $composableBuilder(
    column: $table.shop,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$OshisTableOrderingComposer get oshiId {
    final $$OshisTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.oshiId,
      referencedTable: $db.oshis,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OshisTableOrderingComposer(
            $db: $db,
            $table: $db.oshis,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoodsTable> {
  $$GoodsTableAnnotationComposer({
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

  GeneratedColumn<String> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get shop =>
      $composableBuilder(column: $table.shop, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$OshisTableAnnotationComposer get oshiId {
    final $$OshisTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.oshiId,
      referencedTable: $db.oshis,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OshisTableAnnotationComposer(
            $db: $db,
            $table: $db.oshis,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoodsTable,
          Good,
          $$GoodsTableFilterComposer,
          $$GoodsTableOrderingComposer,
          $$GoodsTableAnnotationComposer,
          $$GoodsTableCreateCompanionBuilder,
          $$GoodsTableUpdateCompanionBuilder,
          (Good, $$GoodsTableReferences),
          Good,
          PrefetchHooks Function({bool oshiId})
        > {
  $$GoodsTableTableManager(_$AppDatabase db, $GoodsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> oshiId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> purchaseDate = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String?> shop = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
              }) => GoodsCompanion(
                id: id,
                oshiId: oshiId,
                name: name,
                purchaseDate: purchaseDate,
                category: category,
                amount: amount,
                shop: shop,
                quantity: quantity,
                imagePath: imagePath,
                memo: memo,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int oshiId,
                required String name,
                required String purchaseDate,
                required String category,
                required int amount,
                Value<String?> shop = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                required String createdAt,
              }) => GoodsCompanion.insert(
                id: id,
                oshiId: oshiId,
                name: name,
                purchaseDate: purchaseDate,
                category: category,
                amount: amount,
                shop: shop,
                quantity: quantity,
                imagePath: imagePath,
                memo: memo,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$GoodsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({oshiId = false}) {
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
                    if (oshiId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.oshiId,
                                referencedTable: $$GoodsTableReferences
                                    ._oshiIdTable(db),
                                referencedColumn: $$GoodsTableReferences
                                    ._oshiIdTable(db)
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

typedef $$GoodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoodsTable,
      Good,
      $$GoodsTableFilterComposer,
      $$GoodsTableOrderingComposer,
      $$GoodsTableAnnotationComposer,
      $$GoodsTableCreateCompanionBuilder,
      $$GoodsTableUpdateCompanionBuilder,
      (Good, $$GoodsTableReferences),
      Good,
      PrefetchHooks Function({bool oshiId})
    >;
typedef $$SavingPlansTableCreateCompanionBuilder =
    SavingPlansCompanion Function({
      Value<int> id,
      required int oshiId,
      required String name,
      required String startDate,
      Value<String?> goalDate,
      Value<int?> goalAmount,
      required int dailyAmount,
      required String createdAt,
    });
typedef $$SavingPlansTableUpdateCompanionBuilder =
    SavingPlansCompanion Function({
      Value<int> id,
      Value<int> oshiId,
      Value<String> name,
      Value<String> startDate,
      Value<String?> goalDate,
      Value<int?> goalAmount,
      Value<int> dailyAmount,
      Value<String> createdAt,
    });

final class $$SavingPlansTableReferences
    extends BaseReferences<_$AppDatabase, $SavingPlansTable, SavingPlan> {
  $$SavingPlansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OshisTable _oshiIdTable(_$AppDatabase db) =>
      db.oshis.createAlias('saving_plans__oshi_id__oshis__id');

  $$OshisTableProcessedTableManager get oshiId {
    final $_column = $_itemColumn<int>('oshi_id')!;

    final manager = $$OshisTableTableManager(
      $_db,
      $_db.oshis,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_oshiIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SavingRecordsTable, List<SavingRecord>>
  _savingRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.savingRecords,
    aliasName: 'saving_plans__id__saving_records__plan_id',
  );

  $$SavingRecordsTableProcessedTableManager get savingRecordsRefs {
    final manager = $$SavingRecordsTableTableManager(
      $_db,
      $_db.savingRecords,
    ).filter((f) => f.planId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_savingRecordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SavingPlansTableFilterComposer
    extends Composer<_$AppDatabase, $SavingPlansTable> {
  $$SavingPlansTableFilterComposer({
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

  ColumnFilters<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalDate => $composableBuilder(
    column: $table.goalDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get goalAmount => $composableBuilder(
    column: $table.goalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyAmount => $composableBuilder(
    column: $table.dailyAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$OshisTableFilterComposer get oshiId {
    final $$OshisTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.oshiId,
      referencedTable: $db.oshis,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OshisTableFilterComposer(
            $db: $db,
            $table: $db.oshis,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> savingRecordsRefs(
    Expression<bool> Function($$SavingRecordsTableFilterComposer f) f,
  ) {
    final $$SavingRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.savingRecords,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavingRecordsTableFilterComposer(
            $db: $db,
            $table: $db.savingRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SavingPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $SavingPlansTable> {
  $$SavingPlansTableOrderingComposer({
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

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalDate => $composableBuilder(
    column: $table.goalDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get goalAmount => $composableBuilder(
    column: $table.goalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyAmount => $composableBuilder(
    column: $table.dailyAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$OshisTableOrderingComposer get oshiId {
    final $$OshisTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.oshiId,
      referencedTable: $db.oshis,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OshisTableOrderingComposer(
            $db: $db,
            $table: $db.oshis,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SavingPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavingPlansTable> {
  $$SavingPlansTableAnnotationComposer({
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

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get goalDate =>
      $composableBuilder(column: $table.goalDate, builder: (column) => column);

  GeneratedColumn<int> get goalAmount => $composableBuilder(
    column: $table.goalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dailyAmount => $composableBuilder(
    column: $table.dailyAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$OshisTableAnnotationComposer get oshiId {
    final $$OshisTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.oshiId,
      referencedTable: $db.oshis,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OshisTableAnnotationComposer(
            $db: $db,
            $table: $db.oshis,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> savingRecordsRefs<T extends Object>(
    Expression<T> Function($$SavingRecordsTableAnnotationComposer a) f,
  ) {
    final $$SavingRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.savingRecords,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavingRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.savingRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SavingPlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavingPlansTable,
          SavingPlan,
          $$SavingPlansTableFilterComposer,
          $$SavingPlansTableOrderingComposer,
          $$SavingPlansTableAnnotationComposer,
          $$SavingPlansTableCreateCompanionBuilder,
          $$SavingPlansTableUpdateCompanionBuilder,
          (SavingPlan, $$SavingPlansTableReferences),
          SavingPlan,
          PrefetchHooks Function({bool oshiId, bool savingRecordsRefs})
        > {
  $$SavingPlansTableTableManager(_$AppDatabase db, $SavingPlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavingPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavingPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavingPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> oshiId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> startDate = const Value.absent(),
                Value<String?> goalDate = const Value.absent(),
                Value<int?> goalAmount = const Value.absent(),
                Value<int> dailyAmount = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
              }) => SavingPlansCompanion(
                id: id,
                oshiId: oshiId,
                name: name,
                startDate: startDate,
                goalDate: goalDate,
                goalAmount: goalAmount,
                dailyAmount: dailyAmount,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int oshiId,
                required String name,
                required String startDate,
                Value<String?> goalDate = const Value.absent(),
                Value<int?> goalAmount = const Value.absent(),
                required int dailyAmount,
                required String createdAt,
              }) => SavingPlansCompanion.insert(
                id: id,
                oshiId: oshiId,
                name: name,
                startDate: startDate,
                goalDate: goalDate,
                goalAmount: goalAmount,
                dailyAmount: dailyAmount,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SavingPlansTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({oshiId = false, savingRecordsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (savingRecordsRefs) db.savingRecords,
              ],
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
                    if (oshiId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.oshiId,
                                referencedTable: $$SavingPlansTableReferences
                                    ._oshiIdTable(db),
                                referencedColumn: $$SavingPlansTableReferences
                                    ._oshiIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (savingRecordsRefs)
                    await $_getPrefetchedData<
                      SavingPlan,
                      $SavingPlansTable,
                      SavingRecord
                    >(
                      currentTable: table,
                      referencedTable: $$SavingPlansTableReferences
                          ._savingRecordsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SavingPlansTableReferences(
                            db,
                            table,
                            p0,
                          ).savingRecordsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.planId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SavingPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavingPlansTable,
      SavingPlan,
      $$SavingPlansTableFilterComposer,
      $$SavingPlansTableOrderingComposer,
      $$SavingPlansTableAnnotationComposer,
      $$SavingPlansTableCreateCompanionBuilder,
      $$SavingPlansTableUpdateCompanionBuilder,
      (SavingPlan, $$SavingPlansTableReferences),
      SavingPlan,
      PrefetchHooks Function({bool oshiId, bool savingRecordsRefs})
    >;
typedef $$SavingRecordsTableCreateCompanionBuilder =
    SavingRecordsCompanion Function({
      Value<int> id,
      required int planId,
      required String date,
      required int amount,
      required String createdAt,
    });
typedef $$SavingRecordsTableUpdateCompanionBuilder =
    SavingRecordsCompanion Function({
      Value<int> id,
      Value<int> planId,
      Value<String> date,
      Value<int> amount,
      Value<String> createdAt,
    });

final class $$SavingRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $SavingRecordsTable, SavingRecord> {
  $$SavingRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SavingPlansTable _planIdTable(_$AppDatabase db) =>
      db.savingPlans.createAlias('saving_records__plan_id__saving_plans__id');

  $$SavingPlansTableProcessedTableManager get planId {
    final $_column = $_itemColumn<int>('plan_id')!;

    final manager = $$SavingPlansTableTableManager(
      $_db,
      $_db.savingPlans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SavingRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $SavingRecordsTable> {
  $$SavingRecordsTableFilterComposer({
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

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SavingPlansTableFilterComposer get planId {
    final $$SavingPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.savingPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavingPlansTableFilterComposer(
            $db: $db,
            $table: $db.savingPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SavingRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavingRecordsTable> {
  $$SavingRecordsTableOrderingComposer({
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

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SavingPlansTableOrderingComposer get planId {
    final $$SavingPlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.savingPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavingPlansTableOrderingComposer(
            $db: $db,
            $table: $db.savingPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SavingRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavingRecordsTable> {
  $$SavingRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$SavingPlansTableAnnotationComposer get planId {
    final $$SavingPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.savingPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavingPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.savingPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SavingRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavingRecordsTable,
          SavingRecord,
          $$SavingRecordsTableFilterComposer,
          $$SavingRecordsTableOrderingComposer,
          $$SavingRecordsTableAnnotationComposer,
          $$SavingRecordsTableCreateCompanionBuilder,
          $$SavingRecordsTableUpdateCompanionBuilder,
          (SavingRecord, $$SavingRecordsTableReferences),
          SavingRecord,
          PrefetchHooks Function({bool planId})
        > {
  $$SavingRecordsTableTableManager(_$AppDatabase db, $SavingRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavingRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavingRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavingRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> planId = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
              }) => SavingRecordsCompanion(
                id: id,
                planId: planId,
                date: date,
                amount: amount,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int planId,
                required String date,
                required int amount,
                required String createdAt,
              }) => SavingRecordsCompanion.insert(
                id: id,
                planId: planId,
                date: date,
                amount: amount,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SavingRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({planId = false}) {
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
                    if (planId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.planId,
                                referencedTable: $$SavingRecordsTableReferences
                                    ._planIdTable(db),
                                referencedColumn: $$SavingRecordsTableReferences
                                    ._planIdTable(db)
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

typedef $$SavingRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavingRecordsTable,
      SavingRecord,
      $$SavingRecordsTableFilterComposer,
      $$SavingRecordsTableOrderingComposer,
      $$SavingRecordsTableAnnotationComposer,
      $$SavingRecordsTableCreateCompanionBuilder,
      $$SavingRecordsTableUpdateCompanionBuilder,
      (SavingRecord, $$SavingRecordsTableReferences),
      SavingRecord,
      PrefetchHooks Function({bool planId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$OshisTableTableManager get oshis =>
      $$OshisTableTableManager(_db, _db.oshis);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db, _db.events);
  $$EventExpensesTableTableManager get eventExpenses =>
      $$EventExpensesTableTableManager(_db, _db.eventExpenses);
  $$GoodsTableTableManager get goods =>
      $$GoodsTableTableManager(_db, _db.goods);
  $$SavingPlansTableTableManager get savingPlans =>
      $$SavingPlansTableTableManager(_db, _db.savingPlans);
  $$SavingRecordsTableTableManager get savingRecords =>
      $$SavingRecordsTableTableManager(_db, _db.savingRecords);
}
