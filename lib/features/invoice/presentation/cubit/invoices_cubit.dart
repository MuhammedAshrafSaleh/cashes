import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'invoices_state.dart';

class InvoicesCubit extends Cubit<InvoicesState> {
  InvoicesCubit() : super(InvoicesInitial());
}
