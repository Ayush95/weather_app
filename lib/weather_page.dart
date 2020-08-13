import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _cityController = TextEditingController();
  var _isLoading = false;

  var time;
  var temperature;
  var description;
  var location;

  Future<void> getWeather([var city = 'Kolkata']) async {
    setState(() {
      _isLoading = true;
    });
    final url =
        'http://api.weatherstack.com/forecast?access_key=a3fd7937c2b651f30024b0cf5a7a3cfe&query=$city';
    var response = await http.get(url);
    // print(json.decode(response.body));
    var result = json.decode(response.body);
    if (result == null) {
      return;
    }
    setState(() {
      this.time = result['location']['localtime'];
      this.temperature = result['current']['temperature'];
      this.description = result['current']['weather_descriptions'][0];
      this.location = result['request']['query'];
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  void searchLocation() {
    if (_cityController.text.isEmpty == null || _cityController.text == '') {
      return;
    }
    getWeather(_cityController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.purple[700],
                          Colors.purple[600],
                          Colors.purple,
                        ],
                      ),
                    ),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 30,
                        horizontal: 45,
                      ),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 40,
                            ),
                            child: const Text(
                              'Weather App',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            time.toString().substring(10),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 40),
                          Image.network(
                            'https:\/\/assets.weatherstack.com\/images\/wsymbols01_png_64\/wsymbol_0016_thundery_showers.png',
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: <Widget>[
                              Text(
                                temperature.toString() + '\u00B0c',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Spacer(),
                              Container(
                                width: 100,
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      description.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Text(
                                      location.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40),
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter City Name',
                              hintStyle: TextStyle(color: Colors.white54),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white54,
                                ),
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                            ),
                            controller: _cityController,
                          ),
                          SizedBox(height: 40),
                          Container(
                            width: double.infinity,
                            height: 50,
                            child: RaisedButton(
                              onPressed: searchLocation,
                              child: Text(
                                'Search',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
