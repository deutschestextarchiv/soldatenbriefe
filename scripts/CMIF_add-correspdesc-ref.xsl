<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:correspDesc">
        <xsl:variable name="base-url" select="'https://github.com/deutschestextarchiv/soldatenbriefe/blob/main/data/letter-'"/>
        <xsl:variable name="id">
            <xsl:choose>
                <xsl:when test="matches(@key, '\d\d\d$')">
                    <xsl:value-of select="@key"/>
                </xsl:when>
                <xsl:when test="matches(@key, '^\d\d$')">
                    <xsl:value-of select="concat('0', @key)"/>
                </xsl:when>
                <xsl:when test="matches(@key, '^\d$')">
                    <xsl:value-of select="concat('00', @key)"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="correspDesc">
            <xsl:if test="$id">
            <xsl:attribute name="ref">
                <xsl:value-of select="concat($base-url, $id, '.xml')"/>
            </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="@*|node()"/>            
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>