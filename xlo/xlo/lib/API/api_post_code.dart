import 'package:dio/dio.dart';
import 'package:xlo/models/adress.dart';
import 'package:xlo/repositories/api_error.dart';
import 'package:xlo/repositories/api_response.dart';

Future<ApiResponse> getAdressFromAPI(String postalcode) async {



  final String endpoint =
    "http://viacep.com.br/ws/${postalcode.replaceAll('.', "")
      .replaceAll('-', '')}/json/";

  try {

    final Response response = await Dio().get<Map>(endpoint);

    if(response.data.containsKey('erro') && response.data['erro']) {
      return ApiResponse.error(
        error: ApiError(
            code: -1,
            message: "CEP inválido",
        )
      );
    }

    final Address adress = Address(
      place: response.data["logadouro"],
      district: response.data["bairro"],
      city: response.data["localidade"],
      postalCode: response.data["cep"],
      federativeUnit: response.data["uf"],
    );

    return ApiResponse.sucess(result: adress);

  } on DioError catch(e) {
    return ApiResponse.error(
      error: ApiError(
          code: -1,
          message: "Falha ao contactar o website VIACEP",
      )
    );
  }

}