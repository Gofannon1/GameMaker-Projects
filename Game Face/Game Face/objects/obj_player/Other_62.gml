if (async_load[? "id"] == request_id) {
    var result = async_load[? "result"];

    if (is_undefined(result)) {
        show_debug_message("No result returned from server");
    } else {
        show_debug_message("Raw result: " + string(result));

        if (string_length(result) > 0 && string_pos("{", result) == 1) {
            var json = json_parse(result);
            ai_label = json.prediction.label;
            show_debug_message("Parsed label: " + ai_label);
        } else {
            ai_label = "";
            show_debug_message("Invalid or empty response");
        }
    }

    http_request_pending = false;
}