import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thredo/api/dio_helper.dart';
import 'package:thredo/app_config.dart';
import 'package:thredo/model/wish_list_response.dart';
import 'package:thredo/utils/helper.dart';
import 'package:thredo/view/wishlist/cubit/wish_list_state.dart';

class WishListCubit extends Cubit<WishListState>{
  WishListCubit() : super(WishListInitialState());

  List<WishListData> wishListData = [];

  Future<void> getWishList() async {
    emit(WishListLoadingState());
    try {
      final response = await DioHelper.getData(url: ApiConfig.getWishListEP,isHeader: true);
      if(response.statusCode == 200) {
        final data = WishListResponse.fromJson(response.data);
        wishListData.clear();
        wishListData.addAll(data.data as Iterable<WishListData>);
        emit(WishListSuccessState());
      } else {
        showMessage(message: response.statusMessage.toString());
        emit(WishListErrorState());
      }
    } catch(error) {
      showMessage(message: error.toString());
      emit(WishListErrorState());
    }
  }

  Future<void> removeFromWishlist(String productId) async {
    try {
      final response = await DioHelper.deleteData(
        url: 'user/wishlist/$productId',
        isHeader: true,
      );
      if(response.statusCode == 200 || response.statusCode == 204) {
        wishListData.removeWhere((item) => item.productId == productId);
        emit(WishListSuccessState());
      } else {
        showMessage(message: response.statusMessage.toString());
      }
    } catch(error) {
      showMessage(message: error.toString());
    }
  }
}