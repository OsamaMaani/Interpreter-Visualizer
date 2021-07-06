package com.example.interpretervisualizer.controller;

import com.example.interpretervisualizer.models.PostRequest;
import com.example.interpretervisualizer.models.PostResponse;
import com.example.interpretervisualizer.models.SampleResponse;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMethod;

@RestController
public class WebController {

    @RequestMapping("/interpreter")
    public SampleResponse Sample(@RequestParam(value = "code",
            defaultValue = "Robot") String name) {
        SampleResponse response = new SampleResponse();
        response.setId(1);
        response.setMessage("Your code is "+name);
        return response;
    }
    
    @RequestMapping(value = "/sourcecode", method = RequestMethod.POST)
    public String acceptCode(@RequestBody String source) {
        System.out.println(source);
        return "Request is complete";
    }
}
