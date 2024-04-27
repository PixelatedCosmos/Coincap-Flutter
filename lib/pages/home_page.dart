import 'dart:convert';
import 'package:coincap/pages/details_page.dart';
import 'package:coincap/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  double? _deviceHeight, _deviceWidth;
  final _controller = PageController();
  HTTPService? _http;
  String? _selectedCoin;
  Map<String, dynamic>? _coinCurrencies;

  @override
  void initState() {
    super.initState();
    _http = GetIt.instance.get<HTTPService>();
    _selectedCoin = "bitcoin";
    _fetchData();
  }

  void _fetchData() async {
    var response = await _http!.get("/api/v3/coins/$_selectedCoin");
    Map data = jsonDecode(response.toString());
    setState(
      () {
        _coinCurrencies = data['market_data']['current_price'];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        PageView(
          controller: _controller,
          children: <Widget>[
            Scaffold(
              body: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _selectedCoinDropdown(),
                      _dataWidgets(),
                    ],
                  ),
                ),
              ),
            ),
            DetailsPage(coinCurrencies: _coinCurrencies ?? {}),
          ],
        ),
        Positioned(
          bottom: 10.0,
          left: 0.0,
          right: 0.0,
          child: Center(
            child: SmoothPageIndicator(
              controller: _controller,
              count: 2,
              effect: const WormEffect(
                  dotColor: Colors.grey, activeDotColor: Colors.amber),
            ),
          ),
        ),
      ],
    );
  }

  Widget _selectedCoinDropdown() {
    List<String> coins = ["bitcoin", "ethereum", "tether", "dogecoin"];
    List<DropdownMenuItem<String>> items = coins
        .map(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.w600,
                height: 1.1,
              ),
            ),
          ),
        )
        .toList();
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: DropdownButton(
        value: _selectedCoin,
        items: items,
        onChanged: (value) {
          setState(() {
            _selectedCoin = value;
          });
        },
        dropdownColor: const Color.fromRGBO(52, 52, 52, 1),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        underline: Container(),
      ),
    );
  }

  Widget _dataWidgets() {
    return FutureBuilder(
      future: _http!.get("/api/v3/coins/$_selectedCoin"),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map data = jsonDecode(
            snapshot.data.toString(),
          );
          num usdPrice = data["market_data"]["current_price"]["usd"];
          num change24h = data["market_data"]["price_change_percentage_24h"];
          var image = data["image"]["large"];
          String description = data["description"]["en"];
          Map<String, dynamic> coinCurrencies =
              data['market_data']['current_price'];

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _coinImageWidget(image),
              _currentPriceWidget(usdPrice),
              _percentageChangeWidget(change24h),
              _coinDescriptionWidget(description),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      },
    );
  }

  Widget _currentPriceWidget(num rate) {
    return Text(
      "${rate.toStringAsFixed(2)} USD",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _percentageChangeWidget(num change) {
    return RichText(
      text: TextSpan(
        children: [
          const TextSpan(
            text: "Last 24h: ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
          TextSpan(
            text: "${change > 0 ? '+' : ''}${change.toString()}%",
            style: TextStyle(
              color: change > 0
                  ? Colors.green
                  : change < 0
                      ? Colors.red
                      : Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _coinImageWidget(String imgURL) {
    return Container(
      height: _deviceHeight! * 0.15,
      width: _deviceWidth! * 0.15,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imgURL),
        ),
      ),
    );
  }

  Widget _coinDescriptionWidget(String description) {
    return Container(
      height: _deviceHeight! * 0.45,
      width: _deviceWidth! * 0.90,
      margin: EdgeInsets.symmetric(
        vertical: _deviceHeight! * 0.05,
      ),
      padding: EdgeInsets.symmetric(
        vertical: _deviceHeight! * 0.01,
        horizontal: _deviceHeight! * 0.01,
      ),
      child: SingleChildScrollView(
        child: Text(
          description,
          style: const TextStyle(
            color: Color.fromRGBO(226, 223, 210, 1),
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
