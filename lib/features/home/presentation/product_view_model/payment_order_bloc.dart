import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sajilo_style/features/home/domain/use_case/payment_order_usecase.dart';

// Events
abstract class PaymentOrderEvent extends Equatable {
  const PaymentOrderEvent();
  @override
  List<Object?> get props => [];
}
class CreatePaymentAndOrderEvent extends PaymentOrderEvent {

  final String paymentMethod;
  final double price;
  final String address;
  final String productId;
  final int quantity;
  const CreatePaymentAndOrderEvent({
  
    required this.paymentMethod,
    required this.price,
    required this.address,
    required this.productId,
    required this.quantity,
  });
  @override
  List<Object?> get props => [paymentMethod, price, address, productId, quantity];
}

// States
abstract class PaymentOrderState extends Equatable {
  const PaymentOrderState();
  @override
  List<Object?> get props => [];
}
class PaymentOrderInitial extends PaymentOrderState {}
class PaymentOrderLoading extends PaymentOrderState {}
class PaymentOrderSuccess extends PaymentOrderState {
  final Map<String, dynamic> orderData;
  const PaymentOrderSuccess(this.orderData);
  @override
  List<Object?> get props => [orderData];
}
class PaymentOrderError extends PaymentOrderState {
  final String message;
  const PaymentOrderError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class PaymentOrderBloc extends Bloc<PaymentOrderEvent, PaymentOrderState> {
  final CreatePaymentAndOrderUseCase createPaymentAndOrderUseCase;
  PaymentOrderBloc({required this.createPaymentAndOrderUseCase}) : super(PaymentOrderInitial()) {
    on<CreatePaymentAndOrderEvent>(_onCreatePaymentAndOrder);
  }

  Future<void> _onCreatePaymentAndOrder(CreatePaymentAndOrderEvent event, Emitter<PaymentOrderState> emit) async {
    emit(PaymentOrderLoading());
    try {
      final orderData = await createPaymentAndOrderUseCase(

        paymentMethod: event.paymentMethod,
        price: event.price,
        address: event.address,
        productId: event.productId,
        quantity: event.quantity,
      );
      emit(PaymentOrderSuccess(orderData));
    } catch (e) {
      emit(PaymentOrderError(e.toString()));
    }
  }
} 