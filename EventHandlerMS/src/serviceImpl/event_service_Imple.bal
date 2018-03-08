package src.serviceImpl;

import ballerina.net.http;
import ballerina.io;
import ballerina.observe;
import src.persistance as persist;
import src.model as mod;
import src.utils as util;

// Service implementation to handle get service request
public function handleGetAllEventRequest (http:InRequest req)(http:OutResponse res) {
    observe:Span span = observe:startSpan("Event Handling", "Getting All Events", {}, observe:ReferenceType.ROOT, "");
    res = {};
    var pl, err = persist:getAllEvents();
    if (err != null) {
        span.logError("InternalError", "Error in getting all events");
        res.setJsonPayload(err.message);
        res.statusCode = 500;
        span.addTag("http.status_code", 500);
        span.finishSpan();
        return;
        }
    res.setJsonPayload(pl);
    res.statusCode = 200;
    span.finishSpan();
    return;   
}

// Service implementation to handle get service request
// Parsing a function pointer to make it testable
public function handleAddEvent (json jsonPayload)
                               (http:OutResponse res) {
    observe:Span span = observe:startSpan("Event Handling", "Adding Event", {}, observe:ReferenceType.ROOT, "");
    res = {};
    var event, err = <mod:Event> jsonPayload;
        if (err != null) {
            span.logError("InvalidEvent", err.message);
            // The payload is not what we expected
            res.setJsonPayload(util:generateJsonFromError(err));
            res.statusCode = 500;
            span.addTag("http.status_code", 500);
            span.finishSpan();
            return;
        }
    
    var payload, err = persist:addNewEvent(event, span.spanId);
    io:println("1111111111");
    io:println(payload);

    if (err != null) {
        span.logError("InvalidEvent", err.message);
        res.setJsonPayload(util:generateJsonFromError(err));
        res.statusCode = 500;
        span.addTag("http.status_code", 500);
        span.finishSpan();
        return;
       }
    res.setJsonPayload(payload);
    res.statusCode = 200;
    span.finishSpan();
    return;   
}