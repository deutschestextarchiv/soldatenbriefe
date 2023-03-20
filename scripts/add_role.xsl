<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:exslt="http://exslt.org/common"
    xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="3.0">

  <xsl:variable name="role" select="substring-before(substring-after(tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='main'],'('),')')"/>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
    

  <xsl:template match="tei:author/tei:persName">
    <xsl:element name="persName" namespace="http://www.tei-c.org/ns/1.0">
      <xsl:attribute name="role"> 
        <xsl:value-of select="$role"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
