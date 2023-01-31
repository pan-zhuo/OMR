<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dct="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#" exclude-result-prefixes="xs" version="3.0">
    
    <xsl:output omit-xml-declaration="no" indent="yes" suppress-indentation="comment"/>
    
    <xsl:variable name="base" select="'http://fakeIRI.edu/terms/'"/>
    
    <xsl:template match="/">
        <xsl:apply-templates select="rdf:RDF"/>
    </xsl:template>
    
    <xsl:template match="rdf:RDF">
        <rdf:RDF xmlns:dct="http://purl.org/dc/terms/"
            xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
            xmlns:skos="http://www.w3.org/2004/02/skos/core#">
            <xsl:apply-templates select="node()"/>
        </rdf:RDF>
    </xsl:template>
    
    <xsl:template match="comment()[position() != last()]" expand-text="yes">
        <xsl:comment>{.}</xsl:comment>
    </xsl:template>
    
    <xsl:template match="skos:ConceptScheme" expand-text="yes">
        <xsl:variable name="schemeID"
            select="substring-after(@rdf:about, 'http://marc21rdf.info/terms/')"/>
        <skos:ConceptScheme rdf:about="{concat($base, $schemeID)}">
            <dct:title>{dc:title}</dct:title>
            <dct:description>To be filled from CSV</dct:description>
            <dct:publisher rdf:resource="http://viaf.org/viaf/139541794"/>
        </skos:ConceptScheme>
    </xsl:template>
    
    <xsl:template match="skos:Concept[position() != last()]" expand-text="yes">
        <xsl:variable name="conceptID"
            select="substring-after(@rdf:about, 'http://marc21rdf.info/terms/')"/>
        <skos:Concept rdf:about="{concat($base, $conceptID)}" xml:lang="en">
            <skos:inScheme rdf:resource="{concat($base, substring-before($conceptID, '#'), '#')}"/>
            <skos:prefLabel xml:lang="en">{skos:prefLabel}</skos:prefLabel>
            <xsl:if test="skos:definition">
                <skos:definition xml:lang="en">{skos:definition}</skos:definition>
            </xsl:if>
            <skos:notation xml:lang="en">{skos:notation}</skos:notation>
            <xsl:if test="skos:scopeNote">
                <skos:scopeNote xml:lang="en">{skos:scopeNote}</skos:scopeNote>
            </xsl:if>
            <skos:exactMatch rdf:resource="{@rdf:about}"/>
        </skos:Concept>
    </xsl:template>
    
    <xsl:template match="skos:Concept[position() = last()]"/>
</xsl:stylesheet>
