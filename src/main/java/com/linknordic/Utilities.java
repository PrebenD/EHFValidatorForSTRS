package com.linknordic;

import java.io.File;
import java.io.IOException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.DOMException;
import org.w3c.dom.Document;
import org.xml.sax.SAXException;

public class Utilities {
    
    final static TransformerFactory factory = TransformerFactory.newInstance();
    final static File FakturaXSLT = new File(".\\EHF\\xslt\\MappingMapToEHF_Faktura.xslt");
    final static File KreditnotaXSLT = new File(".\\EHF\\xslt\\MappingMapToEHF_Kreditnota.xslt");
    final static Source xsltFakturaSource = new StreamSource(FakturaXSLT);
    final static Source xsltKredittSource = new StreamSource(KreditnotaXSLT);
    
      
    public static File transforme2b2ehf(final File e2bFile) throws Exception, TransformerException {
        
        StrsApp.logging("Transform E2b to EHF: " + e2bFile.getAbsolutePath());
        //final Transformer transformerFaktura = factory.newTransformer(xsltFakturaSource);
        //final Transformer transformerKreditt = factory.newTransformer(xsltKredittSource);
        final File ehffiletmp = new File(".\\EHF" + "\\" + e2bFile.getName());
        try {
            final Transformer transformerFaktura = factory.newTransformer(xsltFakturaSource);
            final Transformer transformerKreditt = factory.newTransformer(xsltKredittSource);
            final String docType = findDocType(e2bFile.getAbsolutePath());
            System.out.printf("Doctype : %s%n", docType);
            final String message = "Doctype (Faktura 380/Kredittnota 381): ";
            StrsApp.logging(message + docType);
            final Source text = new StreamSource(e2bFile);
            try {
                if (docType.equalsIgnoreCase("380")) {
                    transformerFaktura.transform(text, new StreamResult(ehffiletmp));
                } else {
                    transformerKreditt.transform(text, new StreamResult(ehffiletmp));
                }
            } catch (final Exception e) {
                StrsApp.logging("Warning xslt" + e.getMessage());
            }
        } catch (final Exception e) {
            StrsApp.logging("Warning all: " + e.getMessage());
        }
        return ehffiletmp;
    }

    private static String findDocType(final String e2bFile)
            throws ParserConfigurationException, SAXException, XPathExpressionException, IOException {
      try {
          final DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
          try {
              factory.setNamespaceAware(false);
              final DocumentBuilder builder = factory.newDocumentBuilder();
              final Document doc = builder.parse(e2bFile);
              final XPathFactory xpathfactory = XPathFactory.newInstance();
              final XPath xpath = xpathfactory.newXPath();
              try {
                  final XPathExpression expr = xpath
                          .compile("//Interchange/Invoice/InvoiceHeader/InvoiceType");
                  final Object result = expr.evaluate(doc, XPathConstants.STRING);
                  return (String) result;
              } catch (final XPathExpressionException e) {
                  System.out.println("XPathExpressionException : " + e.getMessage());
              }
          } catch (final DOMException e) {
              System.out.println("DOMException : " + e.getMessage());
          }
      } catch (final ParserConfigurationException e) {
      System.out.println("Get document type" + e.getMessage());
    } 
    return null;
  }
  
}

