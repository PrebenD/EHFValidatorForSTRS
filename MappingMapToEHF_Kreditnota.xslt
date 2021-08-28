<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:ns0="http://www.e2b.no/XMLSchema" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:ext="http://exslt.org/common" exclude-result-prefixes="ns0 xs">
	<!--<xsl:include href="emptyelements.xsl"/>-->
	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
	<xsl:param name="Element" select="/.."/>
	<xsl:template match="/">
		<xsl:variable name="vrtfPass1Result">
			<xsl:variable name="var1_Invoice" select="//ns0:Invoice"/>
			<xsl:variable name="varX1_Invoice" select="ns0:Interchange"/>
			<CreditNote xmlns="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"
				xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
				xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
				xmlns:ccts="urn:un:unece:uncefact:documentation:2"
				xmlns:qdt="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDatatypes-2"
				xmlns:udt="urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2">
				<cbc:UBLVersionID>2.1</cbc:UBLVersionID>
				<cbc:CustomizationID>urn:www.cenbii.eu:transaction:biitrns014:ver2.0:extended:urn:www.peppol.eu:bis:peppol5a:ver2.0:extended:urn:www.difi.no:ehf:kreditnota:ver2.0</cbc:CustomizationID>
				<cbc:ProfileID>urn:www.cenbii.eu:profile:bii05:ver2.0</cbc:ProfileID>
				<xsl:for-each select="$var1_Invoice">
					<xsl:variable name="var2_InvoiceHeader" select="ns0:InvoiceHeader"/>
					<xsl:variable name="var3_result">
						<xsl:for-each select="$var2_InvoiceHeader/ns0:InvoiceType">
							<xsl:choose>
								<xsl:when
									test="string((string(number(string(.))) = '380')) != 'false'">
									<xsl:value-of select="'1'"/>
								</xsl:when>
								<xsl:when
									test="string((string(number(string(.))) = '381')) != 'false'">
									<xsl:value-of select="'1'"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:variable>
					<xsl:if test="string(boolean(string($var3_result))) != 'false'">
						<cbc:ID>
							<xsl:value-of select="string($var2_InvoiceHeader/ns0:InvoiceNumber)"/>
						</cbc:ID>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="$var1_Invoice">
					<cbc:IssueDate>
						<xsl:value-of select="string(ns0:InvoiceHeader/ns0:InvoiceDate)"/>
					</cbc:IssueDate>
				</xsl:for-each>
				<xsl:for-each select="$var1_Invoice/ns0:InvoiceHeader/ns0:InvoiceType">
					<cbc:CreditNoteTypeCode listID="UNCL1001">
						<xsl:value-of select="string(number(string(.)))"/>
					</cbc:CreditNoteTypeCode>
				</xsl:for-each>
				<xsl:for-each select="$var1_Invoice/ns0:InvoiceHeader/ns0:FreeText">
					<cbc:Note>
						<xsl:value-of select="string(.)"/>
					</cbc:Note>
				</xsl:for-each>
				<xsl:for-each select="$var1_Invoice">
					<cbc:DocumentCurrencyCode listID="ISO4217">
						<xsl:value-of select="string(ns0:InvoiceHeader/ns0:Payment/ns0:Currency)"/>
					</cbc:DocumentCurrencyCode>
				</xsl:for-each>
				<cac:OrderReference>
					<xsl:element name="cbc:ID">
						<xsl:for-each
							select="$var1_Invoice/ns0:InvoiceHeader/ns0:InvoiceReferences/ns0:BuyersOrderNumber">
							<xsl:value-of select="string(.)"/>
						</xsl:for-each>
					</xsl:element>
				</cac:OrderReference>
				<xsl:for-each select="$var1_Invoice">
					<cac:BillingReference>
						<cac:InvoiceDocumentReference>
							<cbc:ID>
								<xsl:value-of select="$var1_Invoice/ns0:MessageNumber"/>
							</cbc:ID>
						</cac:InvoiceDocumentReference>
					</cac:BillingReference>
				</xsl:for-each>
				<cac:ContractDocumentReference>
					<cbc:ID>
						<xsl:for-each
							select="$var1_Invoice/ns0:InvoiceHeader/ns0:InvoiceReferences/ns0:BuyersOrderNumber">
							<xsl:value-of select="string(.)"/>
						</xsl:for-each>
					</cbc:ID>
				</cac:ContractDocumentReference>
				<xsl:for-each select="$var1_Invoice">
					<xsl:variable name="var4_InvoiceHeader" select="ns0:InvoiceHeader"/>
					<xsl:for-each select="$var4_InvoiceHeader/ns0:Ref">
						<cac:AdditionalDocumentReference>
							<xsl:for-each select="ns0:Text">
								<cbc:ID>
									<xsl:value-of select="string(.)"/>
								</cbc:ID>
							</xsl:for-each>
							<cbc:DocumentType>
								<xsl:value-of select="string(ns0:Code)"/>
							</cbc:DocumentType>
							<xsl:if test="string((position() = '1')) != 'false'">
								<cac:Attachment>
									<cac:ExternalReference>
										<xsl:for-each select="$var4_InvoiceHeader/ns0:Attachments">
											<cbc:URI>
												<xsl:value-of select="string(.)"/>
											</cbc:URI>
										</xsl:for-each>
									</cac:ExternalReference>
								</cac:Attachment>
							</xsl:if>
						</cac:AdditionalDocumentReference>
					</xsl:for-each>
				</xsl:for-each>
				<cac:AccountingSupplierParty>
					<cac:Party>
						<xsl:for-each
							select="$var1_Invoice/ns0:InvoiceHeader/ns0:Supplier/ns0:LocationId">
							<xsl:variable name="var5_schemeId" select="@schemeId"/>
							<cbc:EndpointID schemeID="NO:ORGNR">
								<xsl:if test="string(boolean($var5_schemeId)) != 'false'">
									<xsl:attribute name="schemeID" namespace="">
										<xsl:value-of select="string($var5_schemeId)"/>
									</xsl:attribute>
								</xsl:if>
								<xsl:value-of select="string(.)"/>
							</cbc:EndpointID>
						</xsl:for-each>
						<cac:PartyIdentification>
							<xsl:for-each
								select="$var1_Invoice/ns0:InvoiceHeader/ns0:Supplier/ns0:OrgNumber">
								<cbc:ID schemeID="ZZZ">
									<xsl:value-of select="string(.)"/>
								</cbc:ID>
							</xsl:for-each>
						</cac:PartyIdentification>
						<cac:PartyName>
							<xsl:for-each select="$var1_Invoice">
								<cbc:Name>
									<xsl:value-of
										select="string(ns0:InvoiceHeader/ns0:Supplier/ns0:Name)"/>
								</cbc:Name>
							</xsl:for-each>
						</cac:PartyName>
						<cac:PostalAddress>
							<xsl:for-each
								select="$var1_Invoice/ns0:InvoiceHeader/ns0:Supplier/ns0:PostalAddress/ns0:Address1">
								<cbc:Postbox>
									<xsl:value-of select="string(.)"/>
								</cbc:Postbox>
							</xsl:for-each>
							<xsl:for-each
								select="$var1_Invoice/ns0:InvoiceHeader/ns0:Supplier/ns0:StreetAddress/ns0:Address1">
								<cbc:StreetName>
									<xsl:value-of select="string(.)"/>
								</cbc:StreetName>
							</xsl:for-each>
							<xsl:for-each
								select="$var1_Invoice/ns0:InvoiceHeader/ns0:Supplier/ns0:StreetAddress/ns0:Address2">
								<cbc:AdditionalStreetName>
									<xsl:value-of select="string(.)"/>
								</cbc:AdditionalStreetName>
							</xsl:for-each>
							<xsl:for-each
								select="$var1_Invoice/ns0:InvoiceHeader/ns0:Supplier/ns0:Department">
								<cbc:Department>
									<xsl:value-of select="string(.)"/>
								</cbc:Department>
							</xsl:for-each>
							<xsl:for-each
								select="$var1_Invoice/ns0:InvoiceHeader/ns0:Supplier/ns0:PostalAddress/ns0:PostalDistrict">
								<cbc:CityName>
									<xsl:value-of select="string(.)"/>
								</cbc:CityName>
							</xsl:for-each>
							<xsl:for-each
								select="$var1_Invoice/ns0:InvoiceHeader/ns0:Supplier/ns0:PostalAddress/ns0:PostalCode">
								<cbc:PostalZone>
									<xsl:value-of select="string(.)"/>
								</cbc:PostalZone>
							</xsl:for-each>
							<xsl:choose>
								<xsl:when
									test="count($var1_Invoice/ns0:InvoiceHeader/ns0:Supplier/ns0:PostalAddress/ns0:CountryCode) > 0">
									<cac:Country>
										<xsl:for-each
											select="$var1_Invoice/ns0:InvoiceHeader/ns0:Supplier/ns0:PostalAddress/ns0:CountryCode">
											<cbc:IdentificationCode listID="ISO3166-1:Alpha2">
												<xsl:value-of select="string(.)"/>
											</cbc:IdentificationCode>
										</xsl:for-each>
									</cac:Country>
								</xsl:when>
								<xsl:otherwise>
									<cac:Country>
										<cbc:IdentificationCode listID="ISO3166-1:Alpha2"
											>NO</cbc:IdentificationCode>
									</cac:Country>
								</xsl:otherwise>
							</xsl:choose>
						</cac:PostalAddress>
						<cac:PartyTaxScheme>
							<xsl:for-each
								select="$var1_Invoice/ns0:InvoiceHeader/ns0:Supplier/ns0:VatId">
								<cbc:CompanyID>
									<xsl:value-of select="string(.)"/>
								</cbc:CompanyID>
							</xsl:for-each>
							<cac:TaxScheme>
								<cbc:ID>VAT</cbc:ID>
							</cac:TaxScheme>
						</cac:PartyTaxScheme>
						<cac:PartyLegalEntity>

							<cbc:RegistrationName>
								<xsl:for-each
									select="$var1_Invoice/ns0:InvoiceHeader/ns0:Supplier/ns0:ContactPerson">
									<xsl:value-of select="string(ns0:Name)"/>
								</xsl:for-each>
							</cbc:RegistrationName>

							<xsl:for-each
								select="$var1_Invoice/ns0:InvoiceHeader/ns0:Supplier/ns0:OrgNumber">
								<cbc:CompanyID>
									<xsl:value-of select="string(.)"/>
								</cbc:CompanyID>
							</xsl:for-each>
						</cac:PartyLegalEntity>
						<cac:Contact>
							<cbc:ID>
								<xsl:for-each
									select="$var1_Invoice/ns0:InvoiceHeader/ns0:Supplier/ns0:ContactPerson">
									<xsl:value-of select="string(ns0:Name)"/>
								</xsl:for-each>
							</cbc:ID>
							<xsl:for-each
								select="$var1_Invoice/ns0:InvoiceHeader/ns0:Supplier/ns0:ContactPerson/ns0:ContactInformation/ns0:PhoneNumber">
								<cbc:Telephone>
									<xsl:value-of select="string(.)"/>
								</cbc:Telephone>
							</xsl:for-each>
							<xsl:for-each
								select="$var1_Invoice/ns0:InvoiceHeader/ns0:Supplier/ns0:ContactPerson/ns0:ContactInformation/ns0:FaxNumber">
								<cbc:Telefax>
									<xsl:value-of select="string(.)"/>
								</cbc:Telefax>
							</xsl:for-each>
							<xsl:for-each
								select="$var1_Invoice/ns0:InvoiceHeader/ns0:Supplier/ns0:ContactPerson/ns0:ContactInformation/ns0:EmailAddress">
								<cbc:ElectronicMail>
									<xsl:value-of select="string(.)"/>
								</cbc:ElectronicMail>
							</xsl:for-each>
						</cac:Contact>
						<xsl:choose>
							<xsl:when
								test="(count($var1_Invoice/ns0:InvoiceHeader/ns0:Supplier/ns0:ContactPerson/ns0:FirstName) > 0 or count($var1_Invoice/ns0:InvoiceHeader/ns0:Supplier/ns0:ContactPerson/ns0:LastName) > 0 or count($var1_Invoice/ns0:InvoiceHeader/ns0:Supplier/ns0:ContactPerson/ns0:Function) > 0)">
								<cac:Person>
									<xsl:for-each
										select="$var1_Invoice/ns0:InvoiceHeader/ns0:Supplier/ns0:ContactPerson/ns0:FirstName">
										<cbc:FirstName>
											<xsl:value-of select="string(.)"/>
										</cbc:FirstName>
									</xsl:for-each>
									<xsl:for-each
										select="$var1_Invoice/ns0:InvoiceHeader/ns0:Supplier/ns0:ContactPerson/ns0:LastName">
										<cbc:FamilyName>
											<xsl:value-of select="string(.)"/>
										</cbc:FamilyName>
									</xsl:for-each>
									<xsl:for-each
										select="$var1_Invoice/ns0:InvoiceHeader/ns0:Supplier/ns0:ContactPerson/ns0:Function">
										<cbc:JobTitle>
											<xsl:value-of select="string(.)"/>
										</cbc:JobTitle>
									</xsl:for-each>
								</cac:Person>
							</xsl:when>
						</xsl:choose>
					</cac:Party>
				</cac:AccountingSupplierParty>
				<cac:AccountingCustomerParty>
					<cac:Party>
						<xsl:for-each
							select="$var1_Invoice/ns0:InvoiceHeader/ns0:Buyer/ns0:LocationId">
							<xsl:variable name="var6_schemeId" select="@schemeId"/>
							<cbc:EndpointID schemeID="NO:ORGNR">
								<xsl:if test="string(boolean($var6_schemeId)) != 'false'">
									<xsl:attribute name="schemeID" namespace="">
										<xsl:value-of select="string($var6_schemeId)"/>
									</xsl:attribute>
								</xsl:if>
								<xsl:value-of select="string(.)"/>
							</cbc:EndpointID>
						</xsl:for-each>
						<cac:PartyIdentification>
							<xsl:for-each
								select="$var1_Invoice/ns0:InvoiceHeader/ns0:Buyer/ns0:PartyId">
								<cbc:ID schemeID="ZZZ">
									<xsl:value-of select="string(.)"/>
								</cbc:ID>
							</xsl:for-each>
						</cac:PartyIdentification>
						<cac:PartyName>
							<xsl:for-each select="$var1_Invoice">
								<cbc:Name>
									<xsl:value-of
										select="string(ns0:InvoiceHeader/ns0:Buyer/ns0:Name)"/>
								</cbc:Name>
							</xsl:for-each>
						</cac:PartyName>
						<cac:PostalAddress>
							<xsl:for-each
								select="$var1_Invoice/ns0:InvoiceHeader/ns0:Buyer/ns0:PostalAddress/ns0:Address1">
								<cbc:Postbox>
									<xsl:value-of select="string(.)"/>
								</cbc:Postbox>
							</xsl:for-each>
							<xsl:for-each
								select="$var1_Invoice/ns0:InvoiceHeader/ns0:Buyer/ns0:StreetAddress/ns0:Address1">
								<cbc:StreetName>
									<xsl:value-of select="string(.)"/>
								</cbc:StreetName>
							</xsl:for-each>
							<xsl:for-each
								select="$var1_Invoice/ns0:InvoiceHeader/ns0:Buyer/ns0:StreetAddress/ns0:Address2">
								<cbc:AdditionalStreetName>
									<xsl:value-of select="string(.)"/>
								</cbc:AdditionalStreetName>
							</xsl:for-each>
							<xsl:for-each
								select="$var1_Invoice/ns0:InvoiceHeader/ns0:Buyer/ns0:PostalAddress/ns0:PostalDistrict">
								<cbc:CityName>
									<xsl:value-of select="string(.)"/>
								</cbc:CityName>
							</xsl:for-each>
							<xsl:for-each
								select="$var1_Invoice/ns0:InvoiceHeader/ns0:Buyer/ns0:PostalAddress/ns0:PostalCode">
								<cbc:PostalZone>
									<xsl:value-of select="string(.)"/>
								</cbc:PostalZone>
							</xsl:for-each>
							<xsl:choose>
								<xsl:when
									test="count($var1_Invoice/ns0:InvoiceHeader/ns0:Buyer/ns0:PostalAddress/ns0:CountryCode) > 0">
									<cac:Country>
										<xsl:for-each
											select="$var1_Invoice/ns0:InvoiceHeader/ns0:Buyer/ns0:PostalAddress/ns0:CountryCode">
											<cbc:IdentificationCode listID="ISO3166-1:Alpha2">
												<xsl:value-of select="string(.)"/>
											</cbc:IdentificationCode>
										</xsl:for-each>
									</cac:Country>
								</xsl:when>
								<xsl:otherwise>
									<cac:Country>
										<cbc:IdentificationCode listID="ISO3166-1:Alpha2"
											>NO</cbc:IdentificationCode>
									</cac:Country>
								</xsl:otherwise>
							</xsl:choose>
						</cac:PostalAddress>
						<cac:PartyTaxScheme>
							<xsl:for-each select="$var1_Invoice">
								<cbc:RegistrationName>
									<xsl:value-of
										select="string(ns0:InvoiceHeader/ns0:Buyer/ns0:Name)"/>
								</cbc:RegistrationName>
							</xsl:for-each>
							<xsl:for-each
								select="$var1_Invoice/ns0:InvoiceHeader/ns0:Buyer/ns0:VatId">
								<cbc:CompanyID>
									<xsl:value-of select="string(.)"/>
								</cbc:CompanyID>
							</xsl:for-each>
							<cac:TaxScheme>
								<!--							<xsl:for-each
									select="$var1_Invoice[(number(string(ns0:InvoiceSummary/ns0:InvoiceTotals/ns0:VatTotalsAmount)) &gt; '0')]">-->
								<cbc:ID>VAT</cbc:ID>
								<!--</xsl:for-each>-->
							</cac:TaxScheme>
						</cac:PartyTaxScheme>
						<cac:PartyLegalEntity>
							<xsl:for-each select="$var1_Invoice">
								<cbc:RegistrationName>
									<xsl:value-of
										select="string(ns0:InvoiceHeader/ns0:Buyer/ns0:Name)"/>
								</cbc:RegistrationName>
							</xsl:for-each>
							<xsl:for-each
								select="$var1_Invoice/ns0:InvoiceHeader/ns0:Buyer/ns0:OrgNumber">
								<cbc:CompanyID>
									<xsl:value-of select="string(.)"/>
								</cbc:CompanyID>
							</xsl:for-each>
							<cac:RegistrationAddress>
								<xsl:for-each
									select="$var1_Invoice/ns0:InvoiceHeader/ns0:Buyer/ns0:PostalAddress/ns0:PostalDistrict">
									<cbc:CityName>
										<xsl:value-of select="string(.)"/>
									</cbc:CityName>
								</xsl:for-each>
								<xsl:choose>
									<xsl:when
										test="count($var1_Invoice/ns0:InvoiceHeader/ns0:Buyer/ns0:PostalAddress/ns0:CountryCode) > 0">
										<cac:Country>
											<xsl:for-each
												select="$var1_Invoice/ns0:InvoiceHeader/ns0:Buyer/ns0:PostalAddress/ns0:CountryCode">
												<cbc:IdentificationCode listID="ISO3166-1:Alpha2">
												<xsl:value-of select="string(.)"/>
												</cbc:IdentificationCode>
											</xsl:for-each>
										</cac:Country>
									</xsl:when>
									<xsl:otherwise>
										<cac:Country>
											<cbc:IdentificationCode listID="ISO3166-1:Alpha2"
												>NO</cbc:IdentificationCode>
										</cac:Country>
									</xsl:otherwise>
								</xsl:choose>
							</cac:RegistrationAddress>
						</cac:PartyLegalEntity>
						<cac:Contact>
							<cbc:ID>
								<xsl:for-each
									select="$var1_Invoice/ns0:InvoiceHeader/ns0:Supplier/ns0:ContactPerson">
									<xsl:value-of select="string(ns0:Name)"/>
								</xsl:for-each>
							</cbc:ID>
							<xsl:for-each
								select="$var1_Invoice/ns0:InvoiceHeader/ns0:Buyer/ns0:ContactPerson/ns0:ContactInformation/ns0:PhoneNumber">
								<cbc:Telephone>
									<xsl:value-of select="string(.)"/>
								</cbc:Telephone>
							</xsl:for-each>
							<xsl:for-each
								select="$var1_Invoice/ns0:InvoiceHeader/ns0:Buyer/ns0:ContactPerson/ns0:ContactInformation/ns0:FaxNumber">
								<cbc:Telefax>
									<xsl:value-of select="string(.)"/>
								</cbc:Telefax>
							</xsl:for-each>
							<xsl:for-each
								select="$var1_Invoice/ns0:InvoiceHeader/ns0:Buyer/ns0:ContactPerson/ns0:ContactInformation/ns0:EmailAddress">
								<cbc:ElectronicMail>
									<xsl:value-of select="string(.)"/>
								</cbc:ElectronicMail>
							</xsl:for-each>
						</cac:Contact>
						<xsl:choose>
							<xsl:when
								test="count($var1_Invoice/ns0:InvoiceHeader/ns0:Buyer/ns0:ContactPerson/ns0:FirstName) > 0 or count($var1_Invoice/ns0:InvoiceHeader/ns0:Buyer/ns0:ContactPerson/ns0:LastName) > 0 or count($var1_Invoice/ns0:InvoiceHeader/ns0:Buyer/ns0:ContactPerson/ns0:Function) > 0">
								<cac:Person>
									<xsl:for-each
										select="$var1_Invoice/ns0:InvoiceHeader/ns0:Buyer/ns0:ContactPerson/ns0:FirstName">
										<cbc:FirstName>
											<xsl:value-of select="string(.)"/>
										</cbc:FirstName>
									</xsl:for-each>
									<xsl:for-each
										select="$var1_Invoice/ns0:InvoiceHeader/ns0:Buyer/ns0:ContactPerson/ns0:LastName">
										<cbc:FamilyName>
											<xsl:value-of select="string(.)"/>
										</cbc:FamilyName>
									</xsl:for-each>
									<xsl:for-each
										select="$var1_Invoice/ns0:InvoiceHeader/ns0:Buyer/ns0:ContactPerson/ns0:Function">
										<cbc:Title>
											<xsl:value-of select="string(.)"/>
										</cbc:Title>
									</xsl:for-each>
								</cac:Person>
							</xsl:when>
						</xsl:choose>
					</cac:Party>
				</cac:AccountingCustomerParty>
				<cac:PayeeParty>
					<xsl:for-each
						select="$var1_Invoice/ns0:InvoiceHeader/ns0:Supplier/ns0:LocationId">
						<xsl:variable name="var7_schemeId" select="@schemeId"/>
						<cbc:EndpointID schemeID="NO:ORGNR">
							<xsl:if test="string(boolean($var7_schemeId)) != 'false'">
								<xsl:attribute name="schemeID" namespace="">
									<xsl:value-of select="string($var7_schemeId)"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:value-of select="string(.)"/>
						</cbc:EndpointID>
					</xsl:for-each>
					<cac:PartyIdentification>
						<xsl:for-each select="$var1_Invoice/ns0:InvoiceHeader/ns0:Buyer/ns0:PartyId">
							<cbc:ID schemeID="ZZZ">
								<xsl:value-of select="string(.)"/>
							</cbc:ID>
						</xsl:for-each>
					</cac:PartyIdentification>
					<cac:PartyName>
						<xsl:for-each select="$var1_Invoice/ns0:InvoiceHeader/ns0:Supplier">
							<cbc:Name>
								<xsl:value-of select="string(ns0:Name)"/>
							</cbc:Name>
						</xsl:for-each>
					</cac:PartyName>
					<cac:PostalAddress>
						<xsl:for-each
							select="$var1_Invoice/ns0:InvoiceHeader/ns0:Supplier/ns0:PostalAddress/ns0:Address1">
							<cbc:Postbox>
								<xsl:value-of select="string(.)"/>
							</cbc:Postbox>
						</xsl:for-each>
						<xsl:for-each
							select="$var1_Invoice/ns0:InvoiceHeader/ns0:Supplier/ns0:StreetAddress/ns0:Address1">
							<cbc:StreetName>
								<xsl:value-of select="string(.)"/>
							</cbc:StreetName>
						</xsl:for-each>
						<xsl:for-each
							select="$var1_Invoice/ns0:InvoiceHeader/ns0:Supplier/ns0:StreetAddress/ns0:Address2">
							<cbc:AdditionalStreetName>
								<xsl:value-of select="string(.)"/>
							</cbc:AdditionalStreetName>
						</xsl:for-each>
						<xsl:for-each
							select="$var1_Invoice/ns0:InvoiceHeader/ns0:Supplier/ns0:PostalAddress/ns0:PostalDistrict">
							<cbc:CityName>
								<xsl:value-of select="string(.)"/>
							</cbc:CityName>
						</xsl:for-each>
						<xsl:for-each
							select="$var1_Invoice/ns0:InvoiceHeader/ns0:Supplier/ns0:PostalAddress/ns0:PostalCode">
							<cbc:PostalZone>
								<xsl:value-of select="string(.)"/>
							</cbc:PostalZone>
						</xsl:for-each>
						<xsl:choose>
							<xsl:when
								test="count($var1_Invoice/ns0:InvoiceHeader/ns0:Supplier/ns0:PostalAddress/ns0:CountryCode) > 0">
								<cac:Country>
									<xsl:for-each
										select="$var1_Invoice/ns0:InvoiceHeader/ns0:Supplier/ns0:PostalAddress/ns0:CountryCode">
										<cbc:IdentificationCode listID="ISO3166-1:Alpha2">
											<xsl:value-of select="string(.)"/>
										</cbc:IdentificationCode>
									</xsl:for-each>
								</cac:Country>
							</xsl:when>
							<xsl:otherwise>
								<cac:Country>
									<cbc:IdentificationCode listID="ISO3166-1:Alpha2"
										>NO</cbc:IdentificationCode>
								</cac:Country>
							</xsl:otherwise>
						</xsl:choose>
					</cac:PostalAddress>
					<cac:PartyLegalEntity>
						<xsl:for-each
							select="$var1_Invoice/ns0:InvoiceHeader/ns0:Supplier/ns0:OrgNumber">
							<cbc:CompanyID>
								<xsl:value-of select="string(.)"/>
							</cbc:CompanyID>
						</xsl:for-each>
					</cac:PartyLegalEntity>
				</cac:PayeeParty>
				<xsl:for-each
					select="$var1_Invoice/ns0:InvoiceHeader/ns0:InvoiceReferences/ns0:DeliveryDate">
					<cac:Delivery>
						<cbc:ActualDeliveryDate>
							<xsl:value-of select="string(.)"/>
						</cbc:ActualDeliveryDate>

						<xsl:choose>
							<xsl:when
								test="count($var1_Invoice/ns0:InvoiceHeader/ns0:DeliveryPart/ns0:LocationId) > 0">
								<cac:DeliveryLocation>
									<xsl:for-each
										select="$var1_Invoice/ns0:InvoiceHeader/ns0:DeliveryPart/ns0:LocationId">
										<xsl:variable name="var8_schemeAgencyName"
											select="@schemeAgencyName"/>
										<xsl:variable name="var9_schemeName" select="@schemeName"/>
										<xsl:variable name="var10_schemeId" select="@schemeId"/>
										<cbc:ID>
											<xsl:if
												test="string(boolean($var10_schemeId)) != 'false'">
												<xsl:attribute name="schemeID" namespace="">
												<xsl:value-of select="string($var10_schemeId)"/>
												</xsl:attribute>
											</xsl:if>
											<xsl:if
												test="string(boolean($var9_schemeName)) != 'false'">
												<xsl:attribute name="schemeName" namespace="">
												<xsl:value-of select="string($var9_schemeName)"/>
												</xsl:attribute>
											</xsl:if>
											<xsl:if
												test="string(boolean($var8_schemeAgencyName)) != 'false'">
												<xsl:attribute name="schemeAgencyName" namespace="">
												<xsl:value-of
												select="string($var8_schemeAgencyName)"/>
												</xsl:attribute>
											</xsl:if>
											<xsl:value-of select="string(.)"/>
										</cbc:ID>
									</xsl:for-each>
									<xsl:choose>
										<xsl:when
											test="count($var1_Invoice/ns0:InvoiceHeader/ns0:DeliveryPart/ns0:StreetAddress/ns0:Address1) > 0">
											<cac:Address>
												<xsl:for-each
												select="$var1_Invoice/ns0:InvoiceHeader/ns0:DeliveryPart/ns0:StreetAddress/ns0:Address1">
												<cbc:StreetName>
												<xsl:value-of select="string(.)"/>
												</cbc:StreetName>
												</xsl:for-each>
												<xsl:for-each
												select="$var1_Invoice/ns0:InvoiceHeader/ns0:DeliveryPart/ns0:StreetAddress/ns0:Address2">
												<cbc:AdditionalStreetName>
												<xsl:value-of select="string(.)"/>
												</cbc:AdditionalStreetName>
												</xsl:for-each>
												<xsl:for-each
												select="$var1_Invoice/ns0:InvoiceHeader/ns0:DeliveryPart/ns0:Department">
												<cbc:Department>
												<xsl:value-of select="string(.)"/>
												</cbc:Department>
												</xsl:for-each>
												<xsl:for-each
												select="$var1_Invoice/ns0:InvoiceHeader/ns0:DeliveryPart/ns0:StreetAddress/ns0:PostalDistrict">
												<cbc:CityName>
												<xsl:value-of select="string(.)"/>
												</cbc:CityName>
												</xsl:for-each>
												<xsl:for-each
												select="$var1_Invoice/ns0:InvoiceHeader/ns0:DeliveryPart/ns0:StreetAddress/ns0:PostalCode">
												<cbc:PostalZone>
												<xsl:value-of select="string(.)"/>
												</cbc:PostalZone>
												</xsl:for-each>
												<xsl:choose>
												<xsl:when
												test="count($var1_Invoice/ns0:InvoiceHeader/ns0:DeliveryPart/ns0:StreetAddress/ns0:CountryCode) > 0">
												<cac:Country>
												<xsl:for-each
												select="$var1_Invoice/ns0:InvoiceHeader/ns0:DeliveryPart/ns0:StreetAddress/ns0:CountryCode">
												<cbc:IdentificationCode listID="ISO3166-1:Alpha2">
												<xsl:value-of select="string(.)"/>
												</cbc:IdentificationCode>
												</xsl:for-each>
												</cac:Country>
												</xsl:when>
												<xsl:otherwise>
												<cac:Country>
												<cbc:IdentificationCode listID="ISO3166-1:Alpha2"
												>NO</cbc:IdentificationCode>
												</cac:Country>
												</xsl:otherwise>
												</xsl:choose>
											</cac:Address>
										</xsl:when>
									</xsl:choose>
								</cac:DeliveryLocation>
							</xsl:when>
						</xsl:choose>
					</cac:Delivery>
				</xsl:for-each>
				<xsl:for-each select="$var1_Invoice">
					<xsl:variable name="var11_InvoiceHeader" select="ns0:InvoiceHeader"/>
					<xsl:for-each select="$var11_InvoiceHeader/ns0:Supplier/ns0:AccountInformation">
						<xsl:variable name="var12_AccountNumber" select="ns0:AccountNumber"/>
						<xsl:if test="string(boolean($var12_AccountNumber)) != 'false'">
							<xsl:variable name="var13_Payment"
								select="$var11_InvoiceHeader/ns0:Payment"/>
							<cac:PaymentMeans>
								<cbc:PaymentMeansCode listID="UNCL4461">
									<xsl:value-of select="string('31')"/>
								</cbc:PaymentMeansCode>
								<xsl:for-each select="$var13_Payment/ns0:DueDate">
									<cbc:PaymentDueDate>
										<xsl:value-of select="string(.)"/>
									</cbc:PaymentDueDate>
								</xsl:for-each>
								<xsl:for-each select="$var13_Payment/ns0:KidNumber">
									<cbc:PaymentID>
										<xsl:value-of select="string(.)"/>
									</cbc:PaymentID>
								</xsl:for-each>
								<cac:PayeeFinancialAccount>
									<xsl:for-each select="$var12_AccountNumber">
										<xsl:variable name="var14_resultof_cast" select="string(.)"/>
										<cbc:ID>
											<xsl:if
												test="string(($var14_resultof_cast != '')) != 'false'">
												<xsl:attribute name="schemeID" namespace=""
												>BBAN</xsl:attribute>
											</xsl:if>
											<xsl:value-of select="$var14_resultof_cast"/>
										</cbc:ID>
									</xsl:for-each>
								</cac:PayeeFinancialAccount>
							</cac:PaymentMeans>
						</xsl:if>
					</xsl:for-each>
				</xsl:for-each>
				<xsl:for-each select="$var1_Invoice">
					<xsl:variable name="var15_InvoiceHeader" select="ns0:InvoiceHeader"/>
					<xsl:for-each select="$var15_InvoiceHeader/ns0:Supplier/ns0:AccountInformation">
						<xsl:variable name="var16_IbanNumber" select="ns0:IbanNumber"/>
						<xsl:if test="string(boolean($var16_IbanNumber)) != 'false'">
							<xsl:variable name="var17_SwiftNumber" select="ns0:SwiftNumber"/>
							<xsl:variable name="var18_Payment"
								select="$var15_InvoiceHeader/ns0:Payment"/>
							<cac:PaymentMeans>
								<cbc:PaymentMeansCode>31</cbc:PaymentMeansCode>
								<xsl:for-each select="$var18_Payment/ns0:DueDate">
									<cbc:PaymentDueDate>
										<xsl:value-of select="string(.)"/>
									</cbc:PaymentDueDate>
								</xsl:for-each>
								<xsl:for-each select="$var17_SwiftNumber[(string(.) != '')]">
									<cbc:PaymentChannelCode>SW</cbc:PaymentChannelCode>
								</xsl:for-each>
								<xsl:for-each select="$var18_Payment/ns0:KidNumber">
									<cbc:PaymentID>
										<xsl:value-of select="string(.)"/>
									</cbc:PaymentID>
								</xsl:for-each>
								<cac:PayeeFinancialAccount>
									<xsl:for-each select="$var16_IbanNumber">
										<xsl:variable name="var19_resultof_cast" select="string(.)"/>
										<cbc:ID>
											<xsl:if
												test="string(($var19_resultof_cast != '')) != 'false'">
												<xsl:attribute name="schemeID" namespace=""
												>IBAN</xsl:attribute>
											</xsl:if>
											<xsl:value-of select="$var19_resultof_cast"/>
										</cbc:ID>
									</xsl:for-each>
									<cac:FinancialInstitutionBranch>
										<cac:FinancialInstitution>
											<xsl:for-each select="$var17_SwiftNumber">
												<xsl:variable name="var20_resultof_cast"
												select="string(.)"/>
												<cbc:ID>
												<xsl:if
												test="string(($var20_resultof_cast != '&quot;&quot;')) != 'false'">
												<xsl:attribute name="schemeID" namespace=""
												>BIC</xsl:attribute>
												</xsl:if>
												<xsl:value-of select="$var20_resultof_cast"/>
												</cbc:ID>
											</xsl:for-each>
										</cac:FinancialInstitution>
									</cac:FinancialInstitutionBranch>
								</cac:PayeeFinancialAccount>
							</cac:PaymentMeans>
						</xsl:if>
					</xsl:for-each>
				</xsl:for-each>
				<xsl:for-each select="$var1_Invoice">
					<xsl:variable name="var21_InvoiceHeader" select="ns0:InvoiceHeader"/>
					<xsl:if
						test="string(not(boolean($var21_InvoiceHeader/ns0:Supplier/ns0:AccountInformation))) != 'false'">
						<xsl:variable name="var22_Payment" select="$var21_InvoiceHeader/ns0:Payment"/>
						<cac:PaymentMeans>
							<cbc:PaymentMeansCode>
								<xsl:value-of select="string('31')"/>
							</cbc:PaymentMeansCode>
							<xsl:for-each select="$var22_Payment/ns0:DueDate">
								<cbc:PaymentDueDate>
									<xsl:value-of select="string(.)"/>
								</cbc:PaymentDueDate>
							</xsl:for-each>
							<xsl:for-each select="$var22_Payment/ns0:KidNumber">
								<cbc:PaymentID>
									<xsl:value-of select="string(.)"/>
								</cbc:PaymentID>
							</xsl:for-each>
						</cac:PaymentMeans>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="$var1_Invoice">
					<xsl:variable name="var23_Payment" select="ns0:InvoiceHeader/ns0:Payment"/>
					<xsl:for-each select="$var23_Payment/ns0:PaymentDiscount">
						<cac:PaymentTerms>
							<xsl:for-each select="$var23_Payment/ns0:PaymentTerms">
								<cbc:Note>
									<xsl:value-of select="string(.)"/>
								</cbc:Note>
							</xsl:for-each>
						</cac:PaymentTerms>
					</xsl:for-each>
				</xsl:for-each>
				<xsl:for-each select="$var1_Invoice">
					<xsl:variable name="var26_cur" select="."/>
					<xsl:for-each select="ns0:InvoiceDiscountChargesAndTax/ns0:InvoiceDiscount">
						<xsl:variable name="var24_Amount" select="ns0:Amount"/>
						<cac:AllowanceCharge>
							<xsl:for-each select="$var24_Amount[(number(string(.)) &gt; '0')]">
								<xsl:variable name="var25_false" select="'false'"/>
								<cbc:ChargeIndicator>
									<xsl:value-of
										select="string(((normalize-space($var25_false) = 'true') or (normalize-space($var25_false) = '1')))"
									/>
								</cbc:ChargeIndicator>
							</xsl:for-each>
							<xsl:for-each select="ns0:Description">
								<cbc:AllowanceChargeReason>
									<xsl:value-of select="string(.)"/>
								</cbc:AllowanceChargeReason>
							</xsl:for-each>
							<xsl:for-each select="$var24_Amount">
								<cbc:Amount>
									<xsl:attribute name="currencyID" namespace="">
										<xsl:value-of
											select="string($var26_cur/ns0:InvoiceHeader/ns0:Payment/ns0:Currency)"
										/>
									</xsl:attribute>
									<xsl:value-of select="string(number(string(.)))"/>
								</cbc:Amount>
							</xsl:for-each>
							<cac:TaxCategory>
								<xsl:for-each
									select="$var26_cur/ns0:InvoiceSummary/ns0:VatTotalsInfo/ns0:VatPercent[(string(number(string(.))) &gt;= '24')]">
									<cbc:ID schemeID="UNCL5305">S</cbc:ID>
								</xsl:for-each>
								<cac:TaxScheme>
									<cbc:ID>VAT</cbc:ID>
								</cac:TaxScheme>
							</cac:TaxCategory>
						</cac:AllowanceCharge>
					</xsl:for-each>
				</xsl:for-each>
				<xsl:for-each select="$var1_Invoice">
					<xsl:variable name="var29_cur" select="."/>
					<xsl:for-each select="ns0:InvoiceDiscountChargesAndTax/ns0:InvoiceCharges">
						<xsl:variable name="var27_Amount" select="ns0:Amount"/>
						<cac:AllowanceCharge>
							<xsl:for-each select="$var27_Amount[(number(string(.)) &gt; '0')]">
								<xsl:variable name="var28_true" select="'true'"/>
								<cbc:ChargeIndicator>
									<xsl:value-of
										select="string(((normalize-space($var28_true) = 'true') or (normalize-space($var28_true) = '1')))"
									/>
								</cbc:ChargeIndicator>
							</xsl:for-each>
							<xsl:for-each select="ns0:Description">
								<cbc:AllowanceChargeReason>
									<xsl:value-of select="string(.)"/>
								</cbc:AllowanceChargeReason>
							</xsl:for-each>
							<xsl:for-each select="$var27_Amount">
								<cbc:Amount>
									<xsl:attribute name="currencyID" namespace="">
										<xsl:value-of
											select="string($var29_cur/ns0:InvoiceHeader/ns0:Payment/ns0:Currency)"
										/>
									</xsl:attribute>
									<xsl:value-of select="string(number(string(.)))"/>
								</cbc:Amount>
							</xsl:for-each>
							<cac:TaxCategory>
								<xsl:for-each
									select="$var29_cur/ns0:InvoiceSummary/ns0:VatTotalsInfo/ns0:VatPercent[(string(number(string(.))) &gt;= '24')]">
									<cbc:ID schemeID="UNCL5305">S</cbc:ID>
								</xsl:for-each>
								<cac:TaxScheme>
									<cbc:ID>VAT</cbc:ID>
								</cac:TaxScheme>
							</cac:TaxCategory>
						</cac:AllowanceCharge>
					</xsl:for-each>
				</xsl:for-each>
				<cac:TaxTotal>
					<xsl:for-each select="$var1_Invoice">
						<cbc:TaxAmount>
							<xsl:attribute name="currencyID" namespace="">
								<xsl:value-of
									select="string(ns0:InvoiceHeader/ns0:Payment/ns0:Currency)"/>
							</xsl:attribute>
							<xsl:value-of
								select="string(number(string(ns0:InvoiceSummary/ns0:InvoiceTotals/ns0:VatTotalsAmount)))"
							/>
						</cbc:TaxAmount>
					</xsl:for-each>
					<xsl:for-each select="$var1_Invoice">
						<xsl:variable name="var33_cur" select="."/>
						<xsl:variable name="var30_InvoiceSummary" select="ns0:InvoiceSummary"/>
						<xsl:for-each select="$var30_InvoiceSummary/ns0:VatTotalsInfo">
							<xsl:variable name="var31_VatPercent" select="ns0:VatPercent"/>
							<cac:TaxSubtotal>
								<xsl:for-each select="ns0:VatBaseAmount">
									<cbc:TaxableAmount>
										<xsl:attribute name="currencyID" namespace="">
											<xsl:value-of
												select="string($var33_cur/ns0:InvoiceHeader/ns0:Payment/ns0:Currency)"
											/>
										</xsl:attribute>
										<xsl:value-of select="string(number(string(.)))"/>
									</cbc:TaxableAmount>
								</xsl:for-each>
								<xsl:for-each select="ns0:VatAmount">
									<cbc:TaxAmount>
										<xsl:attribute name="currencyID" namespace="">
											<xsl:value-of
												select="string($var33_cur/ns0:InvoiceHeader/ns0:Payment/ns0:Currency)"
											/>
										</xsl:attribute>
										<xsl:value-of select="string(number(string(.)))"/>
									</cbc:TaxAmount>
								</xsl:for-each>
								<cac:TaxCategory>
									<xsl:for-each
										select="$var31_VatPercent[(string(number(string(.))) &gt;= '24')]">
										<cbc:ID schemeID="UNCL5305">S</cbc:ID>
									</xsl:for-each>
									<xsl:for-each select="$var31_VatPercent">
										<xsl:variable name="var32_resultof_cast"
											select="number(string(.))"/>
										<xsl:if
											test="string((($var32_resultof_cast &gt;= '5') and ($var32_resultof_cast &lt;= '18'))) != 'false'">
											<cbc:ID schemeID="UNCL5305">AA</cbc:ID>
										</xsl:if>
									</xsl:for-each>
									<xsl:for-each
										select="$var31_VatPercent[(number(string(.)) = '0')]">
										<cbc:ID schemeID="UNCL5305">E</cbc:ID>
									</xsl:for-each>
									<xsl:for-each select="$var31_VatPercent">
										<cbc:Percent>
											<xsl:value-of select="string(number(string(.)))"/>
										</cbc:Percent>
									</xsl:for-each>
									<xsl:for-each
										select="$var31_VatPercent[(number(string(.)) = '0')]">
										<cbc:TaxExemptionReasonCode>AAM</cbc:TaxExemptionReasonCode>
									</xsl:for-each>
									<xsl:for-each
										select="$var31_VatPercent[(number(string(.)) = '0')]">
										<cbc:TaxExemptionReason>Exempt New Means of
											Transport</cbc:TaxExemptionReason>
									</xsl:for-each>
									<cac:TaxScheme>
										<!--									<xsl:if
											test="string((number(string($var30_InvoiceSummary/ns0:InvoiceTotals/ns0:VatTotalsAmount)) &gt; '0')) != 'false'">-->
										<cbc:ID>VAT</cbc:ID>
										<!--</xsl:if>-->
									</cac:TaxScheme>
								</cac:TaxCategory>
							</cac:TaxSubtotal>
						</xsl:for-each>
					</xsl:for-each>
				</cac:TaxTotal>
				<cac:LegalMonetaryTotal>
					<xsl:for-each select="$var1_Invoice">
						<xsl:variable name="var34_cur" select="."/>
						<xsl:for-each
							select="ns0:InvoiceSummary/ns0:InvoiceTotals/ns0:LineItemTotalsAmount">
							<cbc:LineExtensionAmount>
								<xsl:attribute name="currencyID" namespace="">
									<xsl:value-of
										select="string($var34_cur/ns0:InvoiceHeader/ns0:Payment/ns0:Currency)"
									/>
								</xsl:attribute>
								<xsl:value-of select="string(number(string(.)))"/>
							</cbc:LineExtensionAmount>
						</xsl:for-each>
					</xsl:for-each>
					<xsl:for-each select="$var1_Invoice">
						<cbc:TaxExclusiveAmount>
							<xsl:attribute name="currencyID" namespace="">
								<xsl:value-of
									select="string(ns0:InvoiceHeader/ns0:Payment/ns0:Currency)"/>
							</xsl:attribute>
							<xsl:value-of
								select="string(number(string(ns0:InvoiceSummary/ns0:InvoiceTotals/ns0:NetAmount)))"
							/>
						</cbc:TaxExclusiveAmount>
					</xsl:for-each>
					<xsl:for-each select="$var1_Invoice">
						<cbc:TaxInclusiveAmount>
							<xsl:attribute name="currencyID" namespace="">
								<xsl:value-of
									select="string(ns0:InvoiceHeader/ns0:Payment/ns0:Currency)"/>
							</xsl:attribute>
							<xsl:value-of
								select="string(number(string(ns0:InvoiceSummary/ns0:InvoiceTotals/ns0:ActualPayment)))"
							/>
						</cbc:TaxInclusiveAmount>
					</xsl:for-each>
					<xsl:for-each select="$var1_Invoice">
						<xsl:variable name="var35_cur" select="."/>
						<xsl:for-each
							select="ns0:InvoiceSummary/ns0:InvoiceTotals/ns0:DiscountTotalsAmount">
							<cbc:AllowanceTotalAmount>
								<xsl:attribute name="currencyID" namespace="">
									<xsl:value-of
										select="string($var35_cur/ns0:InvoiceHeader/ns0:Payment/ns0:Currency)"
									/>
								</xsl:attribute>
								<xsl:value-of select="string(number(string(.)))"/>
							</cbc:AllowanceTotalAmount>
						</xsl:for-each>
					</xsl:for-each>
					<xsl:for-each select="$var1_Invoice">
						<xsl:variable name="var36_cur" select="."/>
						<xsl:for-each
							select="ns0:InvoiceSummary/ns0:InvoiceTotals/ns0:ChargesTotalsAmount">
							<cbc:ChargeTotalAmount>
								<xsl:attribute name="currencyID" namespace="">
									<xsl:value-of
										select="string($var36_cur/ns0:InvoiceHeader/ns0:Payment/ns0:Currency)"
									/>
								</xsl:attribute>
								<xsl:value-of select="string(number(string(.)))"/>
							</cbc:ChargeTotalAmount>
						</xsl:for-each>
					</xsl:for-each>
					<xsl:for-each select="$var1_Invoice">
						<xsl:variable name="var37_cur" select="."/>
						<xsl:for-each
							select="ns0:InvoiceSummary/ns0:InvoiceTotals/ns0:PrePaidAmount">
							<cbc:PrepaidAmount>
								<xsl:attribute name="currencyID" namespace="">
									<xsl:value-of
										select="string($var37_cur/ns0:InvoiceHeader/ns0:Payment/ns0:Currency)"
									/>
								</xsl:attribute>
								<xsl:value-of select="string(number(string(.)))"/>
							</cbc:PrepaidAmount>
						</xsl:for-each>
					</xsl:for-each>
					<xsl:for-each select="$var1_Invoice">
						<xsl:variable name="var38_cur" select="."/>
						<xsl:for-each
							select="ns0:InvoiceSummary/ns0:InvoiceTotals/ns0:RoundingAmount">
							<cbc:PayableRoundingAmount>
								<xsl:attribute name="currencyID" namespace="">
									<xsl:value-of
										select="string($var38_cur/ns0:InvoiceHeader/ns0:Payment/ns0:Currency)"
									/>
								</xsl:attribute>
								<xsl:value-of select="string(number(string(.)))"/>
							</cbc:PayableRoundingAmount>
						</xsl:for-each>
					</xsl:for-each>
					<xsl:for-each
						select="$var1_Invoice/ns0:InvoiceSummary/ns0:InvoiceTotals/ns0:ActualPayment">
						<cbc:PayableAmount>

							<xsl:attribute name="currencyID" namespace="">
								<xsl:value-of
									select="string(//ns0:InvoiceHeader/ns0:Payment/ns0:Currency)"/>
							</xsl:attribute>

							<xsl:value-of select="string(number(string(.)))"/>
						</cbc:PayableAmount>
					</xsl:for-each>
				</cac:LegalMonetaryTotal>
				<xsl:for-each select="$var1_Invoice">
					<xsl:variable name="var52_cur" select="."/>
					<xsl:variable name="var40_BaseItemDetails" select="//ns0:BaseItemDetails"/>
					<xsl:for-each select="$var40_BaseItemDetails">
						<cac:CreditNoteLine>
							<xsl:for-each select="ns0:LineItemNum">
								<cbc:ID>
									<xsl:value-of select="string(.)"/>
								</cbc:ID>
							</xsl:for-each>
							<xsl:for-each select="ns0:FreeText">
								<cbc:Note>
									<xsl:value-of select="string(.)"/>
								</cbc:Note>
							</xsl:for-each>
							<xsl:variable name="var41_cur" select="."/>
							<xsl:for-each select="ns0:QuantityInvoiced">
								<cbc:CreditedQuantity unitCodeListID="UNECERec20" unitCode="PK">
									<!--<xsl:for-each select="$var41_cur/ns0:UnitOfMeasure">
										<xsl:attribute name="unitCode" namespace="">
											<xsl:choose>
												<xsl:when test="string(.) = 'PAK'">
													<xsl:value-of select='PK'/>
												</xsl:when>
												<xsl:otherwise><xsl:value-of select="string(.)"/></xsl:otherwise>
											</xsl:choose>
											<xsl:value-of select="PK"/>
										</xsl:attribute>
									</xsl:for-each>-->
									<xsl:value-of select="string(number(string(.)))"/>
								</cbc:CreditedQuantity>
							</xsl:for-each>
							<xsl:variable name="var42_cur" select="."/>
							<xsl:for-each select="ns0:LineItemAmount">
								<cbc:LineExtensionAmount>
									<xsl:attribute name="currencyID" namespace="">
										<xsl:value-of
											select="string($var1_Invoice/ns0:InvoiceHeader/ns0:Payment/ns0:Currency)"
										/>
									</xsl:attribute>
									<xsl:value-of select="string(number(string(.)))"/>
								</cbc:LineExtensionAmount>
							</xsl:for-each>

							<xsl:for-each select="ns0:PostingInformation">
								<cbc:AccountingCost>
									<xsl:value-of select="string(.)"/>
								</cbc:AccountingCost>
							</xsl:for-each>
							<xsl:if test="count(ns0:OrderInformation) > 0">
								<cac:OrderLineReference>
									<xsl:for-each select="ns0:OrderInformation/ns0:LineNum">
										<cbc:LineID>
											<xsl:value-of select="string(.)"/>
										</cbc:LineID>
									</xsl:for-each>
								</cac:OrderLineReference>
							</xsl:if>
							<xsl:for-each select="ns0:Discount">
								<xsl:variable name="var43_Amount" select="ns0:Amount"/>
								<cac:AllowanceCharge>
									<!--<xsl:for-each select="$var43_Amount[(number(string(.)) &gt; '0')]">-->
									<xsl:variable name="var44_false" select="'false'"/>
									<cbc:ChargeIndicator>
										<xsl:value-of
											select="string(((normalize-space($var44_false) = 'true') or (normalize-space($var44_false) = '1')))"
										/>
									</cbc:ChargeIndicator>
									<!--</xsl:for-each>-->
									<xsl:for-each select="ns0:Description">
										<cbc:AllowanceChargeReason>
											<xsl:value-of select="string(.)"/>
										</cbc:AllowanceChargeReason>
									</xsl:for-each>
									<xsl:for-each select="$var43_Amount">
										<cbc:Amount>
											<xsl:attribute name="currencyID" namespace="">
												<xsl:value-of
												select="string($var52_cur/ns0:InvoiceHeader/ns0:Payment/ns0:Currency)"
												/>
											</xsl:attribute>
											<xsl:value-of select="string(number(string(.)))"/>
										</cbc:Amount>
									</xsl:for-each>
								</cac:AllowanceCharge>
							</xsl:for-each>
							<xsl:for-each select="ns0:Charges">
								<xsl:variable name="var45_Amount" select="ns0:Amount"/>
								<cac:AllowanceCharge>
									<xsl:for-each
										select="$var45_Amount[(number(string(.)) &gt; '0')]">
										<xsl:variable name="var46_true" select="'true'"/>
										<cbc:ChargeIndicator>
											<xsl:value-of
												select="string(((normalize-space($var46_true) = 'true') or (normalize-space($var46_true) = '1')))"
											/>
										</cbc:ChargeIndicator>
									</xsl:for-each>
									<xsl:for-each select="ns0:Description">
										<cbc:AllowanceChargeReason>
											<xsl:value-of select="string(.)"/>
										</cbc:AllowanceChargeReason>
									</xsl:for-each>
									<xsl:for-each select="$var45_Amount">
										<cbc:Amount>
											<xsl:attribute name="currencyID" namespace="">
												<xsl:value-of
												select="string($var52_cur/ns0:InvoiceHeader/ns0:Payment/ns0:Currency)"
												/>
											</xsl:attribute>
											<xsl:value-of select="string(number(string(.)))"/>
										</cbc:Amount>
									</xsl:for-each>
								</cac:AllowanceCharge>
							</xsl:for-each>
							<!--<cac:TaxTotal>
								<xsl:variable name="var47_cur" select="."/>
								<xsl:for-each select="ns0:VatInfo/ns0:VatAmount">
									<cbc:TaxAmount>
										<xsl:attribute name="currencyID" namespace="">
											<xsl:value-of
												select="string($var52_cur/ns0:InvoiceHeader/ns0:Payment/ns0:Currency)"
											/>
										</xsl:attribute>
										<xsl:value-of select="string(number(string(.)))"/>
									</cbc:TaxAmount>
								</xsl:for-each>
							</cac:TaxTotal>-->
							<cac:Item>
								<cbc:Name>
									<xsl:value-of select="string(ns0:Description)"/>
								</cbc:Name>

								<cac:SellersItemIdentification>
									<xsl:for-each select="ns0:SuppliersProductId">
										<cbc:ID>
											<xsl:value-of select="string(.)"/>
										</cbc:ID>
									</xsl:for-each>
								</cac:SellersItemIdentification>
								<xsl:for-each select="ns0:AdditionalProductId">
									<cac:StandardItemIdentification>
										<xsl:variable name="var48_cur" select="."/>
										<xsl:for-each select="ns0:Text">
											<cbc:ID>
												<xsl:attribute name="schemeID" namespace="">
												<xsl:value-of select="string($var48_cur/ns0:Code)"
												/>
												</xsl:attribute>
												<xsl:value-of select="string(.)"/>
											</cbc:ID>
										</xsl:for-each>
									</cac:StandardItemIdentification>
								</xsl:for-each>
								<cac:ClassifiedTaxCategory>
									<xsl:for-each
										select="ns0:VatInfo/ns0:VatPercent[(string(number(string(.))) &gt;= '24')]">
										<cbc:ID>S</cbc:ID>
									</xsl:for-each>
									<xsl:for-each select="ns0:VatInfo/ns0:VatPercent">
										<xsl:variable name="var49_resultof_cast"
											select="number(string(.))"/>
										<xsl:if
											test="string((($var49_resultof_cast &gt;= '5') and ($var49_resultof_cast &lt;= '18'))) != 'false'">
											<cbc:ID>AA</cbc:ID>
										</xsl:if>
									</xsl:for-each>
									<xsl:for-each
										select="ns0:VatInfo/ns0:VatPercent[(number(string(.)) = '0')]">
										<cbc:ID>E</cbc:ID>
									</xsl:for-each>
									<xsl:for-each select="ns0:VatInfo/ns0:VatPercent">
										<cbc:Percent>
											<xsl:value-of select="string(number(string(.)))"/>
										</cbc:Percent>
									</xsl:for-each>
									<cac:TaxScheme>
										<cbc:ID>VAT</cbc:ID>
									</cac:TaxScheme>
								</cac:ClassifiedTaxCategory>
							</cac:Item>
							<cac:Price>
								<xsl:variable name="var51_cur" select="."/>
								<xsl:for-each select="ns0:UnitPrice">
									<xsl:variable name="var50_result">
										<xsl:for-each select="$var51_cur/ns0:PriceType">
											<xsl:choose>
												<xsl:when
												test="string((string(.) = 'AAA')) != 'false'">
												<xsl:value-of select="'1'"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of select="''"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>
									</xsl:variable>
									<!--<xsl:if test="string(boolean(string($var50_result))) != 'false'">-->
									<cbc:PriceAmount>

										<xsl:attribute name="currencyID" namespace="">
											<xsl:value-of
												select="string($var52_cur/ns0:InvoiceHeader/ns0:Payment/ns0:Currency)"
											/>
										</xsl:attribute>

										<xsl:value-of select="string(number(string(.)))"/>
									</cbc:PriceAmount>
									<!--</xsl:if>-->
								</xsl:for-each>

								<xsl:for-each select="ns0:PerQuantity">
									<cbc:BaseQuantity>
										<xsl:value-of select="string(number(string(.)))"/>
									</cbc:BaseQuantity>
								</xsl:for-each>
							</cac:Price>
						</cac:CreditNoteLine>
					</xsl:for-each>
				</xsl:for-each>
			</CreditNote>
		</xsl:variable>
		<xsl:apply-templates mode="pass2" select="ext:node-set($vrtfPass1Result)/*"/>
	</xsl:template>

	<xsl:template match="node() | @*" mode="pass2">
		<xsl:copy>
			<xsl:apply-templates select="node() | @*" mode="pass2"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="/*" mode="pass2">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="pass2"/>
		</xsl:copy>
	</xsl:template>


	<xsl:template match="*[not(*) and not(normalize-space())]" mode="pass2">
		<xsl:element name="{name()}" namespace="{namespace-uri()}">NA</xsl:element>
	</xsl:template>

</xsl:stylesheet>
