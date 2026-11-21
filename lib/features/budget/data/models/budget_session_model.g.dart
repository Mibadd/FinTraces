// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_session_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBudgetSessionModelCollection on Isar {
  IsarCollection<BudgetSessionModel> get budgetSessionModels =>
      this.collection();
}

const BudgetSessionModelSchema = CollectionSchema(
  name: r'BudgetSessionModel',
  id: -7286190266204543391,
  properties: {
    r'monthYear': PropertySchema(
      id: 0,
      name: r'monthYear',
      type: IsarType.dateTime,
    ),
    r'savingsGoal': PropertySchema(
      id: 1,
      name: r'savingsGoal',
      type: IsarType.long,
    ),
    r'totalSalary': PropertySchema(
      id: 2,
      name: r'totalSalary',
      type: IsarType.long,
    ),
    r'totalSpent': PropertySchema(
      id: 3,
      name: r'totalSpent',
      type: IsarType.long,
    ),
    r'uuid': PropertySchema(
      id: 4,
      name: r'uuid',
      type: IsarType.string,
    )
  },
  estimateSize: _budgetSessionModelEstimateSize,
  serialize: _budgetSessionModelSerialize,
  deserialize: _budgetSessionModelDeserialize,
  deserializeProp: _budgetSessionModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'uuid': IndexSchema(
      id: 2134397340427724972,
      name: r'uuid',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'uuid',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'monthYear': IndexSchema(
      id: -8729709491572084802,
      name: r'monthYear',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'monthYear',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _budgetSessionModelGetId,
  getLinks: _budgetSessionModelGetLinks,
  attach: _budgetSessionModelAttach,
  version: '3.1.0+1',
);

int _budgetSessionModelEstimateSize(
  BudgetSessionModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.uuid.length * 3;
  return bytesCount;
}

void _budgetSessionModelSerialize(
  BudgetSessionModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.monthYear);
  writer.writeLong(offsets[1], object.savingsGoal);
  writer.writeLong(offsets[2], object.totalSalary);
  writer.writeLong(offsets[3], object.totalSpent);
  writer.writeString(offsets[4], object.uuid);
}

BudgetSessionModel _budgetSessionModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BudgetSessionModel();
  object.id = id;
  object.monthYear = reader.readDateTime(offsets[0]);
  object.savingsGoal = reader.readLong(offsets[1]);
  object.totalSalary = reader.readLong(offsets[2]);
  object.totalSpent = reader.readLong(offsets[3]);
  object.uuid = reader.readString(offsets[4]);
  return object;
}

P _budgetSessionModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _budgetSessionModelGetId(BudgetSessionModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _budgetSessionModelGetLinks(
    BudgetSessionModel object) {
  return [];
}

void _budgetSessionModelAttach(
    IsarCollection<dynamic> col, Id id, BudgetSessionModel object) {
  object.id = id;
}

extension BudgetSessionModelByIndex on IsarCollection<BudgetSessionModel> {
  Future<BudgetSessionModel?> getByUuid(String uuid) {
    return getByIndex(r'uuid', [uuid]);
  }

  BudgetSessionModel? getByUuidSync(String uuid) {
    return getByIndexSync(r'uuid', [uuid]);
  }

  Future<bool> deleteByUuid(String uuid) {
    return deleteByIndex(r'uuid', [uuid]);
  }

  bool deleteByUuidSync(String uuid) {
    return deleteByIndexSync(r'uuid', [uuid]);
  }

  Future<List<BudgetSessionModel?>> getAllByUuid(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uuid', values);
  }

  List<BudgetSessionModel?> getAllByUuidSync(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'uuid', values);
  }

  Future<int> deleteAllByUuid(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'uuid', values);
  }

  int deleteAllByUuidSync(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'uuid', values);
  }

  Future<Id> putByUuid(BudgetSessionModel object) {
    return putByIndex(r'uuid', object);
  }

  Id putByUuidSync(BudgetSessionModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'uuid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUuid(List<BudgetSessionModel> objects) {
    return putAllByIndex(r'uuid', objects);
  }

  List<Id> putAllByUuidSync(List<BudgetSessionModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'uuid', objects, saveLinks: saveLinks);
  }
}

extension BudgetSessionModelQueryWhereSort
    on QueryBuilder<BudgetSessionModel, BudgetSessionModel, QWhere> {
  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterWhere>
      anyMonthYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'monthYear'),
      );
    });
  }
}

extension BudgetSessionModelQueryWhere
    on QueryBuilder<BudgetSessionModel, BudgetSessionModel, QWhereClause> {
  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterWhereClause>
      uuidEqualTo(String uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uuid',
        value: [uuid],
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterWhereClause>
      uuidNotEqualTo(String uuid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [],
              upper: [uuid],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [uuid],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [uuid],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [],
              upper: [uuid],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterWhereClause>
      monthYearEqualTo(DateTime monthYear) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'monthYear',
        value: [monthYear],
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterWhereClause>
      monthYearNotEqualTo(DateTime monthYear) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'monthYear',
              lower: [],
              upper: [monthYear],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'monthYear',
              lower: [monthYear],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'monthYear',
              lower: [monthYear],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'monthYear',
              lower: [],
              upper: [monthYear],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterWhereClause>
      monthYearGreaterThan(
    DateTime monthYear, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'monthYear',
        lower: [monthYear],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterWhereClause>
      monthYearLessThan(
    DateTime monthYear, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'monthYear',
        lower: [],
        upper: [monthYear],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterWhereClause>
      monthYearBetween(
    DateTime lowerMonthYear,
    DateTime upperMonthYear, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'monthYear',
        lower: [lowerMonthYear],
        includeLower: includeLower,
        upper: [upperMonthYear],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BudgetSessionModelQueryFilter
    on QueryBuilder<BudgetSessionModel, BudgetSessionModel, QFilterCondition> {
  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterFilterCondition>
      monthYearEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'monthYear',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterFilterCondition>
      monthYearGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'monthYear',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterFilterCondition>
      monthYearLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'monthYear',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterFilterCondition>
      monthYearBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'monthYear',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterFilterCondition>
      savingsGoalEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'savingsGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterFilterCondition>
      savingsGoalGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'savingsGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterFilterCondition>
      savingsGoalLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'savingsGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterFilterCondition>
      savingsGoalBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'savingsGoal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterFilterCondition>
      totalSalaryEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalSalary',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterFilterCondition>
      totalSalaryGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalSalary',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterFilterCondition>
      totalSalaryLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalSalary',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterFilterCondition>
      totalSalaryBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalSalary',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterFilterCondition>
      totalSpentEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalSpent',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterFilterCondition>
      totalSpentGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalSpent',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterFilterCondition>
      totalSpentLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalSpent',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterFilterCondition>
      totalSpentBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalSpent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterFilterCondition>
      uuidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterFilterCondition>
      uuidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterFilterCondition>
      uuidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterFilterCondition>
      uuidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uuid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterFilterCondition>
      uuidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterFilterCondition>
      uuidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterFilterCondition>
      uuidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterFilterCondition>
      uuidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterFilterCondition>
      uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterFilterCondition>
      uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uuid',
        value: '',
      ));
    });
  }
}

extension BudgetSessionModelQueryObject
    on QueryBuilder<BudgetSessionModel, BudgetSessionModel, QFilterCondition> {}

extension BudgetSessionModelQueryLinks
    on QueryBuilder<BudgetSessionModel, BudgetSessionModel, QFilterCondition> {}

extension BudgetSessionModelQuerySortBy
    on QueryBuilder<BudgetSessionModel, BudgetSessionModel, QSortBy> {
  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterSortBy>
      sortByMonthYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthYear', Sort.asc);
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterSortBy>
      sortByMonthYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthYear', Sort.desc);
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterSortBy>
      sortBySavingsGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savingsGoal', Sort.asc);
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterSortBy>
      sortBySavingsGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savingsGoal', Sort.desc);
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterSortBy>
      sortByTotalSalary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSalary', Sort.asc);
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterSortBy>
      sortByTotalSalaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSalary', Sort.desc);
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterSortBy>
      sortByTotalSpent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSpent', Sort.asc);
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterSortBy>
      sortByTotalSpentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSpent', Sort.desc);
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterSortBy>
      sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterSortBy>
      sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension BudgetSessionModelQuerySortThenBy
    on QueryBuilder<BudgetSessionModel, BudgetSessionModel, QSortThenBy> {
  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterSortBy>
      thenByMonthYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthYear', Sort.asc);
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterSortBy>
      thenByMonthYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthYear', Sort.desc);
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterSortBy>
      thenBySavingsGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savingsGoal', Sort.asc);
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterSortBy>
      thenBySavingsGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savingsGoal', Sort.desc);
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterSortBy>
      thenByTotalSalary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSalary', Sort.asc);
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterSortBy>
      thenByTotalSalaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSalary', Sort.desc);
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterSortBy>
      thenByTotalSpent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSpent', Sort.asc);
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterSortBy>
      thenByTotalSpentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSpent', Sort.desc);
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterSortBy>
      thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QAfterSortBy>
      thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension BudgetSessionModelQueryWhereDistinct
    on QueryBuilder<BudgetSessionModel, BudgetSessionModel, QDistinct> {
  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QDistinct>
      distinctByMonthYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthYear');
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QDistinct>
      distinctBySavingsGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'savingsGoal');
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QDistinct>
      distinctByTotalSalary() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalSalary');
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QDistinct>
      distinctByTotalSpent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalSpent');
    });
  }

  QueryBuilder<BudgetSessionModel, BudgetSessionModel, QDistinct>
      distinctByUuid({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }
}

extension BudgetSessionModelQueryProperty
    on QueryBuilder<BudgetSessionModel, BudgetSessionModel, QQueryProperty> {
  QueryBuilder<BudgetSessionModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BudgetSessionModel, DateTime, QQueryOperations>
      monthYearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthYear');
    });
  }

  QueryBuilder<BudgetSessionModel, int, QQueryOperations>
      savingsGoalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'savingsGoal');
    });
  }

  QueryBuilder<BudgetSessionModel, int, QQueryOperations>
      totalSalaryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalSalary');
    });
  }

  QueryBuilder<BudgetSessionModel, int, QQueryOperations> totalSpentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalSpent');
    });
  }

  QueryBuilder<BudgetSessionModel, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }
}
