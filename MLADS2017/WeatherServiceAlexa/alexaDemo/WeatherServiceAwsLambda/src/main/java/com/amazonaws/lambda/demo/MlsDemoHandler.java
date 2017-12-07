package com.amazonaws.lambda.demo;

import java.util.HashSet;
import java.util.Set;

import com.amazon.speech.speechlet.lambda.SpeechletRequestStreamHandler;

public class MlsDemoHandler extends SpeechletRequestStreamHandler {
    private static final Set<String> supportedApplicationIds = new HashSet<String>();
    static {
        supportedApplicationIds.add("[your-amazon-skill-id]");
    }

    public MlsDemoHandler() {
        super(new MySpeechlet(), supportedApplicationIds);
    }
}