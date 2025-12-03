<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:stratml="http://stratml.net/StratML"
    xmlns:dd="http://awards.gov/schema/datadictionary"
    exclude-result-prefixes="stratml dd">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <!-- ========================================================= -->
  <!-- Root template that renders the base page                  -->
  <!-- ========================================================= -->
    
  <xsl:template match="/">
    <html>
      <head>
        <title>Federal Award PID System</title>
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
            <h2>Unknown Document Type</h2>
          </xsl:otherwise>
        </xsl:choose>

      </body>
    </html>
  </xsl:template>

  <!-- ========================================================= -->
  <!-- RENDER STRATML STRATEGIC PLAN                             -->
  <!-- ========================================================= -->
    
  <xsl:template name="render-stratml">
    <h1>Strategic Plan</h1>

    <div class="section">
      <h2>Header</h2>
      <table>
        <tr><th>Title</th><td><xsl:call-template name="linkify-text"><xsl:with-param name="text" select="//stratml:Title"/></xsl:call-template></td></tr>
        <tr><th>Identifier</th><td><xsl:call-template name="linkify-text"><xsl:with-param name="text" select="//stratml:Identifier"/></xsl:call-template></td></tr>
        <tr><th>Description</th><td><xsl:call-template name="linkify-text"><xsl:with-param name="text" select="//stratml:Description"/></xsl:call-template></td></tr>
        <tr><th>Version</th><td><xsl:call-template name="linkify-text"><xsl:with-param name="text" select="//stratml:Version"/></xsl:call-template></td></tr>
      </table>
    </div>

    <h2>Goals</h2>
    <xsl:for-each select="//stratml:Goal">
      <div class="section">
        <h3>
          <xsl:call-template name="linkify-text">
            <xsl:with-param name="text" select="stratml:Name"/>
          </xsl:call-template>
        </h3>

        <p>
          <xsl:call-template name="linkify-text">
            <xsl:with-param name="text" select="stratml:Description"/>
          </xsl:call-template>
        </p>

        <h4>Objectives</h4>
        <ul>
          <xsl:for-each select="stratml:Objective">
            <li>
              <b>
                <xsl:call-template name="linkify-text">
                  <xsl:with-param name="text" select="stratml:Name"/>
                </xsl:call-template>
              </b>

              <xsl:call-template name="linkify-text">
                <xsl:with-param name="text" select="stratml:Description"/>
              </xsl:call-template>
            </li>
          </xsl:for-each>
        </ul>
      </div>
    </xsl:for-each>

  </xsl:template>

  <!-- ========================================================= -->
  <!-- RENDER DATA DICTIONARY                                    -->
  <!-- ========================================================= -->
    
  <xsl:template name="render-dictionary">
    <h1>Data Dictionary</h1>

    <div class="section">
      <h2>Metadata</h2>
      <table>
        <tr>
          <th>Title</th>
          <td>
            <xsl:call-template name="linkify-text">
              <xsl:with-param name="text" select="//dd:Metadata/dd:Title"/>
            </xsl:call-template>
          </td>
        </tr>
        <tr>
          <th>Description</th>
          <td>
            <xsl:call-template name="linkify-text">
              <xsl:with-param name="text" select="//dd:Metadata/dd:Description"/>
            </xsl:call-template>
          </td>
        </tr>
      </table>
    </div>

    <h2>Fields</h2>
    <table>
      <tr>
        <th>Name</th>
        <th>Description</th>
        <th>Type</th>
        <th>Example</th>
      </tr>

      <xsl:for-each select="//dd:Field">
        <tr>
          <td>
            <xsl:call-template name="linkify-text">
              <xsl:with-param name="text" select="dd:Name"/>
            </xsl:call-template>
          </td>
          <td>
            <xsl:call-template name="linkify-text">
              <xsl:with-param name="text" select="dd:Description"/>
            </xsl:call-template>
          </td>
          <td>
            <xsl:call-template name="linkify-text">
              <xsl:with-param name="text" select="dd:Type"/>
            </xsl:call-template>
          </td>
          <td>
            <xsl:call-template name="linkify-text">
              <xsl:with-param name="text" select="dd:Example"/>
            </xsl:call-template>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <!-- ========================================================= -->
  <!-- URL AUTOLINKING TEMPLATE                                  -->
  <!-- ========================================================= -->
    
  <xsl:template name="linkify-text">
    <xsl:param name="text"/>

    <!-- find locations of "http://" & "https://" -->
    <xsl:variable name="http-pos"  select="string-length(substring-before($text, 'http://')) + 1"/>
    <xsl:variable name="https-pos" select="string-length(substring-before($text, 'https://')) + 1"/>

    <!-- pick the earliest, valid URL -->
    <xsl:variable name="url-pos">
      <xsl:choose>
        <xsl:when test="contains($text,'http://') and (not(contains($text,'https://')) or $http-pos &lt; $https-pos)">
          <xsl:value-of select="$http-pos"/>
        </xsl:when>
        <xsl:when test="contains($text,'https://')">
          <xsl:value-of select="$https-pos"/>
        </xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- If no URL, just output text -->
    <xsl:if test="$url-pos = 0">
      <xsl:value-of select="$text"/>
    </xsl:if>

    <!-- URL exists -->
    <xsl:if test="$url-pos &gt; 0">
      <!-- output before URL -->
      <xsl:value-of select="substring($text, 1, $url-pos - 1)"/>

      <!-- remaining text -->
      <xsl:variable name="rest" select="substring($text, $url-pos)"/>

      <!-- extract URL until space -->
      <xsl:variable name="url">
        <xsl:choose>
          <xsl:when test="contains($rest,' ')">
            <xsl:value-of select="substring($rest, 1, string-length(substring-before($rest,' ')))"/>
          </xsl:when>
          <xsl:otherwise><xsl:value-of select="$rest"/></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <!-- clickable hyperlink -->
      <a href="{$url}" target="_blank" rel="noopener noreferrer">
        <xsl:value-of select="$url"/>
      </a>

      <!-- remainder after URL -->
      <xsl:variable name="remaining">
        <xsl:choose>
          <xsl:when test="contains($rest,' ')">
            <xsl:value-of select="substring-after($rest,' ')"/>
          </xsl:when>
          <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <!-- recurse -->
      <xsl:call-template name="linkify-text">
        <xsl:with-param name="text" select="$remaining"/>
      </xsl:call-template>
    </xsl:if>

  </xsl:template>
    <!-- ========================================================= -->
    <!--  AUTOMATIC URL LINKIFIER (SAFE, TABLE-FRIENDLY VERSION)   -->
    <!-- ========================================================= -->
    
    <!-- Intercept all text nodes -->
    <xsl:template match="text()">
      <xsl:call-template name="make-links">
        <xsl:with-param name="text" select="." />
      </xsl:call-template>
    </xsl:template>
    
    <!-- Make URLs clickable -->
    <xsl:template name="make-links">
      <xsl:param name="text"/>
    
      <!-- Detect either protocol -->
      <xsl:choose>
    
        <!-- CASE 1: No URLs found -->
        <xsl:when test="not(contains($text,'http://')) and not(contains($text,'https://'))">
          <xsl:value-of select="$text"/>
        </xsl:when>
    
        <!-- CASE 2: A URL exists -->
        <xsl:otherwise>
    
          <!-- Find earliest URL type -->
          <xsl:variable name="pos-http"  select="string-length(substring-before($text,'http://')) + 1"/>
          <xsl:variable name="pos-https" select="string-length(substring-before($text,'https://')) + 1"/>
    
          <!-- Pick the earliest -->
          <xsl:variable name="pos">
            <xsl:choose>
              <xsl:when test="contains($text,'http://') and not(contains($text,'https://'))">
                <xsl:value-of select="$pos-http"/>
              </xsl:when>
              <xsl:when test="contains($text,'https://') and not(contains($text,'http://'))">
                <xsl:value-of select="$pos-https"/>
              </xsl:when>
              <xsl:when test="$pos-http &lt; $pos-https">
                <xsl:value-of select="$pos-http"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$pos-https"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
    
          <!-- Output text before URL -->
          <xsl:value-of select="substring($text,1,$pos - 1)"/>
    
          <!-- Remaining substring beginning with URL -->
          <xsl:variable name="rest" select="substring($text,$pos)"/>
    
          <!-- Extract URL token (until next space) -->
          <xsl:variable name="url">
            <xsl:choose>
              <xsl:when test="contains($rest,' ')">
                <xsl:value-of select="substring-before($rest,' ')"/>
              </xsl:when>
              <xsl:otherwise><xsl:value-of select="$rest"/></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
    
          <!-- Output clickable URL -->
          <a href="{$url}" target="_blank" rel="noopener noreferrer">
            <xsl:value-of select="$url"/>
          </a>
    
          <!-- After the URL -->
          <xsl:variable name="after">
            <xsl:choose>
              <xsl:when test="contains($rest,' ')">
                <xsl:value-of select="substring-after($rest,' ')"/>
              </xsl:when>
              <xsl:otherwise></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
    
          <!-- Process the remaining text (one more pass only) -->
          <xsl:call-template name="make-links">
            <xsl:with-param name="text" select="$after"/>
          </xsl:call-template>
        </xsl:otherwise>
    
      </xsl:choose>
    </xsl:template>


</xsl:stylesheet>
