package api.interpretervisualizer.controller;

import org.json.JSONObject;
import org.springframework.web.bind.annotation.*;

import simpleinterpreter.InterpreterAdapter;

import java.security.SecureRandom;
import java.util.Base64;

@CrossOrigin(origins = "*", allowedHeaders = "*")
@RestController
public class WebController {

    private static final SecureRandom secureRandom = new SecureRandom(); //threadsafe
    private static final Base64.Encoder base64Encoder = Base64.getUrlEncoder(); //threadsafe
    private static final InterpreterAdapter interpreterAdapter = InterpreterAdapter.getInterpreterAdapter();

    String generateToken() {
        byte[] randomBytes = new byte[24];
        secureRandom.nextBytes(randomBytes);
        String token = base64Encoder.encodeToString(randomBytes);
        return token;
    }

    @RequestMapping("/interpreter/lexical")
    public String lexicalAnalysis(@RequestParam(value = "token") String token) {
        System.out.println("Lexical Analysis Requested!");
        return interpreterAdapter.getLexicalAnalysis(token).toString();
    }

    @RequestMapping("/interpreter/syntactic")
    public String syntacticAnalysis(@RequestParam(value = "token") String token) {
        return interpreterAdapter.getSyntacticAnalysis(token).toString();
    }

    @RequestMapping("/interpreter/se" +
            "" +
            "" +
            "mantic")
    public String symanticAnalysis(@RequestParam(value = "token") String token) {
        return interpreterAdapter.getSymanticAnalysis(token).toString();
    }

    @RequestMapping(value = "/interpreter/sourcecode", method = RequestMethod.POST)
    public String sourceCode(@RequestBody String source) {
        String generatedtoken = generateToken();
        interpreterAdapter.startInterpreter(generatedtoken, source);
        return "{\"Token\":\"" + generatedtoken + "\"}";
    }
}
