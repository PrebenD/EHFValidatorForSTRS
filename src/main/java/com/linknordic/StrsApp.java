package com.linknordic;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import java.net.URI;
import java.net.URL;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;

import java.nio.file.Paths;


import javax.xml.bind.JAXBContext;
import javax.xml.bind.Unmarshaller;
import javax.xml.transform.TransformerConfigurationException;

import no.difi.vefa.validator.Validator;
import no.difi.vefa.validator.ValidatorBuilder;
import no.difi.vefa.validator.api.Validation;
import no.difi.vefa.validator.properties.SimpleProperties;
import no.difi.vefa.validator.source.DirectorySource;
import no.difi.vefa.validator.util.JAXBHelper;
import no.difi.xsd.vefa.validator._1.ArtifactType;
import no.difi.xsd.vefa.validator._1.Artifacts;
import no.difi.xsd.vefa.validator._1.AssertionType;
import no.difi.xsd.vefa.validator._1.FlagType;
import no.difi.xsd.vefa.validator._1.Report;
import no.difi.xsd.vefa.validator._1.SectionType;



public class StrsApp {

    public static void main(String[] args) throws TransformerConfigurationException {
        StrsTransformValidateApp(args[0], args[1]);
    }

    public static String StrsTransformValidateApp(final String inputFn, final String fileType) throws TransformerConfigurationException {
        Boolean error=false;
        try{       
            final File repo = Paths.get(".\\EHF").resolve(String.format("vefa-%svalidator-repo", "")).toAbsolutePath()
                    .normalize().toFile();
            logging("Repo path : " + repo.getPath());
            if (!repo.isDirectory()) {
                repo.mkdir();
                try {
                    final JAXBContext JAXB_CONTEXT = JAXBHelper.context(Artifacts.class);
                    final URI rootUri = URI.create(String.format("https://%svefa.difi.no/validator/repo/", ""));
                    final Unmarshaller unmarshaller = JAXB_CONTEXT.createUnmarshaller();
                    final URI artifactsUri = rootUri.resolve("artifacts.xml");
                    saveUrl(artifactsUri.toURL(), repo, "artifacts.xml");
                    final Artifacts artifactsType = (Artifacts) unmarshaller.unmarshal(artifactsUri.toURL());

                    for (final ArtifactType artifact : artifactsType.getArtifact()) {
                        final URI artifactUri = rootUri.resolve(artifact.getFilename());
                        System.out.printf("Artifact Filename:  %s %n", artifact.getFilename());
                        saveUrl(artifactUri.toURL(), repo, artifact.getFilename());
                        // logging(artifact.getFilename());
                    }

                } catch (final Exception e) {
                    e.printStackTrace();
                }

            }
            try {
                final Validator validator = ValidatorBuilder.newValidator()
                        .setProperties(new SimpleProperties().set("feature.nesting", false)
                                .set("feature.expectation", false).set("feature.suppress_notloaded", false))
                        .setSource(new DirectorySource(repo.toPath())).build();

                // the main loop
                final File fn = new File(inputFn);
                logging(fn.getAbsolutePath());
                if (fn.isFile()) {
                    System.out.printf("e2b file to be transformed to EHF: %s%n", fn);
                    //logging("Hashcode e2bUtil : " + String.valueOf(e2bUtil.hashCode()));
                    final File EHFfile;
                    if(fileType.equals("e2b")){   
                        EHFfile = Utilities.transforme2b2ehf(fn);
                        logging("Type : " + "e2b");
                    }
                    else
                    {
                        EHFfile = fn;
                        logging("Type : " + "ehf");
                    }

                    if(EHFfile.exists() && !EHFfile.isDirectory()) { 
                        logging("EHF output file : " + EHFfile.getPath());
                        System.out.printf("Validating transformed EHF: %s%n", EHFfile);
                        Validation validation = null;

                        try {
                            validation = validator.validate(EHFfile);
                        } catch (final IOException e) {
                            e.printStackTrace();
                            logging(e.getMessage());
                        }

                        final Report rep = validation.getReport();

                        for (final SectionType sectionType : rep.getSection()) {
                            for (final AssertionType assrt : sectionType.getAssertion()) {
                                // default output

                                if ((assrt.getFlag() == FlagType.FATAL) || (assrt.getFlag() == FlagType.ERROR)){//} || assrt.getFlag() == FlagType.WARNING) {
                                    System.out.printf("  %-8s %-20s %s%n", assrt.getFlag(), "[" + assrt.getIdentifier() + "]",
                                            assrt.getText());
                                    final String logMessage = String.format("  %-8s %-20s %s%n", assrt.getFlag(),
                                            "[" + assrt.getIdentifier() + "]", assrt.getText());
                                    logging(logMessage);
                                    logging("Lokasjon (xpath) - " + assrt.getLocationFriendly());
                                    error = true;
                                }
                            }
                        }
                        if(error == false)
                            logging("EHF validering OK.");
                        else   logging("EHF validering NOK."); 

                        }
                    }  
                    else   logging("EHFfile is null"); 
            } catch (final Exception e) {
                logging(e.getMessage());
            }       
        }
        catch (final Exception ex){
            logging(ex.getMessage());
        }
        return ("OK");
    }

    private static void saveUrl(final URL url, final File dir, final String name) {
        System.out.printf("Fetching %s %n", url);
        System.out.printf("Fetching to %s %n", name);
        if (name.contains("/")) {
            final String newDir = name.substring(0, name.indexOf("/"));
            final File file = new File(dir, newDir);
            final boolean bool = file.mkdir();
            if (bool) {
                System.out.println("Directory created successfully");
                logging("Validator directory created successfully");
            } else {
                System.out.println("Sorry couldn’t create specified directory");
                logging("Could not create validator directory successfully");
            }
        }
        try {
            final ReadableByteChannel rbc = Channels.newChannel(url.openStream());
            final FileOutputStream fos = new FileOutputStream(new File(dir, name));
            fos.getChannel().transferFrom(rbc, 0, Long.MAX_VALUE);
        } catch (final IOException e) {
            System.out.printf("Error in filename %s %n", e.getMessage());
            e.printStackTrace();
        }
    }

    public static void logging(final String logMessage) {
        streamserve.context.LogService logService = null;
        streamserve.context.LogData logData = null;

        streamserve.context.Context context = null;
        try
        {
            //Get Streamserve application context.
            context = streamserve.context.ContextFactory.acquireContext(streamserve.context.ContextFactory.ApplicationContextType);

            //Get log service.
            logService = context.getInterface( streamserve.context.LogService.class );
            logData = new streamserve.context.LogDataImpl( "EHF validator message: %1",streamserve.context.LogLevel.info).addParameter(logMessage);
            //Log dynamic string.
            logService.log( "EHF logmessage", logData );
        }
        finally
        {
            if ( null != context )
            {
                streamserve.context.ContextFactory.releaseContext( context );
            }
        }
    }

    
    
}