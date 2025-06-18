import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sajilo_style/app/constant/hive_table_constant.dart';
import 'package:sajilo_style/features/auth/domain/entity/user_entity.dart';
import 'package:uuid/uuid.dart'
;
part 'user_hive_model.g.dart';




@HiveType(typeId: HiveTableConstant.userTableId)
class UserHiveModel extends Equatable {

  @HiveField(0)
  final String? userId;
  @HiveField(1)
  final String fullName;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String phoneNumber;
  @HiveField(4)
  final String password;

  UserHiveModel({
    String? userId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
  }): userId = userId ?? const Uuid().v4();


    // Initial Constructor
  const UserHiveModel.initial()
    : userId = '',
      fullName = '',
      email = '',
      phoneNumber = '',
      password = '';

    
  // from entity
  factory UserHiveModel.fromEntity(UserEntity entity){
    return UserHiveModel(
      userId: entity.userId,
      fullName: entity.fullName,
       email: entity.email, 
       phoneNumber: entity.phoneNumber, 
       password: entity.password,
      
      );
  }

  // To entity
  UserEntity toEntity() {
    return UserEntity(
    userId: userId,
    fullName: fullName,
    email: email,
    phoneNumber: phoneNumber,
    password: password,
    );
  }

     


  @override 
  List<Object?> get props => [
    userId,
    fullName,
    email,
    phoneNumber, 
    password
  ];
 }