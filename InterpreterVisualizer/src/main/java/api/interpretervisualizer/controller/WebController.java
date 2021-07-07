package api.interpretervisualizer.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMethod;
import simpleinterpreter.InterpreterAdapter;

import java.security.SecureRandom;
import java.util.Base64;

@RestController
public class WebController {

    private static final SecureRandom secureRandom = new SecureRandom(); //threadsafe
    private static final Base64.Encoder base64Encoder = Base64.getUrlEncoder(); //threadsafe
    private static final InterpreterAdapter interpreterAdapter = InterpreterAdapter.getInterpreterAdapter();

    String generateToken() {
        byte[] randomBytes = new byte[24];
        secureRandom.nextBytes(randomBytes);
        return base64Encoder.encodeToString(randomBytes);
    }

    @RequestMapping("/interpreter/lexical")
    public String lexicalAnalysis(@RequestParam(value = "token") String token) {
        return interpreterAdapter.getLexicalAnalysis(token).toString();
    }

    @RequestMapping("/interpreter/syntactic")
    public String syntacticAnalysis(@RequestParam(value = "token") String token) {
        return interpreterAdapter.getSyntacticAnalysis(token).toString();
    }

    @RequestMapping("/interpreter/symantic")
    public String symanticAnalysis(@RequestParam(value = "token") String token) {
        return interpreterAdapter.getSymanticAnalysis(token).toString();
    }

    @RequestMapping(value = "/interpreter/sourcecode", method = RequestMethod.POST)
    public String sourceCode(@RequestBody String source) {
        String generatedtoken = generateToken();
        interpreterAdapter.startInterpreter(generatedtoken, source);
        return generatedtoken;
    }
}
