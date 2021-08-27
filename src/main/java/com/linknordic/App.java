package com.linknordic;

import java.io.IOException;
import java.nio.file.Paths;

import no.difi.vefa.validator.Validator;
import no.difi.vefa.validator.ValidatorBuilder;
import no.difi.vefa.validator.api.Validation;

/**
 * Hello world!
 *
 */
public class App 
{
    public static void main( String[] args ) throws IOException
    {
        // Create a new validator using validation artifacts from Difi.
        Validator validator = ValidatorBuilder.newValidator().build();

        // Validate business document.
        Validation validation = validator.validate(Paths.get("C:\\Users\\prebe\\OneDrive\\Desktop\\riis\\EHF2.xml"));

        // Print result of validation.
        System.out.println(validation.getReport().getFlag());
    }
}
