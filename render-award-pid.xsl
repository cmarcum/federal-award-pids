<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:stratml="http://stratml.net/StratML"
    xmlns:dd="http://awards.gov/schema/datadictionary"
    exclude-result-prefixes="stratml dd">

  <xsl:output method="html" indent="yes" encoding="UTF-8"/>

  <xsl:template match="/">
    <html>
      <head>
        <title>PID System XML Rendering</title>
      </head>
      <body>

        <xsl:choose>
          <xsl:when test="/*[local-name()='StrategicPlan']">
            <xsl:call-template name="render-stratml"/>
          </xsl:when>

          <xsl:when test="/*[local-name()='DataDictionary']">
            <xsl:call-template name="render-dictionary"/>
          </xsl:when>

          <xsl:otherwise>
            <h1>Unknown Document Type</h1>
          </xsl:otherwise>
        </xsl:choose>

      </body>
    </html>
  </xsl:template>

  <xsl:template name="render-stratml">
    <h1>Strategic Plan</h1>
  </xsl:template>

  <xsl:template name="render-dictionary">
    <h1>Data Dictionary</h1>
  </xsl:template>

</xsl:stylesheet>
