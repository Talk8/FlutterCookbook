import 'package:fluttercookbook/generated/json/base/json_convert_content.dart';
import 'package:fluttercookbook/x_z_weather_bean_entity.dart';

XZWeatherBeanEntity $XZWeatherBeanEntityFromJson(Map<String, dynamic> json) {
	final XZWeatherBeanEntity xZWeatherBeanEntity = XZWeatherBeanEntity();
	final List<XZWeatherBeanResults>? results = jsonConvert.convertListNotNull<XZWeatherBeanResults>(json['results']);
	if (results != null) {
		xZWeatherBeanEntity.results = results;
	}
	return xZWeatherBeanEntity;
}

Map<String, dynamic> $XZWeatherBeanEntityToJson(XZWeatherBeanEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['results'] =  entity.results?.map((v) => v.toJson()).toList();
	return data;
}

XZWeatherBeanResults $XZWeatherBeanResultsFromJson(Map<String, dynamic> json) {
	final XZWeatherBeanResults xZWeatherBeanResults = XZWeatherBeanResults();
	final XZWeatherBeanResultsLocation? location = jsonConvert.convert<XZWeatherBeanResultsLocation>(json['location']);
	if (location != null) {
		xZWeatherBeanResults.location = location;
	}
	final XZWeatherBeanResultsNow? now = jsonConvert.convert<XZWeatherBeanResultsNow>(json['now']);
	if (now != null) {
		xZWeatherBeanResults.now = now;
	}
	final String? lastUpdate = jsonConvert.convert<String>(json['last_update']);
	if (lastUpdate != null) {
		xZWeatherBeanResults.lastUpdate = lastUpdate;
	}
	return xZWeatherBeanResults;
}

Map<String, dynamic> $XZWeatherBeanResultsToJson(XZWeatherBeanResults entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['location'] = entity.location?.toJson();
	data['now'] = entity.now?.toJson();
	data['last_update'] = entity.lastUpdate;
	return data;
}

XZWeatherBeanResultsLocation $XZWeatherBeanResultsLocationFromJson(Map<String, dynamic> json) {
	final XZWeatherBeanResultsLocation xZWeatherBeanResultsLocation = XZWeatherBeanResultsLocation();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		xZWeatherBeanResultsLocation.id = id;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		xZWeatherBeanResultsLocation.name = name;
	}
	final String? country = jsonConvert.convert<String>(json['country']);
	if (country != null) {
		xZWeatherBeanResultsLocation.country = country;
	}
	final String? path = jsonConvert.convert<String>(json['path']);
	if (path != null) {
		xZWeatherBeanResultsLocation.path = path;
	}
	final String? timezone = jsonConvert.convert<String>(json['timezone']);
	if (timezone != null) {
		xZWeatherBeanResultsLocation.timezone = timezone;
	}
	final String? timezoneOffset = jsonConvert.convert<String>(json['timezone_offset']);
	if (timezoneOffset != null) {
		xZWeatherBeanResultsLocation.timezoneOffset = timezoneOffset;
	}
	return xZWeatherBeanResultsLocation;
}

Map<String, dynamic> $XZWeatherBeanResultsLocationToJson(XZWeatherBeanResultsLocation entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['name'] = entity.name;
	data['country'] = entity.country;
	data['path'] = entity.path;
	data['timezone'] = entity.timezone;
	data['timezone_offset'] = entity.timezoneOffset;
	return data;
}

XZWeatherBeanResultsNow $XZWeatherBeanResultsNowFromJson(Map<String, dynamic> json) {
	final XZWeatherBeanResultsNow xZWeatherBeanResultsNow = XZWeatherBeanResultsNow();
	final String? text = jsonConvert.convert<String>(json['text']);
	if (text != null) {
		xZWeatherBeanResultsNow.text = text;
	}
	final String? code = jsonConvert.convert<String>(json['code']);
	if (code != null) {
		xZWeatherBeanResultsNow.code = code;
	}
	final String? temperature = jsonConvert.convert<String>(json['temperature']);
	if (temperature != null) {
		xZWeatherBeanResultsNow.temperature = temperature;
	}
	return xZWeatherBeanResultsNow;
}

Map<String, dynamic> $XZWeatherBeanResultsNowToJson(XZWeatherBeanResultsNow entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['text'] = entity.text;
	data['code'] = entity.code;
	data['temperature'] = entity.temperature;
	return data;
}