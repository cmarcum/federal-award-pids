<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:stratml="http://stratml.net/StratML"
    xmlns:dd="http://awards.gov/schema/datadictionary"
    exclude-result-prefixes="stratml dd">

  <!-- Output HTML -->
  <xsl:output method="html" indent="yes" encoding="UTF-8"/>

  <!-- Root template -->
  <xsl:template match="/">
    <html>
      <head>
        <title>PID System XML Rendering</title>
        <style>
          body {
            font-family: Arial, sans-serif;
            margin: 30px;
            background: #fafafa;
          }
          h1, h2, h3 {
            color: #003366;
            font-family: Georgia, serif;
          }
          table {
            border-collapse: collapse;
            width: 100%;
            margin-bottom: 25px;
            background: white;
          }
          th, td {
            border: 1px solid #999;
            padding: 8px 10px;
          }
          th {
            background: #003366;
            color: #fff;
            text-align: left;
          }
          .section {
            margin: 30px 0;
            padding: 20px;
            background: #fff;
            border: 1px solid #ccc;
          }
        </style>
      </head>
      <body>

        <!-- Document Type Switch -->
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

  <!-- ====================== -->
  <!-- STRATML RENDERING      -->
  <!-- ====================== -->
  <xsl:template name="render-stratml">
    <h1>Strategic Plan</h1>

    <!-- Header -->
    <div class="section">
      <h2>Header</h2>
      <table>
        <tr><th>Field</th><th>Value</th></tr>
        <tr><td>Title</td><td><xsl:value-of select="/stratml:StrategicPlan/stratml:Header/stratml:Title"/></td></tr>
        <tr><td>Version</td><td><xsl:value-of select="/stratml:StrategicPlan/stratml:Header/stratml:Version"/></td></tr>
        <tr><td>Date</td><td><xsl:value-of select="/stratml:StrategicPlan/stratml:Header/stratml:Date"/></td></tr>
        <tr><td>Description</td><td><xsl:value-of select="/stratml:StrategicPlan/stratml:Header/stratml:Description"/></td></tr>
      </table>
    </div>

    <!-- Vision -->
    <div class="section">
      <h2>Vision</h2>
      <p><xsl:value-of select="/stratml:StrategicPlan/stratml:Vision"/></p>
    </div>

    <!-- Mission -->
    <div class="section">
      <h2>Mission</h2>
      <p><xsl:value-of select="/stratml:StrategicPlan/stratml:Mission"/></p>
    </div>

    <!-- Values -->
    <div class="section">
      <h2>Values</h2>
      <ul>
        <xsl:for-each select="/stratml:StrategicPlan/stratml:Values/stratml:Value">
          <li><xsl:value-of select="."/></li>
        </xsl:for-each>
      </ul>
    </div>

    <!-- Stakeholders -->
    <div class="section">
      <h2>Stakeholders</h2>
      <ul>
        <xsl:for-each select="/stratml:StrategicPlan/stratml:Stakeholders/stratml:Stakeholder">
          <li><xsl:value-of select="stratml:Name"/></li>
        </xsl:for-each>
      </ul>
    </div>

    <!-- Goals & Objectives -->
    <div class="section">
      <h2>Goals</h2>

      <xsl:for-each select="/stratml:StrategicPlan/stratml:Goals/stratml:Goal">
        <h3>
          <xsl:value-of select="stratml:Identifier"/> – 
          <xsl:value-of select="stratml:Name"/>
        </h3>

        <xsl:for-each select="stratml:Objectives/stratml:Objective">
          <table>
            <tr><th colspan="2"><xsl:value-of select="stratml:Identifier"/> – <xsl:value-of select="stratml:Name"/></th></tr>
            <tr><td>Description</td><td><xsl:value-of select="stratml:Description"/></td></tr>

            <tr>
              <td>Performance Indicators</td>
              <td>
                <ul>
                  <xsl:for-each select="stratml:PerformanceIndicators/stratml:PerformanceIndicator">
                    <li><xsl:value-of select="."/></li>
                  </xsl:for-each>
                </ul>
              </td>
            </tr>
          </table>
        </xsl:for-each>

      </xsl:for-each>
    </div>

  </xsl:template>

  <!-- ====================== -->
  <!-- DATA DICTIONARY FORMAT -->
  <!-- ====================== -->
  <xsl:template name="render-dictionary">
    <h1>Unified PID System – Data Dictionary</h1>

    <!-- Metadata Section -->
    <div class="section">
      <h2>Metadata</h2>
      <table>
        <tr><th>Field</th><th>Value</th></tr>
        <tr><td>Title</td><td><xsl:value-of select="/dd:DataDictionary/dd:Metadata/dd:Title"/></td></tr>
        <tr><td>Version</td><td><xsl:value-of select="/dd:DataDictionary/dd:Metadata/dd:Version"/></td></tr>
        <tr><td>Date</td><td><xsl:value-of select="/dd:DataDictionary/dd:Metadata/dd:Date"/></td></tr>
        <tr><td>Description</td><td><xsl:value-of select="/dd:DataDictionary/dd:Metadata/dd:Description"/></td></tr>
      </table>
    </div>

    <!-- Fields Section -->
    <div class="section">
      <h2>Fields</h2>

      <xsl:for-each select="/dd:DataDictionary/dd:Fields/dd:Field">
        <table>
          <tr><th colspan="2"><xsl:value-of select="dd:Name"/></th></tr>

          <tr><td>Definition</td><td><xsl:value-of select="dd:Definition"/></td></tr>

          <xsl:if test="dd:AlternateName">
            <tr><td>Alternate Name</td><td><xsl:value-of select="dd:AlternateName"/></td></tr>
          </xsl:if>

          <tr><td>Format</td><td><xsl:value-of select="dd:Format"/></td></tr>
          <tr><td>Required</td><td><xsl:value-of select="dd:Required"/></td></tr>

          <xsl:if test="dd:Example">
            <tr><td>Example</td><td><xsl:value-of select="dd:Example"/></td></tr>
          </xsl:if>
        </table>
      </xsl:for-each>

    </div>
  </xsl:template>
  <!-- Adding some experimental functionality to render URLs as active links -->
    <xsl:template match="text()">
      <xsl:call-template name="linkify">
        <xsl:with-param name="text" select="." />
      </xsl:call-template>
    </xsl:template>
    
    <!-- Recursive URL detection & hyperlinking -->
    <xsl:template name="linkify">
      <xsl:param name="text"/>
    
      <!-- Detect first http:// or https:// occurrence -->
      <xsl:variable name="http-pos" select="string-length(substring-before($text, 'http://')) + 1"/>
      <xsl:variable name="https-pos" select="string-length(substring-before($text, 'https://')) + 1"/>
    
      <!-- Choose the earliest URL occurrence -->
      <xsl:variable name="pos">
        <xsl:choose>
          <xsl:when test="contains($text, 'http://') and contains($text, 'https://')">
            <xsl:choose>
              <xsl:when test="$http-pos &lt; $https-pos"><xsl:value-of select="$http-pos"/></xsl:when>
              <xsl:otherwise><xsl:value-of select="$https-pos"/></xsl:otherwise>
            </xsl:choose>
          </xsl:when>
    
          <xsl:when test="contains($text, 'http://')"><xsl:value-of select="$http-pos"/></xsl:when>
          <xsl:when test="contains($text, 'https://')"><xsl:value-of select="$https-pos"/></xsl:when>
    
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
    
      <!-- If no URL found, output text normally -->
      <xsl:if test="$pos = 0">
        <xsl:value-of select="$text"/>
      </xsl:if>
    
      <!-- Otherwise, output text up to the URL, then the URL as a link -->
      <xsl:if test="$pos &gt; 0">
        <!-- Output text before URL -->
        <xsl:value-of select="substring($text, 1, $pos - 1)"/>
    
        <!-- Extract URL up to next space or end -->
        <xsl:variable name="rest" select="substring($text, $pos)"/>
        <xsl:variable name="url-end">
          <xsl:choose>
            <xsl:when test="contains($rest, ' ')">
              <xsl:value-of select="string-length(substring-before($rest, ' '))"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="string-length($rest)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="url" select="substring($rest, 1, $url-end)"/>
    
        <!-- Output clickable link -->
        <a href="{$url}" target="_blank">
          <xsl:value-of select="$url"/>
        </a>
    
        <!-- Recursively process remaining text -->
        <xsl:variable name="remaining" select="substring($rest, $url-end + 1)"/>
        <xsl:call-template name="linkify">
          <xsl:with-param name="text" select="$remaining"/>
        </xsl:call-template>
      </xsl:if>
    
    </xsl:template>

</xsl:stylesheet>
