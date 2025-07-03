import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:sajilo_style/features/auth/domain/entity/user_entity.dart';

part 'user_api_model.g.dart';


// user api model 
@JsonSerializable()
class UserApiModel  extends Equatable {
  @JsonKey(name: '_id')
  final String? userId;
  final String fullName;
  final String email;
  final String phone_number;
  final String password;
  final String role;




  const UserApiModel({
    this.userId,
    required this.fullName,
    required this.email,
    required this.phone_number,
    required this.password,
    required this.role
  });

  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);


  // To Entity
  UserEntity   toEntity() {
    return UserEntity(
      userId: userId,
      fullName: fullName,
      email: email,
      phone_number: phone_number,
      password: password ?? '',
      role: role 
    );
  }



  // From entity
  factory UserApiModel.fromEntity(UserEntity entity) {
    final user = UserApiModel(
      fullName: entity.fullName,
      email: entity.email,
      phone_number: entity.phone_number,
      password: entity.password,
      role: entity.role

    );
    return user;
  }
  
  @override
  // TODO: implement props
  List<Object?> get props => [
    userId,
    fullName,
    email,
    phone_number, 
    password,
    role

  ];


}