<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns="http://www.tei-c.org/ns/1.0" xmlns:t="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="#all">

  <xsl:param name="dir" required="yes"/>
  <xsl:param name="base" required="yes"/>

  <xsl:output indent="yes" method="xml"/>

  <xsl:template match="/t:TEI">
    <xsl:for-each select=".//t:text/t:body/t:div[@type='letter']">
      <xsl:variable name="file"><xsl:number format="000"/>.xml</xsl:variable>

      <xsl:variable name="outfile">
        <xsl:value-of select="$dir"/>/<xsl:value-of select="$base"/>-<xsl:value-of select="$file"/>
      </xsl:variable>
      <xsl:value-of select="$outfile"/><xsl:text>&#x0a;</xsl:text>
      <xsl:result-document href="{$outfile}">
        <xsl:variable name="author_full" select="replace(substring-before( substring-after(current()/t:head/t:supplied, ': '), ' ('), 'Vorname unbekannt', '')"/>
        <xsl:variable name="date_full" select="replace(current()/t:head//t:date[1], 'genaues Datum unbekannt', '')"/>
        <xsl:text disable-output-escaping="yes">
&lt;?xml-model href="https://www.deutschestextarchiv.de/basisformat_ms.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?&gt;
&lt;?xml-model href="https://www.deutschestextarchiv.de/basisformat.sch" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"?&gt;
</xsl:text>
<TEI>
  <teiHeader>
    <fileDesc>
      <titleStmt>
        <title type="main">
          <xsl:text>[</xsl:text>
          <xsl:apply-templates select="current()/t:head"/>
          <xsl:text>]</xsl:text>
        </title>
        <author>
          <persName>
            <surname>
              <xsl:value-of select="substring-after($author_full, ' ')"/>
            </surname>
            <forename>
              <xsl:value-of select="substring-before($author_full, ' ')"/>
            </forename>
          </persName>
        </author>
        <respStmt>
          <persName>
            <surname>Thomas</surname>
            <forename>Christian</forename>
          </persName>
          <persName>
            <surname>Wiegand</surname>
            <forename>Frank</forename>
          </persName>
          <persName ref="http://d-nb.info/gnd/1204665788">
            <surname>Hug</surname>
            <forename>Marius</forename>
          </persName>
          <orgName ref="https://www.bbaw.de">BBAW</orgName>
          <resp>
            <note type="remarkResponsibility">Text+: Konversion und Kuration der Textsammlung. Langfristige Bereitstellung der DTA-Ausgabe.</note>
          </resp>
        </respStmt>
        <respStmt>
          <persName ref="https://d-nb.info/gnd/115605771X">
            <surname>Neumann</surname>
            <forename>Marko</forename>
          </persName>
          <resp>
            <note type="remarkResponsibility">Transkription von 170 „Soldatenbriefen“ aus den Jahren 1745 bis 1872. Die Briefe entstammen Editionen, Digitalisierungsprojekten, vor allem aber eigener Archivarbeit von Stralsund bis München und Wien. Als Dissertation auch veröffentlicht im Universitätsverlag Winter, siehe <ref target="https://www.winter-verlag.de/de/detail/978-3-8253-4642-3/Neumann_Soldatenbriefe/">Marko Neumann: Soldatenbriefe des 18. und 19. Jahrhunderts, 2019</ref>.</note>
          </resp>
        </respStmt>
      </titleStmt>
      <editionStmt>
        <edition>Vollständige digitalisierte Ausgabe.</edition>
      </editionStmt>
      <extent/>
      <publicationStmt>
        <publisher xml:id="DTACorpusPublisher">
          <orgName>Deutsches Textarchiv</orgName>
          <orgName role="hostingInstitution" xml:lang="eng">Berlin-Brandenburg Academy of Sciences and Humanities (BBAW)</orgName>
          <orgName role="hostingInstitution" xml:lang="deu">Berlin-Brandenburgische Akademie der Wissenschaften (BBAW)</orgName>
          <email>dta@bbaw.de</email>
          <address>
            <addrLine>Jägerstr. 22/23, 10117 Berlin</addrLine>
          </address>
        </publisher>
        <pubPlace>Berlin</pubPlace>
        <date type="publication">
          <xsl:value-of select="replace(string(current-dateTime()),'\..*','Z')"/>
        </date>
        <availability>
          <licence target="http://creativecommons.org/licenses/by-sa/4.0/deed.de"><p>Namensnennung – Weitergabe unter gleichen Bedingungen 4.0 International (CC BY-SA 4.0)</p></licence>
        </availability>
      </publicationStmt>
      <sourceDesc>
        <bibl type="MAN">
          <xsl:text>Soldatenbrief Nr. </xsl:text>
          <xsl:value-of select="current()/@n"/>
          <xsl:text> von </xsl:text>
          <xsl:value-of select="$author_full"/>
          <xsl:text>, </xsl:text>
          <xsl:value-of select="$date_full"/>
          <xsl:text>.</xsl:text>
        </bibl>
        <biblFull>
          <titleStmt>
            <title level="m" type="main">
              <xsl:text>[</xsl:text>
              <xsl:apply-templates select="current()/t:head"/>
              <xsl:text>]</xsl:text>
            </title>
            <author>
              <persName>
                <surname>
                  <xsl:value-of select="substring-after($author_full, ' ')"/>
                </surname>
                <forename>
                  <xsl:value-of select="substring-before($author_full, ' ')"/>
                </forename>
              </persName>
            </author>
          </titleStmt>
          <editionStmt>
            <edition/>
          </editionStmt>
          <publicationStmt>
            <publisher/>
            <date>
              <xsl:attribute name="when"><xsl:value-of select="current()/t:head//t:date[1]/@when"/></xsl:attribute>
              <xsl:value-of select="replace($date_full, '.*\.(\d{4})', '$1')"/>
            </date>
          </publicationStmt>
        </biblFull>
        <msDesc>
          <msIdentifier/>
          <physDesc/>
        </msDesc>
      </sourceDesc>
    </fileDesc>
    <encodingDesc>
      <p>Dieses Werk wurde unter Berücksichtigung der <ref target="https://www.deutschestextarchiv.de/doku/richtlinien">DTA-Transkriptionsrichtlinien</ref> erstellt.</p>
      <p>Der Text ist kodiert nach <ref target="https://www.deutschestextarchiv.de/doku/basisformat">DTA-Basisformat (DTABf)</ref>.</p>
    </encodingDesc>
    <profileDesc>
      <langUsage>
        <language ident="deu">(Früh-)Neuhochdeutsch</language>
      </langUsage>
      <textClass>
        <classCode scheme="https://www.deutschestextarchiv.de/doku/klassifikation#dwds1main">Gebrauchsliteratur</classCode>
        <classCode scheme="https://www.deutschestextarchiv.de/doku/klassifikation#dwds1sub">Brief</classCode>
      </textClass>
    </profileDesc>
  </teiHeader>
  <text>
    <body>
      <xsl:copy-of select="."/>
    </body>
  </text>
</TEI>
      </xsl:result-document>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="t:head//t:choice/t:abbr"/>
  <xsl:template match="t:head//t:note[@type='editorial']"/>

</xsl:stylesheet>
