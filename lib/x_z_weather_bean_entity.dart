import 'package:fluttercookbook/generated/json/base/json_field.dart';
import 'package:fluttercookbook/generated/json/x_z_weather_bean_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class XZWeatherBeanEntity {
	List<XZWeatherBeanResults>? results;

	XZWeatherBeanEntity();

	factory XZWeatherBeanEntity.fromJson(Map<String, dynamic> json) => $XZWeatherBeanEntityFromJson(json);

	Map<String, dynamic> toJson() => $XZWeatherBeanEntityToJson(this);

	XZWeatherBeanEntity copyWith({List<XZWeatherBeanResults>? results}) {
		return XZWeatherBeanEntity()
			..results= results ?? this.results;
	}

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class XZWeatherBeanResults {
	XZWeatherBeanResultsLocation? location;
	XZWeatherBeanResultsNow? now;
	@JSONField(name: "last_update")
	String? lastUpdate = '';

	XZWeatherBeanResults();

	factory XZWeatherBeanResults.fromJson(Map<String, dynamic> json) => $XZWeatherBeanResultsFromJson(json);

	Map<String, dynamic> toJson() => $XZWeatherBeanResultsToJson(this);

	XZWeatherBeanResults copyWith({XZWeatherBeanResultsLocation? location, XZWeatherBeanResultsNow? now, String? lastUpdate}) {
		return XZWeatherBeanResults()
			..location= location ?? this.location
			..now= now ?? this.now
			..lastUpdate= lastUpdate ?? this.lastUpdate;
	}

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class XZWeatherBeanResultsLocation {
	String? id = '';
	String? name = '';
	String? country = '';
	String? path = '';
	String? timezone = '';
	@JSONField(name: "timezone_offset")
	String? timezoneOffset = '';

	XZWeatherBeanResultsLocation();

	factory XZWeatherBeanResultsLocation.fromJson(Map<String, dynamic> json) => $XZWeatherBeanResultsLocationFromJson(json);

	Map<String, dynamic> toJson() => $XZWeatherBeanResultsLocationToJson(this);

	XZWeatherBeanResultsLocation copyWith({String? id, String? name, String? country, String? path, String? timezone, String? timezoneOffset}) {
		return XZWeatherBeanResultsLocation()
			..id= id ?? this.id
			..name= name ?? this.name
			..country= country ?? this.country
			..path= path ?? this.path
			..timezone= timezone ?? this.timezone
			..timezoneOffset= timezoneOffset ?? this.timezoneOffset;
	}

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class XZWeatherBeanResultsNow {
	String? text = '';
	String? code = '';
	String? temperature = '';

	XZWeatherBeanResultsNow();

	factory XZWeatherBeanResultsNow.fromJson(Map<String, dynamic> json) => $XZWeatherBeanResultsNowFromJson(json);

	Map<String, dynamic> toJson() => $XZWeatherBeanResultsNowToJson(this);

	XZWeatherBeanResultsNow copyWith({String? text, String? code, String? temperature}) {
		return XZWeatherBeanResultsNow()
			..text= text ?? this.text
			..code= code ?? this.code
			..temperature= temperature ?? this.temperature;
	}

	@override
	String toString() {
		return jsonEncode(this);
	}
}