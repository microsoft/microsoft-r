package com.amazonaws.lambda.demo;

import java.util.HashSet;
import java.util.Set;

import com.amazon.speech.speechlet.lambda.SpeechletRequestStreamHandler;

public class MlsDemoHandler extends SpeechletRequestStreamHandler {
    private static final Set<String> supportedApplicationIds = new HashSet<String>();
    static {
        /*
         * This Id can be found on https://developer.amazon.com/edw/home.html#/ "Edit" the relevant
         * Alexa Skill and put the relevant Application Ids in this Set.
         */
        supportedApplicationIds.add("[your-application-id]");
    }

    public MlsDemoHandler() {
        super(new MySpeechlet(), supportedApplicationIds);
    }
}
