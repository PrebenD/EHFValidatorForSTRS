# EHFValidatorForSTRS
Build:
mvn package assembly:single  // først package plugin - så assembly plugin. Lager FAT jar. Satt i pom.xml

java -jar testproject-1.0-jar-with-dependencies.jar ..\..\EHF.xml

APP.java
Helt enkel validering. ingen argugumenter input fil deklarert i kode.

STRSAPP.java
Denne skal brukes i streamserve

I streamserve :

En EHF katalog i arbridskatalogen til servicen.

EHF
  -xslt // katalog for xslt script for e2b til ehf
 

// After process script
// path til produsert efaktura fil. 
$inputE2b = ".\EHF\inputE2b.xml";
// e2b eller ehf som input
$type="ehf";

if(preproc() != 1)
	$iRetVal  = JavaInvokeStaticMethod("com.linknordic.StrsApp", "StrsTransformValidateApp",$inputE2b, $type, $retStatus);

if($iRetVal != "0")
	log(4, "Dette gikk ikke...");

log(4, "EHF $retStatus : " + $retStatus);
